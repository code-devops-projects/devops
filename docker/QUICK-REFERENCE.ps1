# =============================================================================
# DOCKER TOOLS - REFERENCIA RÁPIDA
# =============================================================================

# ┌─────────────────────────────────────────────────────────────────────────┐
# │                          GESTIÓN INTERACTIVA                            │
# └─────────────────────────────────────────────────────────────────────────┘

# Manager completo con menú interactivo
.\docker-manager.ps1


# ┌─────────────────────────────────────────────────────────────────────────┐
# │                        LIMPIEZA DE DOCKER                               │
# └─────────────────────────────────────────────────────────────────────────┘

# Limpieza completa del sistema (RECOMENDADO para mantenimiento)
.\clean-system.ps1

# Limpiar solo contenedores
.\clean-containers.ps1

# Limpiar solo imágenes
.\clean-images.ps1                  # Todas las imágenes
.\clean-images.ps1 -DanglingOnly    # Solo imágenes <none>
.\clean-images.ps1 -Unused          # Solo imágenes sin usar

# Limpiar solo volúmenes (⚠️ CUIDADO: Elimina datos)
.\clean-volumes.ps1

# Limpiar solo redes
.\clean-networks.ps1


# ┌─────────────────────────────────────────────────────────────────────────┐
# │                    GESTIÓN DE CONTENEDORES                              │
# └─────────────────────────────────────────────────────────────────────────┘

# Detener todos los contenedores
.\stop-all-containers.ps1

# Iniciar todos los contenedores detenidos
.\start-all-containers.ps1

# Reiniciar contenedores
.\restart-containers.ps1                              # Todos (interactivo)
.\restart-containers.ps1 -ContainerName "postgres"    # Uno específico


# ┌─────────────────────────────────────────────────────────────────────────┐
# │                    INFORMACIÓN Y MONITOREO                              │
# └─────────────────────────────────────────────────────────────────────────┘

# Ver información completa del sistema
.\show-docker-info.ps1

# Ver logs de contenedores
.\show-logs.ps1                                         # Interactivo
.\show-logs.ps1 -ContainerName "api"                    # Específico
.\show-logs.ps1 -ContainerName "api" -Lines 500         # Con más líneas
.\show-logs.ps1 -ContainerName "api" -Follow            # Tiempo real


# ┌─────────────────────────────────────────────────────────────────────────┐
# │                        COMANDOS DOCKER                                  │
# └─────────────────────────────────────────────────────────────────────────┘

# Ver contenedores activos
docker ps

# Ver todos los contenedores
docker ps -a

# Ver imágenes
docker images

# Ver volúmenes
docker volume ls

# Ver redes
docker network ls

# Ver uso de espacio
docker system df

# Ver estadísticas en tiempo real
docker stats


# ┌─────────────────────────────────────────────────────────────────────────┐
# │                    FLUJOS DE TRABAJO COMUNES                            │
# └─────────────────────────────────────────────────────────────────────────┘

# --- LIMPIEZA DIARIA ---
# Liberar espacio sin eliminar imágenes
.\clean-containers.ps1
.\clean-volumes.ps1

# --- LIMPIEZA SEMANAL ---
# Limpieza completa del sistema
.\clean-system.ps1

# --- RESET TOTAL ---
# Eliminar absolutamente todo de Docker
.\docker-manager.ps1  # Opción [19]

# --- REINICIO DE SERVICIOS ---
# Reiniciar todos los servicios
.\restart-containers.ps1

# --- INTEGRACIÓN CON BASES DE DATOS ---
# Detener bases de datos + limpiar + reiniciar
cd ..\database
.\stop_all.ps1
cd ..\docker
.\clean-system.ps1
cd ..\database
.\start_all.ps1


# ┌─────────────────────────────────────────────────────────────────────────┐
# │                    SOLUCIÓN DE PROBLEMAS                                │
# └─────────────────────────────────────────────────────────────────────────┘

# Docker lento o sin espacio
.\show-docker-info.ps1     # Ver uso de espacio
.\clean-system.ps1         # Limpiar

# Contenedor no inicia
.\show-logs.ps1 -ContainerName "nombre-contenedor"

# Problemas de red
.\clean-networks.ps1
docker network ls

# Volumen corrupto
.\stop-all-containers.ps1
.\clean-volumes.ps1
# Recrear volúmenes con docker-compose


# ┌─────────────────────────────────────────────────────────────────────────┐
# │                    ALIAS RECOMENDADOS                                   │
# └─────────────────────────────────────────────────────────────────────────┘

# Agregar a tu $PROFILE de PowerShell:

function dclean { Set-Location "C:\www\devops-code-project\devops\docker"; .\clean-system.ps1 }
function dinfo { Set-Location "C:\www\devops-code-project\devops\docker"; .\show-docker-info.ps1 }
function dmgr { Set-Location "C:\www\devops-code-project\devops\docker"; .\docker-manager.ps1 }
function dstop { Set-Location "C:\www\devops-code-project\devops\docker"; .\stop-all-containers.ps1 }
function dstart { Set-Location "C:\www\devops-code-project\devops\docker"; .\start-all-containers.ps1 }
function dlogs { Set-Location "C:\www\devops-code-project\devops\docker"; .\show-logs.ps1 }

# Uso:
# dclean   → Limpieza rápida
# dinfo    → Ver información
# dmgr     → Abrir manager
# dstop    → Detener todo
# dstart   → Iniciar todo
# dlogs    → Ver logs


# ┌─────────────────────────────────────────────────────────────────────────┐
# │                    NOTAS IMPORTANTES                                    │
# └─────────────────────────────────────────────────────────────────────────┘

# ⚠️ ADVERTENCIAS:
# - clean-volumes.ps1 elimina datos PERMANENTEMENTE
# - clean-images.ps1 requiere descargar imágenes nuevamente
# - Siempre hacer BACKUP antes de limpiar volúmenes de producción

# ✅ BUENAS PRÁCTICAS:
# - Ejecutar clean-system.ps1 semanalmente
# - Usar show-docker-info.ps1 antes de limpiar
# - Detener contenedores antes de eliminar volúmenes
# - Usar docker-manager.ps1 para exploración interactiva

# 📝 TIPS:
# - Todos los scripts solicitan confirmación para operaciones destructivas
# - Los scripts verifican que Docker esté disponible antes de ejecutar
# - Códigos de color: Verde=Éxito, Amarillo=Advertencia, Rojo=Error
