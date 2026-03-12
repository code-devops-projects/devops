# ***************************************************************************** 
# *                  ELIMINACION TOTAL DE DOCKER (SIN TILDES)                 *
# ***************************************************************************** 
# Descripcion:
#   - Detiene Docker Desktop y el servicio Docker si estan en ejecucion.
#   - Elimina contenedores, imagenes, volumenes, redes, contextos y build caches.
#   - Borra todas las carpetas y archivos de configuracion de Docker en Windows.
#   - Deja el sistema sin rastro de Docker, como si nunca hubiera estado instalado.
#
# Uso:
#   1. Guardar como .\cleanup-docker.ps1
#   2. Abrir PowerShell como Administrador.
#   3. Ejecutar: .\cleanup-docker.ps1
#
# Nota: Este proceso es IRREVERSIBLE, borra absolutamente todo de Docker.
# *****************************************************************************

Write-Host "`n=== INICIO DE ELIMINACION TOTAL DE DOCKER ===`n" -ForegroundColor Yellow

try {
    # -------------------------------------------------------------------------
    # 1. Detener Docker Desktop y el servicio Docker
    # -------------------------------------------------------------------------
    Write-Host "Paso 1: Deteniendo Docker Desktop y el servicio Docker..." -ForegroundColor Cyan
    
    # Detener la aplicacion Docker Desktop si esta en ejecucion
    Stop-Process -Name "Docker Desktop" -Force -ErrorAction SilentlyContinue
    
    # Detener el servicio Docker si existe
    if (Get-Service docker -ErrorAction SilentlyContinue) {
        Stop-Service docker -Force -ErrorAction SilentlyContinue
    }
    Write-Host " - Docker Desktop y servicio Docker detenidos si estaban en ejecucion."


    # -------------------------------------------------------------------------
    # 2. Eliminar contenedores, imagenes, volumenes, redes, contextos, etc.
    # -------------------------------------------------------------------------
    Write-Host "`nPaso 2: Eliminando contenedores, imagenes, volumenes, redes..." -ForegroundColor Cyan

    # Contenedores
    $containers = docker ps -aq
    if ($containers) {
        docker stop $containers | Out-Null
        docker rm $containers | Out-Null
        Write-Host " - Contenedores eliminados."
    } else {
        Write-Host " - No hay contenedores para eliminar."
    }

    # Imagenes
    $images = docker images -q
    if ($images) {
        docker rmi $images -f | Out-Null
        Write-Host " - Imagenes eliminadas."
    } else {
        Write-Host " - No hay imagenes para eliminar."
    }

    # Volumenes
    $volumes = docker volume ls -q
    if ($volumes) {
        docker volume rm $volumes | Out-Null
        Write-Host " - Volumenes eliminados."
    } else {
        Write-Host " - No hay volumenes para eliminar."
    }

    # Redes personalizadas (excluyendo bridge, host y none)
    $networks = docker network ls -q | Where-Object { $_ -notmatch "bridge|host|none" }
    if ($networks) {
        docker network rm $networks | Out-Null
        Write-Host " - Redes personalizadas eliminadas."
    } else {
        Write-Host " - No hay redes personalizadas para eliminar."
    }

    # Contextos Docker (excluyendo 'default')
    $contexts = docker context ls --format '{{.Name}}' | Where-Object { $_ -ne "default" }
    if ($contexts) {
        foreach ($ctx in $contexts) {
            docker context rm $ctx -f | Out-Null
        }
        Write-Host " - Contextos Docker eliminados."
    } else {
        Write-Host " - No hay contextos adicionales para eliminar."
    }

    # Limpieza de builds de Docker Buildx
    Write-Host "`n - Eliminando builds de Docker Buildx..."
    docker buildx prune -a -f | Out-Null

    # Limpieza profunda del sistema Docker
    Write-Host " - Realizando un prune completo de Docker..."
    docker system prune -a --volumes -f | Out-Null

    Write-Host " - Contenedores, imagenes, volumenes y redes eliminados con exito."
    

    # -------------------------------------------------------------------------
    # 3. Borrar datos y configuraciones de Docker
    # -------------------------------------------------------------------------
    Write-Host "`nPaso 3: Eliminando carpetas y archivos de configuracion de Docker..." -ForegroundColor Cyan
    
    # Rutas tipicas donde Docker (y Docker Desktop) guarda datos y configuraciones
    $paths = @(
        "C:\ProgramData\Docker",
        "C:\ProgramData\DockerDesktop",
        "$env:LOCALAPPDATA\Docker",
        "$env:LOCALAPPDATA\DockerDesktop",
        "$env:APPDATA\Docker",
        "$env:APPDATA\DockerDesktop",
        "$env:USERPROFILE\.docker"  # Carpeta .docker en el perfil del usuario
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            try {
                Remove-Item -Recurse -Force $path -ErrorAction SilentlyContinue
                Write-Host " - Eliminada la ruta: $path"
            } catch {
                Write-Host " - Error al eliminar: $path - $($_.Exception.Message)"
            }
        } else {
            Write-Host " - No existe la ruta: $path"
        }
    }

    Write-Host "`n=== ELIMINACION COMPLETA DE DOCKER FINALIZADA ===`n" -ForegroundColor Green

} catch {
    Write-Host "`nOcurrio un error durante la limpieza total de Docker!`n" -ForegroundColor Red
    Write-Host "Mensaje de error: $($_.Exception.Message)"
}