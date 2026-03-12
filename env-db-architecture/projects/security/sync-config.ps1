# Script para sincronizar la configuración global desde config/.env
# a todos los ambientes (dev, qa, staging, prod)
#
# Uso: .\sync-config.ps1

$ErrorActionPreference = "Stop"

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   SINCRONIZADOR DE CONFIGURACIÓN GLOBAL               ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Ruta al archivo de configuración global
$configFile = "environments\config\.env"

if (-not (Test-Path $configFile)) {
    Write-Host "❌ Error: No se encontró el archivo $configFile" -ForegroundColor Red
    exit 1
}

# Leer configuración global
Write-Host "📖 Leyendo configuración global desde: $configFile" -ForegroundColor Yellow
$globalConfig = Get-Content $configFile | Where-Object {
    $_ -notmatch '^\s*#' -and $_ -notmatch '^\s*$'
}

# Ambientes a actualizar
$environments = @('dev', 'qa', 'staging', 'prod')

# Configuración específica de cada ambiente (solo contraseñas)
$envPasswords = @{
    'dev' = 'dev_Str0ng_S3cr3t_2024'
    'qa' = 'qa_S3cur3_P@ss_2024'
    'staging' = 'stg_Str0ng_S3cr3t_2024'
    'prod' = 'prd_Str0ng_S3cr3t_2024'
}

foreach ($env in $environments) {
    $envFile = "environments\$env\.env"
    
    Write-Host "`n🔄 Actualizando $env..." -ForegroundColor Cyan
    
    # Crear contenido del archivo
    $content = @"
# ============================================
# CONFIGURACIÓN GLOBAL (sincronizada desde config/.env)
# ============================================
# ⚠️  NO EDITAR MANUALMENTE ESTA SECCIÓN
# Para cambios globales, edita environments/config/.env
# y ejecuta sync-config.ps1
# ============================================

"@
    
    # Agregar variables globales
    foreach ($line in $globalConfig) {
        $content += "$line`n"
    }
    
    # Agregar configuración específica del ambiente
    $content += @"

# ============================================
# CONFIGURACIÓN ESPECÍFICA DE $($env.ToUpper())
# ============================================
# Puedes editar esta sección manualmente

POSTGRES_PASSWORD=$($envPasswords[$env])
"@
    
    # Guardar archivo
    $content | Out-File -FilePath $envFile -Encoding UTF8 -NoNewline
    
    Write-Host "   ✅ $envFile actualizado" -ForegroundColor Green
}

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✅ SINCRONIZACIÓN COMPLETADA                         ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "📝 Cambios aplicados a:" -ForegroundColor Yellow
foreach ($env in $environments) {
    Write-Host "   • environments/$env/.env" -ForegroundColor White
}

Write-Host "`n💡 Para aplicar los cambios, reinicia los contenedores:" -ForegroundColor Cyan
Write-Host "   .\manage.ps1 dev rebuild" -ForegroundColor White
Write-Host ""
