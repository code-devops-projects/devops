# Kong API Gateway - ShoppingCar Project

## 📋 Descripción

Kong API Gateway con **Kong Manager** configurado en modo **DB-less (declarativo)** para el proyecto ShoppingCar, siguiendo estándares de routing y puertos establecidos.

---

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENTE                                  │
│                    (Browser/Mobile App)                          │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
         ┌────────────────────────────┐
         │   KONG API GATEWAY         │
         │   Puerto 80 / 8090         │
         └────────┬───────────────────┘
                  │
         ┌────────┴─────────┬──────────────┬──────────────┐
         │                  │              │              │
         ▼                  ▼              ▼              ▼
    /portal/*           /app/*        /api/*       /unavailable
    ┌────────┐       ┌────────┐    ┌────────┐    ┌──────────┐
    │Portal  │       │  App   │    │  API   │    │ Fallback │
    │Services│       │Services│    │Services│    │ Service  │
    └────────┘       └────────┘    └────────┘    └──────────┘
        │                │              │              │
        ▼                ▼              ▼              ▼
    Frontends        Frontends      Backend        Mock/503
    (Angular)        (Ionic)        (REST)         Response
```

---

## 📁 Estructura de Archivos

```
kong/
├── docker-compose.yml          # Compose file para Kong + Mocks (PRINCIPAL)
├── kong.yml                    # Configuración declarativa de Kong - 13 servicios (PRINCIPAL)
├── Dockerfile                  # Dockerfile para Kong con Kong Manager
├── Dockerfile.mock             # Dockerfile para servicios mock
├── mock_responder.py           # Flask app que retorna 503 controlado
├── .env.local                  # Variables de entorno para desarrollo local
├── .env.dev                    # Variables de entorno para ambiente dev
├── kong-admin.ps1              # Script PowerShell para administración
├── GUIA_PRUEBAS.md            # Guía completa de pruebas y URLs
├── RESUMEN_DESPLIEGUE.md      # Resumen ejecutivo del despliegue
├── VALIDACION_INFRAESTRUCTURA.md # Reporte completo de validación ✅
├── KONG_ADMIN_DIRECTO.md      # Guía de Admin API
├── SHOPPINGCAR_GATEWAY.md     # Documentación del estándar ShoppingCar
├── README.md                   # Este archivo
└── decode_base64_secret.py     # Utilidad para decodificar secretos
```

---

## 🚀 Inicio Rápido

### 1. Levantar Kong Gateway + Servicios Mock

```powershell
cd c:\www\devops-code-project\devops\kong
docker compose up -d --build
```

### 2. Verificar Estado

```powershell
docker compose ps
```

Deberías ver 14 contenedores corriendo:
- 1 Kong Gateway
- 13 Servicios Mock (4 portals, 4 apps, 4 APIs, 1 fallback)

### 3. Probar Rutas

```powershell
# Portal
Invoke-WebRequest -Uri "http://localhost/portal/customer" -UseBasicParsing

# App
Invoke-WebRequest -Uri "http://localhost/app/inventory" -UseBasicParsing

# API
Invoke-WebRequest -Uri "http://localhost:8090/api/security" -UseBasicParsing

# Fallback
Invoke-WebRequest -Uri "http://localhost/unavailable" -UseBasicParsing
```

**Respuesta esperada** (HTTP 503):
```json
{
  "message": "The requested service is currently unavailable. This is a controlled fallback response.",
  "service": "customer-portal"
}
```

---

## 📡 Puertos y Routing

### Kong Gateway

| Puerto | Función                    | Tipo de Tráfico        |
|--------|----------------------------|------------------------|
| 80     | Proxy HTTP                 | Frontends (Portal+App) |
| 8090   | Proxy HTTP                 | Backend APIs           |
| 8001   | Admin API                  | Administración REST    |
| 8002   | Kong Manager               | Interfaz Web Visual    |
| 8443   | Proxy HTTPS                | SSL/TLS                |
| 8445   | Admin/Manager HTTPS        | SSL/TLS Admin          |

> **Nota**: Puerto 8090 para APIs porque 8080 está ocupado por Jenkins

### Prefijos de Ruta (Path-based routing)

| Prefijo       | Tipo de Servicio          | Puerto Kong |
|---------------|---------------------------|-------------|
| `/portal/*`   | Frontend Portales         | 80          |
| `/app/*`      | Frontend Apps (Mobile)    | 80          |
| `/api/*`      | Backend REST APIs         | 8090        |
| `/unavailable`| Fallback Service          | 80          |

### Servicios Individuales Expuestos

#### Portales (`:80` interno)
- `http://localhost:3001` - customer-portal
- `http://localhost:3002` - security-portal
- `http://localhost:4201` - inventory-portal
- `http://localhost:4202` - invoice-portal

#### Apps (`:8100/:8081/:9100` internos)
- `http://localhost:8101` - customer-app
- `http://localhost:8102` - security-app
- `http://localhost:8082` - inventory-app
- `http://localhost:9101` - invoice-app

#### APIs (`:5000/:9000` internos)
- `http://localhost:5001` - customer-api
- `http://localhost:5002` - security-api
- `http://localhost:5003` - inventory-api
- `http://localhost:9001` - invoice-api

---

## 🔧 Configuración

### Modo DB-less (Actual)

Kong usa configuración declarativa (`kong.yml`):
- Sin base de datos PostgreSQL
- Configuración en archivo YAML
- Cambios requieren reinicio de Kong
- Ideal para ambientes simples y CI/CD

### Estructura de `kong.yml`

```yaml
_format_version: "2.1"

services:
  - name: customer_api           # Nombre del servicio en Kong
    url: http://mock-customer-api:5000  # URL del upstream
    routes:
      - name: customer_api_route
        paths:
          - /api/customer        # Ruta pública
        strip_path: true         # Elimina /api/customer antes de proxy
```

---

## 🔄 Reemplazar Mocks con Servicios Reales

### Paso 1: Actualizar `kong.yml`

Cambiar la URL del servicio:

```yaml
# ANTES (Mock)
services:
  - name: customer_api
    url: http://mock-customer-api:5000

# DESPUÉS (Real)
services:
  - name: customer_api
    url: http://customer-api:5000
```

### Paso 2: Actualizar `docker-compose.yml`

Reemplazar servicio mock con servicio real:

```yaml
# ELIMINAR
mock-customer-api:
  build:
    context: .
    dockerfile: Dockerfile.mock
  environment:
    SERVICE_NAME: customer-api

# AGREGAR
customer-api:
  image: devops-customer-api:latest
  container_name: customer-api
  ports:
    - "5001:5000"
  networks:
    - gateway_net
  environment:
    - DATABASE_URL=postgresql://...
    - API_KEY=...
```

### Paso 3: Reiniciar Servicios

```powershell
docker compose up -d --force-recreate
```

---

## 🛠️ Comandos Útiles

### Gestión de Contenedores

```powershell
# Ver estado
docker compose ps

# Ver logs de Kong
docker logs kong -f

# Ver logs de un mock
docker logs mock-customer-api -f

# Reiniciar Kong
docker restart kong

# Detener todo
docker compose down

# Iniciar todo
docker compose up -d

# Reconstruir imágenes
docker compose up -d --build
```

### Kong Admin API

```powershell
# Listar servicios
Invoke-WebRequest -Uri "http://localhost:8001/services" -UseBasicParsing

# Listar rutas
Invoke-WebRequest -Uri "http://localhost:8001/routes" -UseBasicParsing

# Estado de Kong
Invoke-WebRequest -Uri "http://localhost:8001/status" -UseBasicParsing

# Información del nodo
Invoke-WebRequest -Uri "http://localhost:8001" -UseBasicParsing
```

---

## 📚 Documentación Adicional

- **GUIA_PRUEBAS.md**: Guía completa con todas las URLs de prueba y troubleshooting
- **.env.local**: Variables de entorno para desarrollo local
- **.env.dev**: Variables de entorno para ambiente dev

---

## 🐛 Troubleshooting

### Kong no inicia

```powershell
# Ver logs
docker logs kong

# Verificar sintaxis de kong.yml
docker run --rm -v ${PWD}/kong.yml:/tmp/kong.yml kong:latest kong config parse /tmp/kong.yml
```

### Ruta no funciona

```powershell
# Verificar que esté registrada
Invoke-WebRequest -Uri "http://localhost:8001/routes" -UseBasicParsing | ConvertFrom-Json

# Reiniciar Kong
docker restart kong
```

### Servicio no responde

```powershell
# Ver logs del servicio
docker logs mock-customer-api

# Verificar que esté en la red correcta
docker network inspect kong_gateway_net

# Verificar que esté corriendo
docker ps | Select-String "mock-customer"
```

### Error "no Route matched"

- Verificar path en `kong.yml`
- Verificar que `strip_path: true` esté configurado
- Reiniciar Kong después de cambios en config

---

## ✅ Checklist de Despliegue

- [x] Kong Gateway levantado y healthy
- [x] Kong Manager accesible (puerto 8002)
- [x] 13 servicios mock funcionando
- [x] Rutas `/portal/*` responden
- [x] Rutas `/app/*` responden
- [x] Rutas `/api/*` responden (puerto 8090)
- [x] Fallback `/unavailable` responde
- [x] Mensajes 503 controlados
- [x] Kong Admin API accesible (puerto 8001)
- [ ] Reemplazar mocks con servicios reales
- [ ] Configurar autenticación (JWT/OAuth)
- [ ] Habilitar rate limiting
- [ ] Configurar CORS
- [ ] Migrar a DB mode (PostgreSQL) para producción

---

## 📝 Notas Importantes

- ⚠️ **Puerto 8080**: Ocupado por Jenkins, por eso APIs en 8090
- ✅ **Strip Path**: Habilitado en todas las rutas (Kong elimina prefijo antes de proxy)
- ✅ **Health Checks**: Kong valida salud de upstreams
- ✅ **Fallback Messages**: Servicios mock retornan 503 con mensaje JSON controlado
- ✅ **Docker Network**: Todos los servicios deben estar en `gateway_net`
- ⚠️ **DB-less Mode**: Cambios en `kong.yml` requieren reinicio de Kong

---

## 🔗 Enlaces Útiles

- [Kong Documentation](https://docs.konghq.com/)
- [Kong DB-less Mode](https://docs.konghq.com/gateway/latest/production/deployment-topologies/db-less-and-declarative-config/)
- [Kong Admin API Reference](https://docs.konghq.com/gateway/latest/admin-api/)
- [Kong Declarative Config Format](https://docs.konghq.com/gateway/latest/production/deployment-topologies/db-less-and-declarative-config/#declarative-configuration-format)

---

**Versión**: 1.0  
**Fecha**: 18 de Octubre de 2025  
**Kong**: 3.6  
**Proyecto**: ShoppingCar DevOps
