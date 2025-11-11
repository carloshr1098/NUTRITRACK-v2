@echo off
title NutriTrack Startup
color 0A

echo ==========================================
echo        🚀 INICIANDO NUTRITRACK 🚀
echo ==========================================
echo.

cd /d "%~dp0"

echo 📁 Directorio del proyecto: %CD%
echo.

echo 🔍 Verificando archivos necesarios...
if not exist "pom.xml" (
    echo ❌ Error: No se encontró pom.xml
    pause
    exit /b 1
)

if not exist "frontend\package.json" (
    echo ❌ Error: No se encontró frontend\package.json
    pause
    exit /b 1
)

echo ✅ Archivos encontrados correctamente
echo.

echo 🟦 Iniciando Backend (Spring Boot)...
start "NutriTrack Backend" cmd /k "echo 🟦 BACKEND - NutriTrack && echo Puerto: 8080 && mvn spring-boot:run"

echo ⏳ Esperando 3 segundos...
timeout /t 3 /nobreak >nul

echo 🟩 Iniciando Frontend (Vue.js + Vite)...
start "NutriTrack Frontend" cmd /k "cd frontend && echo 🟩 FRONTEND - NutriTrack && echo Puerto: 3000 && npm run dev"

echo.
echo ✅ Servicios iniciándose...
echo 🌐 Frontend: http://localhost:3000
echo 🔧 Backend:  http://localhost:8080
echo 🗄️  H2 Console: http://localhost:8080/h2-console
echo.
echo 📝 Nota: Se abrieron ventanas separadas para cada servicio
echo ⏳ Espera unos segundos para que los servicios se inicien completamente
echo.

set /p openBrowser="¿Deseas abrir el navegador automáticamente? (s/n): "
if /i "%openBrowser%"=="s" (
    echo 🌐 Abriendo navegador en 5 segundos...
    timeout /t 5 /nobreak >nul
    start http://localhost:3000
)

echo.
echo 🎉 NutriTrack iniciado correctamente!
echo Para detener los servicios, cierra las ventanas del backend y frontend
echo.
pause