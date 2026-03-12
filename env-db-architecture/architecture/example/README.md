# PostgreSQL Multi-Ambiente - Shopping Cart

Configuración de PostgreSQL para múltiples ambientes con Docker Compose.

## 📋 Configuración de Puertos

| Ambiente    | Puerto | Carpeta                    | Contenedor                        |
|-------------|--------|----------------------------|-----------------------------------|
| Producción  | 5432   | environments/prod          | shopping-cart-postgres-prod       |
| Staging     | 5433   | environments/staging       | shopping-cart-postgres-staging    |
| QA          | 5434   | environments/qa            | shopping-cart-postgres-qa         |
| Desarrollo  | 5435   | environments/dev           | shopping-cart-postgres-develop    |

## � Estructura de Carpetas

```
postgres/
├── environments/
│   ├── prod/
│   │   ├── docker-compose.yml
│   │   ├── .env
│   │   └── README.md
│   ├── staging/
│   │   ├── docker-compose.yml
│   │   ├── .env
│   │   └── README.md
│   ├── qa/
│   │   ├── docker-compose.yml
│   │   ├── .env
│   │   └── README.md
│   └── dev/
│       ├── docker-compose.yml
│       ├── .env
│       └── README.md
├── backups/
│   ├── prod/
│   ├── staging/
│   ├── qa/
│   └── develop/
├── docker-compose.yml (todos los ambientes)
├── Dockerfile
├── manage.ps1
└── README.md
```

## 🚀 Uso con Script manage.ps1 (Recomendado)

### Comandos básicos
```powershell
# Levantar ambientes
.\manage.ps1 prod up
.\manage.ps1 staging up
.\manage.ps1 qa up
.\manage.ps1 dev up

# Ver logs
.\manage.ps1 prod logs
.\manage.ps1 staging logs

# Detener
.\manage.ps1 prod down
.\manage.ps1 staging down

# Ver estado
.\manage.ps1 prod status
.\manage.ps1 all status

# Reiniciar
.\manage.ps1 prod restart

# Reconstruir
.\manage.ps1 prod rebuild
```

## 🔧 Uso Manual (Navegando a cada carpeta)

### Producción
```powershell
cd environments\prod
docker-compose up -d
docker-compose logs -f
docker-compose down
cd ..\..
```

### Staging
```powershell
cd environments\staging
docker-compose up -d
docker-compose logs -f
docker-compose down
cd ..\..
```

### QA
```powershell
cd environments\qa
docker-compose up -d
docker-compose logs -f
docker-compose down
cd ..\..
```

### Desarrollo
```powershell
cd environments\dev
docker-compose up -d
docker-compose logs -f
docker-compose down
cd ..\..
```

## 🔄 Uso con docker-compose.yml (Todos los ambientes)

```powershell
# Levantar todos los ambientes
docker-compose up -d

# Levantar un ambiente específico
docker-compose up -d postgres-prod
docker-compose up -d postgres-staging
docker-compose up -d postgres-qa
docker-compose up -d postgres-develop

# Ver logs de todos
docker-compose logs -f

# Ver logs de un ambiente específico
docker-compose logs -f postgres-prod

# Detener todos
docker-compose down

# Detener un ambiente específico
docker-compose stop postgres-prod
```

## 🔧 Comandos Útiles

### Verificar estado de salud
```powershell
# Producción
docker exec -it shopping-cart-postgres-prod pg_isready -U postgres

# Staging
docker exec -it shopping-cart-postgres-staging pg_isready -U postgres

# QA
docker exec -it shopping-cart-postgres-qa pg_isready -U postgres

# Desarrollo
docker exec -it shopping-cart-postgres-develop pg_isready -U postgres
```

### Conectarse a la base de datos
```powershell
# Producción (puerto 5432)
psql -h localhost -p 5432 -U postgres -d shopping_cart_prod

# Staging (puerto 5433)
psql -h localhost -p 5433 -U postgres -d shopping_cart_staging

# QA (puerto 5434)
psql -h localhost -p 5434 -U postgres -d shopping_cart_qa

# Desarrollo (puerto 5435)
psql -h localhost -p 5435 -U postgres -d shopping_cart_dev
```

### Backup Manual
```powershell
# Producción
docker exec shopping-cart-postgres-prod pg_dump -U postgres shopping_cart_prod > ./backups/prod/backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql

# Staging
docker exec shopping-cart-postgres-staging pg_dump -U postgres shopping_cart_staging > ./backups/staging/backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql
```

### Reconstruir contenedor
```powershell
# Ejemplo para producción
docker-compose -f docker-compose.prod.yml down
docker-compose -f docker-compose.prod.yml build --no-cache
docker-compose -f docker-compose.prod.yml up -d
```

## 📁 Estructura de Archivos

```
.
├── docker-compose.yml              # Configuración de todos los ambientes
├── docker-compose.prod.yml         # Solo producción
├── docker-compose.staging.yml      # Solo staging
├── docker-compose.qa.yml           # Solo QA
├── docker-compose.dev.yml          # Solo desarrollo
├── Dockerfile                      # Imagen PostgreSQL con locale es_ES
├── .env.prod                       # Variables de producción
├── .env.staging                    # Variables de staging
├── .env.qa                         # Variables de QA
├── .env.dev                        # Variables de desarrollo
└── backups/
    ├── prod/
    ├── staging/
    ├── qa/
    └── develop/
```

## 🔐 Configuración de Variables de Entorno

Cada archivo `.env.*` debe contener:

```bash
POSTGRES_PASSWORD=tu_password_aqui
POSTGRES_USER=postgres
POSTGRES_DB=nombre_base_datos
```

## ⚠️ Notas Importantes

1. **Backups**: Los datos antiguos del volumen corrupto están en `postgres_data_prod_backup.tar.gz`
2. **Locale**: Todos los ambientes usan locale `es_ES.UTF-8`
3. **PostgreSQL Version**: 16
4. **Healthcheck**: Cada contenedor verifica su salud cada 30 segundos

## 🆘 Solución de Problemas

### Error: "directorio existe pero no está vacío"
```powershell
# Detener contenedor
docker-compose -f docker-compose.prod.yml down

# Eliminar volumen
docker volume rm postgres_data_prod

# Levantar nuevamente
docker-compose -f docker-compose.prod.yml up -d
```

### Ver contenido de un volumen
```powershell
docker run --rm -v postgres_data_prod:/data alpine ls -la /data
```
