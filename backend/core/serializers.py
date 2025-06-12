# backend/core/serializers.py

from rest_framework import serializers
from django.contrib.auth.models import User
from .models import (
    TipoEleccion,
    Candidato,
    Pregunta,
    OpcionRespuesta,
    PosturaCandidato,
    CandidatoFavorito,
    CandidatoDescartado,
    DecisionFinal,
    RespuestaUsuario,
    MatchCandidato,
    Noticia
)
from django.contrib.auth import get_user_model
from decimal import Decimal

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'password']

    def create(self, validated_data):
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', ''),
            password=validated_data['password']
        )
        return user

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']
        read_only_fields = fields


class TipoEleccionSerializer(serializers.ModelSerializer):
    class Meta:
        model = TipoEleccion
        fields = '__all__'

class OpcionRespuestaSerializer(serializers.ModelSerializer):
    class Meta:
        model = OpcionRespuesta
        fields = ['id', 'texto', 'valor']

class PreguntaSerializer(serializers.ModelSerializer):
    opciones_respuesta = OpcionRespuestaSerializer(many=True, read_only=True)
    tipo_eleccion_nombre = serializers.CharField(source='tipo_eleccion.nombre', read_only=True)

    class Meta:
        model = Pregunta
        fields = ['id', 'texto', 'orden', 'tipo_eleccion', 'tipo_eleccion_nombre', 'opciones_respuesta']

class CandidatoSerializer(serializers.ModelSerializer):
    tipos_eleccion = serializers.SerializerMethodField()
    tipos_eleccion_nombres = serializers.SerializerMethodField()

    class Meta:
        model = Candidato
        fields = [
            'id', 'nombre', 'apellido', 'partido', 'bio', 'ciudad',
            'propuesta_electoral', 'perfile_picture',
            'tipos_eleccion', 'tipos_eleccion_nombres'
        ]

    def get_tipos_eleccion(self, obj):
        print(f"DEBUG: En get_tipos_eleccion (CandidatoSerializer)")
        print(f"DEBUG: Tipo de 'obj' recibido: {type(obj)}")
        print(f"DEBUG: Contenido de 'obj': {obj}")
        

        if isinstance(obj, dict):
            return obj.get('tipos_eleccion', [])

        return [te.id for te in obj.tipos_eleccion.all()]

    def get_tipos_eleccion_nombres(self, obj):
       
        if isinstance(obj, dict):
            return obj.get('tipos_eleccion_nombres', []) 
       
        return [te.nombre for te in obj.tipos_eleccion.all()]


class PosturaCandidatoSerializer(serializers.ModelSerializer):
    opcion_respuesta_texto = serializers.CharField(source='opcion_respuesta.texto', read_only=True)
    candidato_nombre_completo = serializers.SerializerMethodField()
    pregunta_texto = serializers.CharField(source='pregunta.texto', read_only=True)
    opcion_respuesta_valor = serializers.IntegerField(source='opcion_respuesta.valor', read_only=True)

    class Meta:
        model = PosturaCandidato
        fields = [
            'id', 'candidato', 'pregunta', 'opcion_respuesta', 'justificacion',
            'opcion_respuesta_texto', 'opcion_respuesta_valor',
            'candidato_nombre_completo', 'pregunta_texto'
        ]
        read_only_fields = ['opcion_respuesta_texto', 'opcion_respuesta_valor', 'candidato_nombre_completo', 'pregunta_texto']

    def get_candidato_nombre_completo(self, obj):
        return f"{obj.candidato.nombre} {obj.candidato.apellido}".strip()


class MatchCandidatoResultSerializer(serializers.ModelSerializer):
    
    candidato_data = CandidatoSerializer(source='candidato', read_only=True)

    user = serializers.StringRelatedField(read_only=True)


    match_percentage = serializers.DecimalField(
        source='match_percentage_value',
        max_digits=5, decimal_places=2, read_only=True
    )
    preguntas_consideradas = serializers.IntegerField(
        source='num_preguntas_consideradas',
        read_only=True
    )

    class Meta:
        model = MatchCandidato
        fields = [
            'id',
            'user',
            'candidato_data', 
            'match_percentage',
            'preguntas_consideradas'
        ]



class CandidatoFavoritoSerializer(serializers.ModelSerializer):
    candidato_data = CandidatoSerializer(source='candidato', read_only=True)

    class Meta:
        model = CandidatoFavorito
        fields = ['id', 'candidato', 'fecha_agregado', 'candidato_data']
        read_only_fields = ['fecha_agregado', 'candidato_data']

    def validate(self, data):
        user = self.context['request'].user
        if CandidatoFavorito.objects.filter(user=user, candidato=data['candidato']).exists():
            raise serializers.ValidationError("Este candidato ya está en tus favoritos.")
        return data
    
class CandidatoDescartadoSerializer(serializers.ModelSerializer):
    candidato_data = CandidatoSerializer(source='candidato', read_only=True)

    class Meta:
        model = CandidatoDescartado
        fields = ['id', 'candidato', 'fecha_descartado', 'candidato_data']
        read_only_fields = ['fecha_descartado', 'candidato_data']


class RespuestaUsuarioCreateSerializer(serializers.ModelSerializer):
    pregunta = serializers.PrimaryKeyRelatedField(queryset=Pregunta.objects.all())
    opcion_elegida = serializers.PrimaryKeyRelatedField(queryset=OpcionRespuesta.objects.all())

    class Meta:
        model = RespuestaUsuario
        fields = ['pregunta', 'opcion_elegida']

    def validate(self, data):
        pregunta = data.get('pregunta')
        opcion_elegida = data.get('opcion_elegida')

        if pregunta and opcion_elegida and opcion_elegida.pregunta != pregunta:
            raise serializers.ValidationError(
                {"opcion_elegida": "La opción elegida no pertenece a la pregunta especificada."}
            )
        return data


class RespuestaUsuarioReadSerializer(serializers.ModelSerializer):
    pregunta_texto = serializers.CharField(source='pregunta.texto', read_only=True)
    opcion_elegida_texto = serializers.CharField(source='opcion_elegida.texto', read_only=True)
    opcion_elegida_valor = serializers.IntegerField(source='opcion_elegida.valor', read_only=True)

    class Meta:
        model = RespuestaUsuario
        fields = ['id', 'pregunta', 'pregunta_texto', 'opcion_elegida', 'opcion_elegida_texto', 'opcion_elegida_valor', 'fecha_respuesta']
        read_only_fields = ['id', 'fecha_respuesta']

class NoticiaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Noticia
        fields = ['id', 'titulo', 'descripcion', 'fecha_publicacion', 'actualizado_en']
        read_only_fields = ['fecha_publicacion', 'actualizado_en']