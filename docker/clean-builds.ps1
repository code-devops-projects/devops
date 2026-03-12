# =============================================================================
# Docker - Limpieza de Build Cache y Build History
# =============================================================================
# Descripción: Elimina todo el build cache y el historial de builds de Docker
# Uso: .\clean-builds.ps1
# =============================================================================

Write-Host "`n🔨 Limpieza de Builds de Docker" -ForegroundColor Yellow
Write-Host "================================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Mostrar información actual de builds
    Write-Host "📊 Información actual de builds:" -ForegroundColor Cyan
    docker builder ls
    Write-Host ""

    # Advertencia
    Write-Host "⚠️  Esta operación eliminará:" -ForegroundColor Yellow
    Write-Host "   • Todo el build cache" -ForegroundColor White
    Write-Host "   • Todo el historial de builds" -ForegroundColor White
    Write-Host "   • Todos los builders excepto el default" -ForegroundColor White
    Write-Host ""
    
    $confirm = Read-Host "¿Desea continuar? (si/no)"

    if ($confirm -ne "si") {
        Write-Host "❌ Operación cancelada." -ForegroundColor Yellow
        exit 0
    }

    Write-Host "`n🧹 Iniciando limpieza de builds...`n" -ForegroundColor Cyan

    # Paso 1: Limpiar build cache con prune agresivo
    Write-Host "🔨 Limpiando build cache (modo agresivo)..." -ForegroundColor Cyan
    docker builder prune -af --filter "until=1h"
    Write-Host "   ✅ Build cache reciente limpiado" -ForegroundColor Green

    Write-Host "`n🔨 Limpiando TODO el build cache..." -ForegroundColor Cyan
    docker builder prune -af
    Write-Host "   ✅ Todo el build cache limpiado" -ForegroundColor Green

    # Paso 2: Limpiar builders adicionales
    Write-Host "`n🔧 Verificando builders adicionales..." -ForegroundColor Cyan
    $builders = docker builder ls --format "{{.Name}}" | Where-Object { $_ -ne "default" }
    
    if ($builders) {
        foreach ($builder in $builders) {
            Write-Host "   🗑️  Eliminando builder: $builder" -ForegroundColor Yellow
            docker builder rm $builder -f 2>$null | Out-Null
        }
        Write-Host "   ✅ Builders adicionales eliminados" -ForegroundColor Green
    } else {
        Write-Host "   ℹ️  No hay builders adicionales para eliminar" -ForegroundColor Gray
    }

    # Paso 3: Inspeccionar y limpiar el builder default
    Write-Host "`n🔍 Limpiando builder default..." -ForegroundColor Cyan
    docker builder use default 2>$null | Out-Null
    docker builder prune -af --keep-storage 0 2>$null | Out-Null
    Write-Host "   ✅ Builder default limpiado" -ForegroundColor Green

    # Paso 4: Verificar resultado
    Write-Host "`n📊 Estado final:" -ForegroundColor Cyan
    docker system df
    Write-Host ""
    docker builder ls
    
    Write-Host "`n✅ Limpieza de builds completada exitosamente!`n" -ForegroundColor Green
    Write-Host "💡 Nota: Los próximos builds serán más lentos porque el cache fue eliminado.`n" -ForegroundColor Yellow

} catch {
    Write-Host "`n❌ Error durante la limpieza de builds:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
