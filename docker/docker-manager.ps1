# =============================================================================
# Docker Manager - Herramienta de Gestión Completa de Docker
# =============================================================================
# Descripción: Script interactivo para gestionar contenedores, imágenes,
#              volúmenes, redes y realizar operaciones de limpieza en Docker
# Uso: .\docker-manager.ps1
# =============================================================================

function Show-Menu {
    Clear-Host
    Write-Host "╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║              DOCKER MANAGER - Menú Principal                  ║" -ForegroundColor Cyan
    Write-Host "╠═══════════════════════════════════════════════════════════════╣" -ForegroundColor Cyan
    Write-Host "║                                                               ║" -ForegroundColor Cyan
    Write-Host "║  CONTENEDORES                                                 ║" -ForegroundColor Yellow
    Write-Host "║  [1]  Listar contenedores activos                            ║" -ForegroundColor White
    Write-Host "║  [2]  Listar todos los contenedores                          ║" -ForegroundColor White
    Write-Host "║  [3]  Detener contenedor(es)                                 ║" -ForegroundColor White
    Write-Host "║  [4]  Iniciar contenedor(es)                                 ║" -ForegroundColor White
    Write-Host "║  [5]  Reiniciar contenedor(es)                               ║" -ForegroundColor White
    Write-Host "║  [6]  Eliminar contenedor(es)                                ║" -ForegroundColor White
    Write-Host "║  [7]  Ver logs de contenedor                                 ║" -ForegroundColor White
    Write-Host "║                                                               ║" -ForegroundColor Cyan
    Write-Host "║  IMÁGENES                                                     ║" -ForegroundColor Yellow
    Write-Host "║  [8]  Listar imágenes                                        ║" -ForegroundColor White
    Write-Host "║  [9]  Eliminar imagen(es)                                    ║" -ForegroundColor White
    Write-Host "║  [10] Eliminar imágenes sin usar (dangling)                  ║" -ForegroundColor White
    Write-Host "║                                                               ║" -ForegroundColor Cyan
    Write-Host "║  VOLÚMENES                                                    ║" -ForegroundColor Yellow
    Write-Host "║  [11] Listar volúmenes                                       ║" -ForegroundColor White
    Write-Host "║  [12] Eliminar volumen(es)                                   ║" -ForegroundColor White
    Write-Host "║  [13] Eliminar volúmenes sin usar                            ║" -ForegroundColor White
    Write-Host "║                                                               ║" -ForegroundColor Cyan
    Write-Host "║  REDES                                                        ║" -ForegroundColor Yellow
    Write-Host "║  [14] Listar redes                                           ║" -ForegroundColor White
    Write-Host "║  [15] Eliminar red(es)                                       ║" -ForegroundColor White
    Write-Host "║  [16] Eliminar redes sin usar                                ║" -ForegroundColor White
    Write-Host "║                                                               ║" -ForegroundColor Cyan
    Write-Host "║  LIMPIEZA                                                     ║" -ForegroundColor Yellow
    Write-Host "║  [17] Limpieza rápida (contenedores detenidos + dangling)   ║" -ForegroundColor White
    Write-Host "║  [18] Limpieza completa (prune system)                       ║" -ForegroundColor White
    Write-Host "║  [19] Limpieza total (TODO: contenedores + imágenes + vols) ║" -ForegroundColor Red
    Write-Host "║                                                               ║" -ForegroundColor Cyan
    Write-Host "║  INFORMACIÓN                                                  ║" -ForegroundColor Yellow
    Write-Host "║  [20] Ver estadísticas de Docker                             ║" -ForegroundColor White
    Write-Host "║  [21] Ver uso de espacio en disco                            ║" -ForegroundColor White
    Write-Host "║  [22] Ver información del sistema Docker                     ║" -ForegroundColor White
    Write-Host "║                                                               ║" -ForegroundColor Cyan
    Write-Host "║  [0]  Salir                                                   ║" -ForegroundColor White
    Write-Host "║                                                               ║" -ForegroundColor Cyan
    Write-Host "╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Get-DockerStatus {
    try {
        docker ps > $null 2>&1
        return $true
    }
    catch {
        Write-Host "⚠️  Docker no está disponible. Verifica que Docker Desktop esté ejecutándose." -ForegroundColor Red
        return $false
    }
}

# =============================================================================
# FUNCIONES DE CONTENEDORES
# =============================================================================

function Show-ActiveContainers {
    Write-Host "`n📦 Contenedores activos:" -ForegroundColor Cyan
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
}

function Show-AllContainers {
    Write-Host "`n📦 Todos los contenedores:" -ForegroundColor Cyan
    docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"
}

function Stop-Containers {
    Write-Host "`n🛑 Detener contenedores" -ForegroundColor Yellow
    Write-Host "Opciones: [1] Un contenedor específico | [2] Todos los contenedores activos"
    $choice = Read-Host "Seleccione"
    
    if ($choice -eq "1") {
        Show-ActiveContainers
        $container = Read-Host "`nIngrese el ID o nombre del contenedor"
        docker stop $container
        Write-Host "✅ Contenedor detenido" -ForegroundColor Green
    }
    elseif ($choice -eq "2") {
        $containers = docker ps -q
        if ($containers) {
            docker stop $containers
            Write-Host "✅ Todos los contenedores detenidos" -ForegroundColor Green
        }
        else {
            Write-Host "ℹ️  No hay contenedores activos" -ForegroundColor Yellow
        }
    }
}

function Start-Containers {
    Write-Host "`n▶️  Iniciar contenedores" -ForegroundColor Yellow
    Show-AllContainers
    $container = Read-Host "`nIngrese el ID o nombre del contenedor"
    docker start $container
    Write-Host "✅ Contenedor iniciado" -ForegroundColor Green
}

function Restart-Containers {
    Write-Host "`n🔄 Reiniciar contenedores" -ForegroundColor Yellow
    Show-ActiveContainers
    $container = Read-Host "`nIngrese el ID o nombre del contenedor"
    docker restart $container
    Write-Host "✅ Contenedor reiniciado" -ForegroundColor Green
}

function Remove-Containers {
    Write-Host "`n🗑️  Eliminar contenedores" -ForegroundColor Yellow
    Write-Host "Opciones: [1] Un contenedor | [2] Todos los contenedores detenidos | [3] TODOS (forzar)"
    $choice = Read-Host "Seleccione"
    
    if ($choice -eq "1") {
        Show-AllContainers
        $container = Read-Host "`nIngrese el ID o nombre del contenedor"
        docker rm $container -f
        Write-Host "✅ Contenedor eliminado" -ForegroundColor Green
    }
    elseif ($choice -eq "2") {
        docker container prune -f
        Write-Host "✅ Contenedores detenidos eliminados" -ForegroundColor Green
    }
    elseif ($choice -eq "3") {
        $confirm = Read-Host "⚠️  Esto eliminará TODOS los contenedores. ¿Confirmar? (si/no)"
        if ($confirm -eq "si") {
            $containers = docker ps -aq
            if ($containers) {
                docker rm -f $containers
                Write-Host "✅ Todos los contenedores eliminados" -ForegroundColor Green
            }
        }
    }
}

function Show-ContainerLogs {
    Write-Host "`n📋 Ver logs de contenedor" -ForegroundColor Yellow
    Show-ActiveContainers
    $container = Read-Host "`nIngrese el ID o nombre del contenedor"
    $lines = Read-Host "¿Cuántas líneas mostrar? (default: 100)"
    if ([string]::IsNullOrWhiteSpace($lines)) { $lines = "100" }
    
    Write-Host "`nÚltimas $lines líneas del contenedor $container`:" -ForegroundColor Cyan
    docker logs --tail $lines $container
}

# =============================================================================
# FUNCIONES DE IMÁGENES
# =============================================================================

function Show-Images {
    Write-Host "`n🖼️  Imágenes de Docker:" -ForegroundColor Cyan
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}"
}

function Remove-Images {
    Write-Host "`n🗑️  Eliminar imágenes" -ForegroundColor Yellow
    Write-Host "Opciones: [1] Una imagen específica | [2] Todas las imágenes sin usar"
    $choice = Read-Host "Seleccione"
    
    if ($choice -eq "1") {
        Show-Images
        $image = Read-Host "`nIngrese el ID o nombre de la imagen"
        docker rmi $image -f
        Write-Host "✅ Imagen eliminada" -ForegroundColor Green
    }
    elseif ($choice -eq "2") {
        $confirm = Read-Host "⚠️  Esto eliminará todas las imágenes sin usar. ¿Confirmar? (si/no)"
        if ($confirm -eq "si") {
            docker image prune -a -f
            Write-Host "✅ Imágenes sin usar eliminadas" -ForegroundColor Green
        }
    }
}

function Remove-DanglingImages {
    Write-Host "`n🗑️  Eliminando imágenes dangling (<none>)..." -ForegroundColor Yellow
    docker image prune -f
    Write-Host "✅ Imágenes dangling eliminadas" -ForegroundColor Green
}

# =============================================================================
# FUNCIONES DE VOLÚMENES
# =============================================================================

function Show-Volumes {
    Write-Host "`n💾 Volúmenes de Docker:" -ForegroundColor Cyan
    docker volume ls
}

function Remove-Volumes {
    Write-Host "`n🗑️  Eliminar volúmenes" -ForegroundColor Yellow
    Write-Host "Opciones: [1] Un volumen específico | [2] Todos los volúmenes sin usar"
    $choice = Read-Host "Seleccione"
    
    if ($choice -eq "1") {
        Show-Volumes
        $volume = Read-Host "`nIngrese el nombre del volumen"
        docker volume rm $volume
        Write-Host "✅ Volumen eliminado" -ForegroundColor Green
    }
    elseif ($choice -eq "2") {
        $confirm = Read-Host "⚠️  Esto eliminará todos los volúmenes sin usar. ¿Confirmar? (si/no)"
        if ($confirm -eq "si") {
            docker volume prune -f
            Write-Host "✅ Volúmenes sin usar eliminados" -ForegroundColor Green
        }
    }
}

function Remove-UnusedVolumes {
    Write-Host "`n🗑️  Eliminando volúmenes sin usar..." -ForegroundColor Yellow
    docker volume prune -f
    Write-Host "✅ Volúmenes sin usar eliminados" -ForegroundColor Green
}

# =============================================================================
# FUNCIONES DE REDES
# =============================================================================

function Show-Networks {
    Write-Host "`n🌐 Redes de Docker:" -ForegroundColor Cyan
    docker network ls
}

function Remove-Networks {
    Write-Host "`n🗑️  Eliminar redes" -ForegroundColor Yellow
    Write-Host "Opciones: [1] Una red específica | [2] Todas las redes sin usar"
    $choice = Read-Host "Seleccione"
    
    if ($choice -eq "1") {
        Show-Networks
        $network = Read-Host "`nIngrese el ID o nombre de la red"
        docker network rm $network
        Write-Host "✅ Red eliminada" -ForegroundColor Green
    }
    elseif ($choice -eq "2") {
        docker network prune -f
        Write-Host "✅ Redes sin usar eliminadas" -ForegroundColor Green
    }
}

function Remove-UnusedNetworks {
    Write-Host "`n🗑️  Eliminando redes sin usar..." -ForegroundColor Yellow
    docker network prune -f
    Write-Host "✅ Redes sin usar eliminadas" -ForegroundColor Green
}

# =============================================================================
# FUNCIONES DE LIMPIEZA
# =============================================================================

function Start-QuickCleanup {
    Write-Host "`n🧹 Limpieza rápida de Docker..." -ForegroundColor Yellow
    Write-Host "Eliminando contenedores detenidos..." -ForegroundColor Cyan
    docker container prune -f
    Write-Host "Eliminando imágenes dangling..." -ForegroundColor Cyan
    docker image prune -f
    Write-Host "✅ Limpieza rápida completada" -ForegroundColor Green
}

function Start-CompleteCleanup {
    Write-Host "`n🧹 Limpieza completa del sistema Docker..." -ForegroundColor Yellow
    $confirm = Read-Host "⚠️  Esto eliminará contenedores detenidos, redes sin usar, imágenes sin usar y build cache. ¿Confirmar? (si/no)"
    
    if ($confirm -eq "si") {
        docker system prune -a -f
        Write-Host "✅ Limpieza completa finalizada" -ForegroundColor Green
    }
}

function Start-TotalCleanup {
    Write-Host "`n🔥 LIMPIEZA TOTAL DE DOCKER" -ForegroundColor Red
    Write-Host "⚠️  ADVERTENCIA: Esto eliminará:" -ForegroundColor Yellow
    Write-Host "   - Todos los contenedores (activos e inactivos)" -ForegroundColor Red
    Write-Host "   - Todas las imágenes" -ForegroundColor Red
    Write-Host "   - Todos los volúmenes" -ForegroundColor Red
    Write-Host "   - Todas las redes personalizadas" -ForegroundColor Red
    Write-Host "   - Todo el build cache" -ForegroundColor Red
    
    $confirm = Read-Host "`n¿Está ABSOLUTAMENTE SEGURO? Escriba 'ELIMINAR TODO' para confirmar"
    
    if ($confirm -eq "ELIMINAR TODO") {
        Write-Host "`n🛑 Deteniendo todos los contenedores..." -ForegroundColor Yellow
        $containers = docker ps -aq
        if ($containers) { docker stop $containers }
        
        Write-Host "🗑️  Eliminando todos los contenedores..." -ForegroundColor Yellow
        if ($containers) { docker rm -f $containers }
        
        Write-Host "🗑️  Eliminando todas las imágenes..." -ForegroundColor Yellow
        $images = docker images -aq
        if ($images) { docker rmi -f $images }
        
        Write-Host "🗑️  Eliminando todos los volúmenes..." -ForegroundColor Yellow
        docker volume prune -f --all
        
        Write-Host "🗑️  Eliminando todas las redes..." -ForegroundColor Yellow
        docker network prune -f
        
        Write-Host "🗑️  Limpiando build cache..." -ForegroundColor Yellow
        docker builder prune -af
        
        Write-Host "`n✅ LIMPIEZA TOTAL COMPLETADA" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Operación cancelada" -ForegroundColor Yellow
    }
}

# =============================================================================
# FUNCIONES DE INFORMACIÓN
# =============================================================================

function Show-DockerStats {
    Write-Host "`n📊 Estadísticas de contenedores en tiempo real:" -ForegroundColor Cyan
    Write-Host "Presione Ctrl+C para salir`n" -ForegroundColor Yellow
    docker stats
}

function Show-DiskUsage {
    Write-Host "`n💿 Uso de espacio en disco de Docker:" -ForegroundColor Cyan
    docker system df -v
}

function Show-SystemInfo {
    Write-Host "`n🖥️  Información del sistema Docker:" -ForegroundColor Cyan
    docker info
}

# =============================================================================
# BUCLE PRINCIPAL
# =============================================================================

if (-not (Get-DockerStatus)) {
    Write-Host "`nPresione Enter para salir..."
    Read-Host
    exit
}

do {
    Show-Menu
    $selection = Read-Host "Seleccione una opción"
    
    switch ($selection) {
        '1'  { Show-ActiveContainers; Read-Host "`nPresione Enter para continuar" }
        '2'  { Show-AllContainers; Read-Host "`nPresione Enter para continuar" }
        '3'  { Stop-Containers; Read-Host "`nPresione Enter para continuar" }
        '4'  { Start-Containers; Read-Host "`nPresione Enter para continuar" }
        '5'  { Restart-Containers; Read-Host "`nPresione Enter para continuar" }
        '6'  { Remove-Containers; Read-Host "`nPresione Enter para continuar" }
        '7'  { Show-ContainerLogs; Read-Host "`nPresione Enter para continuar" }
        '8'  { Show-Images; Read-Host "`nPresione Enter para continuar" }
        '9'  { Remove-Images; Read-Host "`nPresione Enter para continuar" }
        '10' { Remove-DanglingImages; Read-Host "`nPresione Enter para continuar" }
        '11' { Show-Volumes; Read-Host "`nPresione Enter para continuar" }
        '12' { Remove-Volumes; Read-Host "`nPresione Enter para continuar" }
        '13' { Remove-UnusedVolumes; Read-Host "`nPresione Enter para continuar" }
        '14' { Show-Networks; Read-Host "`nPresione Enter para continuar" }
        '15' { Remove-Networks; Read-Host "`nPresione Enter para continuar" }
        '16' { Remove-UnusedNetworks; Read-Host "`nPresione Enter para continuar" }
        '17' { Start-QuickCleanup; Read-Host "`nPresione Enter para continuar" }
        '18' { Start-CompleteCleanup; Read-Host "`nPresione Enter para continuar" }
        '19' { Start-TotalCleanup; Read-Host "`nPresione Enter para continuar" }
        '20' { Show-DockerStats }
        '21' { Show-DiskUsage; Read-Host "`nPresione Enter para continuar" }
        '22' { Show-SystemInfo; Read-Host "`nPresione Enter para continuar" }
        '0'  { Write-Host "`n👋 Saliendo..." -ForegroundColor Cyan; break }
        default { Write-Host "`n❌ Opción inválida" -ForegroundColor Red; Read-Host "`nPresione Enter para continuar" }
    }
} while ($selection -ne '0')
