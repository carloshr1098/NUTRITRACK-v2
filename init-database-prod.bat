@echo off
echo ========================================
echo NUTRITRACK - Inicializar Base de Datos
echo ========================================
echo.
echo Este script inicializara la base de datos de produccion en Railway
echo.
pause

echo.
echo Verificando estado actual...
curl -X GET https://nutritrack-v2-production.up.railway.app/api/init/status
echo.
echo.

echo Inicializando base de datos...
curl -X POST https://nutritrack-v2-production.up.railway.app/api/init/database
echo.
echo.

echo Verificando resultado...
curl -X GET https://nutritrack-v2-production.up.railway.app/api/init/status
echo.
echo.

echo ========================================
echo Proceso completado
echo ========================================
pause
