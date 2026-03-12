# =============================================================================
# Docker - Limpieza Completa del Sistema
# =============================================================================
# Descripción: Ejecuta una limpieza completa de Docker eliminando contenedores
#              detenidos, imágenes sin usar, volúmenes huérfanos, redes sin 
#              usar y build cache
# Uso: .\clean-system.ps1
# =============================================================================

Write-Host "`n🧹 Limpieza Completa del Sistema Docker" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Mostrar información actual
    Write-Host "📊 Uso de espacio actual:" -ForegroundColor Cyan
    docker system df
    Write-Host ""

    # Advertencia
    Write-Host "⚠️  Esta operación eliminará:" -ForegroundColor Yellow
    Write-Host "   • Todos los contenedores detenidos" -ForegroundColor White
    Write-Host "   • Todas las imágenes sin usar" -ForegroundColor White
    Write-Host "   • Todos los volúmenes sin usar" -ForegroundColor White
    Write-Host "   • Todas las redes sin usar" -ForegroundColor White
    Write-Host "   • Todo el build cache" -ForegroundColor White
    Write-Host ""
    
    $confirm = Read-Host "¿Desea continuar? (si/no)"

    if ($confirm -ne "si") {
        Write-Host "❌ Operación cancelada." -ForegroundColor Yellow
        exit 0
    }

    Write-Host "`n🧹 Iniciando limpieza del sistema...`n" -ForegroundColor Cyan

    # Limpieza de contenedores
    Write-Host "📦 Limpiando contenedores detenidos..." -ForegroundColor Cyan
    docker container prune -f
    Write-Host "   ✅ Contenedores limpiados" -ForegroundColor Green

    # Limpieza de imágenes
    Write-Host "`n🖼️  Limpiando imágenes sin usar..." -ForegroundColor Cyan
    docker image prune -a -f
    Write-Host "   ✅ Imágenes limpiadas" -ForegroundColor Green

    # Limpieza de volúmenes
    Write-Host "`n💾 Limpiando volúmenes sin usar..." -ForegroundColor Cyan
    docker volume prune -f
    Write-Host "   ✅ Volúmenes limpiados" -ForegroundColor Green

    # Limpieza de redes
    Write-Host "`n🌐 Limpiando redes sin usar..." -ForegroundColor Cyan
    docker network prune -f
    Write-Host "   ✅ Redes limpiadas" -ForegroundColor Green

    # Limpieza de build cache
    Write-Host "`n🔨 Limpiando build cache..." -ForegroundColor Cyan
    docker builder prune -af
    Write-Host "   ✅ Build cache limpiado" -ForegroundColor Green

    # Mostrar espacio recuperado
    Write-Host "`n📊 Uso de espacio después de la limpieza:" -ForegroundColor Cyan
    docker system df
    
    Write-Host "`n✅ Limpieza completa del sistema finalizada exitosamente!`n" -ForegroundColor Green

} catch {
    Write-Host "`n❌ Error durante la limpieza del sistema:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
