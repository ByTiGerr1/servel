from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    RegisterUserView,
    CustomAuthToken,
    UserDetailView,
    NoticiaDetailView,
    NoticiaListCreateView,
    TipoEleccionListView,
    CandidatoListView,
    CandidatoDetailView,
    PreguntasPendientesView,
    MatchCandidatoViewSet,
    CandidatoFavoritoViewSet,
    CandidatoDescartadoViewSet,
    SubmitUserAnswersView,
)

router = DefaultRouter()
router.register(r'candidatos-favoritos', CandidatoFavoritoViewSet, basename='candidato-favorito')

router.register(r'descartados', CandidatoDescartadoViewSet, basename='descartado')

urlpatterns = [
    path('register/', RegisterUserView.as_view(), name='register'),
    path('login/', CustomAuthToken.as_view(), name='login'),
    path('me/', UserDetailView.as_view(), name='user-detail'),

    path('tipos-eleccion/', TipoEleccionListView.as_view(), name='tipos-eleccion-list'),
    path('candidatos/', CandidatoListView.as_view(), name='candidato-list'),
    path('candidatos/<int:pk>/', CandidatoDetailView.as_view(), name='candidato-detail'),

    path('preguntas/', PreguntasPendientesView.as_view(), name='pregunta-list'),
    path('match-candidatos/', MatchCandidatoViewSet.as_view({'get': 'match_candidatos'}), name='match-candidatos'),

    path('respuestas/', SubmitUserAnswersView.as_view(), name='submit-answers'),
    path('noticias/', NoticiaListCreateView.as_view(), name='noticia-list-create'),
    path('noticias/<int:pk>/', NoticiaDetailView.as_view(), name='noticia-detail'),
    path('', include(router.urls)),
]