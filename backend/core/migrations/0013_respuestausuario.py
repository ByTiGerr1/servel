# Generated by Django 5.2.1 on 2025-05-31 19:37

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('core', '0012_candidato_opcionrespuesta_pregunta_tipoeleccion_and_more'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='RespuestaUsuario',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('fecha_respuesta', models.DateTimeField(auto_now_add=True)),
                ('opcion_elegida', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='core.opcionrespuesta')),
                ('pregunta', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='core.pregunta')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='respuestas_usuario', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'verbose_name_plural': 'Respuestas de Usuarios',
                'unique_together': {('user', 'pregunta')},
            },
        ),
    ]
