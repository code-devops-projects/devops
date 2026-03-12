# =============================================================================
# Docker - Iniciar Todos los Contenedores
# =============================================================================
# Descripción: Inicia todos los contenedores detenidos
# Uso: .\start-all-containers.ps1
# =============================================================================

Write-Host "`n▶️  Iniciar Todos los Contenedores Docker" -ForegroundColor Yellow
Write-Host "=========================================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Obtener contenedores detenidos
    $stoppedContainers = docker ps -aq -f status=exited

    if (-not $stoppedContainers) {
        Write-Host "ℹ️  No hay contenedores detenidos para iniciar." -ForegroundColor Green
        
        # Mostrar contenedores en ejecución si los hay
        $running = docker ps -q
        if ($running) {
            Write-Host "`n📦 Contenedores ya en ejecución:" -ForegroundColor Cyan
            docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
        }
        Write-Host ""
        exit 0
    }

    # Mostrar contenedores detenidos
    Write-Host "📦 Contenedores detenidos:" -ForegroundColor Cyan
    docker ps -a -f status=exited --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
    Write-Host ""

    # Contar contenedores
    $count = ($stoppedContainers | Measure-Object).Count
    Write-Host "▶️  Iniciando $count contenedor(es)..." -ForegroundColor Yellow

    # Iniciar todos los contenedores detenidos
    foreach ($container in $stoppedContainers) {
        $name = docker inspect --format='{{.Name}}' $container
        $name = $name.TrimStart('/')
        docker start $container | Out-Null
        Write-Host "   ✅ Iniciado: $name" -ForegroundColor Green
    }

    Write-Host "`n✅ Todos los contenedores han sido iniciados exitosamente!`n" -ForegroundColor Green

} catch {
    Write-Host "`n❌ Error al iniciar contenedores:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
