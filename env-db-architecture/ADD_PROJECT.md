# Cómo agregar un nuevo proyecto PostgreSQL

1. Copia la estructura de la carpeta `example/` y renómbrala con el nombre del nuevo proyecto.
2. Actualiza el archivo `environments/config/.env` con el nombre y configuración del proyecto.
3. Ejecuta los scripts:
   ```powershell
   ./init-project.ps1 -ProjectName "nuevo-proyecto"
   ./sync-config.ps1
   ./manage.ps1 dev up
   ```
4. Verifica que los archivos `.env` y `docker-compose.yml` estén presentes en cada ambiente.
5. Documenta el nuevo proyecto en su propio `README.md`.
6. Actualiza la documentación y diagramas en la raíz si es necesario.
