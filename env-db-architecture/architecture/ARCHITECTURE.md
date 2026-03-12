# Arquitectura de Proyectos PostgreSQL Multi-Ambiente

Este repositorio implementa una arquitectura modular para gestionar múltiples proyectos PostgreSQL, cada uno con ambientes independientes y automatización.

## Estructura General

```
projects/
  ├─ inventory/
  ├─ penalty/
  └─ security/
example/
```
Cada proyecto contiene:
- `environments/`: Configuración y archivos Docker Compose por ambiente (`dev`, `qa`, `staging`, `prod`).
- `backups/`: Carpeta de backups por ambiente.
- Scripts de automatización (`init-project.ps1`, `manage.ps1`, `sync-config.ps1`).

## Diagrama de Despliegue

![Diagrama de Despliegue](architecture-deploy-plantuml.puml)

## Flujo de Automatización

![Flujo de Automatización](architecture-flow-plantuml.puml)

## Buenas Prácticas
- Mantener `.env` y backups fuera del control de versiones.
- Usar los scripts para evitar errores manuales.
- Documentar cambios y flujos en cada proyecto.

## Seguridad
- Las credenciales y archivos `.env` están excluidos por `.gitignore`.
- Los backups están aislados por proyecto y ambiente.

## Ejemplo de Proyecto
Ver carpeta `example/` para una plantilla base.
