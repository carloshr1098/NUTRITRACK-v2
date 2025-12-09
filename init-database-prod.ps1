# NUTRITRACK - Inicializar Base de Datos en Producción (Railway)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "NUTRITRACK - Inicializar Base de Datos" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseUrl = "https://nutritrack-v2-production.up.railway.app"

# Verificar estado actual
Write-Host "Verificando estado actual de la base de datos..." -ForegroundColor Yellow
try {
    $status = Invoke-RestMethod -Uri "$baseUrl/api/init/status" -Method Get
    Write-Host "Estado actual:" -ForegroundColor Green
    Write-Host "  - Inicializada: $($status.initialized)" -ForegroundColor White
    Write-Host "  - Usuarios: $($status.users)" -ForegroundColor White
    Write-Host "  - Pacientes: $($status.patients)" -ForegroundColor White
    Write-Host ""
    
    if ($status.initialized -eq $true) {
        Write-Host "⚠️  La base de datos ya está inicializada." -ForegroundColor Yellow
        Write-Host ""
        $confirm = Read-Host "¿Deseas reinicializar de todos modos? (S/N)"
        if ($confirm -ne "S" -and $confirm -ne "s") {
            Write-Host "Operación cancelada." -ForegroundColor Red
            exit
        }
    }
} catch {
    Write-Host "❌ Error al verificar el estado: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Asegúrate de que Railway está desplegado correctamente." -ForegroundColor Yellow
    Write-Host ""
}

# Inicializar base de datos
Write-Host "Inicializando base de datos..." -ForegroundColor Yellow
try {
    $result = Invoke-RestMethod -Uri "$baseUrl/api/init/database" -Method Post
    Write-Host "✅ Base de datos inicializada exitosamente!" -ForegroundColor Green
    Write-Host "Resultado:" -ForegroundColor Green
    Write-Host "  - Mensaje: $($result.message)" -ForegroundColor White
    Write-Host "  - Usuarios creados: $($result.users)" -ForegroundColor White
    Write-Host "  - Pacientes creados: $($result.patients)" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host "❌ Error al inicializar: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
}

# Verificar resultado final
Write-Host "Verificando resultado final..." -ForegroundColor Yellow
try {
    $finalStatus = Invoke-RestMethod -Uri "$baseUrl/api/init/status" -Method Get
    Write-Host "Estado final:" -ForegroundColor Green
    Write-Host "  - Inicializada: $($finalStatus.initialized)" -ForegroundColor White
    Write-Host "  - Usuarios: $($finalStatus.users)" -ForegroundColor White
    Write-Host "  - Pacientes: $($finalStatus.patients)" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host "⚠️  No se pudo verificar el resultado final" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Credenciales de acceso:" -ForegroundColor Cyan
Write-Host "  Admin:      admin / admin123" -ForegroundColor White
Write-Host "  Nutriólogo: nutriologo / nutri123" -ForegroundColor White
Write-Host "  Paciente:   paciente / paciente123" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Proceso completado. Presiona Enter para salir..." -ForegroundColor Green
Read-Host
