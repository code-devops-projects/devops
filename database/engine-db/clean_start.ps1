# =============================================================================
# Clean and Start All Databases Script
# =============================================================================
# Description: Clean ONLY database containers and their volumes, then start fresh
#              Does NOT affect other Docker resources outside this project.
# Usage: .\clean_start.ps1
# =============================================================================

$project = "databases"
$containers = @("db-postgres", "db-mysql", "db-mongo", "db-sqlserver", "db-cassandra", "db-sqlite")
$services = @(
    @{ Name = "PostgreSQL"; Path = "./postgres/docker-compose.yml" },
    @{ Name = "MySQL";      Path = "./mysql/docker-compose.yml" },
    @{ Name = "MongoDB";    Path = "./mongo/docker-compose.yml" },
    @{ Name = "SQL Server"; Path = "./sqlserver/docker-compose.yml" },
    @{ Name = "Cassandra";  Path = "./casandra/docker-compose.yml" },
    @{ Name = "SQLite";     Path = "./sqlite/docker-compose.yml" }
)

Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "  CLEANING AND STARTING ALL DATABASES" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This will DELETE ALL DATABASE DATA for this project only." -ForegroundColor Red
Write-Host "Other Docker containers, images and volumes will NOT be affected." -ForegroundColor Yellow
Write-Host ""
$confirmation = Read-Host "Are you sure you want to continue? (yes/no)"

if ($confirmation -ne 'yes') {
    Write-Host "Operation cancelled." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Step 1: Stopping containers and removing volumes..." -ForegroundColor Yellow
foreach ($svc in $services) {
    Write-Host "  Cleaning $($svc.Name)..." -ForegroundColor Cyan
    docker compose -p $project -f $svc.Path down -v 2>$null
}

Write-Host ""
Write-Host "Step 2: Removing remaining containers (if any)..." -ForegroundColor Yellow
foreach ($c in $containers) {
    docker rm -f $c 2>$null
}

Write-Host ""
Write-Host "Step 3: Starting all databases with fresh data..." -ForegroundColor Green
foreach ($svc in $services) {
    Write-Host "  Starting $($svc.Name)..." -ForegroundColor Cyan
    docker compose -p $project -f $svc.Path up -d
}

Write-Host ""
Write-Host "Waiting for databases to be ready..." -ForegroundColor Cyan
Start-Sleep -Seconds 30

Write-Host ""
Write-Host "Database Status:" -ForegroundColor Cyan
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=db-"

Write-Host ""
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "  DATABASES READY" -ForegroundColor Green
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
