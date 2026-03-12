# Script para validar configuración de ambientes y archivos clave
$ErrorActionPreference = "Stop"
$projects = @("inventory", "penalty", "security")
$envs = @("dev", "qa", "staging", "prod")
foreach ($project in $projects) {
    Write-Host "Validando proyecto: $project"
    foreach ($env in $envs) {
        $envPath = "projects/$project/environments/$env"
        $envFile = "$envPath/.env"
        $composeFile = "$envPath/docker-compose.yml"
        if (!(Test-Path $envFile)) {
            Write-Warning "Falta $envFile"
        }
        if (!(Test-Path $composeFile)) {
            Write-Warning "Falta $composeFile"
        }
        # Validar variables obligatorias en cada .env
        $requiredVars = @("POSTGRES_USER", "POSTGRES_PASSWORD", "POSTGRES_DB")
        if (Test-Path $envFile) {
            $lines = Get-Content $envFile
            foreach ($var in $requiredVars) {
                $found = $false
                foreach ($line in $lines) {
                    if ($line -match "^$var=(.+)") {
                        if ($matches[1].Trim() -eq "") {
                            Write-Warning "$($envFile): $($var) está vacío"
                        }
                        $found = $true
                        break
                    }
                }
                if (-not $found) {
                    Write-Warning "$($envFile): Falta variable $($var)"
                }
            }
            # Validar permisos inseguros en .env
            $acl = Get-Acl $envFile
            foreach ($ace in $acl.Access) {
                if ($ace.IdentityReference -eq 'Everyone' -and $ace.FileSystemRights -match 'Write') {
                    Write-Warning "$($envFile): Permisos inseguros (escritura para Everyone)"
                }
            }
            # Validar contraseñas expuestas o inseguras
            foreach ($line in $lines) {
                if ($line -match "^POSTGRES_PASSWORD=(.+)$") {
                    $pwd = $matches[1]
                    $commonPwds = @('password', '123456', 'postgres', 'admin', 'qwerty', 'letmein', 'test', 'root')
                    foreach ($common in $commonPwds) {
                        if ($pwd.ToLower() -eq $common) {
                            Write-Warning "$($envFile): Contraseña expuesta o común detectada ($pwd)"
                        }
                    }
                }
                # Validar formato de puertos
                if ($line -match "^PORT_([A-Z]+)=(\d+)$") {
                    $port = $matches[2]
                    if ([int]$port -lt 1024 -or [int]$port -gt 65535) {
                        Write-Warning "$($envFile): Puerto fuera de rango ($port)"
                    }
                }
            }
        }
    }
    $configFile = "projects/$project/environments/config/.env"
    if (!(Test-Path $configFile)) {
        Write-Warning "Falta $configFile"
    }
}
Write-Host "Validación completada."
