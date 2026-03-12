# Ejemplo de Integración CI/CD

Este ejemplo muestra cómo automatizar el despliegue de un ambiente PostgreSQL usando GitHub Actions.

```yaml
name: Deploy PostgreSQL Environment
on:
  push:
    branches: [ main ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v2
      - name: Build and Start PostgreSQL
        run: |
          cd projects/inventory/environments/prod
          docker-compose up -d
      - name: Run Validation
        run: |
          pwsh ../../../../validate-config.ps1
```

Adapta el flujo para otros proyectos y ambientes según sea necesario.
