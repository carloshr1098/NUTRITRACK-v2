# NutriTrack Startup Script
# Este script inicia automáticamente el backend y frontend de NutriTrack

Write-Host "🚀 Iniciando NutriTrack..." -ForegroundColor Green
Write-Host "=" * 50

# Obtener la ruta del proyecto
$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Host "📁 Directorio del proyecto: $projectPath" -ForegroundColor Yellow

# Verificar que los directorios existen
if (-not (Test-Path "$projectPath\pom.xml")) {
    Write-Host "❌ Error: No se encontró pom.xml en $projectPath" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "$projectPath\frontend\package.json")) {
    Write-Host "❌ Error: No se encontró package.json en $projectPath\frontend" -ForegroundColor Red
    exit 1
}

# Función para verificar si un puerto está en uso
function Test-Port {
    param([int]$Port)
    $result = netstat -an | Select-String ":$Port "
    return $result.Count -gt 0
}

# Verificar puertos
Write-Host "🔍 Verificando puertos..." -ForegroundColor Cyan
if (Test-Port 8080) {
    Write-Host "⚠️  Puerto 8080 ya está en uso (Backend)" -ForegroundColor Yellow
} else {
    Write-Host "✅ Puerto 8080 disponible" -ForegroundColor Green
}

if (Test-Port 3000) {
    Write-Host "⚠️  Puerto 3000 ya está en uso (Frontend)" -ForegroundColor Yellow
} else {
    Write-Host "✅ Puerto 3000 disponible" -ForegroundColor Green
}

Write-Host ""
Write-Host "🔄 Iniciando servicios..." -ForegroundColor Cyan

# Iniciar Backend en una nueva ventana de PowerShell
Write-Host "🟦 Iniciando Backend (Spring Boot)..." -ForegroundColor Blue
Start-Process PowerShell -ArgumentList "-NoExit", "-Command", "cd '$projectPath'; Write-Host '🟦 BACKEND - NutriTrack' -ForegroundColor Blue; Write-Host 'Puerto: 8080' -ForegroundColor Green; mvn spring-boot:run"

# Esperar un poco para que el backend se inicie
Start-Sleep -Seconds 3

# Iniciar Frontend en una nueva ventana de PowerShell
Write-Host "🟩 Iniciando Frontend (Vue.js + Vite)..." -ForegroundColor Green
Start-Process PowerShell -ArgumentList "-NoExit", "-Command", "cd '$projectPath\frontend'; Write-Host '🟩 FRONTEND - NutriTrack' -ForegroundColor Green; Write-Host 'Puerto: 3000' -ForegroundColor Blue; npm run dev"

Write-Host ""
Write-Host "✅ Servicios iniciándose..." -ForegroundColor Green
Write-Host "🌐 Frontend: http://localhost:3000" -ForegroundColor Cyan
Write-Host "🔧 Backend:  http://localhost:8080" -ForegroundColor Cyan
Write-Host "🗄️  H2 Console: http://localhost:8080/h2-console" -ForegroundColor Cyan
Write-Host ""
Write-Host "📝 Nota: Se abrieron ventanas separadas para cada servicio" -ForegroundColor Yellow
Write-Host "⏳ Espera unos segundos para que los servicios se inicien completamente" -ForegroundColor Yellow

# Opción para abrir el navegador automáticamente
$openBrowser = Read-Host "¿Deseas abrir el navegador automáticamente? (s/n)"
if ($openBrowser -eq "s" -or $openBrowser -eq "S" -or $openBrowser -eq "y" -or $openBrowser -eq "Y") {
    Write-Host "🌐 Abriendo navegador..." -ForegroundColor Green
    Start-Sleep -Seconds 5  # Esperar a que el frontend se inicie
    Start-Process "http://localhost:3000"
}

Write-Host ""
Write-Host "🎉 NutriTrack iniciado correctamente!" -ForegroundColor Green
Write-Host "Para detener los servicios, cierra las ventanas del backend y frontend" -ForegroundColor Yellow