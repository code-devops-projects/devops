# 🟣 Ambiente de Desarrollo

## Configuración
- **Puerto**: 5435
- **Base de datos**: shopping_cart_dev
- **Contenedor**: shopping-cart-postgres-develop
- **Red**: network_develop
- **Volumen**: postgres_data_develop

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
docker exec -it shopping-cart-postgres-develop pg_isready -U postgres
```

### Conectarse a la base de datos
```powershell
psql -h localhost -p 5435 -U postgres -d shopping_cart_dev
```

### Backup manual
```powershell
docker exec shopping-cart-postgres-develop pg_dump -U postgres shopping_cart_dev > ../../backups/develop/backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql
```

### Restaurar backup
```powershell
Get-Content ../../backups/develop/backup_XXXXXXXX_XXXXXX.sql | docker exec -i shopping-cart-postgres-develop psql -U postgres -d shopping_cart_dev
```

### Recrear base de datos (desarrollo)
```powershell
# Detener y eliminar volumen
docker-compose down -v

# Levantar nuevamente con volumen limpio
docker-compose up -d
```

## Variables de entorno (.env)
```bash
POSTGRES_PASSWORD=dev_Str0ng_S3cr3t_2024
POSTGRES_USER=postgres
POSTGRES_DB=shopping_cart_dev
```

🔧 **Nota**: Ambiente para desarrollo local. Puedes recrear la BD sin problemas.
