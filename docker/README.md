# 🐳 Docker Management Tools

Conjunto completo de herramientas PowerShell para gestionar Docker de manera eficiente y segura.

## 📋 Tabla de Contenidos

- [Descripción](#descripción)
- [Requisitos](#requisitos)
- [Herramientas Disponibles](#herramientas-disponibles)
  - [Gestión Interactiva](#gestión-interactiva)
  - [Limpieza](#limpieza)
  - [Gestión de Contenedores](#gestión-de-contenedores)
  - [Información y Monitoreo](#información-y-monitoreo)
- [Ejemplos de Uso](#ejemplos-de-uso)
- [Buenas Prácticas](#buenas-prácticas)

---

## 🎯 Descripción

Esta colección de scripts PowerShell proporciona una interfaz amigable para gestionar todos los aspectos de Docker, desde operaciones básicas hasta limpieza completa del sistema.

## ⚙️ Requisitos

- **Windows** con PowerShell 5.1 o superior
- **Docker Desktop** instalado y en ejecución
- Permisos de administrador (para algunas operaciones)

---

## 🛠️ Herramientas Disponibles

### 🎮 Gestión Interactiva

#### `docker-manager.ps1`
Script interactivo con menú completo para todas las operaciones de Docker.

```powershell
.\docker-manager.ps1
```

**Funcionalidades:**
- ✅ Gestión de contenedores (listar, iniciar, detener, eliminar)
- ✅ Gestión de imágenes (listar, eliminar, limpiar dangling)
- ✅ Gestión de volúmenes (listar, eliminar)
- ✅ Gestión de redes (listar, eliminar)
- ✅ Operaciones de limpieza (rápida, completa, total)
- ✅ Información y estadísticas del sistema
- ✅ Ver logs de contenedores

---

### 🧹 Limpieza

#### `clean-containers.ps1`
Detiene y elimina **todos** los contenedores.

```powershell
.\clean-containers.ps1
```

**Elimina:**
- ✅ Todos los contenedores (en ejecución y detenidos)

---

#### `clean-images.ps1`
Elimina imágenes de Docker con opciones flexibles.

```powershell
# Eliminar todas las imágenes
.\clean-images.ps1

# Solo imágenes dangling (<none>)
.\clean-images.ps1 -DanglingOnly

# Solo imágenes sin usar
.\clean-images.ps1 -Unused
```

**Opciones:**
- `-DanglingOnly`: Solo elimina imágenes sin etiqueta
- `-Unused`: Solo elimina imágenes que no están en uso

---

#### `clean-volumes.ps1`
Elimina **todos** los volúmenes de Docker.

```powershell
.\clean-volumes.ps1
```

**⚠️ ADVERTENCIA:** Esto eliminará los datos permanentemente.

---

#### `clean-networks.ps1`
Elimina todas las redes personalizadas de Docker.

```powershell
.\clean-networks.ps1
```

**Nota:** Las redes predeterminadas (bridge, host, none) no se eliminan.

---

#### `clean-system.ps1`
Limpieza completa del sistema Docker (prune).

```powershell
.\clean-system.ps1
```

**Elimina:**
- ✅ Contenedores detenidos
- ✅ Imágenes sin usar
- ✅ Volúmenes sin usar
- ✅ Redes sin usar
- ✅ Build cache

**💡 Recomendado:** Usar este script para mantenimiento regular.

---

### 📦 Gestión de Contenedores

#### `stop-all-containers.ps1`
Detiene todos los contenedores en ejecución.

```powershell
.\stop-all-containers.ps1
```

---

#### `start-all-containers.ps1`
Inicia todos los contenedores detenidos.

```powershell
.\start-all-containers.ps1
```

---

#### `restart-containers.ps1`
Reinicia uno o todos los contenedores.

```powershell
# Reiniciar un contenedor específico
.\restart-containers.ps1 -ContainerName "mi-contenedor"

# Reiniciar todos los contenedores (interactivo)
.\restart-containers.ps1
```

---

### 📊 Información y Monitoreo

#### `show-docker-info.ps1`
Muestra información completa del sistema Docker.

```powershell
.\show-docker-info.ps1
```

**Muestra:**
- Versión de Docker
- Resumen de contenedores
- Resumen de imágenes
- Resumen de volúmenes
- Resumen de redes
- Uso de espacio en disco
- Información del sistema

---

#### `show-logs.ps1`
Visualiza los logs de un contenedor.

```powershell
# Interactivo (seleccionar contenedor)
.\show-logs.ps1

# Contenedor específico
.\show-logs.ps1 -ContainerName "mi-contenedor"

# Con número de líneas personalizado
.\show-logs.ps1 -ContainerName "mi-contenedor" -Lines 200

# Seguimiento en tiempo real
.\show-logs.ps1 -ContainerName "mi-contenedor" -Follow
```

**Parámetros:**
- `-ContainerName`: Nombre o ID del contenedor
- `-Lines`: Número de líneas a mostrar (default: 100)
- `-Follow`: Modo seguimiento en tiempo real

---

## 📖 Ejemplos de Uso

### Escenario 1: Limpieza de Desarrollo Diaria
```powershell
# Limpieza rápida sin eliminar imágenes
.\clean-containers.ps1
.\clean-volumes.ps1
```

### Escenario 2: Limpieza Semanal Completa
```powershell
# Limpieza completa del sistema
.\clean-system.ps1
```

### Escenario 3: Reset Total de Docker
```powershell
# Eliminar absolutamente todo
.\clean-containers.ps1
.\clean-images.ps1
.\clean-volumes.ps1
.\clean-networks.ps1

# O usar el manager interactivo (opción 19)
.\docker-manager.ps1
```

### Escenario 4: Reinicio de Servicios
```powershell
# Reiniciar todos los contenedores
.\restart-containers.ps1

# O reiniciar uno específico
.\restart-containers.ps1 -ContainerName "postgres"
```

### Escenario 5: Debugging
```powershell
# Ver información del sistema
.\show-docker-info.ps1

# Ver logs de un contenedor problemático
.\show-logs.ps1 -ContainerName "api-backend" -Lines 500 -Follow
```

---

## 🎯 Buenas Prácticas

### ✅ Hacer

1. **Ejecutar limpieza regular**
   ```powershell
   # Cada semana o cuando notes lentitud
   .\clean-system.ps1
   ```

2. **Verificar información antes de limpiar**
   ```powershell
   .\show-docker-info.ps1
   ```

3. **Usar el manager interactivo para operaciones exploratorias**
   ```powershell
   .\docker-manager.ps1
   ```

4. **Detener contenedores antes de eliminar volúmenes**
   ```powershell
   .\stop-all-containers.ps1
   .\clean-volumes.ps1
   ```

### ❌ Evitar

1. **No ejecutar `clean-volumes.ps1` sin respaldo**
   - Los datos se perderán permanentemente

2. **No eliminar volúmenes de bases de datos en producción**
   - Siempre hacer backup primero

3. **No ejecutar limpieza total sin confirmar**
   - Deberás descargar todas las imágenes nuevamente

---

## 📁 Estructura de Archivos

```
docker/
├── docker-manager.ps1           # 🎮 Manager interactivo completo
├── clean-containers.ps1         # 🗑️ Limpiar contenedores
├── clean-images.ps1             # 🗑️ Limpiar imágenes
├── clean-volumes.ps1            # 🗑️ Limpiar volúmenes
├── clean-networks.ps1           # 🗑️ Limpiar redes
├── clean-system.ps1             # 🧹 Limpieza completa
├── stop-all-containers.ps1      # 🛑 Detener todos
├── start-all-containers.ps1     # ▶️ Iniciar todos
├── restart-containers.ps1       # 🔄 Reiniciar contenedores
├── show-docker-info.ps1         # 📊 Información del sistema
├── show-logs.ps1                # 📋 Ver logs
└── README.md                    # 📖 Esta documentación
```

---

## 🔗 Integración con Database Scripts

Estos scripts se integran perfectamente con los scripts de la carpeta `database/`:

```powershell
# Detener todas las bases de datos
cd ..\database
.\stop_all.ps1

# Limpiar Docker completamente
cd ..\docker
.\clean-system.ps1

# Reiniciar bases de datos limpias
cd ..\database
.\start_all.ps1
```

---

## 💡 Tips y Trucos

### Crear Alias para Scripts Frecuentes

Agrega a tu perfil de PowerShell (`$PROFILE`):

```powershell
# Alias para Docker
function dclean { & "C:\path\to\docker\clean-system.ps1" }
function dinfo { & "C:\path\to\docker\show-docker-info.ps1" }
function dmgr { & "C:\path\to\docker\docker-manager.ps1" }
function dstop { & "C:\path\to\docker\stop-all-containers.ps1" }
function dstart { & "C:\path\to\docker\start-all-containers.ps1" }
```

Luego puedes ejecutar:
```powershell
dclean   # Limpieza rápida
dinfo    # Ver información
dmgr     # Abrir manager
```

---

## 🆘 Solución de Problemas

### Docker no está disponible
```
❌ Docker no está disponible. Verifica que Docker Desktop esté ejecutándose.
```
**Solución:** Inicia Docker Desktop y espera a que esté completamente cargado.

### Error al eliminar volumen
```
⚠️ No se pudo eliminar volumen (puede estar en uso)
```
**Solución:** Detén los contenedores primero:
```powershell
.\stop-all-containers.ps1
.\clean-volumes.ps1
```

### Espacio en disco insuficiente
```powershell
# Verificar uso de espacio
.\show-docker-info.ps1

# Limpieza agresiva
.\clean-system.ps1
```

---

## 📝 Notas Adicionales

- **Seguridad:** Todos los scripts solicitan confirmación antes de operaciones destructivas
- **Logs:** Los scripts proporcionan información detallada de cada operación
- **Errores:** Los errores se muestran claramente con código de color rojo
- **Compatibilidad:** Funciona con Docker Desktop para Windows

---

## 🤝 Contribuciones

Para mejorar estos scripts:
1. Prueba exhaustivamente en un entorno de desarrollo
2. Documenta cualquier cambio
3. Mantén el estilo de código consistente
4. Agrega validaciones de seguridad apropiadas

---

## 📄 Licencia

Scripts de uso interno para gestión de DevOps.

---

**Última actualización:** Noviembre 2025  
**Versión:** 1.0.0
