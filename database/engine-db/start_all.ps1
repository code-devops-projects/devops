# =============================================================================
# Database Containers Start Script
# =============================================================================
# Description: Create all database containers without starting them
# Usage: .\start_all.ps1 [-AutoStart]
# =============================================================================

param(
    [switch]$AutoStart
)

$project = "databases"
$services = @(
    @{ Name = "PostgreSQL"; Path = "./postgres/docker-compose.yml" },
    @{ Name = "MySQL";      Path = "./mysql/docker-compose.yml" },
    @{ Name = "MongoDB";    Path = "./mongo/docker-compose.yml" },
    @{ Name = "SQL Server"; Path = "./sqlserver/docker-compose.yml" },
    @{ Name = "Cassandra";  Path = "./casandra/docker-compose.yml" },
    @{ Name = "SQLite";     Path = "./sqlite/docker-compose.yml" }
)

if ($AutoStart) {
    Write-Host "Starting all database containers..." -ForegroundColor Green
    foreach ($svc in $services) {
        Write-Host "  Starting $($svc.Name)..." -ForegroundColor Cyan
        docker compose -p $project -f $svc.Path up -d
    }
    Write-Host "All databases started." -ForegroundColor Green
} else {
    Write-Host "Creating database containers (not started)..." -ForegroundColor Yellow
    foreach ($svc in $services) {
        Write-Host "  Creating $($svc.Name)..." -ForegroundColor Cyan
        docker compose -p $project -f $svc.Path up --no-start
    }
    Write-Host "All containers created. Start them individually with: docker start <container-name>" -ForegroundColor Green
}

