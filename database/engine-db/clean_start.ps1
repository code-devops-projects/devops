# =============================================================================
# Clean and Start All Databases Script
# =============================================================================
# Description: Clean all containers and volumes, then start fresh
# Usage: .\clean_start.ps1
# =============================================================================

Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "  CLEANING AND STARTING ALL DATABASES" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  WARNING: This will DELETE ALL DATABASE DATA!" -ForegroundColor Red
Write-Host ""
$confirmation = Read-Host "Are you sure you want to continue? (yes/no)"

if ($confirmation -ne 'yes') {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Step 1: Stopping all database containers..." -ForegroundColor Yellow
docker-compose -p databases -f ./postgres/docker-compose.yml down -v 2>$null
docker-compose -p databases -f ./mysql/docker-compose.yml down -v 2>$null
docker-compose -p databases -f ./mongo/docker-compose.yml down -v 2>$null
docker-compose -p databases -f ./sqlserver/docker-compose.yml down -v 2>$null
docker-compose -p databases -f ./cassandra/docker-compose.yml down -v 2>$null
docker-compose -p databases -f ./sqlite/docker-compose.yml down -v 2>$null

Write-Host ""
Write-Host "Step 2: Removing old containers..." -ForegroundColor Yellow
docker rm -f db-postgres db-mysql db-mongo db-sqlserver db-cassandra db-sqlite 2>$null
docker rm -f serve-postgres serve-mysql serve-mongo serve-sqlserver serve-cassandra serve-sqlite 2>$null

Write-Host ""
Write-Host "Step 3: Removing old volumes..." -ForegroundColor Yellow
docker volume rm mysql_mysql_data 2>$null
docker volume rm postgres_postgres_data 2>$null
docker volume rm mongo_mongo_data 2>$null
docker volume rm sqlserver_sqlserver_data 2>$null
docker volume rm cassandra_cassandra_data 2>$null
docker volume rm sqlite_sqlite_data 2>$null

Write-Host ""
Write-Host "Step 4: Cleaning unused Docker resources..." -ForegroundColor Yellow
docker system prune -f

Write-Host ""
Write-Host "Step 5: Starting all databases with fresh data..." -ForegroundColor Green
docker-compose -p databases -f ./postgres/docker-compose.yml up -d
docker-compose -p databases -f ./mysql/docker-compose.yml up -d
docker-compose -p databases -f ./mongo/docker-compose.yml up -d
docker-compose -p databases -f ./sqlserver/docker-compose.yml up -d
docker-compose -p databases -f ./cassandra/docker-compose.yml up -d
docker-compose -p databases -f ./sqlite/docker-compose.yml up -d

Write-Host ""
Write-Host "✅ All databases started successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Waiting for databases to be ready (30 seconds)..." -ForegroundColor Cyan
Start-Sleep -Seconds 30

Write-Host ""
Write-Host "Database Status:" -ForegroundColor Cyan
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=db-"

Write-Host ""
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "  DATABASES READY!" -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Available databases:" -ForegroundColor White
Write-Host "  - PostgreSQL:  localhost:5432 (user: postgres)" -ForegroundColor Gray
Write-Host "  - MySQL:       localhost:3306 (user: root)" -ForegroundColor Gray
Write-Host "  - MongoDB:     localhost:27017" -ForegroundColor Gray
Write-Host "  - SQL Server:  localhost:1433 (user: sa)" -ForegroundColor Gray
Write-Host "  - Cassandra:   localhost:9042" -ForegroundColor Gray
Write-Host "  - SQLite:      Container (file-based)" -ForegroundColor Gray
Write-Host ""
