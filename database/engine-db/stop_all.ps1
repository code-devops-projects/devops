# =============================================================================
# Database Containers Stop Script
# =============================================================================
# Description: Stop all database containers
# Usage: .\stop_all.ps1
# =============================================================================

Write-Host "Stopping database containers..." -ForegroundColor Yellow

docker-compose -p databases -f ./postgres/docker-compose.yml down
docker-compose -p databases -f ./mysql/docker-compose.yml down
docker-compose -p databases -f ./mongo/docker-compose.yml down
docker-compose -p databases -f ./sqlserver/docker-compose.yml down
docker-compose -p databases -f ./cassandra/docker-compose.yml down
docker-compose -p databases -f ./sqlite/docker-compose.yml down

Write-Host "All databases stopped successfully!" -ForegroundColor Green
