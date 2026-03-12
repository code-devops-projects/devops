# 🟢 Ambiente de Producción

## Configuración
- **Puerto**: 5432
- **Base de datos**: shopping_cart_prod
- **Contenedor**: shopping-cart-postgres-prod
- **Red**: network_prod
- **Volumen**: postgres_data_prod

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
docker exec -it shopping-cart-postgres-prod pg_isready -U postgres
```

### Conectarse a la base de datos
```powershell
psql -h localhost -p 5432 -U postgres -d shopping_cart_prod
```

### Backup manual
```powershell
docker exec shopping-cart-postgres-prod pg_dump -U postgres shopping_cart_prod > ../../backups/prod/backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql
```

### Restaurar backup
```powershell
Get-Content ../../backups/prod/backup_XXXXXXXX_XXXXXX.sql | docker exec -i shopping-cart-postgres-prod psql -U postgres -d shopping_cart_prod
```

## Variables de entorno (.env)
```bash
POSTGRES_PASSWORD=prd_Str0ng_S3cr3t_2024
POSTGRES_USER=postgres
POSTGRES_DB=shopping_cart_prod
```

⚠️ **IMPORTANTE**: Este es el ambiente de producción. Manéjalo con precaución.
