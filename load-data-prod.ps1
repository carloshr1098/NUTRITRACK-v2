# Script para cargar data.sql en producción
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "NUTRITRACK - Cargar Datos Completos" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$baseUrl = "https://nutritrack-v2-production.up.railway.app"

Write-Host "Cargando data.sql (alimentos, categorias, pacientes)..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri "$baseUrl/api/init/load-data" -Method Post -TimeoutSec 120
    
    Write-Host "Datos cargados exitosamente!" -ForegroundColor Green
    Write-Host "  Declaraciones ejecutadas: $($response.executed)" -ForegroundColor White
    Write-Host "  Declaraciones omitidas: $($response.skipped)" -ForegroundColor Yellow
    Write-Host "`nEstado final:" -ForegroundColor Cyan
    Write-Host "  Usuarios totales: $($response.users)" -ForegroundColor White
    Write-Host "  Pacientes totales: $($response.patients)" -ForegroundColor White
    
} catch {
    Write-Host "Error al cargar datos: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Proceso completado. Presiona Enter para salir..." -ForegroundColor Gray
$null = Read-Host
