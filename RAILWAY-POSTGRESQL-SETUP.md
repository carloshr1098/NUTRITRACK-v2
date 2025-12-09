# Configuración de PostgreSQL en Railway - NutriTrack

## Pasos para Configurar PostgreSQL en Railway

### 1. Agregar PostgreSQL a tu proyecto en Railway

1. Ve a tu proyecto en Railway: https://railway.app/
2. Click en **"+ New"** → **"Database"** → **"Add PostgreSQL"**
3. Railway automáticamente creará:
   - Una base de datos PostgreSQL
   - La variable de entorno `DATABASE_URL`
   - Conexión automática entre tu servicio y la base de datos

### 2. Verificar Variables de Entorno

1. Ve a tu servicio (nutritrack-v2)
2. Click en la pestaña **"Variables"**
3. Asegúrate de que existan estas variables:
   - `DATABASE_URL` (se crea automáticamente al agregar PostgreSQL)
   - `JWT_SECRET` (tu secreto JWT)
   - `FRONTEND_URL` (https://nutritrack-v2.vercel.app)
   - `PORT` (8080)

### 3. Desplegar Cambios

Los cambios ya están en el repositorio. Railway desplegará automáticamente cuando detecte el push.

### 4. Inicializar Base de Datos

Una vez que Railway termine de desplegar (2-3 minutos), ejecuta:

```powershell
.\init-database-prod.ps1
```

O manualmente:

```powershell
# Verificar estado
Invoke-RestMethod -Uri "https://nutritrack-v2-production.up.railway.app/api/init/status" -Method Get

# Inicializar
Invoke-RestMethod -Uri "https://nutritrack-v2-production.up.railway.app/api/init/database" -Method Post
```

### 5. Credenciales de Acceso

Después de inicializar:

- **Admin**: `admin` / `admin123`
- **Nutriólogo**: `nutriologo` / `nutri123`
- **Paciente**: `paciente` / `paciente123`

## Verificar que PostgreSQL está Funcionando

### En Railway Dashboard:
1. Click en tu servicio PostgreSQL
2. Ve a la pestaña **"Data"**
3. Deberías ver las tablas: `users`, `roles`, `patients`, `foods`, etc.

### Desde la Aplicación:
1. Abre: https://nutritrack-v2.vercel.app
2. Intenta iniciar sesión con: `nutriologo` / `nutri123`
3. Crea un paciente o agrega datos
4. Reinicia el servicio en Railway
5. Verifica que los datos persisten

## Solución de Problemas

### Error: "Database already initialized"
- Esto es normal si ya inicializaste antes
- Los datos están guardados en PostgreSQL

### Error: 502 Bad Gateway
- Espera 2-3 minutos más
- Railway está desplegando la aplicación
- Verifica los logs en Railway: Click en servicio → "Deployments" → Click en el deployment más reciente

### Error: Cannot connect to database
- Verifica que agregaste PostgreSQL en Railway
- Verifica que `DATABASE_URL` existe en las variables de entorno
- Railway debe mostrar una línea conectando tu servicio con PostgreSQL

## Beneficios de PostgreSQL vs H2

✅ **Persistencia real**: Los datos sobreviven reinicios del contenedor  
✅ **Backups automáticos**: Railway hace backups de PostgreSQL  
✅ **Escalabilidad**: Puedes aumentar recursos de la BD independientemente  
✅ **Herramientas**: Puedes conectarte con pgAdmin, DBeaver, etc.  
✅ **SQL completo**: Soporte completo de características PostgreSQL  

## Próximos Pasos

1. Agregar PostgreSQL en Railway
2. Esperar el redespliegue automático
3. Ejecutar `.\init-database-prod.ps1`
4. ¡Listo! Tu aplicación usa PostgreSQL persistente
