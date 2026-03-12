# 🎛️ Configuración Global del Proyecto

Esta carpeta contiene la **configuración centralizada** que afecta a **TODOS los ambientes** (dev, qa, staging, prod).

## 📋 Archivo Principal: `.env`

Todas las variables globales están definidas en `environments/config/.env`.

## 🔧 Variables Configurables

### 🏷️ Identificación del Proyecto
```bash
PROJECT_NAME=shopping-cart
DB_NAME_BASE=shopping_cart
POSTGRES_USER=postgres
```

- **PROJECT_NAME**: Nombre del proyecto. Se usa en:
  - Nombres de contenedores: `${PROJECT_NAME}-postgres-dev`
  - Nombres de redes: `${PROJECT_NAME}_network_dev`
  - Labels de Docker

- **DB_NAME_BASE**: Base del nombre de BD. Resultado:
  - `shopping_cart_dev`
  - `shopping_cart_qa`
  - `shopping_cart_staging`
  - `shopping_cart_prod`

- **POSTGRES_USER**: Usuario común para todos los ambientes

### 🔌 Puertos por Ambiente
```bash
PORT_PROD=5432
PORT_STAGING=5433
PORT_QA=5434
PORT_DEV=5435
```

**Cambia los puertos aquí** y afectará a todos los ambientes automáticamente.

### 🌐 Prefijos de Red
```bash
NETWORK_PREFIX=network
```

Genera redes como:
- `shopping-cart_network_dev`
- `shopping-cart_network_qa`
- `shopping-cart_network_staging`
- `shopping-cart_network_prod`

### 💾 Prefijos de Volumen
```bash
VOLUME_PREFIX=postgres_data
```

Genera volúmenes como:
- `postgres_data_dev`
- `postgres_data_qa`
- `postgres_data_staging`
- `postgres_data_prod`

### 🐘 Configuración PostgreSQL
```bash
POSTGRES_VERSION=16
LOCALE=es_ES.UTF-8
```

## 📝 Cómo Usar

### ✅ Para cambiar configuración global:

1. **Edita** `environments/config/.env`
2. **Ejecuta** el script de sincronización:
   ```powershell
   .\sync-config.ps1
   ```
3. **Reinicia** los contenedores afectados:
   ```powershell
   .\manage.ps1 dev rebuild
   ```

### ✅ Cambios comunes:

**Cambiar nombre del proyecto:**
```bash
# En environments/config/.env
PROJECT_NAME=mi-nuevo-proyecto
```

**Cambiar puertos:**
```bash
# En environments/config/.env
PORT_DEV=5555
PORT_QA=5556
PORT_STAGING=5557
PORT_PROD=5558
```

**Cambiar nombre base de BD:**
```bash
# En environments/config/.env
DB_NAME_BASE=mi_base_datos
```

Después de cualquier cambio, ejecuta `.\sync-config.ps1` desde la raíz del proyecto.

## 🎯 Ventajas de esta Configuración

✅ **Un solo punto de configuración**: Cambia todo desde un archivo  
✅ **Sin tocar archivos de ambiente**: Los ambientes solo tienen su contraseña  
✅ **Consistencia**: Todos los ambientes usan la misma estructura  
✅ **Escalable**: Fácil agregar nuevos ambientes  
✅ **Mantenible**: No duplicas configuración en múltiples archivos

## ⚠️ Importante

- **NO cambies** los archivos `docker-compose.yml` de cada ambiente
- **Solo edita** `environments/config/.env` para cambios globales
- **Cada ambiente** (`dev/.env`, `qa/.env`, etc.) solo tiene su contraseña específica

## 📚 Orden de Carga de Variables

Docker Compose carga los archivos `.env` en este orden:

1. `../config/.env` - Variables globales del proyecto
2. `.env` - Variables específicas del ambiente (sobrescribe si hay conflicto)

Esto permite que cada ambiente tenga su propia contraseña mientras comparte la configuración global.
