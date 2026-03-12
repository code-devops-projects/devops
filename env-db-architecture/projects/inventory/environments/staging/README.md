# 🟡 Ambiente de Staging

## Configuración
- **Puerto**: 5433
- **Base de datos**: shopping_cart_staging
- **Contenedor**: shopping-cart-postgres-staging
- **Red**: network_staging
- **Volumen**: postgres_data_staging

## Comandos

### Levantar el ambiente
```powershell
docker-compose up -d
```

### Ver logs
```powershell
docker-compose logs -f
```

### Detener el ambiente
```powershell
docker-compose down
```

### Verificar estado
```powershell
docker-compose ps
docker exec -it shopping-cart-postgres-staging pg_isready -U postgres
```

### Conectarse a la base de datos
```powershell
psql -h localhost -p 5433 -U postgres -d shopping_cart_staging
```

### Backup manual
```powershell
docker exec shopping-cart-postgres-staging pg_dump -U postgres shopping_cart_staging > ../../backups/staging/backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql
```

### Restaurar backup
```powershell
Get-Content ../../backups/staging/backup_XXXXXXXX_XXXXXX.sql | docker exec -i shopping-cart-postgres-staging psql -U postgres -d shopping_cart_staging
```

## Variables de entorno (.env)
```bash
POSTGRES_PASSWORD=stg_Str0ng_S3cr3t_2024
POSTGRES_USER=postgres
POSTGRES_DB=shopping_cart_staging
```

💡 **Nota**: Ambiente para pruebas previas a producción.
