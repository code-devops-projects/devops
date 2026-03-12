# Procedimientos de Seguridad

## Cifrado de Backups
- Utiliza herramientas como `gpg` o `openssl` para cifrar archivos `.sql` y `.tar.gz` en la carpeta `backups/`.
- Ejemplo:
```powershell
# Cifrar backup
openssl aes-256-cbc -in backup.sql -out backup.sql.enc -k TU_CLAVE
# Descifrar backup
openssl aes-256-cbc -d -in backup.sql.enc -out backup.sql -k TU_CLAVE
```

## Rotación de Contraseñas
- Actualiza las contraseñas en los archivos `.env` periódicamente.
- Usa el script `sync-config.ps1` para propagar los cambios a todos los ambientes.

## Buenas Prácticas
- No compartir archivos `.env` ni backups sin cifrar.
- Mantener `.env` y backups fuera del control de versiones.
- Documentar cada cambio de credenciales.

## Auditoría y Changelog Automático
- El sistema ejecuta el script `audit-changelog.ps1` para auditar y registrar automáticamente los cambios en archivos críticos de configuración y backups.
- Cada ejecución genera o actualiza el archivo `audit-changelog.log` con la siguiente información:
  - Fecha y hora de la auditoría
  - Proyecto y entorno
  - Ruta del archivo auditado (`.env`, `docker-compose.yml`, y backups `.sql` si existen)
  - Hash SHA256 del contenido para verificar integridad y detectar modificaciones
- Este registro permite:
  - Detectar cambios no autorizados o accidentales
  - Auditar el historial de configuraciones y respaldos
  - Validar la integridad de los archivos críticos
- Para ejecutar manualmente:
```powershell
pwsh ./audit-changelog.ps1
```
- Recomendación: revisar periódicamente el log y automatizar alertas ante cambios inesperados.

## Alertas Automáticas ante Cambios Inesperados
- El sistema ejecuta el script `audit-alert.ps1` para comparar el changelog actual con el estado anterior de los archivos críticos.
- Si se detecta un cambio inesperado en cualquier archivo auditado, se registra una alerta en `audit-alert.log` y se muestra una advertencia.
- El estado de los archivos se guarda en `audit-state.json` para futuras comparaciones.
- Para ejecutar manualmente:
```powershell
pwsh ./audit-alert.ps1
```
- Recomendación: automatizar la ejecución tras cada cambio relevante y revisar el archivo de alertas periódicamente.
