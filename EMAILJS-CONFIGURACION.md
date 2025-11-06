# Configuración de EmailJS para NutriTrack

## 📧 ¿Qué es EmailJS?

EmailJS es una librería JavaScript que permite enviar emails directamente desde el frontend sin necesidad de un servidor backend. Es ideal para enviar notificaciones, confirmaciones y recordatorios de manera sencilla.

## 🎯 Implementación en NutriTrack

EmailJS se utiliza en NutriTrack para:
- ✉️ **Enviar notificaciones de citas**: Cuando se crea una cita, se envía automáticamente un email al paciente con los detalles
- 🔔 **Recordatorios**: Se puede extender para enviar recordatorios de citas próximas
- ❌ **Cancelaciones**: Notificar al paciente cuando una cita es cancelada

## 📋 Pasos para Configurar EmailJS

### 1. Crear Cuenta en EmailJS

1. Ve a [https://www.emailjs.com/](https://www.emailjs.com/)
2. Haz clic en "Sign Up" y crea una cuenta gratuita
3. Verifica tu email

### 2. Configurar un Servicio de Email

1. En el dashboard, ve a **"Email Services"**
2. Haz clic en **"Add New Service"**
3. Selecciona tu proveedor de email (Gmail, Outlook, etc.)
4. Sigue las instrucciones para conectar tu cuenta de email
5. Copia el **Service ID** que se genera (ejemplo: `service_nutritrack`)

### 3. Crear una Plantilla de Email

1. Ve a **"Email Templates"**
2. Haz clic en **"Create New Template"**
3. Configura tu plantilla con estas variables:

```
Asunto: {{subject}}

Hola {{to_name}},

Tu cita ha sido confirmada con los siguientes detalles:

📅 Fecha: {{appointment_date}}
⏰ Hora: {{appointment_time}}
📋 Tipo de cita: {{appointment_type}}
👨‍⚕️ Nutricionista: {{nutritionist_name}}

Notas adicionales:
{{notes}}

¡Te esperamos!

Saludos,
Equipo NutriTrack
```

4. Guarda la plantilla y copia el **Template ID** (ejemplo: `template_cita`)

### 4. Obtener Public Key

1. Ve a **"Account"** > **"API Keys"**
2. Copia tu **Public Key** (ejemplo: `YOUR_PUBLIC_KEY`)

### 5. Configurar en el Código

Edita el archivo `frontend/src/services/emailService.js`:

```javascript
const EMAILJS_CONFIG = {
  serviceId: 'service_nutritrack',  // Tu Service ID
  templateId: 'template_cita',      // Tu Template ID
  publicKey: 'YOUR_PUBLIC_KEY'       // Tu Public Key
};
```

## 🚀 Uso en la Aplicación

### Crear Cita con Notificación

1. El nutriólogo crea una nueva cita en la sección "Gestión de Citas"
2. Asegura que el checkbox "Enviar notificación por email al paciente" esté marcado
3. Al crear la cita, automáticamente se enviará un email al paciente

### Flujo Técnico

```javascript
// 1. Se crea la cita en la base de datos
const citaCreada = await api.post('/appointments', nuevaCita)

// 2. Si sendEmail está activado, se envía el email
if (nuevaCita.sendEmail) {
  await sendAppointmentNotification({
    patientName: 'Juan Pérez',
    patientEmail: 'juan@example.com',
    appointmentDate: '15 de marzo de 2024',
    appointmentTime: '10:00 AM',
    appointmentType: 'Consulta',
    nutritionistName: 'Dr. Nutriólogo',
    notes: 'Traer estudios recientes'
  })
}

// 3. Se muestra confirmación al usuario
mostrarExito('✉️ Notificación enviada al paciente por email')
```

## 📦 Estructura de Archivos

```
frontend/
  src/
    services/
      emailService.js          # Servicio de EmailJS con funciones de envío
    components/
      GestionCitas.vue         # Componente que usa EmailJS para notificaciones
```

## 🔍 Funciones Disponibles

### `initEmailJS()`
Inicializa EmailJS con la Public Key. Se debe llamar al montar el componente.

### `sendAppointmentNotification(appointmentData)`
Envía notificación de cita nueva al paciente.

**Parámetros:**
- `patientName`: Nombre del paciente
- `patientEmail`: Email del paciente
- `appointmentDate`: Fecha formateada
- `appointmentTime`: Hora formateada
- `appointmentType`: Tipo de cita
- `nutritionistName`: Nombre del nutriólogo
- `notes`: Notas adicionales

**Retorna:**
```javascript
{
  success: true/false,
  message: 'Mensaje descriptivo',
  response: objeto_respuesta_emailjs
}
```

### `sendAppointmentReminder(reminderData)`
Envía recordatorio de cita próxima (extensión futura).

### `sendAppointmentCancellation(cancellationData)`
Envía notificación de cita cancelada (extensión futura).

## 💡 Ventajas de EmailJS

✅ **Sin Backend**: No requiere servidor para enviar emails  
✅ **Fácil Configuración**: Setup en minutos  
✅ **Gratis**: Plan gratuito incluye 200 emails/mes  
✅ **Plantillas**: Sistema de templates personalizable  
✅ **Seguro**: No expone credenciales en el código  
✅ **Múltiples Servicios**: Soporta Gmail, Outlook, Yahoo, etc.

## ⚠️ Limitaciones

- Plan gratuito: 200 emails por mes
- Requiere conexión a internet del cliente
- No apto para emails masivos o críticos

## 🔐 Seguridad

- ✅ La Public Key es segura para usar en frontend
- ✅ No se exponen credenciales de email
- ✅ EmailJS maneja la autenticación con el proveedor de email
- ⚠️ No incluir Service ID o Template ID sensibles en repositorios públicos

## 📊 Ejemplo de Plantilla de Email (HTML)

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; }
    .content { padding: 20px; background-color: #f9f9f9; }
    .detail { margin: 10px 0; padding: 10px; background-color: white; border-left: 3px solid #4CAF50; }
    .footer { text-align: center; color: #666; font-size: 12px; margin-top: 20px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>🏥 Confirmación de Cita - NutriTrack</h1>
    </div>
    <div class="content">
      <p>Hola <strong>{{to_name}}</strong>,</p>
      <p>Tu cita ha sido confirmada con los siguientes detalles:</p>
      
      <div class="detail">
        📅 <strong>Fecha:</strong> {{appointment_date}}
      </div>
      <div class="detail">
        ⏰ <strong>Hora:</strong> {{appointment_time}}
      </div>
      <div class="detail">
        📋 <strong>Tipo de cita:</strong> {{appointment_type}}
      </div>
      <div class="detail">
        👨‍⚕️ <strong>Nutricionista:</strong> {{nutritionist_name}}
      </div>
      
      <p><strong>Notas adicionales:</strong></p>
      <p style="background-color: #fff3cd; padding: 10px; border-radius: 5px;">
        {{notes}}
      </p>
      
      <p>¡Te esperamos!</p>
    </div>
    <div class="footer">
      <p>Este es un mensaje automático de NutriTrack. Por favor no responder a este email.</p>
    </div>
  </div>
</body>
</html>
```

## 🧪 Testing

Para probar la funcionalidad:

1. Asegúrate de tener configuradas las credenciales en `emailService.js`
2. Crea una cita desde la interfaz
3. Marca el checkbox de "Enviar notificación por email"
4. Verifica que llegue el email al paciente
5. Revisa la consola del navegador para ver logs de éxito/error

## 📚 Recursos Adicionales

- [Documentación oficial de EmailJS](https://www.emailjs.com/docs/)
- [Ejemplos de plantillas](https://www.emailjs.com/docs/examples/)
- [API Reference](https://www.emailjs.com/docs/sdk/send/)
- [Troubleshooting](https://www.emailjs.com/docs/faq/)

## 🎓 Para la Tarea

**Librería**: EmailJS (@emailjs/browser)

**Descripción**: Librería JavaScript que permite enviar emails directamente desde el navegador sin necesidad de un servidor backend. Utiliza servicios de email populares como Gmail, Outlook, etc.

**Justificación**: Permite enviar notificaciones automáticas a los pacientes cuando se crean, modifican o cancelan citas, mejorando la comunicación y reduciendo ausencias. Es ideal para aplicaciones que necesitan envío de emails sin complejidad de servidor.

**Implementación**: 
- Instalada vía npm: `npm install @emailjs/browser`
- Servicio creado en `frontend/src/services/emailService.js`
- Integrada en componente `GestionCitas.vue`
- Checkbox para activar/desactivar envío de notificaciones
- Plantillas de email personalizables en dashboard de EmailJS

**Características**:
- ✉️ Envío de notificaciones de citas
- 🔔 Recordatorios automáticos (extensible)
- ❌ Notificaciones de cancelación
- 📧 Templates personalizables con HTML
- 🔒 Seguro (no expone credenciales)
