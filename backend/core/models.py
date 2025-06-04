from django.db import models
from django.contrib.auth.models import User

# Create your models here.

class TipoEleccion(models.Model):
    nombre = models.CharField(max_length=100, unique=True, help_text="Ej: Presidencial, Parlamentaria , Regional, Municipal")
    descripcion = models.TextField(blank=True, null=True, help_text="Descripciòn breve del tipo de eleccion")
    fecha_eleccion = models.DateField(null=True, blank=True, help_text="Fecha oficial de la eleccion")

    class Meta: 
        verbose_name_plural = "Tipos de elección"
    def __str__(self):
        return self.nombre

class Pregunta(models.Model):
    texto = models.TextField()
    tipo_eleccion = models.ForeignKey(TipoEleccion, on_delete=models.CASCADE, related_name="preguntas")
    orden = models.IntegerField(default=0)

    class Meta: 
        verbose_name_plural = "Preguntas"
        ordering = ['orden']
    
    def __str__(self):
        return f"[{self.tipo_eleccion.nombre}] {self.texto[:50]}..."

class OpcionRespuesta(models.Model):
    pregunta = models.ForeignKey(Pregunta, on_delete=models.CASCADE, related_name='opciones_respuesta')
    texto = models.CharField(max_length=255)
    valor = models.IntegerField(help_text="Valor numérico de la opción (ej. 1 al 5 para escalas, 0/1 para sí/no).")

    class Meta: 
        verbose_name_plural = "Opciones de respuesta"
        unique_together = ('pregunta', 'texto')
    def __str__(self):
        return f"{self.pregunta.texto[:30]}... - {self.texto} (Valor: {self.valor})"

OPCION_MUY_DE_ACUERDO = "Muy de acuerdo"
OPCION_DE_ACUERDO = "De acuerdo"
OPCION_NEUTRAL = "Neutral"
OPCION_EN_DESACUERDO = "En desacuerdo"
OPCION_MUY_EN_DESACUERDO = "Muy en desacuerdo"

OPCIONES_ACUERDO_DESACUERDO = [
    (OPCION_MUY_DE_ACUERDO, 5),
    (OPCION_DE_ACUERDO, 4),
    (OPCION_NEUTRAL, 3),
    (OPCION_EN_DESACUERDO, 2),
    (OPCION_MUY_EN_DESACUERDO, 1),
]

class RespuestaUsuario(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='respuestas_usuario')
    pregunta = models.ForeignKey(Pregunta, on_delete=models.CASCADE)
    opcion_elegida = models.ForeignKey(OpcionRespuesta, on_delete=models.CASCADE) # La opción que el usuario seleccionó
    fecha_respuesta = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "Respuestas de Usuarios"
        unique_together = ('user', 'pregunta') # Un usuario solo puede responder una pregunta una vez

    def __str__(self):
        return f"{self.user.username} respondió '{self.opcion_elegida.texto}' a '{self.pregunta.texto[:30]}...'"

class MatchCandidato(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='matches_candidato')
    candidato = models.ForeignKey('Candidato', on_delete=models.CASCADE) # Usar 'Candidato' como string si Candidato está definido más abajo
    match_percentage_value = models.DecimalField(max_digits=5, decimal_places=2, default=0.0)
    num_preguntas_consideradas = models.IntegerField(default=0)
    # Puedes añadir un campo para la fecha de la última actualización del match si es necesario
    fecha_ultima_actualizacion = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name_plural = "Matches de Candidatos"
        unique_together = ('user', 'candidato') # Un usuario solo tiene un match por candidato

    def __str__(self):
        return f"Match de {self.user.username} con {self.candidato.nombre} {self.candidato.apellido}: {self.match_percentage_value}%"

def crear_opciones_acuerdo_desacuerdo(pregunta):
    """Crea las opciones estándar de 'acuerdo/desacuerdo' para una pregunta."""
    opciones = []
    for texto, valor in OPCIONES_ACUERDO_DESACUERDO:
        opciones.append(OpcionRespuesta(pregunta=pregunta, texto=texto, valor=valor))
    OpcionRespuesta.objects.bulk_create(opciones)

class Candidato(models.Model):
    nombre = models.CharField(max_length=100)
    apellido = models.CharField(max_length=100, blank=True, default='')
    partido = models.CharField(max_length=200, help_text="Nombre del partido politico")
    bio = models.TextField(blank=True, null=True, help_text="Breve descripción")
    ciudad = models.CharField(max_length=100, blank=True, default='')
    propuesta_electoral = models.TextField(help_text="Resumen o texto principal de su propuesta electoral.")
    perfile_picture = models.ImageField(default='assets/default.avif', upload_to='profiles/')
    tipos_eleccion = models.ManyToManyField(TipoEleccion, related_name='candidatos')
    
    class Meta: 
        verbose_name_plural = "Candidatos"
    
    def __str__(self):
        return f"{self.nombre} {self.apellido}"

class PosturaCandidato(models.Model):
    candidato = models.ForeignKey(Candidato, on_delete=models.CASCADE, related_name='posturas_candidato')
    pregunta = models.ForeignKey(Pregunta, on_delete=models.CASCADE)
    opcion_respuesta = models.ForeignKey(OpcionRespuesta, on_delete=models.CASCADE)
    justificacion = models.TextField(blank=True, null=True, help_text="Breve justificación de la postura del candidato sobre el tema.")

    class Meta:
        verbose_name_plural = "Posturas de Candidatos"
        unique_together = ('candidato', 'pregunta') # Un candidato solo puede tener una postura por pregunta

    def __str__(self):
        return f"{self.candidato.apellido} - {self.pregunta.texto[:30]}... ({self.opcion_respuesta.texto})"

class CandidatoFavorito(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='favoritos')
    candidato = models.ForeignKey(Candidato, on_delete=models.CASCADE)
    fecha_agregado = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "Candidatos Favoritos"
        unique_together = ('user', 'candidato')
    def __str__(self):
        return f"{self.user.username} - Favorito: {self.candidato.nombre} {self.candidato.apellido}"

class CandidatoDescartado(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='descartados')
    candidato = models.ForeignKey(Candidato, on_delete=models.CASCADE)
    fecha_descartado = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "Candidatos Descartados"
        unique_together = ('user', 'candidato')
    def __str__(self):
        return f"{self.user.username} - Descartado: {self.candidato.nombre} {self.candidato.apellido}"
    
class DecisionFinal(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='decisiones_finales')
    candidato_elegido = models.ForeignKey(Candidato, on_delete=models.CASCADE, related_name='elegido_por_usuarios')
    tipo_eleccion = models.ForeignKey(TipoEleccion, on_delete=models.CASCADE)
    fecha_decision = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "Decisiones Finales"
        unique_together = ('user', 'tipo_eleccion')
    def __str__(self):
        return f"{self.user.username} eligió a {self.candidato_elegido.nombre} para {self.tipo_eleccion.nombre}"
