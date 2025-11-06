import emailjs from '@emailjs/browser';

// Configuración de EmailJS
// IMPORTANTE: Estos valores deben ser reemplazados con tus credenciales reales de EmailJS
// Para obtenerlas:
// 1. Crea una cuenta en https://www.emailjs.com/
// 2. Crea un servicio de email (Gmail, Outlook, etc.)
// 3. Crea una plantilla de email
// 4. Obtén tu Public Key desde Account > API Keys
const EMAILJS_CONFIG = {
  serviceId: 'Nutritrack',           // Tu Service ID
  templateId: 'template_dioeknw',    // Tu Template ID
  publicKey: 'BLU6HXAV_22F4fzPv'     // Tu Public Key
};

/**
 * Inicializa EmailJS con la clave pública
 */
export const initEmailJS = () => {
  emailjs.init(EMAILJS_CONFIG.publicKey);
};

/**
 * Envía un email de notificación de cita
 * @param {Object} appointmentData - Datos de la cita
 * @param {string} appointmentData.patientName - Nombre del paciente
 * @param {string} appointmentData.patientEmail - Email del paciente
 * @param {string} appointmentData.appointmentDate - Fecha de la cita
 * @param {string} appointmentData.appointmentTime - Hora de la cita
 * @param {string} appointmentData.appointmentType - Tipo de cita
 * @param {string} appointmentData.nutritionistName - Nombre del nutriólogo
 * @param {string} appointmentData.notes - Notas adicionales
 * @returns {Promise} - Promesa con el resultado del envío
 */
export const sendAppointmentNotification = async (appointmentData) => {
  try {
    // Parámetros que se enviarán al template de EmailJS
    const templateParams = {
      to_name: appointmentData.patientName,
      to_email: appointmentData.patientEmail,
      appointment_date: appointmentData.appointmentDate,
      appointment_time: appointmentData.appointmentTime,
      appointment_type: appointmentData.appointmentType,
      nutritionist_name: appointmentData.nutritionistName,
      notes: appointmentData.notes || 'Sin notas adicionales',
      subject: `Confirmación de Cita - NutriTrack`
    };

    // Envía el email usando EmailJS
    const response = await emailjs.send(
      EMAILJS_CONFIG.serviceId,
      EMAILJS_CONFIG.templateId,
      templateParams
    );

    console.log('Email enviado exitosamente:', response);
    return {
      success: true,
      message: 'Notificación enviada correctamente',
      response
    };
  } catch (error) {
    console.error('Error al enviar email:', error);
    return {
      success: false,
      message: 'Error al enviar la notificación',
      error
    };
  }
};

/**
 * Envía un email de recordatorio de cita
 * @param {Object} reminderData - Datos del recordatorio
 * @returns {Promise} - Promesa con el resultado del envío
 */
export const sendAppointmentReminder = async (reminderData) => {
  try {
    const templateParams = {
      to_name: reminderData.patientName,
      to_email: reminderData.patientEmail,
      appointment_date: reminderData.appointmentDate,
      appointment_time: reminderData.appointmentTime,
      subject: `Recordatorio de Cita - NutriTrack`
    };

    const response = await emailjs.send(
      EMAILJS_CONFIG.serviceId,
      'template_reminder', // Template diferente para recordatorios
      templateParams
    );

    return {
      success: true,
      message: 'Recordatorio enviado correctamente',
      response
    };
  } catch (error) {
    console.error('Error al enviar recordatorio:', error);
    return {
      success: false,
      message: 'Error al enviar el recordatorio',
      error
    };
  }
};

/**
 * Envía un email de cancelación de cita
 * @param {Object} cancellationData - Datos de la cancelación
 * @returns {Promise} - Promesa con el resultado del envío
 */
export const sendAppointmentCancellation = async (cancellationData) => {
  try {
    const templateParams = {
      to_name: cancellationData.patientName,
      to_email: cancellationData.patientEmail,
      appointment_date: cancellationData.appointmentDate,
      cancellation_reason: cancellationData.reason || 'No especificada',
      subject: `Cancelación de Cita - NutriTrack`
    };

    const response = await emailjs.send(
      EMAILJS_CONFIG.serviceId,
      'template_cancellation', // Template para cancelaciones
      templateParams
    );

    return {
      success: true,
      message: 'Notificación de cancelación enviada',
      response
    };
  } catch (error) {
    console.error('Error al enviar cancelación:', error);
    return {
      success: false,
      message: 'Error al enviar la notificación de cancelación',
      error
    };
  }
};

export default {
  initEmailJS,
  sendAppointmentNotification,
  sendAppointmentReminder,
  sendAppointmentCancellation
};
