# 🚀 Guía de Despliegue NutriTrack

## Opción 1: Railway (Recomendado - Más Fácil)

### Backend + PostgreSQL en Railway

1. **Crear cuenta en Railway**
   - Ve a [railway.app](https://railway.app)
   - Regístrate con GitHub

2. **Crear nuevo proyecto**
   - Click en "New Project"
   - Selecciona "Deploy from GitHub repo"
   - Conecta tu repositorio NUTRITRACK-v2

3. **Agregar PostgreSQL**
   - En tu proyecto, click en "+ New"
   - Selecciona "Database" → "PostgreSQL"
   - Railway creará automáticamente la base de datos

4. **Configurar variables de entorno**
   
   En el servicio del backend, ve a "Variables" y agrega:
   
   ```env
   SPRING_PROFILES_ACTIVE=prod
   
   # Estas las copia Railway automáticamente desde PostgreSQL:
   DATABASE_URL=postgresql://user:password@host:port/database
   DB_USERNAME=postgres
   DB_PASSWORD=tu_password_generado
   
   # Estas las debes crear:
   JWT_SECRET=bnV0cml0cmFja19zdXBlcl9zZWNyZXRfa2V5X2Zvcl9qd3RfYXV0aGVudGljYXRpb25fMjAyNA==
   FRONTEND_URL=https://tu-frontend.vercel.app
   PORT=8080
   ```

5. **Desplegar**
   - Railway detectará automáticamente que es un proyecto Spring Boot
   - Se desplegará automáticamente en cada push a GitHub
   - Obtendrás una URL como: `https://nutritrack-production.up.railway.app`

### Frontend en Vercel

1. **Crear cuenta en Vercel**
   - Ve a [vercel.com](https://vercel.com)
   - Regístrate con GitHub

2. **Importar proyecto**
   - Click en "Add New..." → "Project"
   - Selecciona tu repositorio
   - Configura:
     - **Framework Preset**: Vite
     - **Root Directory**: `frontend`
     - **Build Command**: `npm run build`
     - **Output Directory**: `dist`

3. **Variables de entorno**
   
   En Vercel, agrega:
   ```env
   VITE_API_URL=https://nutritrack-production.up.railway.app
   ```

4. **Actualizar API URL en el código**
   
   Edita `frontend/src/services/api.js`:
   ```javascript
   const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080';
   ```

5. **Desplegar**
   - Vercel desplegará automáticamente
   - Obtendrás una URL como: `https://nutritrack.vercel.app`

---

## Opción 2: Render (Alternativa Gratuita)

### Backend en Render

1. **Crear cuenta en Render**
   - Ve a [render.com](https://render.com)
   - Regístrate con GitHub

2. **Crear Web Service**
   - Click en "New +" → "Web Service"
   - Conecta tu repositorio
   - Configura:
     - **Name**: nutritrack-backend
     - **Environment**: Java
     - **Build Command**: `mvn clean package -DskipTests`
     - **Start Command**: `java -jar target/nutritrack-backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod`

3. **Agregar PostgreSQL**
   - Click en "New +" → "PostgreSQL"
   - Copia la "Internal Database URL"

4. **Variables de entorno**
   ```env
   SPRING_PROFILES_ACTIVE=prod
   DATABASE_URL=tu_internal_database_url
   DB_USERNAME=tu_username
   DB_PASSWORD=tu_password
   JWT_SECRET=bnV0cml0cmFja19zdXBlcl9zZWNyZXRfa2V5X2Zvcl9qd3RfYXV0aGVudGljYXRpb25fMjAyNA==
   FRONTEND_URL=https://tu-frontend.vercel.app
   ```

---

## 📋 Checklist Antes de Desplegar

- [ ] Commit y push de todos los cambios
- [ ] Actualizar CORS con la URL de producción del frontend
- [ ] Configurar variables de entorno
- [ ] Probar localmente con PostgreSQL (opcional)
- [ ] Desactivar logs de DEBUG en producción

---

## 🔧 Comandos Útiles

### Compilar para producción
```bash
mvn clean package -DskipTests
```

### Probar localmente con perfil de producción
```bash
java -jar target/nutritrack-backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod
```

### Ver logs en Railway
```bash
railway logs
```

---

## 🔐 Seguridad en Producción

1. **Cambiar JWT Secret**
   - Genera un nuevo secret más largo y seguro
   - Usa al menos 256 bits (32 caracteres)

2. **HTTPS**
   - Railway y Vercel proporcionan HTTPS automáticamente
   - Asegúrate de usar URLs https://

3. **Variables de entorno**
   - Nunca hagas commit de credenciales
   - Usa variables de entorno para todo

4. **CORS**
   - Configura solo los dominios específicos de producción
   - Elimina localhost de producción

---

## 💰 Costos

### Railway
- **Plan Free**: $5 de crédito mensual
- Suficiente para: Backend + PostgreSQL con tráfico bajo/medio
- Después: ~$5-10/mes

### Vercel
- **Plan Free**: Ilimitado para proyectos personales
- 100% gratis para tu frontend

### Render
- **Plan Free**: Backend + PostgreSQL
- Limitación: Se duerme después de 15 min de inactividad
- Primera petición tarda ~30 segundos en despertar

---

## 🆘 Troubleshooting

### Error: "Cannot connect to database"
- Verifica que DATABASE_URL esté correctamente configurada
- Verifica que el usuario y contraseña sean correctos
- Verifica que la base de datos PostgreSQL esté activa

### Error: "CORS policy"
- Agrega la URL del frontend a `cors.allowed-origins`
- Reinicia el backend después de cambiar CORS

### Error: "Port already in use"
- Railway asigna el puerto automáticamente vía variable `PORT`
- Usa `server.port=${PORT:8080}` en application-prod.properties

---

## 📚 Próximos Pasos

1. Configurar dominio personalizado (opcional)
2. Configurar CI/CD con GitHub Actions
3. Agregar monitoreo y alertas
4. Configurar backups automáticos de la base de datos
5. Implementar rate limiting
6. Agregar logging centralizado
