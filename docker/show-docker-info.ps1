# =============================================================================
# Docker - Ver Información del Sistema
# =============================================================================
# Descripción: Muestra información detallada del sistema Docker
# Uso: .\show-docker-info.ps1
# =============================================================================

Write-Host "`n📊 Información del Sistema Docker" -ForegroundColor Yellow
Write-Host "==================================`n" -ForegroundColor Yellow

try {
    # Verificar que Docker está disponible
    docker ps > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        exit 1
    }

    # Versión de Docker
    Write-Host "🐳 Versión de Docker:" -ForegroundColor Cyan
    docker version --format "   Client: {{.Client.Version}}`n   Server: {{.Server.Version}}"
    Write-Host ""

    # Contenedores
    Write-Host "📦 Contenedores:" -ForegroundColor Cyan
    $totalContainers = (docker ps -aq | Measure-Object).Count
    $runningContainers = (docker ps -q | Measure-Object).Count
    $stoppedContainers = $totalContainers - $runningContainers
    Write-Host "   Total: $totalContainers" -ForegroundColor White
    Write-Host "   En ejecución: $runningContainers" -ForegroundColor Green
    Write-Host "   Detenidos: $stoppedContainers" -ForegroundColor Yellow
    Write-Host ""

    # Imágenes
    Write-Host "🖼️  Imágenes:" -ForegroundColor Cyan
    $totalImages = (docker images -aq | Measure-Object).Count
    $danglingImages = (docker images -f "dangling=true" -q | Measure-Object).Count
    Write-Host "   Total: $totalImages" -ForegroundColor White
    Write-Host "   Dangling: $danglingImages" -ForegroundColor Yellow
    Write-Host ""

    # Volúmenes
    Write-Host "💾 Volúmenes:" -ForegroundColor Cyan
    $totalVolumes = (docker volume ls -q | Measure-Object).Count
    Write-Host "   Total: $totalVolumes" -ForegroundColor White
    Write-Host ""

    # Redes
    Write-Host "🌐 Redes:" -ForegroundColor Cyan
    $totalNetworks = (docker network ls -q | Measure-Object).Count
    Write-Host "   Total: $totalNetworks" -ForegroundColor White
    Write-Host ""

    # Uso de disco
    Write-Host "💿 Uso de Espacio en Disco:" -ForegroundColor Cyan
    docker system df
    Write-Host ""

    # Información del sistema
    Write-Host "🖥️  Información del Sistema:" -ForegroundColor Cyan
    $info = docker info --format "   OS: {{.OperatingSystem}}`n   Architecture: {{.Architecture}}`n   CPUs: {{.NCPU}}`n   Memory: {{.MemTotal}}"
    Write-Host $info
    Write-Host ""

} catch {
    Write-Host "`n❌ Error al obtener información:" -ForegroundColor Red
    Write-Host "   $($_.Exception.Message)`n" -ForegroundColor Red
    exit 1
}
