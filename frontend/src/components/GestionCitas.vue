<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <h2 class="text-h4 mb-4">
          <v-icon class="mr-2">mdi-calendar-plus</v-icon>
          Gestión de Citas
        </h2>
      </v-col>
    </v-row>

    <!-- Formulario para nueva cita -->
    <v-row>
      <v-col cols="12" md="6">
        <v-card elevation="2">
          <v-card-title class="bg-green text-white">
            <v-icon class="mr-2">mdi-plus</v-icon>
            Nueva Cita
          </v-card-title>
          <v-card-text class="pa-4">
            <v-form @submit.prevent="crearCita" ref="form">
              <v-select
                v-model="nuevaCita.patientId"
                :items="pacientes"
                item-title="fullName"
                item-value="id"
                label="Paciente"
                prepend-icon="mdi-account"
                :rules="[v => !!v || 'Seleccione un paciente']"
                required
              ></v-select>

              <v-text-field
                v-model="nuevaCita.appointmentDate"
                label="Fecha y Hora"
                type="datetime-local"
                prepend-icon="mdi-calendar-clock"
                :rules="[v => !!v || 'Seleccione fecha y hora']"
                required
              ></v-text-field>

              <v-select
                v-model="nuevaCita.appointmentType"
                :items="tiposCita"
                label="Tipo de Cita"
                prepend-icon="mdi-clipboard-text"
                :rules="[v => !!v || 'Seleccione el tipo de cita']"
                required
              ></v-select>

              <v-text-field
                v-model="nuevaCita.duration"
                label="Duración (minutos)"
                type="number"
                prepend-icon="mdi-clock"
                :rules="[v => v > 0 || 'Duración debe ser mayor a 0']"
              ></v-text-field>

              <v-checkbox
                v-model="nuevaCita.sendEmail"
                label="Enviar notificación por email al paciente"
                color="green"
                hint="Se enviará un email al paciente con los detalles de la cita"
                persistent-hint
              >
                <template v-slot:label>
                  <span class="d-flex align-center">
                    <v-icon class="mr-2" size="small">mdi-email-send</v-icon>
                    Enviar notificación por email al paciente
                  </span>
                </template>
              </v-checkbox>

              <v-btn
                type="submit"
                color="green"
                block
                size="large"
                :loading="loading"
                class="mt-3"
              >
                <v-icon class="mr-2">mdi-calendar-plus</v-icon>
                Crear Cita
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Citas de hoy -->
      <v-col cols="12" md="6">
        <v-card elevation="2">
          <v-card-title class="bg-blue text-white">
            <v-icon class="mr-2">mdi-calendar-today</v-icon>
            Citas de Hoy
          </v-card-title>
          <v-card-text class="pa-0">
            <v-list v-if="citasHoy.length > 0">
              <v-list-item
                v-for="cita in citasHoy"
                :key="cita.id"
                class="border-b"
              >
                <template v-slot:prepend>
                  <v-avatar color="blue" size="40">
                    <v-icon color="white">mdi-account</v-icon>
                  </v-avatar>
                </template>

                <v-list-item-title>
                  {{ cita.patient?.firstName }} {{ cita.patient?.lastName }}
                </v-list-item-title>
                <v-list-item-subtitle>
                  {{ formatearHora(cita.appointmentDate) }} - {{ cita.appointmentType }}
                </v-list-item-subtitle>

                <template v-slot:append>
                  <v-chip
                    :color="getStatusColor(cita.status)"
                    size="small"
                    variant="flat"
                  >
                    {{ cita.status }}
                  </v-chip>
                </template>
              </v-list-item>
            </v-list>
            <v-card-text v-else class="text-center text-grey">
              <v-icon size="48" class="mb-2">mdi-calendar-blank</v-icon>
              <div>No hay citas programadas para hoy</div>
            </v-card-text>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Lista completa de citas -->
    <v-row class="mt-4">
      <v-col cols="12">
        <v-card elevation="2">
          <v-card-title class="bg-orange text-white d-flex justify-space-between align-center">
            <span>
              <v-icon class="mr-2">mdi-calendar-multiple</v-icon>
              Todas las Citas
            </span>
            <v-btn 
              color="white" 
              variant="outlined" 
              @click="cargarCitas"
              size="small"
            >
              <v-icon class="mr-1">mdi-refresh</v-icon>
              Actualizar
            </v-btn>
          </v-card-title>
          <v-card-text class="pa-0">
            <v-data-table
              :headers="headers"
              :items="todasLasCitas"
              :loading="loadingTable"
              no-data-text="No hay citas registradas"
              loading-text="Cargando citas..."
              class="elevation-0"
            >
              <template v-slot:item.patient="{ item }">
                {{ item.patient?.firstName }} {{ item.patient?.lastName }}
              </template>

              <template v-slot:item.appointmentDate="{ item }">
                {{ formatearFechaCompleta(item.appointmentDate) }}
              </template>

              <template v-slot:item.status="{ item }">
                <v-chip
                  :color="getStatusColor(item.status)"
                  size="small"
                  variant="flat"
                >
                  {{ item.status }}
                </v-chip>
              </template>

              <template v-slot:item.actions="{ item }">
                <v-btn
                  color="primary"
                  variant="text"
                  size="small"
                  @click="editarCita(item)"
                >
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
                <v-btn
                  color="error"
                  variant="text"
                  size="small"
                  @click="cancelarCita(item)"
                  v-if="item.status !== 'CANCELLED'"
                >
                  <v-icon>mdi-cancel</v-icon>
                </v-btn>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Snackbar para notificaciones -->
    <v-snackbar
      v-model="snackbar.show"
      :color="snackbar.color"
      timeout="3000"
    >
      {{ snackbar.message }}
    </v-snackbar>
  </v-container>
</template>

<script>
import api from '@/services/api'
import { sendAppointmentNotification, initEmailJS } from '@/services/emailService'

export default {
  name: 'GestionCitas',
  data() {
    return {
      loading: false,
      loadingTable: false,
      pacientes: [],
      citasHoy: [],
      todasLasCitas: [],
      nuevaCita: {
        patientId: null,
        appointmentDate: '',
        appointmentType: 'CONSULTATION',
        duration: 60,
        sendEmail: true // Nueva opción para enviar email
      },
      tiposCita: [
        { title: 'Consulta', value: 'CONSULTATION' },
        { title: 'Seguimiento', value: 'FOLLOW_UP' },
        { title: 'Emergencia', value: 'EMERGENCY' }
      ],
      headers: [
        { title: 'Paciente', key: 'patient', sortable: true },
        { title: 'Fecha y Hora', key: 'appointmentDate', sortable: true },
        { title: 'Tipo', key: 'appointmentType', sortable: false },
        { title: 'Duración', key: 'durationMinutes', sortable: false },
        { title: 'Estado', key: 'status', sortable: true },
        { title: 'Acciones', key: 'actions', sortable: false }
      ],
      snackbar: {
        show: false,
        message: '',
        color: 'success'
      }
    }
  },
  mounted() {
    // Inicializar EmailJS al montar el componente
    initEmailJS()
    this.cargarDatos()
  },
  methods: {
    async cargarDatos() {
      await Promise.all([
        this.cargarPacientes(),
        this.cargarCitasHoy(),
        this.cargarCitas()
      ])
    },

    async cargarPacientes() {
      try {
        const response = await api.get('/appointments/patients')
        this.pacientes = response.data.map(p => ({
          ...p,
          fullName: `${p.firstName} ${p.lastName}`
        }))
      } catch (error) {
        this.mostrarError('Error al cargar pacientes')
      }
    },

    async cargarCitasHoy() {
      try {
        const response = await api.get('/appointments/today')
        this.citasHoy = response.data
      } catch (error) {
        this.mostrarError('Error al cargar citas de hoy')
      }
    },

    async cargarCitas() {
      this.loadingTable = true
      try {
        const response = await api.get('/appointments')
        this.todasLasCitas = response.data
      } catch (error) {
        this.mostrarError('Error al cargar citas')
      } finally {
        this.loadingTable = false
      }
    },

    async crearCita() {
      // Validar que todos los campos requeridos estén completos
      if (!this.nuevaCita.patientId || !this.nuevaCita.appointmentDate || !this.nuevaCita.appointmentType) {
        this.mostrarError('Por favor complete todos los campos requeridos')
        return
      }

      this.loading = true
      try {
        const response = await api.post('/appointments', this.nuevaCita)
        const citaCreada = response.data
        
        // Enviar notificación por email si la opción está activada
        if (this.nuevaCita.sendEmail) {
          // Pasar el objeto completo con todos los datos necesarios
          await this.enviarNotificacionEmail({
            ...citaCreada,
            patientId: this.nuevaCita.patientId // Asegurar que tenemos el patientId
          })
        }
        
        this.mostrarExito('Cita creada exitosamente')
        this.limpiarFormulario()
        await this.cargarDatos()
        
      } catch (error) {
        const message = error.response?.data?.message || 'Error al crear la cita'
        this.mostrarError(message)
      } finally {
        this.loading = false
      }
    },

    async enviarNotificacionEmail(cita) {
      try {
        // Buscar datos del paciente
        const paciente = this.pacientes.find(p => p.id === cita.patientId)
        
        console.log('Paciente encontrado:', paciente)
        console.log('Email del paciente:', paciente?.email)
        
        if (!paciente || !paciente.email) {
          console.warn('Paciente sin email, no se puede enviar notificación')
          console.warn('Datos del paciente:', JSON.stringify(paciente, null, 2))
          return
        }

        // Formatear fecha y hora - usar el valor original del formulario
        const fechaOriginal = this.nuevaCita.appointmentDate // Formato: "2025-11-05T14:30"
        const fechaCita = new Date(fechaOriginal)
        
        console.log('Fecha original del formulario:', fechaOriginal)
        console.log('Fecha parseada:', fechaCita)
        
        const fecha = fechaCita.toLocaleDateString('es-ES', {
          weekday: 'long',
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        })
        const hora = fechaCita.toLocaleTimeString('es-ES', {
          hour: '2-digit',
          minute: '2-digit'
        })

        // Obtener nombre del tipo de cita
        const tipoCitaObj = this.tiposCita.find(t => t.value === cita.appointmentType)
        const tipoCita = tipoCitaObj ? tipoCitaObj.title : cita.appointmentType

        // Datos para el email
        const emailData = {
          patientName: `${paciente.firstName} ${paciente.lastName}`,
          patientEmail: paciente.email,
          appointmentDate: fecha,
          appointmentTime: hora,
          appointmentType: tipoCita,
          nutritionistName: 'Dr. Nutriólogo NutriTrack', // Puedes obtener el nombre real del usuario logueado
          notes: cita.notes || 'Recuerde llegar 10 minutos antes de su cita'
        }

        // Enviar email usando EmailJS
        const resultado = await sendAppointmentNotification(emailData)
        
        if (resultado.success) {
          this.mostrarInfo('✉️ Notificación enviada al paciente por email')
        } else {
          console.warn('No se pudo enviar la notificación por email:', resultado.error)
        }
      } catch (error) {
        console.error('Error al enviar notificación:', error)
        // No mostramos error al usuario para no interrumpir el flujo
      }
    },

    async cancelarCita(cita) {
      if (!confirm(`¿Está seguro de cancelar la cita con ${cita.patient?.firstName} ${cita.patient?.lastName}?`)) {
        return
      }

      try {
        await api.delete(`/appointments/${cita.id}`)
        this.mostrarExito('Cita cancelada exitosamente')
        await this.cargarDatos()
      } catch (error) {
        this.mostrarError('Error al cancelar la cita')
      }
    },

    editarCita(cita) {
      // Por ahora solo mostrar mensaje, se puede implementar modal de edición
      this.mostrarInfo('Función de edición en desarrollo')
    },

    limpiarFormulario() {
      this.nuevaCita = {
        patientId: null,
        appointmentDate: '',
        appointmentType: 'CONSULTATION',
        duration: 60,
        sendEmail: true
      }
      
      // Resetear el formulario de manera segura
      if (this.$refs.form) {
        this.$nextTick(() => {
          this.$refs.form.reset()
        })
      }
    },

    formatearHora(fecha) {
      return new Date(fecha).toLocaleTimeString('es-ES', {
        hour: '2-digit',
        minute: '2-digit'
      })
    },

    formatearFechaCompleta(fecha) {
      return new Date(fecha).toLocaleString('es-ES', {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      })
    },

    getStatusColor(status) {
      const colors = {
        'SCHEDULED': 'blue',
        'COMPLETED': 'green',
        'CANCELLED': 'red',
        'NO_SHOW': 'orange'
      }
      return colors[status] || 'grey'
    },

    mostrarExito(message) {
      this.snackbar = { show: true, message, color: 'success' }
    },

    mostrarError(message) {
      this.snackbar = { show: true, message, color: 'error' }
    },

    mostrarInfo(message) {
      this.snackbar = { show: true, message, color: 'info' }
    }
  }
}
</script>

<style scoped>
.border-b {
  border-bottom: 1px solid #e0e0e0;
}
</style>