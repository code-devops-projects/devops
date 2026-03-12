# =============================================================================
# Docker - Limpieza de Imágenes
# =============================================================================
# Descripción: Elimina todas las imágenes de Docker
# Uso: .\clean-images.ps1 [Opciones]
#      -DanglingOnly : Solo elimina imágenes sin etiqueta (<none>)
#      -Unused       : Solo elimina imágenes sin usar
# =============================================================================

param(
    [switch]$DanglingOnly,
    [switch]$Unused
)

Write-Host "`n🗑️  Limpieza de Imágenes Docker" -ForegroundColor Yellow
Write-Host "================================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Listar imágenes actuales
    Write-Host "🖼️  Imágenes actuales:" -ForegroundColor Cyan
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
    Write-Host ""

    # Modo Dangling Only
    if ($DanglingOnly) {
        Write-Host "🗑️  Eliminando solo imágenes dangling (<none>)..." -ForegroundColor Cyan
        docker image prune -f
        Write-Host "`n✅ Imágenes dangling eliminadas!`n" -ForegroundColor Green
        exit 0
    }

    # Modo Unused
    if ($Unused) {
        Write-Host "⚠️  Se eliminarán todas las imágenes sin usar." -ForegroundColor Yellow
        $confirm = Read-Host "¿Desea continuar? (si/no)"
        
        if ($confirm -eq "si") {
            Write-Host "`n🗑️  Eliminando imágenes sin usar..." -ForegroundColor Cyan
            docker image prune -a -f
            Write-Host "`n✅ Imágenes sin usar eliminadas!`n" -ForegroundColor Green
        } else {
            Write-Host "❌ Operación cancelada." -ForegroundColor Yellow
        }
        exit 0
    }

    # Modo por defecto: eliminar todas
    $images = docker images -aq
    
    if (-not $images) {
        Write-Host "ℹ️  No hay imágenes para eliminar." -ForegroundColor Green
        exit 0
    }

    # Confirmar operación
    $count = ($images | Measure-Object).Count
    Write-Host "⚠️  Se eliminarán $count imagen(es)." -ForegroundColor Yellow
    Write-Host "⚠️  ADVERTENCIA: Deberás descargar las imágenes nuevamente!" -ForegroundColor Red
    $confirm = Read-Host "¿Desea continuar? (si/no)"

    if ($confirm -ne "si") {
        Write-Host "❌ Operación cancelada." -ForegroundColor Yellow
        exit 0
    }

    # Eliminar todas las imágenes
    Write-Host "`n🗑️  Eliminando imágenes..." -ForegroundColor Cyan
    docker rmi -f $images 2>$null | Out-Null
    
    # Verificar resultado
    $remaining = docker images -aq
    if (-not $remaining) {
        Write-Host "   ✅ Todas las imágenes eliminadas" -ForegroundColor Green
        Write-Host "`n✅ Limpieza de imágenes completada exitosamente!`n" -ForegroundColor Green
    } else {
        $remainingCount = ($remaining | Measure-Object).Count
        Write-Host "   ⚠️  $remainingCount imagen(es) no pudieron ser eliminadas" -ForegroundColor Yellow
        Write-Host "`n💡 Sugerencia: Algunas imágenes pueden estar en uso. Detén los contenedores primero." -ForegroundColor Cyan
    }

} catch {
    Write-Host "`n❌ Error durante la limpieza de imágenes:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
