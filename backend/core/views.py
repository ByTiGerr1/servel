from decimal import Decimal
from rest_framework import mixins 
from rest_framework import generics, status, permissions, viewsets, serializers
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.decorators import action
from rest_framework.authtoken.models import Token
from rest_framework.settings import api_settings
from rest_framework.routers import DefaultRouter # Esto no se usa en las vistas directamente, solo en urls
from django.db import transaction
from django.contrib.auth.models import User
from django.db.models import Prefetch, Count, Case, When, F, ExpressionWrapper, FloatField


from .models import (
    TipoEleccion, Candidato, Pregunta, OpcionRespuesta,
    PosturaCandidato, RespuestaUsuario, CandidatoFavorito,
    CandidatoDescartado, MatchCandidato, Noticia
)
from .serializers import (
    UserSerializer, UserProfileSerializer, TipoEleccionSerializer, CandidatoSerializer,
    PreguntaSerializer, RespuestaUsuarioCreateSerializer, MatchCandidatoResultSerializer,
    CandidatoFavoritoSerializer, CandidatoDescartadoSerializer, NoticiaSerializer
)

# --- Vistas de Autenticación y Registro ---

class RegisterUserView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]  # Permitir registro sin autenticación

    def create(self, request, *args, **kwargs):
        """Create a new user and return an auth token in the response."""
        response = super().create(request, *args, **kwargs)
        user_id = response.data.get('id')
        if user_id is not None:
            user = User.objects.get(id=user_id)
            token, _ = Token.objects.get_or_create(user=user)
            response.data['token'] = token.key
        return response

class CustomAuthToken(ObtainAuthToken):
    """
    Handle user login and token generation.
    Returns token after successful authentication.
    """
    renderer_classes = api_settings.DEFAULT_RENDERER_CLASSES

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'user_id': user.pk,
            'email': user.email
        })

class UserDetailView(generics.RetrieveAPIView):
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user

# --- Vistas para Listar Tipos de Elección y Candidatos ---

class TipoEleccionListView(generics.ListAPIView):
    queryset = TipoEleccion.objects.all()
    serializer_class = TipoEleccionSerializer
    permission_classes = [permissions.IsAuthenticated]

class CandidatoListView(generics.ListAPIView):
    queryset = Candidato.objects.all()
    serializer_class = CandidatoSerializer
    permission_classes = [permissions.IsAuthenticated]

class CandidatoDetailView(generics.RetrieveAPIView):
    queryset = Candidato.objects.all()
    serializer_class = CandidatoSerializer
    permission_classes = [permissions.IsAuthenticated]

# --- Vistas para Preguntas y Respuestas ---

class PreguntasPendientesView(APIView):

    permission_classes = [permissions.IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        tipo_eleccion_id = request.query_params.get('tipo_eleccion_id')

        if not tipo_eleccion_id:
            return Response(
                {"detail": "Se requiere el parámetro 'tipo_eleccion_id'."},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            tipo_eleccion = TipoEleccion.objects.get(id=tipo_eleccion_id)
        except TipoEleccion.DoesNotExist:
            return Response(
                {"detail": "Tipo de elección no encontrado."},
                status=status.HTTP_404_NOT_FOUND
            )

        # IDs de las preguntas que el usuario ya respondió para este tipo de elección
        answered_question_ids = RespuestaUsuario.objects.filter(
            user=user,
            pregunta__tipo_eleccion=tipo_eleccion
        ).values_list('pregunta__id', flat=True)

        # Preguntas pendientes 
        pending_questions = Pregunta.objects.filter(
            tipo_eleccion=tipo_eleccion
        ).exclude(
            id__in=answered_question_ids
        ).prefetch_related(
            'opciones_respuesta'
        ).order_by('orden')

        serializer = PreguntaSerializer(pending_questions, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class SubmitUserAnswersView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = RespuestaUsuarioCreateSerializer(data=request.data, many=True, context={'request': request})

        if serializer.is_valid():
            try:
                with transaction.atomic():
                    user = request.user
                    for validated_item in serializer.validated_data:
                        pregunta = validated_item['pregunta']
                        opcion_elegida = validated_item['opcion_elegida']

                        # Realiza el update_or_create para cada respuesta
                        RespuestaUsuario.objects.update_or_create(
                            user=user,
                            pregunta=pregunta,
                            defaults={'opcion_elegida': opcion_elegida}
                        )
                return Response(
                    {'message': 'Respuestas procesadas exitosamente.'},
                    status=status.HTTP_201_CREATED
                )
            except Exception as e:
                print(f"ERROR al guardar respuestas en DB: {e}")
                return Response(
                    {'detail': f'Error interno del servidor al procesar respuestas: {str(e)}'},
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )
        else:
            print(f"ERROR: Datos de respuestas inválidos: {serializer.errors}")
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# --- Vistas para el Algoritmo de Matching y Favoritos/Descartados/Decisión Final ---

# --- Vista para el Match de Candidatos ---
class MatchCandidatoViewSet(viewsets.GenericViewSet):
    permission_classes = [permissions.IsAuthenticated]


    @action(detail=False, methods=['get'])
    def match_candidatos(self, request):
        user = request.user
        tipo_eleccion_id = request.query_params.get('tipo_eleccion_id')

        if not tipo_eleccion_id:
            return Response({"detail": "Falta el parámetro 'tipo_eleccion_id'"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            tipo_eleccion = TipoEleccion.objects.get(id=tipo_eleccion_id)
        except TipoEleccion.DoesNotExist:
            return Response({"detail": "Tipo de elección no encontrado."}, status=status.HTTP_404_NOT_FOUND)

    
        respuestas_usuario = RespuestaUsuario.objects.filter(
            user=user,
            pregunta__tipo_eleccion=tipo_eleccion
        ).select_related('opcion_elegida', 'pregunta')

     
        if not respuestas_usuario.exists():
            return Response({"detail": "El usuario no ha respondido preguntas para este tipo de elección."},
                            status=status.HTTP_400_BAD_REQUEST)

    
        user_responses_map = {
            respuesta.pregunta.id: respuesta.opcion_elegida.valor
            for respuesta in respuestas_usuario
        }
        num_preguntas_usuario_respondidas = len(user_responses_map)


        candidatos = Candidato.objects.filter(
            tipos_eleccion=tipo_eleccion
        ).prefetch_related(
            Prefetch('posturas_candidato', queryset=PosturaCandidato.objects.select_related('pregunta', 'opcion_respuesta'))
        )

        match_results = [] 

        for candidato in candidatos:
     
            match_candidato, created = MatchCandidato.objects.get_or_create(
                user=user,
                candidato=candidato
            )


            total_match_score = 0
            considered_questions_count = 0

            for postura in candidato.posturas_candidato.all():
                if postura.pregunta.id in user_responses_map:
                    user_value = user_responses_map[postura.pregunta.id]
                    candidate_value = postura.opcion_respuesta.valor


                    diff = abs(user_value - candidate_value)

                    max_possible_difference = 4 
                    score = 1 - (Decimal(diff) / Decimal(max_possible_difference))
                    total_match_score += score
                    considered_questions_count += 1

    
            if considered_questions_count > 0:
                match_percentage = (total_match_score / Decimal(considered_questions_count)) * 100
              
                match_percentage = match_percentage.quantize(Decimal('0.01'))
            else:
                match_percentage = Decimal('0.00')

            match_candidato.match_percentage_value = match_percentage
            match_candidato.num_preguntas_consideradas = considered_questions_count
            match_candidato.save() 

            match_results.append(match_candidato)

        match_results.sort(key=lambda x: x.match_percentage_value, reverse=True)


        serializer = MatchCandidatoResultSerializer(match_results, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class CandidatoFavoritoViewSet(
    mixins.CreateModelMixin,
    mixins.ListModelMixin,
    mixins.DestroyModelMixin,
    viewsets.GenericViewSet
):
    serializer_class = CandidatoFavoritoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
     
        return CandidatoFavorito.objects.filter(user=self.request.user).select_related('candidato')

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class CandidatoDescartadoViewSet(
    mixins.CreateModelMixin,
    mixins.ListModelMixin,
    mixins.DestroyModelMixin,
    viewsets.GenericViewSet
):
    serializer_class = CandidatoDescartadoSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
 
        return CandidatoDescartado.objects.filter(user=self.request.user).select_related('candidato')

    def perform_create(self, serializer):
        try:
            existing_discarded = CandidatoDescartado.objects.filter(
                user=self.request.user,
                candidato=serializer.validated_data['candidato']
            ).first()
            if existing_discarded:
                raise serializers.ValidationError({"detail": "Este candidato ya ha sido descartado."})
            serializer.save(user=self.request.user)
        except Exception as e:
            if "duplicate key value violates unique constraint" in str(e).lower():
                raise serializers.ValidationError({"detail": "Este candidato ya ha sido descartado."})
            raise serializers.ValidationError({"detail": f"Error al descartar candidato: {e}"})

class NoticiaListCreateView(generics.ListCreateAPIView):
    queryset = Noticia.objects.all()
    serializer_class = NoticiaSerializer
    permission_classes = [permissions.AllowAny]

class NoticiaDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Noticia.objects.all()
    serializer_class = NoticiaSerializer
    permission_classes = [permissions.AllowAny]