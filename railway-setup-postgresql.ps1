# ============================================================================
# GUÍA PASO A PASO: Configurar PostgreSQL en Railway
# ============================================================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CONFIGURAR POSTGRESQL EN RAILWAY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 PASOS A SEGUIR:" -ForegroundColor Yellow
Write-Host ""

Write-Host "1️⃣  Ir a Railway" -ForegroundColor Green
Write-Host "   👉 Abre: https://railway.app/" -ForegroundColor White
Write-Host "   👉 Inicia sesión con tu cuenta" -ForegroundColor White
Write-Host "   👉 Selecciona tu proyecto 'nutritrack-v2'" -ForegroundColor White
Write-Host ""
Write-Host "   Presiona Enter cuando estés en tu proyecto..." -ForegroundColor Yellow
Read-Host

Write-Host "2️⃣  Agregar Base de Datos PostgreSQL" -ForegroundColor Green
Write-Host "   👉 En tu proyecto, busca el botón '+ New' o '+ Add Service'" -ForegroundColor White
Write-Host "   👉 Selecciona 'Database'" -ForegroundColor White
Write-Host "   👉 Elige 'Add PostgreSQL'" -ForegroundColor White
Write-Host "   👉 Railway creará automáticamente:" -ForegroundColor White
Write-Host "      - Una nueva base de datos PostgreSQL" -ForegroundColor Cyan
Write-Host "      - La variable DATABASE_URL" -ForegroundColor Cyan
Write-Host "      - La conexión entre tu servicio y PostgreSQL" -ForegroundColor Cyan
Write-Host ""
Write-Host "   ⚠️  IMPORTANTE: Espera a que PostgreSQL termine de desplegarse" -ForegroundColor Yellow
Write-Host "   (Verás un círculo verde cuando esté listo)" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Presiona Enter cuando PostgreSQL esté desplegado..." -ForegroundColor Yellow
Read-Host

Write-Host "3️⃣  Verificar Conexión Automática" -ForegroundColor Green
Write-Host "   👉 Deberías ver una LÍNEA conectando:" -ForegroundColor White
Write-Host "      [Tu Servicio nutritrack-v2] ←→ [PostgreSQL]" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Si NO ves la línea de conexión:" -ForegroundColor Yellow
Write-Host "   👉 Click en tu servicio 'nutritrack-v2'" -ForegroundColor White
Write-Host "   👉 Ve a la pestaña 'Settings'" -ForegroundColor White
Write-Host "   👉 Busca 'Service Connections' o 'Connect to PostgreSQL'" -ForegroundColor White
Write-Host "   👉 Conecta el servicio PostgreSQL" -ForegroundColor White
Write-Host ""
Write-Host "   Presiona Enter cuando veas la conexión..." -ForegroundColor Yellow
Read-Host

Write-Host "4️⃣  Verificar Variable DATABASE_URL" -ForegroundColor Green
Write-Host "   👉 Click en tu servicio 'nutritrack-v2'" -ForegroundColor White
Write-Host "   👉 Ve a la pestaña 'Variables'" -ForegroundColor White
Write-Host "   👉 Busca la variable 'DATABASE_URL'" -ForegroundColor White
Write-Host "   👉 Debe verse algo como:" -ForegroundColor White
Write-Host "      postgresql://postgres:password@containers...railway.app:5432/railway" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Si NO existe DATABASE_URL:" -ForegroundColor Yellow
Write-Host "   👉 Ve al servicio PostgreSQL" -ForegroundColor White
Write-Host "   👉 Pestaña 'Connect'" -ForegroundColor White
Write-Host "   👉 Copia el 'DATABASE_URL' (Public URL)" -ForegroundColor White
Write-Host "   👉 Ve a tu servicio 'nutritrack-v2' → Variables" -ForegroundColor White
Write-Host "   👉 Agrega nueva variable: DATABASE_URL = [el URL copiado]" -ForegroundColor White
Write-Host ""
Write-Host "   Presiona Enter cuando DATABASE_URL esté configurada..." -ForegroundColor Yellow
Read-Host

Write-Host "5️⃣  Verificar Otras Variables de Entorno" -ForegroundColor Green
Write-Host "   En tu servicio 'nutritrack-v2' → Variables, asegúrate de tener:" -ForegroundColor White
Write-Host ""
Write-Host "   ✅ DATABASE_URL" -ForegroundColor Green
Write-Host "      (creada automáticamente por Railway)" -ForegroundColor Gray
Write-Host ""
Write-Host "   ✅ JWT_SECRET" -ForegroundColor Green
Write-Host "      (tu secreto JWT, ejemplo: 'mySecretKey123456789')" -ForegroundColor Gray
Write-Host ""
Write-Host "   ✅ FRONTEND_URL" -ForegroundColor Green
Write-Host "      https://nutritrack-v2.vercel.app" -ForegroundColor Gray
Write-Host ""
Write-Host "   ✅ PORT (opcional)" -ForegroundColor Green
Write-Host "      8080" -ForegroundColor Gray
Write-Host ""
Write-Host "   Presiona Enter cuando todas las variables estén configuradas..." -ForegroundColor Yellow
Read-Host

Write-Host "6️⃣  Esperar Redespliegue Automático" -ForegroundColor Green
Write-Host "   👉 Railway detectará los cambios y redesplegará automáticamente" -ForegroundColor White
Write-Host "   👉 Esto tomará 2-3 minutos" -ForegroundColor White
Write-Host "   👉 Verás el progreso en la pestaña 'Deployments'" -ForegroundColor White
Write-Host ""
Write-Host "   Esperando que Railway complete el despliegue..." -ForegroundColor Yellow

$maxAttempts = 20
$attempt = 0
$deployed = $false

while ($attempt -lt $maxAttempts -and -not $deployed) {
    Start-Sleep -Seconds 15
    $attempt++
    Write-Host "   Intento $attempt/$maxAttempts..." -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri "https://nutritrack-v2-production.up.railway.app/api/init/status" `
                                       -Method Get `
                                       -TimeoutSec 10 `
                                       -UseBasicParsing `
                                       -ErrorAction Stop
        
        if ($response.StatusCode -eq 200) {
            $deployed = $true
            Write-Host "   ✅ Servidor desplegado correctamente!" -ForegroundColor Green
        }
    } catch {
        Write-Host "   ⏳ Aún desplegando..." -ForegroundColor Yellow
    }
}

if (-not $deployed) {
    Write-Host ""
    Write-Host "   ⚠️  El despliegue está tardando más de lo esperado" -ForegroundColor Yellow
    Write-Host "   👉 Verifica los logs en Railway:" -ForegroundColor White
    Write-Host "      - Click en tu servicio" -ForegroundColor Gray
    Write-Host "      - Pestaña 'Deployments'" -ForegroundColor Gray
    Write-Host "      - Click en el deployment más reciente" -ForegroundColor Gray
    Write-Host "      - Lee los logs para ver si hay errores" -ForegroundColor Gray
    Write-Host ""
    $continue = Read-Host "   ¿Continuar con la inicialización de todas formas? (S/N)"
    if ($continue -ne "S" -and $continue -ne "s") {
        Write-Host "   ❌ Proceso cancelado" -ForegroundColor Red
        exit
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CONFIGURACIÓN COMPLETADA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎉 PostgreSQL está configurado en Railway!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 SIGUIENTE PASO:" -ForegroundColor Yellow
Write-Host "   Ejecuta el script de inicialización:" -ForegroundColor White
Write-Host "   .\init-database-prod.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Este script creara:" -ForegroundColor White
Write-Host "   - Los 3 usuarios (admin, nutriologo, paciente)" -ForegroundColor Gray
Write-Host "   - Los roles del sistema" -ForegroundColor Gray
Write-Host "   - El perfil del paciente de prueba" -ForegroundColor Gray
Write-Host ""
Write-Host "Presiona Enter para salir..." -ForegroundColor Green
Read-Host
