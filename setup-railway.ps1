# Guia para configurar PostgreSQL en Railway

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CONFIGURAR POSTGRESQL EN RAILWAY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "PASOS A SEGUIR:" -ForegroundColor Yellow
Write-Host ""

Write-Host "PASO 1: Ir a Railway" -ForegroundColor Green
Write-Host "  - Abre: https://railway.app/" -ForegroundColor White
Write-Host "  - Inicia sesion con tu cuenta" -ForegroundColor White
Write-Host "  - Selecciona tu proyecto nutritrack-v2" -ForegroundColor White
Write-Host ""

Write-Host "PASO 2: Agregar PostgreSQL" -ForegroundColor Green
Write-Host "  - Click en el boton + New" -ForegroundColor White
Write-Host "  - Selecciona Database" -ForegroundColor White
Write-Host "  - Elige Add PostgreSQL" -ForegroundColor White
Write-Host "  - Espera a que se despliegue (circulo verde)" -ForegroundColor White
Write-Host ""

Write-Host "PASO 3: Verificar Conexion" -ForegroundColor Green
Write-Host "  - Debe aparecer una linea conectando:" -ForegroundColor White
Write-Host "    [nutritrack-v2] <-> [PostgreSQL]" -ForegroundColor Cyan
Write-Host ""

Write-Host "PASO 4: Verificar Variables" -ForegroundColor Green
Write-Host "  - Click en nutritrack-v2" -ForegroundColor White
Write-Host "  - Ve a la pestana Variables" -ForegroundColor White
Write-Host "  - Verifica que existan:" -ForegroundColor White
Write-Host "    * DATABASE_URL (auto-creada)" -ForegroundColor Cyan
Write-Host "    * JWT_SECRET" -ForegroundColor Cyan
Write-Host "    * FRONTEND_URL = https://nutritrack-v2.vercel.app" -ForegroundColor Cyan
Write-Host ""

Write-Host "PASO 5: Esperar Redespliegue" -ForegroundColor Green
Write-Host "  Verificando si el servidor esta listo..." -ForegroundColor Yellow
Write-Host ""

$attempts = 0
$maxAttempts = 15
$ready = $false

while ($attempts -lt $maxAttempts -and -not $ready) {
    $attempts++
    Write-Host "  Intento $attempts de $maxAttempts..." -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri "https://nutritrack-v2-production.up.railway.app/api/init/status" -Method Get -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            $ready = $true
            Write-Host "  Servidor listo!" -ForegroundColor Green
        }
    } catch {
        Write-Host "  Aun desplegando..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
    }
}

Write-Host ""
if ($ready) {
    Write-Host "CONFIGURACION COMPLETADA!" -ForegroundColor Green
    Write-Host ""
    Write-Host "SIGUIENTE PASO:" -ForegroundColor Yellow
    Write-Host "  Ejecuta: .\init-database-prod.ps1" -ForegroundColor Cyan
} else {
    Write-Host "El servidor aun esta desplegando" -ForegroundColor Yellow
    Write-Host "Espera 2-3 minutos y luego ejecuta:" -ForegroundColor White
    Write-Host "  .\init-database-prod.ps1" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Presiona Enter para continuar..." -ForegroundColor White
Read-Host
