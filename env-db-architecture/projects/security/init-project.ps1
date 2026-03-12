# Script para inicializar un nuevo proyecto PostgreSQL multi-ambiente
# Uso: .\init-project.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

$ErrorActionPreference = "Stop"

Write-Host "\n╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   INICIALIZADOR DE PROYECTO POSTGRES MULTI-AMBIENTE  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝\n" -ForegroundColor Cyan

# Ruta al archivo de configuración global
$configFile = "environments\config\.env"

if (-not (Test-Path $configFile)) {
    Write-Host "❌ Error: No se encontró el archivo $configFile" -ForegroundColor Red
    exit 1
}

# Leer configuración global
$configLines = Get-Content $configFile

# Actualizar PROJECT_NAME en config/.env
$newConfig = $configLines | ForEach-Object {
    if ($_ -match '^PROJECT_NAME=') {
        "PROJECT_NAME=$ProjectName"
    } else {
        $_
    }
}
$newConfig | Set-Content $configFile -Encoding UTF8
Write-Host "✅ PROJECT_NAME actualizado en $configFile" -ForegroundColor Green

# Sincronizar a todos los ambientes
Write-Host "🔄 Ejecutando sync-config.ps1 para propagar cambios..." -ForegroundColor Yellow
& .\sync-config.ps1


Write-Host "\n✅ Proyecto inicializado correctamente: $ProjectName" -ForegroundColor Green
Write-Host "\nLevantando todos los ambientes..." -ForegroundColor Cyan

& .\manage.ps1 dev up
& .\manage.ps1 qa up
& .\manage.ps1 staging up
& .\manage.ps1 prod up

Write-Host "\nTodos los ambientes han sido levantados." -ForegroundColor Green
Write-Host "Puedes editar más variables en $configFile y volver a ejecutar este script si lo necesitas." -ForegroundColor Yellow
