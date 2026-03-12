# =============================================================================
# Docker - Ver Logs de Contenedor
# =============================================================================
# Descripción: Muestra los logs de un contenedor específico o todos
# Uso: .\show-logs.ps1 [nombre-contenedor] [-Lines 100] [-Follow]
# =============================================================================

param(
    [string]$ContainerName,
    [int]$Lines = 100,
    [switch]$Follow
)

Write-Host "`n📋 Logs de Contenedores Docker" -ForegroundColor Yellow
Write-Host "==============================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Si no se especificó contenedor, mostrar lista
    if ([string]::IsNullOrWhiteSpace($ContainerName)) {
        Write-Host "📦 Contenedores disponibles:" -ForegroundColor Cyan
        docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
        Write-Host ""
        $ContainerName = Read-Host "Ingrese el nombre o ID del contenedor"
    }

    # Verificar que el contenedor existe
    $exists = docker ps -a --filter "name=$ContainerName" --format "{{.Names}}"
    if (-not $exists) {
        Write-Host "❌ El contenedor '$ContainerName' no existe.`n" -ForegroundColor Red
        exit 1
    }

    Write-Host "📋 Mostrando logs del contenedor: $ContainerName" -ForegroundColor Cyan
    Write-Host "Líneas: $Lines" -ForegroundColor Gray
    if ($Follow) {
        Write-Host "Modo: Seguimiento en tiempo real (Ctrl+C para salir)" -ForegroundColor Gray
    }
    Write-Host "`n$('─' * 70)" -ForegroundColor Gray

    # Mostrar logs
    if ($Follow) {
        docker logs -f --tail $Lines $ContainerName
    } else {
        docker logs --tail $Lines $ContainerName
    }

    Write-Host "`n$('─' * 70)" -ForegroundColor Gray
    Write-Host "✅ Fin de los logs`n" -ForegroundColor Green

} catch {
    Write-Host "`n❌ Error al obtener logs:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
