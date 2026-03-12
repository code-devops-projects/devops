# Database Containers

Enterprise-grade database containers optimized for development and production environments.

## 📦 Available Databases

| Database | Version | Port | Container Name |
|----------|---------|------|----------------|
| PostgreSQL | 16 (Alpine) | 5432 | db-postgres |
| MySQL | 8.0 | 3306 | db-mysql |
| MongoDB | 8.0 | 27017 | db-mongo |
| SQL Server | 2022 | 1433 | db-sqlserver |
| Cassandra | 5.0 | 9042 | db-cassandra |
| SQLite | Latest | N/A | db-sqlite |

## 🚀 Quick Start

### Start All Databases
```powershell
.\start_all.ps1
```

### Stop All Databases
```powershell
.\stop_all.ps1
```

### Start Individual Database
```powershell
cd postgres
docker-compose up -d
```

## 🔐 Default Credentials

Check the `.env` file in each database folder for credentials.

**PostgreSQL:**
- User: `postgres`
- Password: Check `postgres/.env`

**MySQL:**
- User: `root`
- Password: Check `mysql/.env`

**MongoDB:**
- User: Check `mongo/.env`
- Password: Check `mongo/.env`

**SQL Server:**
- User: `sa`
- Password: Check `sqlserver/.env`

**Cassandra:**
- Default configuration (no authentication)

## 📁 Backup Location

All databases store backups in their respective `./backups` directory:
- `postgres/backups/`
- `mysql/backups/`
- `mongo/backups/`
- `sqlserver/backups/`
- `cassandra/backups/`

## 🔧 Best Practices Implemented

✅ **LTS Versions**: Using Long-Term Support versions for stability
✅ **Clean Images**: Minimal dependencies, no unnecessary packages
✅ **Generic Network**: `db-network` - works for any organization
✅ **Health Checks**: All containers have proper health monitoring
✅ **Restart Policy**: `unless-stopped` for better control
✅ **Security**: Credentials stored in `.env` files (never commit these!)
✅ **Portability**: Relative paths for Windows/Linux compatibility

## 🌐 Network

All databases share the same network: `db-network`

This allows inter-container communication using container names:
```
mongodb://db-mongo:27017
postgresql://db-postgres:5432
mysql://db-mysql:3306
```

## 📊 Monitoring

Check container health:
```powershell
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

View logs:
```powershell
docker logs db-postgres
docker logs db-mysql
docker logs db-mongo
docker logs db-sqlserver
docker logs db-cassandra
```

## 🛠️ Maintenance

### Clean unused volumes (⚠️ This deletes data!)
```powershell
docker-compose down -v
```

### Restart a database
```powershell
docker restart db-postgres
```

### Rebuild images
```powershell
docker-compose up -d --build
```

## 📝 Notes

- All databases use persistent volumes to preserve data between restarts
- Containers use `unless-stopped` restart policy (won't start on Docker daemon restart unless manually started before)
- Health checks ensure databases are fully operational before marking as healthy
