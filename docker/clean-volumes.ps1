# =============================================================================
# Docker - Limpieza de Volúmenes
# =============================================================================
# Descripción: Elimina todos los volúmenes de Docker (incluidos los en uso)
# Uso: .\clean-volumes.ps1
# =============================================================================

Write-Host "`n🗑️  Limpieza de Volúmenes Docker" -ForegroundColor Yellow
Write-Host "=================================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Listar volúmenes actuales
    Write-Host "💾 Volúmenes actuales:" -ForegroundColor Cyan
    docker volume ls
    Write-Host ""

    # Obtener todos los volúmenes
    $volumes = docker volume ls -q
    
    if (-not $volumes) {
        Write-Host "ℹ️  No hay volúmenes para eliminar." -ForegroundColor Green
        exit 0
    }

    # Confirmar operación
    $count = ($volumes | Measure-Object).Count
    Write-Host "⚠️  Se eliminarán $count volumen(es)." -ForegroundColor Yellow
    Write-Host "⚠️  ADVERTENCIA: Esto eliminará los datos permanentemente!" -ForegroundColor Red
    $confirm = Read-Host "¿Desea continuar? (si/no)"

    if ($confirm -ne "si") {
        Write-Host "❌ Operación cancelada." -ForegroundColor Yellow
        exit 0
    }

    # Primero intentar eliminar volúmenes sin usar
    Write-Host "`n🗑️  Eliminando volúmenes sin usar..." -ForegroundColor Cyan
    docker volume prune -f | Out-Null

    # Obtener volúmenes restantes
    $remainingVolumes = docker volume ls -q
    
    if ($remainingVolumes) {
        Write-Host "🗑️  Eliminando volúmenes en uso (forzando)..." -ForegroundColor Cyan
        foreach ($volume in $remainingVolumes) {
            try {
                docker volume rm -f $volume 2>$null | Out-Null
                Write-Host "   ✅ Eliminado: $volume" -ForegroundColor Green
            } catch {
                Write-Host "   ⚠️  No se pudo eliminar: $volume (puede estar en uso)" -ForegroundColor Yellow
            }
        }
    }

    # Verificar resultado
    $finalVolumes = docker volume ls -q
    if (-not $finalVolumes) {
        Write-Host "`n✅ Todos los volúmenes fueron eliminados exitosamente!`n" -ForegroundColor Green
    } else {
        $remaining = ($finalVolumes | Measure-Object).Count
        Write-Host "`n⚠️  $remaining volumen(es) no pudieron ser eliminados (están en uso por contenedores activos)`n" -ForegroundColor Yellow
        Write-Host "💡 Sugerencia: Ejecuta clean-containers.ps1 primero y luego intenta de nuevo." -ForegroundColor Cyan
    }

} catch {
    Write-Host "`n❌ Error durante la limpieza de volúmenes:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
