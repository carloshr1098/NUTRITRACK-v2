# NutriTrack - Sistema Integral de Gestión Nutricional

## Descripción del Proyecto

NutriTrack es una aplicación web completa diseñada para la gestión nutricional profesional. El sistema permite a nutriólogos gestionar pacientes, programar citas, crear planes dietéticos personalizados y realizar seguimiento del progreso de sus pacientes de manera eficiente y segura.

## Arquitectura Tecnológica

### Backend
- **Framework**: Spring Boot 3.5.0
- **Lenguaje**: Java 17
- **Base de Datos**: H2 Database (embebida)
- **Seguridad**: Spring Security con JWT
- **ORM**: Hibernate/JPA
- **Gestión de Dependencias**: Maven

### Frontend
- **Framework**: Vue.js 3
- **UI Framework**: Vuetify
- **Build Tool**: Vite
- **Gestión de Estado**: Pinia
- **HTTP Client**: Axios

### Herramientas de Desarrollo
- **IDE**: Visual Studio Code
- **Control de Versiones**: Git
- **Servidor de Desarrollo**: Vite Dev Server
- **Documentación**: Markdown

## Características Principales

### Sistema de Autenticación
- Autenticación basada en JWT (JSON Web Tokens)
- Sistema de roles: Administrador, Nutriólogo, Paciente
- Gestión segura de sesiones
- Protección de endpoints mediante Spring Security

### Gestión de Pacientes
- Registro completo de pacientes con datos médicos
- Historial clínico y datos antropométricos
- Seguimiento de alergias y restricciones dietéticas
- Información de contacto de emergencia

### Sistema de Citas
- Programación de citas entre nutriólogos y pacientes
- Validación de conflictos de horarios
- Estados de citas: programada, completada, cancelada
- Sistema de notas y observaciones

### Planes Dietéticos
- Creación de planes nutricionales personalizados
- Gestión de comidas por tipo y horario
- Información nutricional detallada (calorías, proteínas, carbohidratos, grasas)
- Seguimiento de objetivos calóricos diarios

### Seguimiento de Peso
- Registro histórico de peso corporal
- Cálculo automático de IMC
- Gráficos de progreso y tendencias
- Notas de seguimiento

## Instalación y Configuración

### Prerrequisitos
- Java JDK 17 o superior
- Node.js 16 o superior
- Maven 3.8 o superior
- Git

### 1. Clonar el Repositorio

```bash
git clone [URL_DEL_REPOSITORIO]
cd NUTRITRACK
```

### 2. Configuración del Backend

```bash
# Compilar el proyecto
mvn clean compile

# Ejecutar el servidor backend (puerto 8080)
mvn spring-boot:run
```

### 3. Configuración del Frontend

```bash
# Navegar al directorio frontend
cd frontend

# Instalar dependencias
npm install

# Ejecutar servidor de desarrollo (puerto 3000)
npm run dev
```

## Uso del Sistema

### Inicialización de Datos

Para inicializar el sistema con datos de ejemplo, realizar una petición POST a:
```
POST http://localhost:8080/api/auth/init-data
```

### Credenciales de Acceso

**Usuarios de ejemplo:**
- **Nutriólogo**: `nutriologo` / `123456`
- **Paciente**: `paciente` / `123456`
- **Administrador**: `admin` / `123456`

### URLs de Acceso

- **Frontend**: http://localhost:3000 (o puerto disponible)
- **Backend API**: http://localhost:8080
- **Base de datos H2**: http://localhost:8080/h2-console

### Configuración H2 Database

Para acceder a la consola H2:
- URL: `jdbc:h2:file:./data/nutritrack_db`
- Usuario: `sa`
- Contraseña: `password`

## Desarrollo con VS Code

### Tareas Disponibles

El proyecto incluye tareas de VS Code preconfiguradas:

1. **Start Backend Server**: Inicia el servidor Spring Boot
2. **Start Frontend Server**: Inicia el servidor de desarrollo Vue.js
3. **Build Backend**: Compila el proyecto Maven
4. **Build Frontend**: Construye la aplicación Vue para producción
5. **Start All Servers**: Inicia ambos servidores simultáneamente

### Ejecutar Tareas

1. Presiona `Ctrl+Shift+P` (Windows/Linux) o `Cmd+Shift+P` (Mac)
2. Escribe "Tasks: Run Task"
3. Selecciona la tarea deseada

## Estructura del Proyecto

```
NUTRITRACK/
├── src/main/java/com/nutritrack/          # Backend Spring Boot
│   ├── controller/                        # REST Controllers
│   ├── entity/                           # JPA Entities
│   ├── repository/                       # Data Repositories
│   ├── service/                          # Business Logic
│   ├── security/                         # JWT Security Config
│   └── payload/                          # Request/Response DTOs
├── frontend/                             # Frontend Vue.js
│   ├── src/
│   │   ├── views/                        # Vue Components
│   │   ├── services/                     # API Services
│   │   ├── router/                       # Vue Router
│   │   └── plugins/                      # Vuetify Config
│   ├── package.json                      # Dependencies
│   └── vite.config.js                    # Build Config
├── .vscode/tasks.json                    # VS Code Tasks
├── pom.xml                               # Maven Dependencies
└── README.md                             # Documentación
```

## API Endpoints

### Autenticación
- `POST /api/auth/signin` - Iniciar sesión
- `POST /api/auth/signup` - Registrar usuario
- `POST /api/auth/init-data` - Inicializar datos de ejemplo

### Citas
- `GET /api/appointments` - Listar todas las citas
- `GET /api/appointments/today` - Citas del día actual
- `POST /api/appointments` - Crear nueva cita
- `PUT /api/appointments/{id}` - Actualizar cita
- `DELETE /api/appointments/{id}` - Cancelar cita
- `GET /api/appointments/patients` - Listar pacientes disponibles

### Funcionalidades por Rol

#### Nutriólogo
- Gestión completa de pacientes
- Programación y seguimiento de citas
- Creación de planes dietéticos
- Análisis de progreso de pacientes

#### Paciente
- Visualización de citas programadas
- Acceso a planes dietéticos asignados
- Registro de peso corporal
- Seguimiento de progreso personal

#### Administrador
- Gestión de usuarios del sistema
- Reportes generales
- Configuración del sistema

## Tecnologías Utilizadas

### Backend
- **Spring Boot 3.5.0**: Framework principal
- **Spring Security**: Autenticación y autorización
- **Spring Data JPA**: Persistencia de datos
- **H2 Database**: Base de datos embebida
- **JWT**: Tokens de autenticación
- **Maven**: Gestión de dependencias

### Frontend
- **Vue.js 3**: Framework JavaScript
- **Vuetify 3**: Componentes Material Design
- **Vue Router**: Navegación SPA
- **Axios**: Cliente HTTP
- **Chart.js**: Gráficos y visualizaciones
- **Vite**: Herramienta de desarrollo

## Seguridad

### Medidas de Seguridad Implementadas
- Autenticación JWT con expiración configurada
- Encriptación de contraseñas con BCrypt
- Validación de roles en endpoints sensibles
- Protección CORS configurada
- Validación de entrada de datos
- Manejo seguro de errores

### Configuración CORS
El sistema está configurado para permitir peticiones desde múltiples puertos de desarrollo (3000, 3001, 3002) para facilitar el desarrollo.

## Base de Datos

El sistema utiliza H2 Database en modo embebido para facilitar el desarrollo y despliegue. La base de datos se crea automáticamente al iniciar la aplicación y se almacena en el directorio `data/`.

### Entidades Principales
- Usuario
- Rol  
- Paciente
- Cita
- PlanDieta
- ComidaDieta
- RegistroPeso

Para más detalles sobre el modelo de datos, consultar el archivo `DIAGRAMA_CLASES_UML.md`.

## Estado del Proyecto

**Funcionalidades Completadas:**
- Arquitectura base del sistema
- Sistema de autenticación JWT
- Gestión de citas completa
- Interface de usuario responsiva
- Validación de datos y seguridad

**Funcionalidades en Desarrollo:**
- Gestión completa de planes dietéticos
- Sistema de reportes y análisis
- Notificaciones y recordatorios

## Desarrollo y Contribución

### Estándares de Código
- Seguir convenciones de nomenclatura de Java y JavaScript
- Documentar métodos y clases principales
- Implementar validaciones apropiadas
- Mantener separación de responsabilidades

### Testing
El proyecto incluye estructura para pruebas unitarias e integración. Se recomienda ejecutar las pruebas antes de realizar commits:

```bash
mvn test
```

## Licencia

Este proyecto ha sido desarrollado con fines académicos y educativos.

## Autor

**Carlo**  
Octubre 2025

---

Para más información técnica y detalles del diseño del sistema, consultar la documentación adicional en `DIAGRAMA_CLASES_UML.md`.
- Crear un issue en GitHub
- Email: soporte@nutritrack.com
- Documentación: [Wiki del proyecto](wiki-link)

---

**NutriTrack** - Transformando la gestión nutricional con tecnología moderna 🥗💻