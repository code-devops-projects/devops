# Script para auditoría y generación de changelog automático
$ErrorActionPreference = "Stop"
$projects = @("inventory", "penalty", "security")
$envs = @("dev", "qa", "staging", "prod")
$logFile = "audit-changelog.log"

function Get-FileHashOrNone($file) {
    if (Test-Path $file) {
        return (Get-FileHash $file -Algorithm SHA256).Hash
    } else {
        return "NO_EXISTE"
    }
}

$changes = @()
foreach ($project in $projects) {
    foreach ($env in $envs) {
        $envFile = "projects/$project/environments/$env/.env"
        $composeFile = "projects/$project/environments/$env/docker-compose.yml"
        $envHash = Get-FileHashOrNone $envFile
        $composeHash = Get-FileHashOrNone $composeFile
        $changes += [PSCustomObject]@{
            Fecha = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Proyecto = $project
            Entorno = $env
            Archivo = $envFile
            Hash = $envHash
        }
        $changes += [PSCustomObject]@{
            Fecha = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
            Proyecto = $project
            Entorno = $env
            Archivo = $composeFile
            Hash = $composeHash
        }
        $backupDir = "projects/$project/backups/$env"
        if (Test-Path $backupDir) {
            $files = Get-ChildItem $backupDir -Filter *.sql
            foreach ($file in $files) {
                $changes += [PSCustomObject]@{
                    Fecha = (Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
                    Proyecto = $project
                    Entorno = $env
                    Archivo = $file.FullName
                    Hash = Get-FileHashOrNone $file.FullName
                }
            }
        }
    }
}
$changes | Export-Csv -Path $logFile -NoTypeInformation -Encoding UTF8
Write-Host "Auditoría y changelog generado en $logFile"