# 🚀 Scripts de Automatización para NutriTrack

Este directorio contiene varios scripts para automatizar el inicio y parada de los servicios de NutriTrack.

## 📁 Archivos disponibles

### Scripts de Inicio:
- **`start-nutritrack.bat`** - Script batch simple (recomendado)
- **`start-nutritrack.ps1`** - Script PowerShell avanzado
- **`start-nutritrack.js`** - Script Node.js multiplataforma

### Scripts de Utilidad:
- **`stop-nutritrack.bat`** - Detiene todos los servicios
- **`create-shortcut.ps1`** - Crea acceso directo en el escritorio

## 🔧 Cómo usar

### Opción 1: Script Batch (Más fácil)
1. Haz doble clic en `start-nutritrack.bat`
2. El script iniciará automáticamente:
   - Backend en puerto 8080
   - Frontend en puerto 3000
3. Se abrirán ventanas separadas para cada servicio

### Opción 2: Script PowerShell (Más funciones)
1. Haz clic derecho en `start-nutritrack.ps1`
2. Selecciona "Ejecutar con PowerShell"
3. Incluye verificación de puertos y más opciones

### Opción 3: Crear Acceso Directo
1. Ejecuta `create-shortcut.ps1`
2. Se creará un acceso directo "🚀 Iniciar NutriTrack.lnk"
3. Puedes mover este acceso al escritorio o barra de tareas

## 🛑 Para detener los servicios

### Opción 1: Ventanas separadas
- Cierra las ventanas del backend y frontend que se abrieron

### Opción 2: Script de parada
- Ejecuta `stop-nutritrack.bat` para detener todos los procesos automáticamente

## 🌐 URLs importantes

Una vez iniciados los servicios:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8080
- **H2 Database Console**: http://localhost:8080/h2-console

## ⚠️ Solución de problemas

### Si aparece error "Puerto en uso":
1. Ejecuta `stop-nutritrack.bat` para detener servicios anteriores
2. O reinicia tu computadora si el problema persiste

### Si PowerShell no permite ejecutar scripts:
1. Abre PowerShell como administrador
2. Ejecuta: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`
3. Confirma con "Y"

### Si falta Maven o Node.js:
- **Maven**: Descarga desde https://maven.apache.org/
- **Node.js**: Descarga desde https://nodejs.org/

## 🔄 Agregar al inicio de Windows (opcional)

Para que NutriTrack se inicie automáticamente con Windows:
1. Presiona `Win + R`
2. Escribe `shell:startup`
3. Copia el acceso directo "🚀 Iniciar NutriTrack.lnk" a esa carpeta

---

## 📝 Notas adicionales

- Los scripts verifican automáticamente si los archivos necesarios existen
- Se crean ventanas separadas para cada servicio para facilitar el debugging
- Los logs de cada servicio aparecen en su respectiva ventana
- El frontend tiene hot-reload automático durante desarrollo