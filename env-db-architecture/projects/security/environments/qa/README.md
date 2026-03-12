# 🔵 Ambiente de QA

## Configuración
- **Puerto**: 5434
- **Base de datos**: shopping_cart_qa
- **Contenedor**: shopping-cart-postgres-qa
- **Red**: network_qa
- **Volumen**: postgres_data_qa

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
docker exec -it shopping-cart-postgres-qa pg_isready -U postgres
```

### Conectarse a la base de datos
```powershell
psql -h localhost -p 5434 -U postgres -d shopping_cart_qa
```

### Backup manual
```powershell
docker exec shopping-cart-postgres-qa pg_dump -U postgres shopping_cart_qa > ../../backups/qa/backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql
```

### Restaurar backup
```powershell
Get-Content ../../backups/qa/backup_XXXXXXXX_XXXXXX.sql | docker exec -i shopping-cart-postgres-qa psql -U postgres -d shopping_cart_qa
```

## Variables de entorno (.env)
```bash
POSTGRES_PASSWORD=qa_Str0ng_S3cr3t_2024
POSTGRES_USER=postgres
POSTGRES_DB=shopping_cart_qa
```

🧪 **Nota**: Ambiente para pruebas de calidad (QA).
