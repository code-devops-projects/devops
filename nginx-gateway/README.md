# Nginx API Gateway

Esta configuración implementa un API Gateway usando Nginx como proxy inverso para gestionar múltiples servicios backend.

## Estructura del Proyecto

```
nginx-gateway/
├── docker-compose.yml    # Configuración de servicios Docker
├── Dockerfile           # Configuración de la imagen Nginx
├── nginx.conf          # Configuración principal de Nginx
├── ssl/                # Directorio para certificados SSL
└── README.md           # Este archivo
```

## Características

- Proxy inverso con Nginx
- Soporte para HTTPS
- Redirección automática de HTTP a HTTPS
- Configuración de CORS
- Headers de seguridad
- Balanceo de carga básico
- Timeouts configurables
- Páginas de error personalizadas

## Endpoints

- Servicio de Seguridad: `https://localhost/api/security/`
- Servicio de Ubicación: `https://localhost/api/ubication/`

## Requisitos

- Docker
- Docker Compose
- Certificados SSL (colocar en el directorio `ssl/`)

## Configuración SSL

Colocar los siguientes archivos en el directorio `ssl/`:
- `server.crt`: Certificado SSL
- `server.key`: Llave privada SSL

## Uso

1. Colocar los certificados SSL en el directorio `ssl/`
2. Ejecutar:
   ```bash
   docker-compose up -d
   ```

## Configuración de Servicios Backend

Los servicios backend deben estar disponibles en la red `network_local_server` y escuchar en el puerto 9000.

## Seguridad

- TLS 1.2 y 1.3 habilitados
- Headers de seguridad configurados
- CORS configurado
- Redirección forzada a HTTPS 