# =============================================================================
# Docker - Limpieza TOTAL Absoluta
# =============================================================================
# Descripción: Elimina ABSOLUTAMENTE TODO de Docker (contenedores, imágenes,
#              volúmenes, redes, builds, cache). Deja Docker como recién 
#              instalado.
# Uso: .\clean-all.ps1
# =============================================================================

Write-Host "`n🔥 LIMPIEZA TOTAL ABSOLUTA DE DOCKER" -ForegroundColor Red
Write-Host "====================================`n" -ForegroundColor Red

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Mostrar estado actual
    Write-Host "📊 Estado actual del sistema:" -ForegroundColor Cyan
    docker system df
    Write-Host ""

    # ADVERTENCIA FUERTE
    Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║                    ⚠️  ADVERTENCIA CRÍTICA  ⚠️                 ║" -ForegroundColor Red
    Write-Host "╠═══════════════════════════════════════════════════════════════╣" -ForegroundColor Red
    Write-Host "║                                                               ║" -ForegroundColor Red
    Write-Host "║  Esta operación eliminará ABSOLUTAMENTE TODO en Docker:      ║" -ForegroundColor Yellow
    Write-Host "║                                                               ║" -ForegroundColor Red
    Write-Host "║  ❌ TODOS los contenedores (activos e inactivos)             ║" -ForegroundColor White
    Write-Host "║  ❌ TODAS las imágenes                                       ║" -ForegroundColor White
    Write-Host "║  ❌ TODOS los volúmenes (datos permanentemente perdidos)     ║" -ForegroundColor White
    Write-Host "║  ❌ TODAS las redes personalizadas                          ║" -ForegroundColor White
    Write-Host "║  ❌ TODO el build cache y build history                     ║" -ForegroundColor White
    Write-Host "║  ❌ TODOS los builders adicionales                          ║" -ForegroundColor White
    Write-Host "║                                                               ║" -ForegroundColor Red
    Write-Host "║  ⚡ CONSECUENCIAS:                                            ║" -ForegroundColor Yellow
    Write-Host "║  • Pérdida permanente de datos en volúmenes                  ║" -ForegroundColor White
    Write-Host "║  • Necesitarás descargar todas las imágenes nuevamente       ║" -ForegroundColor White
    Write-Host "║  • Los builds serán mucho más lentos sin cache               ║" -ForegroundColor White
    Write-Host "║  • Todas las configuraciones de red se perderán              ║" -ForegroundColor White
    Write-Host "║                                                               ║" -ForegroundColor Red
    Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
    
    Write-Host "Para confirmar esta operación DESTRUCTIVA, escriba exactamente:" -ForegroundColor Yellow
    Write-Host "ELIMINAR TODO DOCKER" -ForegroundColor Red
    Write-Host ""
    $confirm = Read-Host "Confirmar"

    if ($confirm -ne "ELIMINAR TODO DOCKER") {
        Write-Host "`n❌ Operación cancelada. Confirmación incorrecta." -ForegroundColor Yellow
        exit 0
    }

    Write-Host "`n🔥 Iniciando eliminación total...`n" -ForegroundColor Red
    Start-Sleep -Seconds 2

    # =========================================================================
    # PASO 1: CONTENEDORES
    # =========================================================================
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "📦 PASO 1/6: Eliminando contenedores..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    $containers = docker ps -aq
    if ($containers) {
        Write-Host "   🛑 Deteniendo contenedores activos..." -ForegroundColor Cyan
        docker stop $containers 2>$null | Out-Null
        Write-Host "   🗑️  Eliminando todos los contenedores..." -ForegroundColor Cyan
        docker rm -f $containers 2>$null | Out-Null
        $count = ($containers | Measure-Object).Count
        Write-Host "   ✅ $count contenedor(es) eliminado(s)" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  No hay contenedores" -ForegroundColor Gray
    }

    # =========================================================================
    # PASO 2: IMÁGENES
    # =========================================================================
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "🖼️  PASO 2/6: Eliminando imágenes..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    $images = docker images -aq
    if ($images) {
        Write-Host "   🗑️  Eliminando todas las imágenes..." -ForegroundColor Cyan
        docker rmi -f $images 2>$null | Out-Null
        $count = ($images | Measure-Object).Count
        Write-Host "   ✅ $count imagen(es) eliminada(s)" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  No hay imágenes" -ForegroundColor Gray
    }
    
    Write-Host "   🧹 Limpiando imágenes residuales..." -ForegroundColor Cyan
    docker image prune -af 2>$null | Out-Null

    # =========================================================================
    # PASO 3: VOLÚMENES
    # =========================================================================
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "💾 PASO 3/6: Eliminando volúmenes..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    $volumes = docker volume ls -q
    if ($volumes) {
        Write-Host "   🗑️  Eliminando todos los volúmenes..." -ForegroundColor Cyan
        foreach ($vol in $volumes) {
            docker volume rm -f $vol 2>$null | Out-Null
        }
        $count = ($volumes | Measure-Object).Count
        Write-Host "   ✅ $count volumen(es) eliminado(s)" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  No hay volúmenes" -ForegroundColor Gray
    }
    
    Write-Host "   🧹 Limpiando volúmenes residuales..." -ForegroundColor Cyan
    docker volume prune -af 2>$null | Out-Null

    # =========================================================================
    # PASO 4: REDES
    # =========================================================================
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "🌐 PASO 4/6: Eliminando redes..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    $networks = docker network ls --format "{{.Name}}" | Where-Object { $_ -notin @("bridge", "host", "none") }
    if ($networks) {
        Write-Host "   🗑️  Eliminando redes personalizadas..." -ForegroundColor Cyan
        foreach ($net in $networks) {
            docker network rm $net 2>$null | Out-Null
        }
        $count = ($networks | Measure-Object).Count
        Write-Host "   ✅ $count red(es) eliminada(s)" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  No hay redes personalizadas" -ForegroundColor Gray
    }
    
    Write-Host "   🧹 Limpiando redes residuales..." -ForegroundColor Cyan
    docker network prune -f 2>$null | Out-Null

    # =========================================================================
    # PASO 5: BUILD CACHE Y BUILDERS
    # =========================================================================
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "🔨 PASO 5/6: Eliminando build cache y builders..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    Write-Host "   🗑️  Eliminando build cache..." -ForegroundColor Cyan
    docker builder prune -af --keep-storage 0 2>$null | Out-Null
    
    Write-Host "   🗑️  Eliminando builders adicionales..." -ForegroundColor Cyan
    $builders = docker builder ls --format "{{.Name}}" | Where-Object { $_ -ne "default" }
    if ($builders) {
        foreach ($builder in $builders) {
            docker builder rm $builder -f 2>$null | Out-Null
        }
    }
    Write-Host "   ✅ Build cache y builders eliminados" -ForegroundColor Green

    # =========================================================================
    # PASO 6: LIMPIEZA FINAL DEL SISTEMA
    # =========================================================================
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    Write-Host "🧹 PASO 6/6: Limpieza final del sistema..." -ForegroundColor Yellow
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    
    Write-Host "   🧹 Ejecutando system prune total..." -ForegroundColor Cyan
    docker system prune -af --volumes 2>$null | Out-Null
    Write-Host "   ✅ Sistema completamente limpio" -ForegroundColor Green

    # =========================================================================
    # RESUMEN FINAL
    # =========================================================================
    Write-Host "`n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    Write-Host "✅ LIMPIEZA TOTAL COMPLETADA" -ForegroundColor Green
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Green
    
    Write-Host "`n📊 Estado final del sistema:" -ForegroundColor Cyan
    docker system df
    
    Write-Host "`n💡 Docker ha sido completamente limpiado." -ForegroundColor Yellow
    Write-Host "   • Todos los recursos han sido eliminados" -ForegroundColor White
    Write-Host "   • El sistema está como recién instalado" -ForegroundColor White
    Write-Host "   • Puedes empezar de cero con tus proyectos`n" -ForegroundColor White

} catch {
    Write-Host "`n❌ Error durante la limpieza total:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
