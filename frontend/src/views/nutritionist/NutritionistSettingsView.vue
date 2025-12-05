<template>
  <div class="settings-view">
    <div class="settings-header">
      <h1>⚙️ Configuración</h1>
      <p>Personaliza tu experiencia en NutriTrack</p>
    </div>

    <div class="settings-container">
      <!-- Notificaciones -->
      <div class="settings-section">
        <div class="section-header">
          <span class="section-icon">🔔</span>
          <h2>Notificaciones</h2>
        </div>
        <div class="section-content">
          <div class="setting-item">
            <div class="setting-info">
              <h3>Notificaciones por correo</h3>
              <p>Recibe alertas de nuevas citas y actualizaciones</p>
            </div>
            <label class="toggle-switch">
              <input type="checkbox" v-model="configuracion.notificaciones.email">
              <span class="toggle-slider"></span>
            </label>
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Recordatorios de citas</h3>
              <p>Alertas 24 horas antes de cada cita</p>
            </div>
            <label class="toggle-switch">
              <input type="checkbox" v-model="configuracion.notificaciones.recordatorios">
              <span class="toggle-slider"></span>
            </label>
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Notificaciones de seguimiento</h3>
              <p>Alertas cuando pacientes actualicen su peso</p>
            </div>
            <label class="toggle-switch">
              <input type="checkbox" v-model="configuracion.notificaciones.seguimiento">
              <span class="toggle-slider"></span>
            </label>
          </div>
        </div>
      </div>

      <!-- Apariencia -->
      <div class="settings-section">
        <div class="section-header">
          <span class="section-icon">🎨</span>
          <h2>Apariencia</h2>
        </div>
        <div class="section-content">
          <div class="setting-item">
            <div class="setting-info">
              <h3>Idioma</h3>
              <p>Selecciona el idioma de la aplicación</p>
            </div>
            <select v-model="configuracion.apariencia.idioma" class="setting-select">
              <option value="es">Español</option>
              <option value="en">English</option>
            </select>
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Sistema de unidades</h3>
              <p>Métrico (kg, cm) o Imperial (lb, in)</p>
            </div>
            <select v-model="configuracion.apariencia.unidades" class="setting-select">
              <option value="metrico">Métrico</option>
              <option value="imperial">Imperial</option>
            </select>
          </div>
        </div>
      </div>

      <!-- PDF y Reportes -->
      <div class="settings-section">
        <div class="section-header">
          <span class="section-icon">📄</span>
          <h2>PDF y Reportes</h2>
        </div>
        <div class="section-content">
          <div class="setting-item">
            <div class="setting-info">
              <h3>Incluir logo en PDFs</h3>
              <p>Agrega tu logo profesional a todos los reportes</p>
            </div>
            <label class="toggle-switch">
              <input type="checkbox" v-model="configuracion.pdf.incluirLogo">
              <span class="toggle-slider"></span>
            </label>
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Pie de página personalizado</h3>
              <p>Texto que aparecerá en todos los PDFs generados</p>
            </div>
            <input 
              type="text" 
              v-model="configuracion.pdf.piePagina" 
              class="setting-input"
              placeholder="Ej: Nutrición profesional - www.ejemplo.com"
            >
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Formato de fecha</h3>
              <p>Cómo se mostrarán las fechas en los reportes</p>
            </div>
            <select v-model="configuracion.pdf.formatoFecha" class="setting-select">
              <option value="DD/MM/YYYY">DD/MM/YYYY</option>
              <option value="MM/DD/YYYY">MM/DD/YYYY</option>
              <option value="YYYY-MM-DD">YYYY-MM-DD</option>
            </select>
          </div>
        </div>
      </div>

      <!-- Privacidad y Seguridad -->
      <div class="settings-section">
        <div class="section-header">
          <span class="section-icon">🔒</span>
          <h2>Privacidad y Seguridad</h2>
        </div>
        <div class="section-content">
          <div class="setting-item">
            <div class="setting-info">
              <h3>Autenticación de dos factores</h3>
              <p>Seguridad adicional para tu cuenta (Próximamente)</p>
            </div>
            <label class="toggle-switch">
              <input type="checkbox" v-model="configuracion.seguridad.dobleFactor" disabled>
              <span class="toggle-slider"></span>
            </label>
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Tiempo de sesión</h3>
              <p>Cerrar sesión automáticamente después de inactividad</p>
            </div>
            <select v-model="configuracion.seguridad.tiempoSesion" class="setting-select">
              <option value="30">30 minutos</option>
              <option value="60">1 hora</option>
              <option value="120">2 horas</option>
              <option value="0">Nunca</option>
            </select>
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Cambiar contraseña</h3>
              <p>Actualiza tu contraseña periódicamente</p>
            </div>
            <button @click="irACambiarPassword" class="btn-action">
              Cambiar Contraseña
            </button>
          </div>
        </div>
      </div>

      <!-- Configuración Profesional -->
      <div class="settings-section">
        <div class="section-header">
          <span class="section-icon">👨‍⚕️</span>
          <h2>Configuración Profesional</h2>
        </div>
        <div class="section-content">
          <div class="setting-item">
            <div class="setting-info">
              <h3>Duración de citas</h3>
              <p>Tiempo predeterminado para cada consulta</p>
            </div>
            <select v-model="configuracion.profesional.duracionCitas" class="setting-select">
              <option value="30">30 minutos</option>
              <option value="45">45 minutos</option>
              <option value="60">60 minutos</option>
              <option value="90">90 minutos</option>
            </select>
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Horario de trabajo</h3>
              <p>Define tu disponibilidad habitual</p>
            </div>
            <div class="time-range">
              <input 
                type="time" 
                v-model="configuracion.profesional.horarioInicio" 
                class="time-input"
              >
              <span>a</span>
              <input 
                type="time" 
                v-model="configuracion.profesional.horarioFin" 
                class="time-input"
              >
            </div>
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Especialidades</h3>
              <p>Áreas de especialización (separadas por coma)</p>
            </div>
            <input 
              type="text" 
              v-model="configuracion.profesional.especialidades" 
              class="setting-input"
              placeholder="Ej: Nutrición deportiva, Pérdida de peso, Diabetes"
            >
          </div>
        </div>
      </div>

      <!-- Integraciones -->
      <div class="settings-section">
        <div class="section-header">
          <span class="section-icon">🔗</span>
          <h2>Integraciones</h2>
        </div>
        <div class="section-content">
          <div class="setting-item">
            <div class="setting-info">
              <h3>Sincronización con Google Calendar</h3>
              <p>Sincroniza tus citas automáticamente (Próximamente)</p>
            </div>
            <button class="btn-integration" disabled>
              <span>📅</span> Conectar Google Calendar
            </button>
          </div>

          <div class="setting-item">
            <div class="setting-info">
              <h3>Exportación de datos</h3>
              <p>Exporta toda tu información en formato CSV</p>
            </div>
            <button @click="exportarDatos" class="btn-integration">
              <span>💾</span> Exportar Datos
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Botones de acción -->
    <div class="settings-footer">
      <button @click="guardarConfiguracion" class="btn-save">
        💾 Guardar Cambios
      </button>
      <button @click="restaurarDefecto" class="btn-reset">
        🔄 Restaurar Valores por Defecto
      </button>
    </div>

    <!-- Snackbar -->
    <div v-if="snackbar.show" class="snackbar" :class="snackbar.color">
      {{ snackbar.message }}
    </div>
  </div>
</template>

<script>
import { ref, onMounted, watch } from 'vue';
import { useRouter } from 'vue-router';

export default {
  name: 'NutritionistSettingsView',
  setup() {
    const router = useRouter();
    
    const configuracion = ref({
      notificaciones: {
        email: true,
        recordatorios: true,
        seguimiento: false
      },
      apariencia: {
        idioma: 'es',
        unidades: 'metrico'
      },
      pdf: {
        incluirLogo: true,
        piePagina: '',
        formatoFecha: 'DD/MM/YYYY'
      },
      seguridad: {
        dobleFactor: false,
        tiempoSesion: 60
      },
      profesional: {
        duracionCitas: 45,
        horarioInicio: '09:00',
        horarioFin: '18:00',
        especialidades: ''
      }
    });

    const snackbar = ref({
      show: false,
      message: '',
      color: 'success'
    });

    const cargarConfiguracion = () => {
      const configGuardada = localStorage.getItem('nutritrack_config');
      if (configGuardada) {
        configuracion.value = { ...configuracion.value, ...JSON.parse(configGuardada) };
      }
    };

    const guardarConfiguracion = () => {
      localStorage.setItem('nutritrack_config', JSON.stringify(configuracion.value));
      mostrarSnackbar('✅ Configuración guardada exitosamente', 'success');
    };

    const restaurarDefecto = () => {
      if (confirm('¿Estás seguro de restaurar todos los valores por defecto?')) {
        configuracion.value = {
          notificaciones: {
            email: true,
            recordatorios: true,
            seguimiento: false
          },
          apariencia: {
            idioma: 'es',
            unidades: 'metrico'
          },
          pdf: {
            incluirLogo: true,
            piePagina: '',
            formatoFecha: 'DD/MM/YYYY'
          },
          seguridad: {
            dobleFactor: false,
            tiempoSesion: 60
          },
          profesional: {
            duracionCitas: 45,
            horarioInicio: '09:00',
            horarioFin: '18:00',
            especialidades: ''
          }
        };
        localStorage.removeItem('nutritrack_config');
        mostrarSnackbar('🔄 Configuración restaurada', 'info');
      }
    };

    const irACambiarPassword = () => {
      router.push('/nutriologo/perfil');
      // Scroll a la sección de cambiar contraseña después de un pequeño delay
      setTimeout(() => {
        const passwordSection = document.querySelector('.cambio-password-section');
        if (passwordSection) {
          passwordSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
      }, 500);
    };

    const exportarDatos = () => {
      mostrarSnackbar('📊 Preparando exportación... (Función en desarrollo)', 'info');
      // TODO: Implementar exportación real
    };

    const mostrarSnackbar = (mensaje, color) => {
      snackbar.value = {
        show: true,
        message: mensaje,
        color: color
      };
      
      setTimeout(() => {
        snackbar.value.show = false;
      }, 3000);
    };

    onMounted(() => {
      cargarConfiguracion();
    });

    return {
      configuracion,
      snackbar,
      guardarConfiguracion,
      restaurarDefecto,
      irACambiarPassword,
      exportarDatos
    };
  }
};
</script>

<style scoped>
.settings-view {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
  animation: fadeIn 0.3s ease-in;
}

.settings-header {
  text-align: center;
  margin-bottom: 3rem;
  padding-bottom: 2rem;
  border-bottom: 3px solid #e0e0e0;
}

.settings-header h1 {
  font-size: 2.5rem;
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.settings-header p {
  font-size: 1.1rem;
  color: #7f8c8d;
}

.settings-container {
  display: grid;
  gap: 2rem;
  margin-bottom: 2rem;
}

.settings-section {
  background: white;
  border-radius: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  overflow: hidden;
  transition: transform 0.2s ease;
}

.settings-section:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.section-header {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1.5rem;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.section-icon {
  font-size: 2rem;
}

.section-header h2 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 600;
}

.section-content {
  padding: 1.5rem;
}

.setting-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1.5rem;
  border-bottom: 1px solid #f0f0f0;
  gap: 2rem;
}

.setting-item:last-child {
  border-bottom: none;
}

.setting-info {
  flex: 1;
}

.setting-info h3 {
  margin: 0 0 0.5rem 0;
  font-size: 1.1rem;
  color: #2c3e50;
  font-weight: 600;
}

.setting-info p {
  margin: 0;
  font-size: 0.9rem;
  color: #7f8c8d;
}

/* Toggle Switch */
.toggle-switch {
  position: relative;
  display: inline-block;
  width: 56px;
  height: 28px;
  flex-shrink: 0;
}

.toggle-switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.toggle-slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: 0.3s;
  border-radius: 28px;
}

.toggle-slider:before {
  position: absolute;
  content: "";
  height: 20px;
  width: 20px;
  left: 4px;
  bottom: 4px;
  background-color: white;
  transition: 0.3s;
  border-radius: 50%;
}

.toggle-switch input:checked + .toggle-slider {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.toggle-switch input:checked + .toggle-slider:before {
  transform: translateX(28px);
}

.toggle-switch input:disabled + .toggle-slider {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Inputs */
.setting-select,
.setting-input,
.time-input {
  padding: 0.75rem 1rem;
  border: 2px solid #e0e0e0;
  border-radius: 8px;
  font-size: 1rem;
  transition: all 0.3s ease;
  background: white;
  min-width: 200px;
}

.setting-select:focus,
.setting-input:focus,
.time-input:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.time-range {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.time-input {
  min-width: 120px;
}

/* Botones */
.btn-action,
.btn-integration {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-action {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.btn-action:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.btn-integration {
  background: white;
  color: #667eea;
  border: 2px solid #667eea;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.btn-integration:hover:not(:disabled) {
  background: #667eea;
  color: white;
}

.btn-integration:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Footer */
.settings-footer {
  display: flex;
  justify-content: center;
  gap: 1rem;
  padding: 2rem;
  background: white;
  border-radius: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.btn-save,
.btn-reset {
  padding: 1rem 2rem;
  border: none;
  border-radius: 12px;
  font-size: 1.1rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-save {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  color: white;
}

.btn-save:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(17, 153, 142, 0.4);
}

.btn-reset {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  color: white;
}

.btn-reset:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(245, 87, 108, 0.4);
}

/* Snackbar */
.snackbar {
  position: fixed;
  bottom: 2rem;
  left: 50%;
  transform: translateX(-50%);
  padding: 1rem 2rem;
  border-radius: 12px;
  color: white;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
  z-index: 10000;
  animation: slideUp 0.3s ease;
}

.snackbar.success {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
}

.snackbar.info {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* Animations */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateX(-50%) translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateX(-50%) translateY(0);
  }
}

/* Responsive */
@media (max-width: 768px) {
  .settings-view {
    padding: 1rem;
  }

  .settings-header h1 {
    font-size: 2rem;
  }

  .setting-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .setting-select,
  .setting-input {
    width: 100%;
  }

  .settings-footer {
    flex-direction: column;
  }

  .btn-save,
  .btn-reset {
    width: 100%;
  }
}
</style>
