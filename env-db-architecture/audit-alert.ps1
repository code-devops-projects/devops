# Script para alertas automáticas ante cambios inesperados en archivos críticos
$ErrorActionPreference = "Stop"
$logFile = "audit-changelog.log"
$alertFile = "audit-alert.log"

# Cargar el log actual
if (!(Test-Path $logFile)) {
    Write-Host "No existe el changelog. Ejecute primero audit-changelog.ps1."
    exit 1
}
$entries = Import-Csv $logFile

# Cargar el último estado conocido
$stateFile = "audit-state.json"
$lastState = @{}
if (Test-Path $stateFile) {
    $rawState = Get-Content $stateFile | ConvertFrom-Json
    foreach ($prop in $rawState.PSObject.Properties) {
        $lastState[$prop.Name] = $prop.Value
    }
}

$alerts = @()
foreach ($entry in $entries) {
    $key = "$($entry.Proyecto)-$($entry.Entorno)-$($entry.Archivo)"
    $hash = $entry.Hash
    if ($lastState.ContainsKey($key)) {
        if ($lastState[$key] -ne $hash) {
            $alerts += "ALERTA: Cambio detectado en $key ($($entry.Fecha))"
        }
    }
    $lastState[$key] = $hash
}

# Guardar el nuevo estado
$lastState | ConvertTo-Json | Set-Content $stateFile

# Registrar alertas
if ($alerts.Count -gt 0) {
    $alerts | Out-File -Append $alertFile
    Write-Warning "Cambios inesperados detectados. Revise $alertFile."
} else {
    Write-Host "Sin cambios inesperados."
}