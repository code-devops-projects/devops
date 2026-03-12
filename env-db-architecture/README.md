# PostgreSQL Multi-Ambiente

Arquitectura para gestionar múltiples proyectos PostgreSQL con ambientes independientes (`dev`, `qa`, `staging`, `prod`) y automatización por scripts PowerShell.

## Estructura de Carpetas
```
projects/
  ├─ inventory/
  ├─ penalty/
  └─ security/
example/
```
Cada proyecto contiene:
- `environments/`: Configuración y archivos Docker Compose por ambiente
- `backups/`: Backups por ambiente
- Scripts: `init-project.ps1`, `manage.ps1`, `sync-config.ps1`

## Scripts Principales
- `init-project.ps1`: Inicializa el proyecto y propaga configuración.
- `sync-config.ps1`: Sincroniza variables en todos los ambientes.
- `manage.ps1`: Levanta, detiene y consulta el estado de los servicios por ambiente.

## Uso Rápido
```powershell
# Inicializar proyecto
./init-project.ps1 -ProjectName "nombre"
# Sincronizar config
./sync-config.ps1
# Levantar ambiente
./manage.ps1 dev up
```

## Docker Compose
- Cada ambiente tiene su propio `docker-compose.yml`.
- Variables de entorno en `.env` por ambiente.
- Volúmenes y redes aislados por ambiente.

## Backups
- Carpeta `backups/` por ambiente y proyecto.
- Excluidos por `.gitignore`.

## Documentación y Diagramas
- Arquitectura: `ARCHITECTURE.md`
- Diagramas: carpeta `architecture/diagram/`
- Ejemplo base: `example/`

## Buenas Prácticas
- `.env` y backups excluidos por `.gitignore`.
- Usar scripts para evitar errores manuales.
- Documentar cambios y flujos en cada proyecto.

## Solución de Problemas
- Verifica que los archivos `.env` estén presentes y configurados.
- Si Docker Compose no encuentra configuración, revisa la ruta y variables.
- Para restaurar backups, usa los scripts y comandos recomendados en la documentación.

## Seguridad
- Las credenciales y archivos `.env` están excluidos por `.gitignore`.
- Los backups están aislados por proyecto y ambiente.
