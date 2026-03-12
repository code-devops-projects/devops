# Guía de Pruebas - Kong API Gateway ShoppingCar

## 🚀 Estado del Despliegue

✅ **Kong Gateway desplegado exitosamente**
- Kong: `kong:latest` con Kong Manager (DB-less mode)
- 13 servicios mock funcionando
- Red: `gateway_net`
- Configuración: `kong.yml`

---

## 📡 Puertos Expuestos

### Kong Gateway
- **Puerto 80**: Frontends (Portal y App)
- **Puerto 8090**: Backend APIs
- **Puerto 8001**: Kong Admin API
- **Puerto 8002**: Kong Manager (UI)

### Servicios Mock (Individuales)
Los servicios mock también están expuestos directamente para pruebas:

#### Portales (Puerto :80 interno)
- `http://localhost:3001` → customer-portal
- `http://localhost:3002` → security-portal
- `http://localhost:4201` → inventory-portal
- `http://localhost:4202` → invoice-portal

#### Apps (Puertos :8100/:8081/:9100 internos)
- `http://localhost:8101` → customer-app
- `http://localhost:8102` → security-app
- `http://localhost:8082` → inventory-app
- `http://localhost:9101` → invoice-app

#### APIs (Puertos :5000/:9000 internos)
- `http://localhost:5001` → customer-api
- `http://localhost:5002` → security-api
- `http://localhost:5003` → inventory-api
- `http://localhost:9001` → invoice-api

#### Fallback
- `http://localhost:5999` → fallback service

---

## 🧪 URLs de Prueba a través de Kong

### Portal Services (Puerto 80)
```powershell
# Customer Portal
Invoke-WebRequest -Uri "http://localhost/portal/customer" -UseBasicParsing

# Security Portal
Invoke-WebRequest -Uri "http://localhost/portal/security" -UseBasicParsing

# Inventory Portal
Invoke-WebRequest -Uri "http://localhost/portal/inventory" -UseBasicParsing

# Invoice Portal
Invoke-WebRequest -Uri "http://localhost/portal/invoice" -UseBasicParsing
```

### App Services (Puerto 80)
```powershell
# Customer App
Invoke-WebRequest -Uri "http://localhost/app/customer" -UseBasicParsing

# Security App
Invoke-WebRequest -Uri "http://localhost/app/security" -UseBasicParsing

# Inventory App
Invoke-WebRequest -Uri "http://localhost/app/inventory" -UseBasicParsing

# Invoice App
Invoke-WebRequest -Uri "http://localhost/app/invoice" -UseBasicParsing
```

### Backend APIs (Puerto 8090)
```powershell
# Customer API
Invoke-WebRequest -Uri "http://localhost:8090/api/customer" -UseBasicParsing

# Security API
Invoke-WebRequest -Uri "http://localhost:8090/api/security" -UseBasicParsing

# Inventory API
Invoke-WebRequest -Uri "http://localhost:8090/api/inventory" -UseBasicParsing

# Invoice API
Invoke-WebRequest -Uri "http://localhost:8090/api/invoice" -UseBasicParsing
```

### Fallback Service (Puerto 80)
```powershell
# Servicio de fallback explícito
Invoke-WebRequest -Uri "http://localhost/unavailable" -UseBasicParsing
```

---

## ✅ Respuestas Esperadas

Todos los servicios mock retornan un mensaje JSON con código **HTTP 503** (Service Unavailable):

```json
{
  "message": "The requested service is currently unavailable. This is a controlled fallback response.",
  "service": "customer-portal"
}
```

Este es el comportamiento esperado cuando los servicios reales no están desplegados aún.

---

## 🔧 Comandos de Administración

### Ver estado de contenedores
```powershell
docker compose ps
```

### Ver logs de Kong
```powershell
docker logs kong
docker logs kong -f  # seguir logs en tiempo real
```

### Ver logs de un servicio mock específico
```powershell
docker logs mock-customer-api
docker logs mock-customer-portal
# etc...
```

### Reiniciar Kong Gateway
```powershell
docker restart kong
```

### Detener todos los servicios
```powershell
cd c:\www\devops-code-project\devops\kong
docker compose down
```

### Iniciar todos los servicios
```powershell
cd c:\www\devops-code-project\devops\kong
docker compose up -d
```

### Reconstruir servicios mock
```powershell
cd c:\www\devops-code-project\devops\kong
docker compose up -d --build
```

---

## 🔍 Kong Admin API

### Listar todos los servicios configurados
```powershell
Invoke-WebRequest -Uri "http://localhost:8001/services" -UseBasicParsing | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

### Listar todas las rutas configuradas
```powershell
Invoke-WebRequest -Uri "http://localhost:8001/routes" -UseBasicParsing | ConvertFrom-Json | ConvertTo-Json -Depth 10
```

### Ver salud de Kong
```powershell
Invoke-WebRequest -Uri "http://localhost:8001/status" -UseBasicParsing
```

---

## 📋 Estándar ShoppingCar Implementado

### Prefijos de Ruta
- `/portal/*` → Portales frontend (Angular/React/Vue)
- `/app/*` → Aplicaciones frontend (Ionic/Mobile)
- `/api/*` → Backend APIs (REST/GraphQL)
- `/unavailable` → Servicio de fallback explícito

### Mapeo de Puertos
```
Puerto Host → Puerto Kong → Tipo de Servicio
─────────────────────────────────────────────
80         → 8000       → Frontends (portals + apps)
8090       → 8000       → Backend APIs
8001       → 8001       → Kong Admin API
```

### Comportamiento de Fallback
Cuando un servicio real no está disponible:
1. Kong intenta conectar al servicio backend definido
2. Si falla, retorna un mensaje controlado con HTTP 503
3. El mensaje JSON identifica el servicio que no está disponible
4. La aplicación frontend puede mostrar un mensaje amigable al usuario

---

## 🎯 Próximos Pasos

### Para Reemplazar Servicios Mock con Servicios Reales:

1. **Actualizar `kong.yml`**:
   - Cambiar `url: http://mock-customer-api:5000` 
   - Por `url: http://customer-api:5000` (nombre del contenedor real)

2. **Actualizar `docker-compose.yml`**:
   - Reemplazar servicios `mock-*` con los contenedores reales
   - Mantener los mismos nombres de servicio en la red
   - Asegurar que usen la red `gateway_net`

3. **Ejemplo para Customer API**:
   ```yaml
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

4. **Reiniciar servicios**:
   ```powershell
   docker compose up -d --force-recreate
   ```

---

## 📝 Notas Importantes

- ⚠️ **Puerto 8080 ocupado por Jenkins**: Por eso los APIs backend están en puerto 8090
- ✅ **Modo DB-less**: Kong usa configuración declarativa (`kong.yml`)
- ✅ **Strip Path habilitado**: Las rutas eliminan el prefijo antes de enviar al backend
- ✅ **Health checks**: Kong marca servicios como `healthy` cuando responden correctamente
- ✅ **Docker Networks**: Todos los servicios deben estar en la red `gateway_net`
- ✅ **Kong Manager**: Interfaz web disponible en http://localhost:8002

---

## 🐛 Troubleshooting

### Error: "no Route matched with those values"
- Verificar que la ruta esté definida en `kong.yml`
- Reiniciar Kong: `docker restart kong`

### Error: "Service Unavailable" sin JSON
- Verificar que el servicio mock/real esté corriendo
- Ver logs: `docker logs mock-customer-api`
- Verificar red: `docker network inspect kong_gateway_net`

### Kong no inicia
- Ver logs: `docker logs kong`
- Verificar sintaxis de `kong.yml`
- Verificar permisos del archivo montado

### Servicios mock no responden
- Ver estado: `docker compose ps`
- Reconstruir: `docker compose up -d --build`

---

**Fecha de creación**: 18 de Octubre de 2025  
**Versión Kong**: latest (con Kong Manager)  
**Modo**: DB-less (Declarative Configuration)  
**Proyecto**: ShoppingCar DevOps Gateway
