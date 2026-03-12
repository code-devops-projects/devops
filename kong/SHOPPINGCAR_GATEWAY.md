# Estandarización de Gateway — ShoppingCar

**Fecha:** 2025-10-18  
**Ámbitos:** `local`, `dev`, `qa`, `staging`, `main`  
**Gateway:** Kong escuchando **80** (Frontends: Portal/App) y **8090** (APIs).

---

## 📋 Resumen de Configuración

### Puertos Kong
- **80** → Frontends (Portal/App) - rutas `/portal/*` y `/app/*`
- **8090** → Backend APIs - rutas `/api/*` (cambiadoa 8090 por conflicto con Jenkins en 8080)
- **8001** → Kong Admin API
- **8002** → Kong Manager UI

---

## 🌐 Matriz de Enrutamiento

### Frontend PORTALES (Puerto 80 → `/portal/*`)

| Servicio           | Host:Puerto | Contenedor:Puerto | Ruta Kong                    | URL Acceso                          |
|--------------------|-------------|-------------------|------------------------------|-------------------------------------|
| `customer-portal`  | `3001`      | `80`              | `/portal/customer`           | http://localhost/portal/customer    |
| `security-portal`  | `3002`      | `80`              | `/portal/security`           | http://localhost/portal/security    |
| `inventory-portal` | `4201`      | `80`              | `/portal/inventory`          | http://localhost/portal/inventory   |
| `invoice-portal`   | `4202`      | `80`              | `/portal/invoice`            | http://localhost/portal/invoice     |

### Frontend APPS (Puerto 80 → `/app/*`)

| Servicio        | Host:Puerto | Contenedor:Puerto | Ruta Kong          | URL Acceso                    |
|-----------------|-------------|-------------------|--------------------|-------------------------------|
| `customer-app`  | `8101`      | `8100`            | `/app/customer`    | http://localhost/app/customer |
| `security-app`  | `8102`      | `8100`            | `/app/security`    | http://localhost/app/security |
| `inventory-app` | `8082`      | `8081`            | `/app/inventory`   | http://localhost/app/inventory|
| `invoice-app`   | `9101`      | `9100`            | `/app/invoice`     | http://localhost/app/invoice  |

### Backend APIs (Puerto 8090 → `/api/*`)

| Servicio        | Host:Puerto | Contenedor:Puerto | Ruta Kong           | URL Acceso                          |
|-----------------|-------------|-------------------|---------------------|-------------------------------------|
| `customer-api`  | `5001`      | `5000`            | `/api/customer`     | http://localhost:8090/api/customer  |
| `security-api`  | `5002`      | `5000`            | `/api/security`     | http://localhost:8090/api/security  |
| `inventory-api` | `5003`      | `5000`            | `/api/inventory`    | http://localhost:8090/api/inventory |
| `invoice-api`   | `9001`      | `9000`            | `/api/invoice`      | http://localhost:8090/api/invoice   |

---

## 🚀 Comandos de Ejecución

### Levantar SOLO Kong (sin servicios)
```bash
docker compose up -d kong
```

### Levantar Kong + TODOS los servicios
```bash
docker compose --profile full up -d --build
```

### Levantar Kong + Solo Portales
```bash
docker compose --profile portal up -d
```

### Levantar Kong + Solo Apps
```bash
docker compose --profile app up -d
```

### Levantar Kong + Solo APIs Backend
```bash
docker compose --profile api up -d
```

### Levantar Kong + Frontends (Portal + App)
```bash
docker compose --profile frontend up -d
```

### Levantar Kong + Backends (APIs)
```bash
docker compose --profile backend up -d
```

---

## 🔧 Verificación

### Verificar servicios registrados en Kong
```bash
curl http://localhost:8001/services | ConvertFrom-Json | Select-Object -ExpandProperty data | Select-Object name, protocol, host, port
```

### Verificar rutas registradas
```bash
curl http://localhost:8001/routes | ConvertFrom-Json | Select-Object -ExpandProperty data | Select-Object name, paths, protocols
```

### Verificar estado de contenedores
```bash
docker compose ps
```

### Ver logs de Kong
```bash
docker logs kong --tail 50 -f
```

---

## 🔐 Plugins Configurados

### Todos los servicios:
- ✅ **CORS** - Permite peticiones desde cualquier origen
- ✅ **Rate Limiting** (Solo APIs) - 100 peticiones/minuto

### Configuración CORS:
- **Origins:** `*` (todos los orígenes)
- **Methods:** GET, POST, PUT, DELETE, PATCH
- **Headers:** Accept, Authorization, Content-Type
- **Credentials:** true

---

## 📝 Notas Importantes

1. **Todos los servicios son opcionales** - Si la imagen no existe, no impedirá que Kong inicie
2. **restart: on-failure** - Los contenedores se reinician automáticamente en caso de fallo
3. **strip_path: false** - Las rutas se mantienen completas al hacer proxy
4. **Red compartida** - Todos usan `network_local_server` (debe existir previamente)

---

## 🛠️ Troubleshooting

### Si Kong no inicia:
```bash
docker logs kong
```

### Si un servicio no responde:
```bash
# Verificar que el contenedor esté corriendo
docker ps -a

# Ver logs del servicio específico
docker logs <nombre-contenedor>
```

### Recrear Kong con nueva configuración:
```bash
docker compose down
docker compose up -d --build kong
```

---

## ✅ Checklist de Verificación

- [ ] Red `network_local_server` existe
- [ ] Kong inicia correctamente en puerto 80 y 8080
- [ ] Kong Admin API accesible en puerto 8001
- [ ] Servicios se pueden consultar vía Admin API
- [ ] Rutas funcionan correctamente (probar con curl)
- [ ] CORS configurado para frontends
- [ ] Rate limiting activo en APIs
