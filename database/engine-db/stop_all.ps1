# =============================================================================
# Database Containers Stop Script
# =============================================================================
# Description: Stop all database containers (preserves volumes/data)
# Usage: .\stop_all.ps1
# =============================================================================

$project = "databases"
$services = @(
    @{ Name = "PostgreSQL"; Path = "./postgres/docker-compose.yml" },
    @{ Name = "MySQL";      Path = "./mysql/docker-compose.yml" },
    @{ Name = "MongoDB";    Path = "./mongo/docker-compose.yml" },
    @{ Name = "SQL Server"; Path = "./sqlserver/docker-compose.yml" },
    @{ Name = "Cassandra";  Path = "./casandra/docker-compose.yml" },
    @{ Name = "SQLite";     Path = "./sqlite/docker-compose.yml" }
)

Write-Host "Stopping database containers..." -ForegroundColor Yellow
foreach ($svc in $services) {
    Write-Host "  Stopping $($svc.Name)..." -ForegroundColor Cyan
    docker compose -p $project -f $svc.Path down
}
Write-Host "All databases stopped successfully." -ForegroundColor Green
