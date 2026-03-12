# =============================================================================
# Docker - Limpieza de Contenedores
# =============================================================================
# Descripción: Detiene y elimina todos los contenedores de Docker
# Uso: .\clean-containers.ps1
# =============================================================================

Write-Host "`n🗑️  Limpieza de Contenedores Docker" -ForegroundColor Yellow
Write-Host "====================================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Listar contenedores actuales
    Write-Host "📦 Contenedores actuales:" -ForegroundColor Cyan
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
    Write-Host ""

    # Obtener todos los contenedores
    $containers = docker ps -aq
    
    if (-not $containers) {
        Write-Host "ℹ️  No hay contenedores para eliminar." -ForegroundColor Green
        exit 0
    }

    # Confirmar operación
    $count = ($containers | Measure-Object).Count
    Write-Host "⚠️  Se eliminarán $count contenedor(es)." -ForegroundColor Yellow
    $confirm = Read-Host "¿Desea continuar? (si/no)"

    if ($confirm -ne "si") {
        Write-Host "❌ Operación cancelada." -ForegroundColor Yellow
        exit 0
    }

    # Detener contenedores activos
    Write-Host "`n🛑 Deteniendo contenedores activos..." -ForegroundColor Cyan
    $running = docker ps -q
    if ($running) {
        docker stop $running | Out-Null
        Write-Host "   ✅ Contenedores detenidos" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  No hay contenedores activos" -ForegroundColor Gray
    }

    # Eliminar todos los contenedores
    Write-Host "`n🗑️  Eliminando contenedores..." -ForegroundColor Cyan
    docker rm -f $containers | Out-Null
    Write-Host "   ✅ $count contenedor(es) eliminado(s)" -ForegroundColor Green

    Write-Host "`n✅ Limpieza de contenedores completada exitosamente!`n" -ForegroundColor Green

} catch {
    Write-Host "`n❌ Error durante la limpieza de contenedores:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
