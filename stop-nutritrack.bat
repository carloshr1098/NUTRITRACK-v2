@echo off
title Detener NutriTrack
color 0C

echo ==========================================
echo        🛑 DETENIENDO NUTRITRACK 🛑
echo ==========================================
echo.

echo 🔍 Buscando procesos de NutriTrack...

echo 🟦 Deteniendo Backend (Java/Maven)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8080') do (
    echo Deteniendo proceso en puerto 8080: %%a
    taskkill /f /pid %%a >nul 2>&1
)

echo 🟩 Deteniendo Frontend (Node.js/npm)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000') do (
    echo Deteniendo proceso en puerto 3000: %%a
    taskkill /f /pid %%a >nul 2>&1
)

echo.
echo 🔍 Verificando puertos...
netstat -an | findstr ":8080\|:3000" >nul
if errorlevel 1 (
    echo ✅ Todos los servicios han sido detenidos correctamente
) else (
    echo ⚠️  Algunos procesos pueden seguir corriendo
    echo Puertos activos:
    netstat -an | findstr ":8080\|:3000"
)

echo.
echo 🎉 Proceso de detención completado
pause