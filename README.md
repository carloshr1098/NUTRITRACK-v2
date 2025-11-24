# NutriTrack - Sistema de Gestión Nutricional

Sistema integral de gestión nutricional desarrollado con Spring Boot y Vue.js, diseñado para nutriólogos profesionales que buscan optimizar la administración de sus pacientes, planes dietéticos y seguimiento nutricional.

## Descripción del Proyecto

NutriTrack es una aplicación web completa que permite a los profesionales de la nutrición gestionar de manera eficiente sus consultorios. El sistema incluye funcionalidades para el manejo de pacientes, creación de planes alimenticios personalizados, seguimiento de progreso, y generación de documentación profesional en formato PDF.

### Características Principales

- **Gestión de Pacientes**: Registro completo de información personal, médica y antropométrica
- **Planes Dietéticos Personalizados**: Creación de planes alimenticios con cálculo automático de macronutrientes
- **Base de Datos de Alimentos**: Catálogo extenso con información nutricional detallada
- **Seguimiento de Progreso**: Registro y visualización del historial de peso con gráficas interactivas
- **Generación de PDFs**: Documentos profesionales con marca personalizada para planes dietéticos y expedientes médicos
- **Perfil Profesional**: Gestión de información del nutriólogo (cédula, universidad, contacto)
- **Seguridad Robusta**: Autenticación JWT y control de acceso basado en roles
- **Interfaz Moderna**: Diseño responsive con Vuetify siguiendo Material Design

## Tecnologías Utilizadas

### Backend
- **Java 17**: Lenguaje de programación principal
- **Spring Boot 3.5.0**: Framework para desarrollo de aplicaciones Java
- **Spring Security**: Gestión de autenticación y autorización
- **Spring Data JPA**: Persistencia de datos con Hibernate
- **H2 Database**: Base de datos embebida para desarrollo
- **JWT (io.jsonwebtoken)**: Tokens para autenticación stateless
- **Maven**: Gestión de dependencias y construcción del proyecto

### Frontend
- **Vue.js 3.4**: Framework JavaScript progresivo
- **Vue Router 4.2**: Manejo de rutas en SPA
- **Vuetify 3.5**: Framework de componentes Material Design
- **Vite 4.6**: Build tool y dev server de próxima generación
- **Axios 1.6**: Cliente HTTP para peticiones a la API
- **Chart.js 4.5**: Biblioteca para gráficas y visualizaciones
- **jsPDF 3.0**: Generación de documentos PDF en el navegador
- **EmailJS 4.4**: Servicio de envío de correos electrónicos

## Requisitos Previos

Antes de instalar y ejecutar el proyecto, asegúrate de tener instalado:

- **Java Development Kit (JDK) 17** o superior
- **Apache Maven 3.8** o superior
- **Node.js 18** o superior
- **npm 9** o superior
- **Git** para control de versiones

## Instalación y Configuración

### 1. Clonar el Repositorio

```bash
git clone https://github.com/carloshr1098/NUTRITRACK-v2.git
cd NUTRITRACK
```

### 2. Configuración del Backend

#### Configurar la Base de Datos

El archivo `src/main/resources/application.properties` contiene la configuración de la base de datos H2:

```properties
# Configuración del servidor
server.port=8080

# Configuración de la base de datos H2
spring.datasource.url=jdbc:h2:file:./data/nutritrack_db
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=

# Configuración de JPA/Hibernate
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=false
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.H2Dialect

# Consola H2 (desarrollo)
spring.h2.console.enabled=true
spring.h2.console.path=/h2-console

# Configuración JWT
app.jwtSecret=nutriTrackSecretKeyForJWTAuthenticationAndAuthorizationPurposes2024
app.jwtExpirationMs=86400000
```

#### Compilar el Backend

```bash
mvn clean install
```

#### Ejecutar el Backend

```bash
mvn spring-boot:run
```

El servidor backend estará disponible en `http://localhost:8080`

La consola H2 estará accesible en `http://localhost:8080/h2-console`

### 3. Configuración del Frontend

#### Instalar Dependencias

```bash
cd frontend
npm install
```

#### Configurar Variables de Entorno

Crear un archivo `.env` en la carpeta `frontend` si necesitas configurar variables específicas:

```env
VITE_API_URL=http://localhost:8080/api
```

#### Ejecutar el Frontend en Modo Desarrollo

```bash
npm run dev
```

El servidor de desarrollo estará disponible en `http://localhost:3000`

#### Compilar para Producción

```bash
npm run build
```

Los archivos compilados se generarán en la carpeta `dist/`

## Estructura del Proyecto

```
NUTRITRACK/
│
├── src/main/java/com/nutritrack/          # Código fuente del backend
│   ├── controller/                        # Controladores REST
│   ├── entity/                            # Entidades JPA
│   ├── repository/                        # Repositorios de datos
│   ├── service/                           # Lógica de negocio
│   ├── security/                          # Configuración de seguridad
│   └── payload/                           # DTOs y objetos de transferencia
│
├── src/main/resources/                    # Recursos del backend
│   └── application.properties             # Configuración de la aplicación
│
├── frontend/                              # Aplicación Vue.js
│   ├── public/                            # Archivos estáticos
│   │   └── logo/                          # Recursos de marca
│   ├── src/
│   │   ├── assets/                        # Estilos globales
│   │   ├── components/                    # Componentes reutilizables
│   │   ├── views/                         # Vistas de la aplicación
│   │   │   ├── admin/                     # Vistas de administrador
│   │   │   ├── nutritionist/              # Vistas de nutriólogo
│   │   │   └── patient/                   # Vistas de paciente
│   │   ├── router/                        # Configuración de rutas
│   │   ├── services/                      # Servicios y APIs
│   │   └── plugins/                       # Plugins de Vue
│   │
│   ├── package.json                       # Dependencias del frontend
│   └── vite.config.js                     # Configuración de Vite
│
├── data/                                  # Base de datos H2 (generada)
├── pom.xml                                # Configuración de Maven
└── README.md                              # Este archivo
```

## API Endpoints

### Autenticación

- `POST /api/auth/signup` - Registro de nuevos usuarios
- `POST /api/auth/signin` - Inicio de sesión
- `PUT /api/auth/profile` - Actualizar perfil del usuario (requiere autenticación)

### Pacientes

- `GET /api/patients` - Listar todos los pacientes
- `GET /api/patients/{id}` - Obtener paciente por ID
- `POST /api/patients` - Crear nuevo paciente
- `PUT /api/patients/{id}` - Actualizar paciente
- `DELETE /api/patients/{id}` - Eliminar paciente

### Pesos (Weight Tracking)

- `GET /api/weights/patient/{patientId}` - Obtener historial de peso de un paciente
- `POST /api/weights` - Registrar nuevo peso
- `DELETE /api/weights/{id}` - Eliminar registro de peso

### Alimentos

- `GET /api/foods` - Listar todos los alimentos
- `GET /api/foods/{id}` - Obtener alimento por ID
- `POST /api/foods` - Crear nuevo alimento
- `PUT /api/foods/{id}` - Actualizar alimento
- `DELETE /api/foods/{id}` - Eliminar alimento

### Planes Dietéticos

- `GET /api/diet-plans` - Listar planes dietéticos
- `GET /api/diet-plans/{id}` - Obtener plan dietético por ID
- `POST /api/diet-plans` - Crear nuevo plan dietético
- `PUT /api/diet-plans/{id}` - Actualizar plan dietético
- `DELETE /api/diet-plans/{id}` - Eliminar plan dietético

### Comidas del Plan

- `GET /api/plan-meals/plan/{planId}` - Obtener comidas de un plan
- `POST /api/plan-meals` - Agregar comida a un plan
- `DELETE /api/plan-meals/{id}` - Eliminar comida del plan

## Usuarios por Defecto

El sistema inicializa con tres usuarios de ejemplo:

### Administrador
- **Usuario**: `admin`
- **Contraseña**: `admin123`
- **Rol**: ADMIN

### Nutriólogo
- **Usuario**: `nutriologo`
- **Contraseña**: `nutri123`
- **Rol**: NUTRIOLOGO

### Paciente
- **Usuario**: `paciente`
- **Contraseña**: `paciente123`
- **Rol**: PACIENTE

**Importante**: Se recomienda cambiar estas credenciales en un entorno de producción.

## Configuración de EmailJS

Para habilitar el envío de correos electrónicos desde la aplicación:

1. Crear una cuenta en [EmailJS](https://www.emailjs.com/)
2. Configurar un servicio de email y obtener las credenciales
3. Actualizar el archivo `frontend/src/services/emailService.js` con tus credenciales:

```javascript
const SERVICE_ID = 'tu_service_id'
const TEMPLATE_ID = 'tu_template_id'
const PUBLIC_KEY = 'tu_public_key'
```

## Scripts Útiles

### Backend

```bash
# Compilar el proyecto
mvn clean compile

# Ejecutar tests
mvn test

# Empaquetar la aplicación
mvn package

# Limpiar archivos generados
mvn clean
```

### Frontend

```bash
# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run dev

# Compilar para producción
npm run build

# Previsualizar build de producción
npm run preview

# Ejecutar linter
npm run lint
```

### Scripts de Windows

El proyecto incluye scripts batch para facilitar el inicio en Windows:

- `start-nutritrack.bat` - Inicia backend y frontend simultáneamente
- `stop-nutritrack.bat` - Detiene ambos servidores
- `start-nutritrack.ps1` - Script de PowerShell con funcionalidades adicionales

## Seguridad

### Autenticación JWT

El sistema utiliza JSON Web Tokens (JWT) para la autenticación:

1. El usuario inicia sesión con credenciales
2. El servidor valida y genera un token JWT
3. El token se incluye en el header `Authorization: Bearer <token>` de las peticiones
4. El token expira después de 24 horas (configurable)

### Control de Acceso

El sistema implementa tres niveles de acceso:

- **ADMIN**: Acceso completo al sistema, gestión de usuarios
- **NUTRIOLOGO**: Gestión de pacientes, planes dietéticos, alimentos
- **PACIENTE**: Vista de su propio perfil, planes asignados y progreso

### Encriptación de Contraseñas

Las contraseñas se almacenan utilizando BCrypt con factor de trabajo 10.

## Resolución de Problemas

### El backend no inicia

- Verificar que el puerto 8080 no esté en uso
- Confirmar que Java 17+ está instalado: `java -version`
- Revisar los logs en la consola para errores específicos

### El frontend no se conecta al backend

- Verificar que el backend esté ejecutándose en `http://localhost:8080`
- Revisar la configuración de CORS en el backend
- Comprobar la configuración de la URL base en `frontend/src/services/api.js`

### Error de base de datos bloqueada

Si aparece el error "Database may be already in use":

```bash
# Windows PowerShell
Get-Process -Name "*java*" | Stop-Process -Force
```

Luego reiniciar el servidor backend.

### Problemas con la generación de PDFs

- Verificar que las imágenes del logo estén en `frontend/public/logo/`
- Comprobar la consola del navegador para errores de CORS
- Asegurarse de que el perfil del nutriólogo esté completo

## Contribución

Este proyecto fue desarrollado como sistema de gestión nutricional. Para contribuir:

1. Fork el repositorio
2. Crear una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear un Pull Request

## Licencia

Este proyecto es de código privado. Todos los derechos reservados.

## Contacto

Para preguntas o soporte técnico, contactar al equipo de desarrollo.

## Changelog

### Versión 0.0.1 (Noviembre 2025)

- Implementación inicial del sistema
- Módulo de autenticación con JWT
- Gestión completa de pacientes
- Base de datos de alimentos con información nutricional
- Creación y gestión de planes dietéticos
- Seguimiento de peso con visualizaciones
- Generación de PDFs profesionales con marca personalizada
- Perfil profesional del nutriólogo con información de contacto
- Validaciones de formularios (cédula profesional, teléfono)
- Interfaz responsive con Vuetify

---

**NutriTrack** - Sistema de Gestión Nutricional  2025
