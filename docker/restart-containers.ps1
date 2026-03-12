# =============================================================================
# Docker - Reiniciar Contenedor
# =============================================================================
# Descripción: Reinicia uno o todos los contenedores
# Uso: .\restart-containers.ps1 [nombre-contenedor]
# =============================================================================

param(
    [string]$ContainerName
)

Write-Host "`n🔄 Reiniciar Contenedores Docker" -ForegroundColor Yellow
Write-Host "=================================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Si se especificó un contenedor
    if (-not [string]::IsNullOrWhiteSpace($ContainerName)) {
        # Verificar que el contenedor existe
        $exists = docker ps -a --filter "name=$ContainerName" --format "{{.Names}}"
        if (-not $exists) {
            Write-Host "❌ El contenedor '$ContainerName' no existe.`n" -ForegroundColor Red
            exit 1
        }

        Write-Host "🔄 Reiniciando contenedor: $ContainerName..." -ForegroundColor Cyan
        docker restart $ContainerName | Out-Null
        Write-Host "✅ Contenedor '$ContainerName' reiniciado exitosamente!`n" -ForegroundColor Green
        exit 0
    }

    # Reiniciar todos los contenedores
    Write-Host "📦 Contenedores en ejecución:" -ForegroundColor Cyan
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
    Write-Host ""

    $runningContainers = docker ps -q

    if (-not $runningContainers) {
        Write-Host "ℹ️  No hay contenedores en ejecución para reiniciar.`n" -ForegroundColor Yellow
        exit 0
    }

    $count = ($runningContainers | Measure-Object).Count
    Write-Host "⚠️  Se reiniciarán $count contenedor(es)." -ForegroundColor Yellow
    $confirm = Read-Host "¿Desea continuar? (si/no)"

    if ($confirm -ne "si") {
        Write-Host "❌ Operación cancelada." -ForegroundColor Yellow
        exit 0
    }

    Write-Host "`n🔄 Reiniciando contenedores..." -ForegroundColor Cyan
    foreach ($container in $runningContainers) {
        $name = docker inspect --format='{{.Name}}' $container
        $name = $name.TrimStart('/')
        docker restart $container | Out-Null
        Write-Host "   ✅ Reiniciado: $name" -ForegroundColor Green
    }

    Write-Host "`n✅ Todos los contenedores han sido reiniciados exitosamente!`n" -ForegroundColor Green

} catch {
    Write-Host "`n❌ Error al reiniciar contenedores:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
