# 🎛️ Kong Admin - Acceso Directo sin Konga

## 📋 Métodos de Administración de Kong

Dado que Konga puede ser problemático para configurar, aquí tienes alternativas simples y efectivas:

---

## ✅ Método 1: Kong Admin API (Recomendado)

### Acceso Directo desde Navegador

**URL Base**: http://localhost:8001

#### URLs Principales:

1. **Dashboard Principal**
   ```
   http://localhost:8001
   ```
   Muestra información general de Kong en formato JSON.

2. **Ver Todos los Servicios**
   ```
   http://localhost:8001/services
   ```
   Lista de los 13 servicios configurados.

3. **Ver Todas las Rutas**
   ```
   http://localhost:8001/routes
   ```
   Lista de todas las rutas configuradas.

4. **Ver Estado de Kong**
   ```
   http://localhost:8001/status
   ```
   Información sobre el estado y métricas de Kong.

5. **Ver Plugins**
   ```
   http://localhost:8001/plugins
   ```
   Plugins instalados y habilitados.

6. **Ver Upstreams**
   ```
   http://localhost:8001/upstreams
   ```
   Configuración de balanceo de carga.

---

## ✅ Método 2: Script PowerShell Interactivo

He creado un script PowerShell que te permite administrar Kong de forma visual:

**Archivo**: `kong-admin.ps1`

### Uso:
```powershell
cd c:\www\devops-code-project\devops\kong
.\kong-admin.ps1
```

El script te mostrará un menú con opciones para:
- Ver servicios
- Ver rutas
- Ver plugins
- Ver estado
- Crear servicio
- Crear ruta
- Y más...

---

## ✅ Método 3: Extensión de VSCode

### Instalar Thunder Client o REST Client

**Thunder Client** (Recomendado):
1. En VS Code, ir a Extensions (Ctrl+Shift+X)
2. Buscar "Thunder Client"
3. Instalar
4. Usar para hacer peticiones a http://localhost:8001

**REST Client**:
1. En VS Code, ir a Extensions (Ctrl+Shift+X)
2. Buscar "REST Client"
3. Instalar
4. Crear archivo `.http` con las peticiones

---

## ✅ Método 4: Postman/Insomnia

### Importar Colección de Kong

1. Descargar colección de Postman para Kong Admin API
2. Importar en Postman/Insomnia
3. Configurar base URL: `http://localhost:8001`
4. Ejecutar peticiones

---

## 📊 Comandos PowerShell Útiles

### Ver Servicios (Formato Bonito)

```powershell
# Ver todos los servicios
$services = Invoke-RestMethod -Uri "http://localhost:8001/services"
$services.data | Format-Table name, id, url -AutoSize

# Ver un servicio específico
$service = Invoke-RestMethod -Uri "http://localhost:8001/services/customer_api"
$service | ConvertTo-Json -Depth 5
```

### Ver Rutas (Formato Bonito)

```powershell
# Ver todas las rutas
$routes = Invoke-RestMethod -Uri "http://localhost:8001/routes"
$routes.data | Format-Table name, @{L='Paths';E={$_.paths -join ', '}}, service.name -AutoSize

# Ver rutas de un servicio específico
$routes = Invoke-RestMethod -Uri "http://localhost:8001/services/customer_api/routes"
$routes.data | Format-Table name, @{L='Paths';E={$_.paths -join ', '}} -AutoSize
```

### Ver Estado de Kong

```powershell
# Estado general
$status = Invoke-RestMethod -Uri "http://localhost:8001/status"
$status | ConvertTo-Json -Depth 3

# Información del nodo
$info = Invoke-RestMethod -Uri "http://localhost:8001"
$info | ConvertTo-Json -Depth 3
```

### Crear Servicio

```powershell
$body = @{
    name = "new-service"
    url = "http://my-api:5000"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8001/services" `
    -Method POST `
    -Body $body `
    -ContentType "application/json"
```

### Crear Ruta

```powershell
$body = @{
    name = "new-route"
    paths = @("/api/new")
    strip_path = $true
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8001/services/new-service/routes" `
    -Method POST `
    -Body $body `
    -ContentType "application/json"
```

### Actualizar Servicio

```powershell
$body = @{
    url = "http://my-new-api:5000"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8001/services/new-service" `
    -Method PATCH `
    -Body $body `
    -ContentType "application/json"
```

### Eliminar Servicio

```powershell
Invoke-RestMethod -Uri "http://localhost:8001/services/new-service" `
    -Method DELETE
```

---

## 🌐 Alternativa Simple: JSON Viewer en Navegador

### Usar Extensiones del Navegador

**Chrome**:
- Instalar extensión "JSON Viewer"
- Ir a http://localhost:8001/services
- El JSON se mostrará formateado y colapsable

**Edge**:
- Ya viene con visor JSON integrado
- Ir a http://localhost:8001/services
- Formato automático

**Firefox**:
- Ya viene con visor JSON integrado
- Ir a http://localhost:8001/services

---

## 📝 Resumen de URLs Clave

| Endpoint | URL | Descripción |
|----------|-----|-------------|
| **Dashboard** | http://localhost:8001 | Info general |
| **Servicios** | http://localhost:8001/services | Lista de servicios |
| **Rutas** | http://localhost:8001/routes | Lista de rutas |
| **Plugins** | http://localhost:8001/plugins | Plugins configurados |
| **Consumers** | http://localhost:8001/consumers | Consumers para auth |
| **Upstreams** | http://localhost:8001/upstreams | Balanceo de carga |
| **Certificates** | http://localhost:8001/certificates | Certificados SSL |
| **Status** | http://localhost:8001/status | Estado y métricas |

---

## 🎯 Recomendación

**Para desarrollo local**: Usar Admin API directamente con PowerShell o navegador

**Para equipo**: Usar Postman/Insomnia con colección compartida

**Para producción**: Considerar Kong Enterprise con Kong Manager oficial

---

## 📚 Documentación de Referencia

- [Kong Admin API](https://docs.konghq.com/gateway/latest/admin-api/)
- [Kong Configuration](https://docs.konghq.com/gateway/latest/reference/configuration/)
- [Kong Plugins](https://docs.konghq.com/hub/)

---

**Acceso Inmediato**: http://localhost:8001/services

Abre esta URL en tu navegador para ver todos tus servicios configurados.
