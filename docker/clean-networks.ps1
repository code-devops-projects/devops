# =============================================================================
# Docker - Limpieza de Redes
# =============================================================================
# Descripción: Elimina todas las redes personalizadas de Docker
# Uso: .\clean-networks.ps1
# =============================================================================

Write-Host "`n🗑️  Limpieza de Redes Docker" -ForegroundColor Yellow
Write-Host "============================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Listar redes actuales
    Write-Host "🌐 Redes actuales:" -ForegroundColor Cyan
    docker network ls
    Write-Host ""

    # Obtener redes personalizadas (excluyendo bridge, host, none)
    $allNetworks = docker network ls --format "{{.Name}}"
    $customNetworks = $allNetworks | Where-Object { $_ -notin @("bridge", "host", "none") }
    
    if (-not $customNetworks) {
        Write-Host "ℹ️  No hay redes personalizadas para eliminar." -ForegroundColor Green
        Write-Host "   Las redes predeterminadas (bridge, host, none) no se pueden eliminar.`n" -ForegroundColor Gray
        exit 0
    }

    # Confirmar operación
    $count = ($customNetworks | Measure-Object).Count
    Write-Host "⚠️  Se eliminarán $count red(es) personalizada(s)." -ForegroundColor Yellow
    Write-Host "ℹ️  Las redes predeterminadas (bridge, host, none) no serán eliminadas." -ForegroundColor Gray
    $confirm = Read-Host "`n¿Desea continuar? (si/no)"

    if ($confirm -ne "si") {
        Write-Host "❌ Operación cancelada." -ForegroundColor Yellow
        exit 0
    }

    # Eliminar redes sin usar
    Write-Host "`n🗑️  Eliminando redes sin usar..." -ForegroundColor Cyan
    docker network prune -f | Out-Null

    # Intentar eliminar redes restantes
    $remainingNetworks = docker network ls --format "{{.Name}}" | Where-Object { $_ -notin @("bridge", "host", "none") }
    
    if ($remainingNetworks) {
        Write-Host "🗑️  Eliminando redes personalizadas..." -ForegroundColor Cyan
        foreach ($network in $remainingNetworks) {
            try {
                docker network rm $network 2>$null | Out-Null
                Write-Host "   ✅ Eliminada: $network" -ForegroundColor Green
            } catch {
                Write-Host "   ⚠️  No se pudo eliminar: $network (puede estar en uso)" -ForegroundColor Yellow
            }
        }
    }

    # Verificar resultado
    $finalNetworks = docker network ls --format "{{.Name}}" | Where-Object { $_ -notin @("bridge", "host", "none") }
    
    if (-not $finalNetworks) {
        Write-Host "`n✅ Todas las redes personalizadas fueron eliminadas exitosamente!`n" -ForegroundColor Green
    } else {
        $remaining = ($finalNetworks | Measure-Object).Count
        Write-Host "`n⚠️  $remaining red(es) no pudieron ser eliminadas (están en uso por contenedores)`n" -ForegroundColor Yellow
        Write-Host "💡 Sugerencia: Detén los contenedores primero y luego intenta de nuevo." -ForegroundColor Cyan
    }

} catch {
    Write-Host "`n❌ Error durante la limpieza de redes:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
