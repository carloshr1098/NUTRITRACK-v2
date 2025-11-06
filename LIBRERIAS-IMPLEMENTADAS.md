# 📚 Librerías y APIs Implementadas en NutriTrack

## Resumen Ejecutivo

Este documento describe las tres librerías/APIs implementadas en el proyecto NutriTrack para cumplir con los requisitos de la tarea académica.

---

## 1. 📄 jsPDF - Generación de Documentos PDF

### Descripción
jsPDF es una librería JavaScript de código abierto que permite generar documentos PDF directamente desde el navegador sin necesidad de procesamiento en el servidor.

### Justificación de Uso
En el contexto de NutriTrack, es esencial que los nutricionistas puedan generar expedientes médicos en formato PDF de manera rápida y profesional. jsPDF permite:
- Crear documentos PDF con toda la información del paciente
- Incluir datos médicos, historial de peso, citas y planes dietéticos
- Descargar o imprimir expedientes sin depender de un servidor
- Mantener un formato consistente y profesional

### Implementación Técnica

**Instalación:**
```bash
npm install jspdf
```

**Archivos modificados:**
- `frontend/src/views/nutritionist/PatientDetailView.vue`

**Código principal:**
```javascript
import jsPDF from 'jspdf'

const generarPDF = () => {
  const doc = new jsPDF()
  
  // Configuración de fuentes y estilos
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(20)
  doc.text('EXPEDIENTE MÉDICO', 105, 20, { align: 'center' })
  
  // Información del paciente
  doc.setFontSize(12)
  doc.text(`Nombre: ${paciente.firstName} ${paciente.lastName}`, 20, 40)
  doc.text(`Email: ${paciente.email}`, 20, 50)
  // ... más información
  
  // Guardar PDF
  doc.save(`expediente_${paciente.firstName}_${paciente.lastName}.pdf`)
}
```

**Funcionalidades implementadas:**
- ✅ Generación de expediente médico completo
- ✅ Inclusión de datos personales y médicos
- ✅ Historial de peso y citas
- ✅ Planes dietéticos activos
- ✅ Formato profesional con encabezados y secciones
- ✅ Descarga automática al navegador

### Capturas de Pantalla
- Botón "Generar PDF" en vista de detalles del paciente
- PDF generado con información completa
- Diseño profesional del documento

---

## 2. 📊 Chart.js - Visualización de Datos

### Descripción
Chart.js es una librería JavaScript de código abierto para crear gráficas interactivas y responsivas en HTML5 Canvas. Es una de las librerías de visualización más populares y fáciles de usar.

### Justificación de Uso
El seguimiento del progreso del paciente es fundamental en nutrición. Chart.js permite:
- Visualizar la evolución del peso del paciente a lo largo del tiempo
- Identificar tendencias y patrones de manera visual
- Facilitar la toma de decisiones sobre ajustes en planes dietéticos
- Mejorar la comunicación nutricionista-paciente mostrando resultados visuales

### Implementación Técnica

**Instalación:**
```bash
npm install chart.js vue-chartjs
```

**Archivos creados/modificados:**

**Backend:**
- `src/main/java/com/nutritrack/entity/WeightRecord.java` - Entidad JPA
- `src/main/java/com/nutritrack/repository/WeightRecordRepository.java` - Repositorio
- `src/main/java/com/nutritrack/controller/WeightRecordController.java` - API REST

**Frontend:**
- `frontend/src/components/WeightChart.vue` - Componente de gráfica
- `frontend/src/views/nutritionist/PatientDetailView.vue` - Vista integrada

**Código Backend (API REST):**
```java
@GetMapping("/patient/{patientId}")
public ResponseEntity<List<WeightRecord>> getWeightRecordsByPatient(@PathVariable Long patientId) {
    List<WeightRecord> records = weightRecordRepository
        .findByPatientIdOrderByRecordDateAsc(patientId);
    return ResponseEntity.ok(records);
}

@PostMapping
public ResponseEntity<WeightRecord> createWeightRecord(@RequestBody WeightRecord record) {
    WeightRecord savedRecord = weightRecordRepository.save(record);
    // Actualizar peso actual del paciente
    patient.setCurrentWeight(BigDecimal.valueOf(record.getWeight()));
    return ResponseEntity.ok(savedRecord);
}
```

**Código Frontend (Componente Chart.js):**
```javascript
import { Line } from 'vue-chartjs'
import { Chart, registerables } from 'chart.js'

Chart.register(...registerables)

export default {
  components: { Line },
  props: {
    weightRecords: {
      type: Array,
      required: true
    }
  },
  computed: {
    chartData() {
      return {
        labels: this.weightRecords.map(r => 
          new Date(r.recordDate).toLocaleDateString('es-ES')
        ),
        datasets: [{
          label: 'Peso (kg)',
          data: this.weightRecords.map(r => r.weight),
          borderColor: '#4CAF50',
          backgroundColor: 'rgba(76, 175, 80, 0.1)',
          tension: 0.4,
          fill: true
        }]
      }
    }
  }
}
```

**Funcionalidades implementadas:**
- ✅ API REST para gestionar registros de peso (GET, POST, DELETE)
- ✅ Gráfica de línea mostrando evolución temporal del peso
- ✅ Formulario para registrar nuevos pesos con fecha y notas
- ✅ Tabla detallada con diferencias entre pesajes (▲/▼)
- ✅ Actualización automática del peso actual del paciente
- ✅ Interfaz responsiva y visualmente atractiva
- ✅ Gráfica interactiva con tooltips

### Base de Datos
Tabla `weight_records`:
- `id` (BIGINT, PK)
- `patient_id` (BIGINT, FK → patients)
- `weight` (DOUBLE)
- `record_date` (DATE)
- `notes` (VARCHAR)

### Capturas de Pantalla
- Sección "📊 Historial de Peso" en detalles del paciente
- Formulario de registro de peso
- Gráfica de línea con evolución temporal
- Tabla con historial completo y diferencias

---

## 3. 📧 EmailJS - Envío de Notificaciones por Email

### Descripción
EmailJS es una librería JavaScript que permite enviar emails directamente desde el navegador sin necesidad de un servidor backend. Utiliza servicios de email populares como Gmail, Outlook, Yahoo, etc., mediante su API.

### Justificación de Uso
La comunicación efectiva con los pacientes es crucial para reducir ausencias y mejorar el seguimiento. EmailJS permite:
- Enviar confirmaciones automáticas de citas
- Notificar cambios o cancelaciones
- Enviar recordatorios de citas próximas
- Mejorar la experiencia del paciente con comunicación oportuna
- No requiere servidor de email propio (usa EmailJS como intermediario)

### Implementación Técnica

**Instalación:**
```bash
npm install @emailjs/browser
```

**Archivos creados/modificados:**
- `frontend/src/services/emailService.js` - Servicio de envío de emails
- `frontend/src/components/GestionCitas.vue` - Integración en gestión de citas

**Código del Servicio:**
```javascript
import emailjs from '@emailjs/browser'

const EMAILJS_CONFIG = {
  serviceId: 'service_nutritrack',
  templateId: 'template_cita',
  publicKey: 'YOUR_PUBLIC_KEY'
}

export const initEmailJS = () => {
  emailjs.init(EMAILJS_CONFIG.publicKey)
}

export const sendAppointmentNotification = async (appointmentData) => {
  try {
    const templateParams = {
      to_name: appointmentData.patientName,
      to_email: appointmentData.patientEmail,
      appointment_date: appointmentData.appointmentDate,
      appointment_time: appointmentData.appointmentTime,
      appointment_type: appointmentData.appointmentType,
      nutritionist_name: appointmentData.nutritionistName,
      notes: appointmentData.notes,
      subject: 'Confirmación de Cita - NutriTrack'
    }

    const response = await emailjs.send(
      EMAILJS_CONFIG.serviceId,
      EMAILJS_CONFIG.templateId,
      templateParams
    )

    return {
      success: true,
      message: 'Notificación enviada correctamente',
      response
    }
  } catch (error) {
    return {
      success: false,
      message: 'Error al enviar la notificación',
      error
    }
  }
}
```

**Integración en Gestión de Citas:**
```javascript
async crearCita() {
  // 1. Crear cita en base de datos
  const response = await api.post('/appointments', this.nuevaCita)
  const citaCreada = response.data
  
  // 2. Enviar notificación por email si está activado
  if (this.nuevaCita.sendEmail) {
    await this.enviarNotificacionEmail(citaCreada)
  }
  
  this.mostrarExito('✉️ Cita creada y notificación enviada')
}
```

**Funcionalidades implementadas:**
- ✅ Servicio de envío de emails con EmailJS
- ✅ Función para notificaciones de citas nuevas
- ✅ Funciones extensibles para recordatorios y cancelaciones
- ✅ Checkbox en formulario para activar/desactivar envío
- ✅ Formato de email personalizable con plantillas
- ✅ Manejo de errores sin interrumpir flujo principal
- ✅ Notificación visual al usuario del envío exitoso

### Configuración Requerida

**Pasos para activar EmailJS:**

1. **Crear cuenta en EmailJS**: https://www.emailjs.com/
2. **Configurar servicio de email**: Conectar Gmail, Outlook, etc.
3. **Crear plantilla de email** con variables:
   ```
   Hola {{to_name}},
   
   Tu cita ha sido confirmada:
   📅 Fecha: {{appointment_date}}
   ⏰ Hora: {{appointment_time}}
   📋 Tipo: {{appointment_type}}
   👨‍⚕️ Nutricionista: {{nutritionist_name}}
   
   Notas: {{notes}}
   ```
4. **Obtener credenciales**:
   - Service ID
   - Template ID
   - Public Key
5. **Actualizar `emailService.js`** con las credenciales

### Capturas de Pantalla
- Checkbox "Enviar notificación por email" en formulario de citas
- Notificación de éxito "✉️ Notificación enviada al paciente"
- Email recibido por el paciente con detalles de la cita
- Dashboard de EmailJS mostrando emails enviados

---

## 📊 Comparación de Librerías

| Característica | jsPDF | Chart.js | EmailJS |
|----------------|-------|----------|---------|
| **Tipo** | Generación de PDFs | Visualización de datos | Envío de emails |
| **Instalación** | npm install jspdf | npm install chart.js | npm install @emailjs/browser |
| **Complejidad** | Media | Media-Alta | Baja |
| **Requiere Backend** | No | Sí (para datos) | No |
| **Configuración Externa** | No | No | Sí (cuenta EmailJS) |
| **Costo** | Gratis | Gratis | Gratis (200 emails/mes) |
| **Documentación** | Excelente | Excelente | Muy buena |
| **Popularidad** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## 🎯 Impacto en el Proyecto

### Beneficios Obtenidos

**jsPDF:**
- ✅ Expedientes médicos profesionales
- ✅ Documentación imprimible
- ✅ Sin dependencia de servicios externos

**Chart.js:**
- ✅ Visualización clara del progreso del paciente
- ✅ Mejor toma de decisiones clínicas
- ✅ Interfaz profesional y atractiva
- ✅ Full-stack implementation (Backend + Frontend)

**EmailJS:**
- ✅ Comunicación automatizada con pacientes
- ✅ Reducción de ausencias a citas
- ✅ Mejor experiencia del usuario
- ✅ Sin infraestructura de email propia

### Arquitectura General

```
┌─────────────────────────────────────────────────────────────┐
│                         NUTRITRACK                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  FRONTEND (Vue.js 3)                                         │
│  ├── jsPDF → Genera PDFs localmente                         │
│  ├── Chart.js → Renderiza gráficas                          │
│  └── EmailJS → Envía emails via API externa                 │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  BACKEND (Spring Boot)                                       │
│  ├── WeightRecordController → API REST para registros       │
│  ├── WeightRecordRepository → Acceso a base de datos        │
│  └── WeightRecord Entity → Modelo de datos                  │
│                                                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  BASE DE DATOS (H2)                                          │
│  └── weight_records → Tabla de registros de peso            │
│                                                              │
└─────────────────────────────────────────────────────────────┘

SERVICIOS EXTERNOS:
  └── EmailJS → Envío de emails (https://www.emailjs.com/)
```

---

## 📦 Archivos del Proyecto

### Estructura Completa

```
NUTRITRACK/
│
├── frontend/
│   ├── package.json                    # Dependencias (jspdf, chart.js, @emailjs/browser)
│   └── src/
│       ├── components/
│       │   ├── GestionCitas.vue       # Usa EmailJS
│       │   └── WeightChart.vue        # Usa Chart.js
│       ├── services/
│       │   └── emailService.js        # Servicio EmailJS
│       └── views/
│           └── nutritionist/
│               └── PatientDetailView.vue  # Usa jsPDF y Chart.js
│
├── src/
│   └── main/
│       └── java/
│           └── com/nutritrack/
│               ├── entity/
│               │   └── WeightRecord.java
│               ├── repository/
│               │   └── WeightRecordRepository.java
│               └── controller/
│                   └── WeightRecordController.java
│
└── DOCUMENTACION/
    ├── EMAILJS-CONFIGURACION.md        # Guía de configuración EmailJS
    └── LIBRERIAS-IMPLEMENTADAS.md      # Este documento
```

---

## 🔧 Instalación y Configuración

### Prerequisitos
- Node.js 16+
- Java 17+
- Maven 3.9+

### Pasos de Instalación

```bash
# 1. Clonar repositorio
git clone [URL_REPOSITORIO]
cd NUTRITRACK

# 2. Instalar dependencias frontend
cd frontend
npm install

# 3. Compilar backend
cd ..
mvn clean install

# 4. Configurar EmailJS (ver EMAILJS-CONFIGURACION.md)
# Editar frontend/src/services/emailService.js con tus credenciales

# 5. Iniciar backend
mvn spring-boot:run

# 6. Iniciar frontend (en otra terminal)
cd frontend
npm run dev

# 7. Acceder a la aplicación
# http://localhost:3000
```

---

## 📸 Capturas de Pantalla Requeridas

Para la entrega de la tarea, capturar:

1. **jsPDF:**
   - Botón "📄 Generar PDF" en vista del paciente
   - PDF descargado abierto mostrando expediente completo
   - Código relevante en `PatientDetailView.vue`

2. **Chart.js:**
   - Sección "📊 Historial de Peso" con gráfica visible
   - Formulario de registro de peso
   - Tabla con historial y diferencias (▲/▼)
   - Código en `WeightChart.vue` y `WeightRecordController.java`

3. **EmailJS:**
   - Checkbox "Enviar notificación por email" en formulario de citas
   - Mensaje de confirmación "✉️ Notificación enviada"
   - Email recibido en bandeja de entrada del paciente
   - Dashboard de EmailJS con estadísticas
   - Código en `emailService.js` y `GestionCitas.vue`

---

## 📚 Referencias

- **jsPDF**: https://github.com/parallax/jsPDF
- **Chart.js**: https://www.chartjs.org/
- **vue-chartjs**: https://vue-chartjs.org/
- **EmailJS**: https://www.emailjs.com/docs/

---

## 👨‍💻 Conclusión

Las tres librerías implementadas en NutriTrack demuestran:

1. **Integración Full-Stack**: Chart.js requirió desarrollo tanto en backend (API REST, entidad JPA) como frontend (componente Vue)

2. **Diversidad Tecnológica**: 
   - jsPDF: Generación de documentos
   - Chart.js: Visualización de datos
   - EmailJS: Comunicación externa

3. **Valor Práctico**: Cada librería resuelve una necesidad real del sistema:
   - Documentación profesional (jsPDF)
   - Análisis visual de progreso (Chart.js)
   - Comunicación con pacientes (EmailJS)

4. **Buenas Prácticas**:
   - Código modular y reutilizable
   - Manejo de errores
   - Experiencia de usuario mejorada
   - Documentación completa

**Fecha de implementación**: Noviembre 2025  
**Desarrollador**: Carlo  
**Proyecto**: NutriTrack - Sistema de Gestión Nutricional
