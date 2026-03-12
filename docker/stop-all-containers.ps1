# =============================================================================
# Docker - Detener Todos los Contenedores
# =============================================================================
# Descripción: Detiene todos los contenedores en ejecución
# Uso: .\stop-all-containers.ps1
# =============================================================================

Write-Host "`n🛑 Detener Todos los Contenedores Docker" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Obtener contenedores en ejecución
    $runningContainers = docker ps -q

    if (-not $runningContainers) {
        Write-Host "ℹ️  No hay contenedores en ejecución.`n" -ForegroundColor Green
        exit 0
    }

    # Mostrar contenedores actuales
    Write-Host "📦 Contenedores en ejecución:" -ForegroundColor Cyan
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
    Write-Host ""

    # Contar contenedores
    $count = ($runningContainers | Measure-Object).Count
    Write-Host "🛑 Deteniendo $count contenedor(es)..." -ForegroundColor Yellow

    # Detener todos los contenedores
    docker stop $runningContainers | Out-Null

    Write-Host "✅ Todos los contenedores han sido detenidos exitosamente!`n" -ForegroundColor Green

} catch {
    Write-Host "`n❌ Error al detener contenedores:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
