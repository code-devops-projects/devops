# Script de ayuda para gestionar los ambientes de PostgreSQL
# Uso: .\manage.ps1 [ambiente] [acción]
# Ejemplos:
#   .\manage.ps1 prod up
#   .\manage.ps1 staging logs
#   .\manage.ps1 dev down

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet('prod', 'staging', 'qa', 'dev', 'all')]
    [string]$Ambiente,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet('up', 'down', 'logs', 'status', 'restart', 'rebuild', 'backup', 'validate-backup')]
    [string]$Accion
)

# Mapear ambiente a carpeta
$environmentPaths = @{
    'prod'    = 'environments\prod'
    'staging' = 'environments\staging'
    'qa'      = 'environments\qa'
    'dev'     = 'environments\dev'
    'all'     = '.'
}

$envPath = $environmentPaths[$Ambiente]
$originalPath = Get-Location

try {
    # Cambiar a la carpeta del ambiente
    Set-Location $envPath

    # Ejecutar acción
    switch ($Accion) {
        'up' {
            Write-Host "🚀 Levantando ambiente: $Ambiente" -ForegroundColor Green
            docker-compose up -d
        }
        'down' {
            Write-Host "⬇️  Deteniendo ambiente: $Ambiente" -ForegroundColor Yellow
            docker-compose down
        }
        'logs' {
            Write-Host "📋 Mostrando logs de: $Ambiente" -ForegroundColor Cyan
            docker-compose logs -f
        }
        'status' {
            Write-Host "📊 Estado de: $Ambiente" -ForegroundColor Magenta
            docker-compose ps
        }
        'restart' {
            Write-Host "🔄 Reiniciando ambiente: $Ambiente" -ForegroundColor Blue
            docker-compose restart
        }
        'rebuild' {
            Write-Host "🔨 Reconstruyendo ambiente: $Ambiente" -ForegroundColor DarkYellow
            docker-compose down
            docker-compose build --no-cache
            docker-compose up -d
        }
        'backup' {
            Write-Host "💾 Realizando backup de ambiente: $Ambiente" -ForegroundColor DarkGreen
            $backupDir = "../../backups/$Ambiente"
            if (!(Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir | Out-Null }
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $backupFile = "$backupDir/backup_$timestamp.sql"
            docker exec $(docker-compose ps -q postgres-$Ambiente) pg_dump -U ${env:POSTGRES_USER} ${env:POSTGRES_DB} > $backupFile
            if (Test-Path $backupFile) {
                Write-Host "Backup creado: $backupFile" -ForegroundColor Green
            } else {
                Write-Warning "No se pudo crear el backup."
            }
        }
        'validate-backup' {
            Write-Host "🔎 Validando backups de ambiente: $Ambiente" -ForegroundColor DarkCyan
            $backupDir = "../../backups/$Ambiente"
            if (!(Test-Path $backupDir)) {
                Write-Warning "No existe la carpeta de backups: $backupDir"
            } else {
                $files = Get-ChildItem $backupDir -Filter *.sql
                if ($files.Count -eq 0) {
                    Write-Warning "No hay backups en $backupDir"
                } else {
                    foreach ($file in $files) {
                        if ($file.Length -gt 0) {
                            Write-Host "Backup válido: $($file.Name) ($($file.Length) bytes)" -ForegroundColor Green
                        } else {
                            Write-Warning "Backup vacío: $($file.Name)"
                        }
                    }
                }
            }
        }
    }

    Write-Host "✅ Acción completada" -ForegroundColor Green
}
finally {
    # Volver a la carpeta original
    Set-Location $originalPath
}
