# Kong Admin - PowerShell Interactive Script
# Administración visual de Kong Gateway desde PowerShell

$KONG_ADMIN_URL = "http://localhost:8001"

function Show-Menu {
    Clear-Host
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "     KONG GATEWAY - ADMINISTRACIÓN INTERACTIVA" -ForegroundColor Cyan
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
    Write-Host " [1] Ver Todos los Servicios" -ForegroundColor Green
    Write-Host " [2] Ver Todas las Rutas" -ForegroundColor Green
    Write-Host " [3] Ver Estado de Kong" -ForegroundColor Green
    Write-Host " [4] Ver Plugins" -ForegroundColor Green
    Write-Host " [5] Ver Servicio Específico" -ForegroundColor Yellow
    Write-Host " [6] Ver Rutas de un Servicio" -ForegroundColor Yellow
    Write-Host " [7] Crear Nuevo Servicio" -ForegroundColor Magenta
    Write-Host " [8] Crear Nueva Ruta" -ForegroundColor Magenta
    Write-Host " [9] Probar Ruta (curl)" -ForegroundColor Blue
    Write-Host " [0] Salir" -ForegroundColor Red
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════" -ForegroundColor Cyan
}

function Get-KongServices {
    Write-Host "`n📋 Obteniendo servicios de Kong..." -ForegroundColor Cyan
    try {
        $response = Invoke-RestMethod -Uri "$KONG_ADMIN_URL/services" -Method GET
        Write-Host "`n✅ Total de servicios: $($response.data.Count)" -ForegroundColor Green
        Write-Host "`n$('═' * 80)" -ForegroundColor Cyan
        $response.data | Format-Table @{
            Label = "Nombre"
            Expression = { $_.name }
            Width = 20
        }, @{
            Label = "ID"
            Expression = { $_.id.Substring(0, 8) + "..." }
            Width = 15
        }, @{
            Label = "URL"
            Expression = { $_.protocol + "://" + $_.host + ":" + $_.port }
            Width = 40
        } -AutoSize
    }
    catch {
        Write-Host "❌ Error al obtener servicios: $_" -ForegroundColor Red
    }
}

function Get-KongRoutes {
    Write-Host "`n📋 Obteniendo rutas de Kong..." -ForegroundColor Cyan
    try {
        $response = Invoke-RestMethod -Uri "$KONG_ADMIN_URL/routes" -Method GET
        Write-Host "`n✅ Total de rutas: $($response.data.Count)" -ForegroundColor Green
        Write-Host "`n$('═' * 100)" -ForegroundColor Cyan
        $response.data | Format-Table @{
            Label = "Nombre"
            Expression = { $_.name }
            Width = 25
        }, @{
            Label = "Paths"
            Expression = { $_.paths -join ', ' }
            Width = 30
        }, @{
            Label = "Strip Path"
            Expression = { $_.strip_path }
            Width = 12
        }, @{
            Label = "Service"
            Expression = { 
                if ($_.service) {
                    $svcId = $_.service.id
                    try {
                        $svc = Invoke-RestMethod -Uri "$KONG_ADMIN_URL/services/$svcId" -Method GET -ErrorAction SilentlyContinue
                        $svc.name
                    } catch {
                        $svcId.Substring(0, 8) + "..."
                    }
                } else {
                    "N/A"
                }
            }
            Width = 20
        } -AutoSize
    }
    catch {
        Write-Host "❌ Error al obtener rutas: $_" -ForegroundColor Red
    }
}

function Get-KongStatus {
    Write-Host "`n📊 Obteniendo estado de Kong..." -ForegroundColor Cyan
    try {
        $status = Invoke-RestMethod -Uri "$KONG_ADMIN_URL/status" -Method GET
        $info = Invoke-RestMethod -Uri "$KONG_ADMIN_URL" -Method GET
        
        Write-Host "`n✅ Kong Gateway Status" -ForegroundColor Green
        Write-Host "`n$('═' * 60)" -ForegroundColor Cyan
        Write-Host "Versión:" -ForegroundColor Yellow -NoNewline
        Write-Host " $($info.version)" -ForegroundColor White
        Write-Host "Hostname:" -ForegroundColor Yellow -NoNewline
        Write-Host " $($info.hostname)" -ForegroundColor White
        Write-Host "Node ID:" -ForegroundColor Yellow -NoNewline
        Write-Host " $($info.node_id)" -ForegroundColor White
        Write-Host "`n📊 Base de Datos:" -ForegroundColor Cyan
        $status.database | Format-List
        Write-Host "`n📊 Server:" -ForegroundColor Cyan
        $status.server | Format-List
    }
    catch {
        Write-Host "❌ Error al obtener estado: $_" -ForegroundColor Red
    }
}

function Get-KongPlugins {
    Write-Host "`n📦 Obteniendo plugins de Kong..." -ForegroundColor Cyan
    try {
        $response = Invoke-RestMethod -Uri "$KONG_ADMIN_URL/plugins" -Method GET
        Write-Host "`n✅ Total de plugins configurados: $($response.data.Count)" -ForegroundColor Green
        
        if ($response.data.Count -eq 0) {
            Write-Host "`n⚠️  No hay plugins configurados aún." -ForegroundColor Yellow
        } else {
            Write-Host "`n$('═' * 80)" -ForegroundColor Cyan
            $response.data | Format-Table name, enabled, @{
                Label = "Service"
                Expression = { if ($_.service) { $_.service.name } else { "Global" } }
            } -AutoSize
        }
    }
    catch {
        Write-Host "❌ Error al obtener plugins: $_" -ForegroundColor Red
    }
}

function Get-SpecificService {
    Write-Host "`n🔍 Ver Servicio Específico" -ForegroundColor Cyan
    $serviceName = Read-Host "Ingrese el nombre del servicio"
    
    if ([string]::IsNullOrWhiteSpace($serviceName)) {
        Write-Host "❌ Nombre de servicio no válido" -ForegroundColor Red
        return
    }
    
    Write-Host "`n📋 Obteniendo servicio '$serviceName'..." -ForegroundColor Cyan
    try {
        $service = Invoke-RestMethod -Uri "$KONG_ADMIN_URL/services/$serviceName" -Method GET
        Write-Host "`n✅ Servicio encontrado" -ForegroundColor Green
        Write-Host "`n$('═' * 60)" -ForegroundColor Cyan
        $service | Format-List name, id, protocol, host, port, path, enabled
    }
    catch {
        Write-Host "❌ Error: Servicio '$serviceName' no encontrado" -ForegroundColor Red
    }
}

function Get-ServiceRoutes {
    Write-Host "`n🔍 Ver Rutas de un Servicio" -ForegroundColor Cyan
    $serviceName = Read-Host "Ingrese el nombre del servicio"
    
    if ([string]::IsNullOrWhiteSpace($serviceName)) {
        Write-Host "❌ Nombre de servicio no válido" -ForegroundColor Red
        return
    }
    
    Write-Host "`n📋 Obteniendo rutas de '$serviceName'..." -ForegroundColor Cyan
    try {
        $response = Invoke-RestMethod -Uri "$KONG_ADMIN_URL/services/$serviceName/routes" -Method GET
        Write-Host "`n✅ Total de rutas: $($response.data.Count)" -ForegroundColor Green
        Write-Host "`n$('═' * 80)" -ForegroundColor Cyan
        $response.data | Format-Table name, @{
            Label = "Paths"
            Expression = { $_.paths -join ', ' }
        }, strip_path -AutoSize
    }
    catch {
        Write-Host "❌ Error: Servicio '$serviceName' no encontrado" -ForegroundColor Red
    }
}

function New-KongService {
    Write-Host "`n➕ Crear Nuevo Servicio" -ForegroundColor Cyan
    Write-Host "`n$('═' * 60)" -ForegroundColor Cyan
    
    $name = Read-Host "Nombre del servicio"
    $url = Read-Host "URL del servicio (ej: http://my-api:5000)"
    
    if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($url)) {
        Write-Host "❌ Datos no válidos" -ForegroundColor Red
        return
    }
    
    Write-Host "`n📝 Creando servicio '$name'..." -ForegroundColor Cyan
    try {
        $body = @{
            name = $name
            url = $url
        } | ConvertTo-Json
        
        $service = Invoke-RestMethod -Uri "$KONG_ADMIN_URL/services" `
            -Method POST `
            -Body $body `
            -ContentType "application/json"
        
        Write-Host "`n✅ Servicio creado exitosamente" -ForegroundColor Green
        $service | Format-List name, id, url
    }
    catch {
        Write-Host "❌ Error al crear servicio: $_" -ForegroundColor Red
    }
}

function New-KongRoute {
    Write-Host "`n➕ Crear Nueva Ruta" -ForegroundColor Cyan
    Write-Host "`n$('═' * 60)" -ForegroundColor Cyan
    
    $serviceName = Read-Host "Nombre del servicio"
    $routeName = Read-Host "Nombre de la ruta"
    $path = Read-Host "Path (ej: /api/myservice)"
    $stripPath = Read-Host "Strip path? (s/n)"
    
    if ([string]::IsNullOrWhiteSpace($serviceName) -or 
        [string]::IsNullOrWhiteSpace($routeName) -or 
        [string]::IsNullOrWhiteSpace($path)) {
        Write-Host "❌ Datos no válidos" -ForegroundColor Red
        return
    }
    
    Write-Host "`n📝 Creando ruta '$routeName'..." -ForegroundColor Cyan
    try {
        $body = @{
            name = $routeName
            paths = @($path)
            strip_path = ($stripPath -eq "s")
        } | ConvertTo-Json
        
        $route = Invoke-RestMethod -Uri "$KONG_ADMIN_URL/services/$serviceName/routes" `
            -Method POST `
            -Body $body `
            -ContentType "application/json"
        
        Write-Host "`n✅ Ruta creada exitosamente" -ForegroundColor Green
        $route | Format-List name, id, paths, strip_path
    }
    catch {
        Write-Host "❌ Error al crear ruta: $_" -ForegroundColor Red
    }
}

function Test-KongRoute {
    Write-Host "`n🧪 Probar Ruta" -ForegroundColor Cyan
    Write-Host "`n$('═' * 60)" -ForegroundColor Cyan
    
    $path = Read-Host "Path a probar (ej: /portal/customer)"
    $port = Read-Host "Puerto (80 para frontends, 8090 para APIs)"
    
    if ([string]::IsNullOrWhiteSpace($path)) {
        Write-Host "❌ Path no válido" -ForegroundColor Red
        return
    }
    
    $url = "http://localhost:$port$path"
    Write-Host "`n📡 Probando: $url" -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        Write-Host "`n✅ Respuesta HTTP $($response.StatusCode)" -ForegroundColor Green
        Write-Host "`n$('═' * 60)" -ForegroundColor Cyan
        Write-Host $response.Content
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "`n⚠️  Respuesta HTTP $statusCode" -ForegroundColor Yellow
        
        if ($_.ErrorDetails.Message) {
            Write-Host "`n$('═' * 60)" -ForegroundColor Cyan
            Write-Host $_.ErrorDetails.Message
        }
    }
}

# Main Loop
do {
    Show-Menu
    $choice = Read-Host "Seleccione una opción"
    
    switch ($choice) {
        "1" { Get-KongServices; Read-Host "`nPresione Enter para continuar" }
        "2" { Get-KongRoutes; Read-Host "`nPresione Enter para continuar" }
        "3" { Get-KongStatus; Read-Host "`nPresione Enter para continuar" }
        "4" { Get-KongPlugins; Read-Host "`nPresione Enter para continuar" }
        "5" { Get-SpecificService; Read-Host "`nPresione Enter para continuar" }
        "6" { Get-ServiceRoutes; Read-Host "`nPresione Enter para continuar" }
        "7" { New-KongService; Read-Host "`nPresione Enter para continuar" }
        "8" { New-KongRoute; Read-Host "`nPresione Enter para continuar" }
        "9" { Test-KongRoute; Read-Host "`nPresione Enter para continuar" }
        "0" { 
            Write-Host "`n👋 ¡Hasta luego!" -ForegroundColor Cyan
            break 
        }
        default { 
            Write-Host "`n❌ Opción no válida" -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($choice -ne "0")
