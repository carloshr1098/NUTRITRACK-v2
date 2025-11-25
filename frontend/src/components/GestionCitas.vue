<template>
  <div class="appointments-container">
    <!-- Header elegante -->
    <div class="appointments-header">
      <div class="header-content">
        <div class="header-icon">📅</div>
        <div class="header-text">
          <h1 class="header-title">Gestión de Citas</h1>
          <p class="header-subtitle">Programar y gestionar citas médicas</p>
        </div>
      </div>
    </div>

  <v-container class="appointments-content">

    <!-- Formulario para nueva cita -->
    <v-row>
      <v-col cols="12" md="6">
        <v-card elevation="3" class="modern-card form-card">
          <v-card-title class="card-header-green">
            <v-icon class="mr-2">mdi-plus</v-icon>
            Nueva Cita
          </v-card-title>
          <v-card-text class="pa-4">
            <v-form @submit.prevent="crearCita" ref="form">
              <v-select
                v-model="nuevaCita.idPaciente"
                :items="pacientes"
                item-title="fullName"
                item-value="id"
                label="Paciente"
                prepend-icon="mdi-account"
                :rules="[v => !!v || 'Seleccione un paciente']"
                required
              ></v-select>

              <v-text-field
                v-model="nuevaCita.fechaCita"
                label="Fecha y Hora"
                type="datetime-local"
                prepend-icon="mdi-calendar-clock"
                :rules="[v => !!v || 'Seleccione fecha y hora']"
                :min="fechaMinima"
                required
                hint="Solo se permiten citas en punto (ej: 14:00) o media hora (ej: 14:30)"
                persistent-hint
              ></v-text-field>

              <v-select
                v-model="nuevaCita.tipoCita"
                :items="tiposCita"
                label="Tipo de Cita"
                prepend-icon="mdi-clipboard-text"
                :rules="[v => !!v || 'Seleccione el tipo de cita']"
                required
              ></v-select>

              <v-select
                v-model="nuevaCita.duracion"
                :items="opcionesDuracion"
                label="Duración"
                prepend-icon="mdi-clock"
                :rules="[v => !!v || 'Seleccione la duración']"
                required
              ></v-select>

              <v-checkbox
                v-model="nuevaCita.enviarEmail"
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
                :loading="cargando"
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
        <v-card elevation="3" class="modern-card today-card">
          <v-card-title class="card-header-blue">
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
                  {{ formatearHora(cita.appointmentDate) }} - {{ traducirTipoCita(cita.appointmentType) }}
                </v-list-item-subtitle>

                <template v-slot:append>
                  <v-chip
                    :color="getStatusColor(cita.status)"
                    size="small"
                    variant="flat"
                  >
                    {{ traducirEstado(cita.status) }}
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
        <v-card elevation="3" class="modern-card list-card">
          <v-card-title class="card-header-orange d-flex justify-space-between align-center">
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
              :headers="encabezados"
              :items="todasLasCitas"
              :loading="cargandoTabla"
              no-data-text="No hay citas registradas"
              loading-text="Cargando citas..."
              class="elevation-0"
            >
              <template v-slot:item.patient="{ item }">
                {{ item.patient?.firstName }} {{ item.patient?.lastName }}
              </template>

              <template v-slot:item.fecha="{ item }">
                {{ formatearSoloFecha(item.appointmentDate) }}
              </template>

              <template v-slot:item.hora="{ item }">
                {{ formatearHora(item.appointmentDate) }}
              </template>

              <template v-slot:item.appointmentType="{ item }">
                {{ traducirTipoCita(item.appointmentType) }}
              </template>

              <template v-slot:item.status="{ item }">
                <v-chip
                  :color="getStatusColor(item.status)"
                  size="small"
                  variant="flat"
                >
                  {{ traducirEstado(item.status) }}
                </v-chip>
              </template>

              <template v-slot:item.actions="{ item }">
                <v-btn
                  color="success"
                  variant="text"
                  size="small"
                  @click="marcarComoAtendida(item)"
                  v-if="item.status === 'SCHEDULED' || item.status === 'CONFIRMED'"
                  title="Marcar como atendida"
                >
                  <v-icon>mdi-check-circle</v-icon>
                </v-btn>
                <v-btn
                  color="primary"
                  variant="text"
                  size="small"
                  @click="editarCita(item)"
                  v-if="item.status !== 'CANCELLED' && item.status !== 'ATENDIDO'"
                >
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
                <v-btn
                  color="error"
                  variant="text"
                  size="small"
                  @click="cancelarCita(item)"
                  v-if="item.status !== 'CANCELLED' && item.status !== 'ATENDIDO'"
                >
                  <v-icon>mdi-cancel</v-icon>
                </v-btn>
                <v-btn
                  color="error"
                  variant="text"
                  size="small"
                  @click="eliminarCita(item)"
                  v-if="item.status === 'CANCELLED'"
                >
                  <v-icon>mdi-delete</v-icon>
                </v-btn>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Diálogo de confirmación bonito -->
    <v-dialog v-model="dialogoConfirmacion.mostrar" max-width="500">
      <v-card>
        <v-card-title class="text-h5 bg-orange-lighten-1 text-white">
          <v-icon class="mr-2">mdi-alert-circle</v-icon>
          {{ dialogoConfirmacion.titulo }}
        </v-card-title>
        <v-card-text class="pt-4">
          <p class="text-h6">{{ dialogoConfirmacion.mensaje }}</p>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="grey"
            variant="text"
            @click="dialogoConfirmacion.mostrar = false"
          >
            Cancelar
          </v-btn>
          <v-btn
            color="error"
            variant="elevated"
            @click="confirmarAccion"
          >
            Confirmar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo de edición de cita -->
    <v-dialog v-model="dialogoEdicion.mostrar" max-width="600">
      <v-card>
        <v-card-title class="text-h5 bg-primary text-white">
          <v-icon class="mr-2">mdi-pencil</v-icon>
          Editar Cita
        </v-card-title>
        <v-card-text class="pt-4">
          <v-form ref="formEdicion" @submit.prevent="guardarCambiosCita">
            <v-select
              v-model="citaEdicion.idPaciente"
              :items="pacientes"
              item-title="fullName"
              item-value="id"
              label="Paciente"
              prepend-icon="mdi-account"
              :rules="[v => !!v || 'Seleccione un paciente']"
              required
            ></v-select>

            <v-text-field
              v-model="citaEdicion.fechaCita"
              label="Fecha y Hora"
              type="datetime-local"
              prepend-icon="mdi-calendar-clock"
              :rules="[v => !!v || 'Seleccione fecha y hora']"
              :min="fechaMinima"
              required
              hint="Solo se permiten citas en punto (ej: 14:00) o media hora (ej: 14:30)"
              persistent-hint
            ></v-text-field>

            <v-select
              v-model="citaEdicion.tipoCita"
              :items="tiposCita"
              label="Tipo de Cita"
              prepend-icon="mdi-clipboard-text"
              :rules="[v => !!v || 'Seleccione el tipo de cita']"
              required
            ></v-select>

            <v-select
              v-model="citaEdicion.duracion"
              :items="opcionesDuracion"
              label="Duración"
              prepend-icon="mdi-clock"
              :rules="[v => !!v || 'Seleccione la duración']"
              required
            ></v-select>

            <v-textarea
              v-model="citaEdicion.notas"
              label="Notas"
              prepend-icon="mdi-note-text"
              rows="3"
              hint="Notas adicionales sobre la cita"
            ></v-textarea>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="grey"
            variant="text"
            @click="cerrarDialogoEdicion"
          >
            Cancelar
          </v-btn>
          <v-btn
            color="primary"
            variant="elevated"
            @click="guardarCambiosCita"
            :loading="cargando"
          >
            <v-icon class="mr-2">mdi-content-save</v-icon>
            Guardar Cambios
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Snackbar para notificaciones -->
    <v-snackbar
      v-model="notificacion.mostrar"
      :color="notificacion.color"
      timeout="3000"
    >
      {{ notificacion.mensaje }}
    </v-snackbar>
  </v-container>

  <!-- Botón de volver -->
  <div class="back-button-container">
    <router-link to="/dashboard" class="btn-back">
      <span class="btn-icon">←</span>
      Volver al Dashboard
    </router-link>
  </div>
  </div>
</template>

<script>
import api from '@/services/api'
import { sendAppointmentNotification, initEmailJS } from '@/services/emailService'

export default {
  name: 'GestionCitas',
  data() {
    return {
      cargando: false,
      cargandoTabla: false,
      pacientes: [],
      citasHoy: [],
      todasLasCitas: [],
      nuevaCita: {
        idPaciente: null,
        fechaCita: '',
        tipoCita: 'CONSULTATION',
        duracion: 60,
        enviarEmail: true // Nueva opción para enviar email
      },
      tiposCita: [
        { title: 'Consulta', value: 'CONSULTATION' },
        { title: 'Seguimiento', value: 'FOLLOW_UP' },
        { title: 'Emergencia', value: 'EMERGENCY' }
      ],
      opcionesDuracion: [
        { title: '30 minutos', value: 30 },
        { title: '60 minutos', value: 60 }
      ],
      encabezados: [
        { title: 'Paciente', key: 'patient', sortable: true },
        { title: 'Fecha', key: 'fecha', sortable: true },
        { title: 'Hora', key: 'hora', sortable: false },
        { title: 'Tipo', key: 'appointmentType', sortable: false },
        { title: 'Duración', key: 'durationMinutes', sortable: false },
        { title: 'Estado', key: 'status', sortable: true },
        { title: 'Acciones', key: 'actions', sortable: false }
      ],
      notificacion: {
        mostrar: false,
        mensaje: '',
        color: 'success'
      },
      dialogoConfirmacion: {
        mostrar: false,
        titulo: '',
        mensaje: '',
        accion: null,
        citaSeleccionada: null
      },
      dialogoEdicion: {
        mostrar: false,
        cita: null
      },
      citaEdicion: {
        id: null,
        idPaciente: null,
        fechaCita: '',
        tipoCita: '',
        duracion: 60,
        notas: ''
      }
    }
  },
  computed: {
    fechaMinima() {
      // Obtener la fecha y hora actual en formato YYYY-MM-DDTHH:mm
      const ahora = new Date()
      const year = ahora.getFullYear()
      const mes = String(ahora.getMonth() + 1).padStart(2, '0')
      const dia = String(ahora.getDate()).padStart(2, '0')
      const hora = String(ahora.getHours()).padStart(2, '0')
      const minutos = String(ahora.getMinutes()).padStart(2, '0')
      return `${year}-${mes}-${dia}T${hora}:${minutos}`
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
      this.cargandoTabla = true
      try {
        const response = await api.get('/appointments')
        this.todasLasCitas = response.data
      } catch (error) {
        this.mostrarError('Error al cargar citas')
      } finally {
        this.cargandoTabla = false
      }
    },

    async crearCita() {
      // Validar que todos los campos requeridos estén completos
      if (!this.nuevaCita.idPaciente || !this.nuevaCita.fechaCita || !this.nuevaCita.tipoCita) {
        this.mostrarError('Por favor complete todos los campos requeridos')
        return
      }

      // Validar que la fecha no sea en el pasado
      const fechaSeleccionada = new Date(this.nuevaCita.fechaCita)
      const ahora = new Date()
      
      if (fechaSeleccionada < ahora) {
        this.mostrarError('No se pueden agendar citas en fechas pasadas')
        return
      }

      // Validar que la hora sea en punto o media hora (00 o 30 minutos)
      const minutos = fechaSeleccionada.getMinutes()
      if (minutos !== 0 && minutos !== 30) {
        this.mostrarError('Las citas solo se pueden agendar en punto (00) o media hora (30)')
        return
      }

      this.cargando = true
      try {
        // Convertir las variables al formato que espera el backend
        const datosParaEnviar = {
          patientId: this.nuevaCita.idPaciente,
          appointmentDate: this.nuevaCita.fechaCita,
          appointmentType: this.nuevaCita.tipoCita,
          duration: this.nuevaCita.duracion,
          sendEmail: this.nuevaCita.enviarEmail
        }
        
        const response = await api.post('/appointments', datosParaEnviar)
        const citaCreada = response.data
        
        console.log('✅ Cita creada:', citaCreada)
        
        // Enviar notificación por email si la opción está activada
        if (this.nuevaCita.enviarEmail) {
          // Pasar todos los datos necesarios para el email
          await this.enviarNotificacionEmail({
            ...citaCreada.appointment || citaCreada, // El backend puede retornar {appointment: {...}} o directamente la cita
            patientId: this.nuevaCita.idPaciente,
            appointmentDate: this.nuevaCita.fechaCita, // Usar los datos del formulario
            appointmentTime: this.nuevaCita.fechaCita, // La fecha completa incluye la hora
            appointmentType: this.nuevaCita.tipoCita,
            notes: this.nuevaCita.notas
          })
        }
        
        this.mostrarExito('Cita creada exitosamente')
        this.limpiarFormulario()
        await this.cargarDatos()
        
      } catch (error) {
        const message = error.response?.data?.message || 'Error al crear la cita'
        this.mostrarError(message)
      } finally {
        this.cargando = false
      }
    },

    async enviarNotificacionEmail(cita) {
      try {
        console.log('📧 ==== ENVIANDO EMAIL ====')
        console.log('Cita completa:', cita)
        console.log('appointmentDate:', cita.appointmentDate)
        console.log('date:', cita.date)
        console.log('appointmentTime:', cita.appointmentTime)
        console.log('time:', cita.time)
        
        // Buscar datos del paciente
        const paciente = this.pacientes.find(p => p.id === cita.patientId)
        
        console.log('Paciente encontrado:', paciente)
        console.log('Email del paciente:', paciente?.email)
        
        if (!paciente || !paciente.email) {
          console.warn('Paciente sin email, no se puede enviar notificación')
          console.warn('Datos del paciente:', JSON.stringify(paciente, null, 2))
          return
        }

        // Formatear fecha y hora - manejar múltiples formatos
        let fechaCita
        
        // El backend puede enviar la fecha en diferentes campos
        const fechaRaw = cita.appointmentDate || cita.date
        const horaRaw = cita.appointmentTime || cita.time
        
        console.log('Fecha raw:', fechaRaw)
        console.log('Hora raw:', horaRaw)
        
        if (!fechaRaw) {
          console.error('❌ No hay fecha disponible en la cita')
          this.mostrarError('❌ No hay fecha disponible en la cita')
          return
        }
        
        // Si la fecha es un string (viene del formulario como datetime-local)
        if (typeof fechaRaw === 'string') {
          fechaCita = new Date(fechaRaw)
          
          // Si la fecha es inválida
          if (isNaN(fechaCita.getTime())) {
            console.error('Formato de fecha no reconocido:', fechaRaw)
            this.mostrarError('❌ Formato de fecha inválido')
            return
          }
        } else if (Array.isArray(fechaRaw)) {
          // Formato array [YYYY, M, D] del backend
          const [year, month, day] = fechaRaw
          
          // Si también tenemos hora en array
          if (Array.isArray(horaRaw) && horaRaw.length >= 2) {
            const [hours, minutes] = horaRaw
            fechaCita = new Date(year, month - 1, day, hours, minutes)
          } else {
            fechaCita = new Date(year, month - 1, day)
          }
        } else {
          fechaCita = new Date(fechaRaw)
        }
        
        console.log('Fecha de la cita:', fechaRaw)
        console.log('Fecha parseada:', fechaCita)
        console.log('Es fecha válida:', !isNaN(fechaCita.getTime()))
        
        // Validar que la fecha sea válida
        if (isNaN(fechaCita.getTime())) {
          console.error('❌ Fecha inválida, no se puede enviar email')
          this.mostrarError('❌ Fecha inválida, no se puede enviar email')
          return
        }
        
        const fecha = fechaCita.toLocaleDateString('es-ES', {
          weekday: 'long',
          year: 'numeric',
          month: 'long',
          day: 'numeric'
        })
        
        // Manejar hora - puede venir del datetime-local del formulario o como array del backend
        let hora
        if (Array.isArray(horaRaw)) {
          const [hours, minutes] = horaRaw
          hora = `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`
        } else if (typeof horaRaw === 'string') {
          // Si es el mismo que fechaRaw (datetime-local), extraer la hora
          if (horaRaw === fechaRaw) {
            hora = fechaCita.toLocaleTimeString('es-ES', {
              hour: '2-digit',
              minute: '2-digit'
            })
          } else {
            hora = horaRaw
          }
        } else if (horaRaw) {
          const horaDate = new Date()
          horaDate.setHours(horaRaw?.hour || 0)
          horaDate.setMinutes(horaRaw?.minute || 0)
          hora = horaDate.toLocaleTimeString('es-ES', {
            hour: '2-digit',
            minute: '2-digit'
          })
        } else {
          // Si no hay hora separada, usar la hora de fechaCita
          hora = fechaCita.toLocaleTimeString('es-ES', {
            hour: '2-digit',
            minute: '2-digit'
          })
        }
        
        console.log('Hora formateada:', hora)

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

        console.log('Datos del email a enviar:', emailData)

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
      console.log('==== MÉTODO CANCELAR CITA LLAMADO ====', cita)
      
      // Obtener nombre del paciente
      const nombrePaciente = cita.patient?.firstName && cita.patient?.lastName 
        ? `${cita.patient.firstName} ${cita.patient.lastName}`
        : 'este paciente'
      
      // Mostrar diálogo de confirmación
      this.dialogoConfirmacion = {
        mostrar: true,
        titulo: 'Cancelar Cita',
        mensaje: `¿Está seguro de que desea cancelar la cita con ${nombrePaciente}?`,
        accion: 'cancelar',
        citaSeleccionada: cita
      }
    },

    async eliminarCita(cita) {
      // Obtener nombre del paciente
      const nombrePaciente = cita.patient?.firstName && cita.patient?.lastName 
        ? `${cita.patient.firstName} ${cita.patient.lastName}`
        : 'este paciente'
      
      // Mostrar diálogo de confirmación
      this.dialogoConfirmacion = {
        mostrar: true,
        titulo: 'Eliminar Cita Permanentemente',
        mensaje: `¿Está seguro de que desea eliminar permanentemente la cita con ${nombrePaciente}? Esta acción no se puede deshacer.`,
        accion: 'eliminar',
        citaSeleccionada: cita
      }
    },

    async confirmarAccion() {
      const cita = this.dialogoConfirmacion.citaSeleccionada
      const accion = this.dialogoConfirmacion.accion
      
      // Cerrar el diálogo
      this.dialogoConfirmacion.mostrar = false
      
      try {
        if (accion === 'cancelar') {
          console.log('Cancelando cita:', cita.id)
          await api.put(`/appointments/${cita.id}`, {
            status: 'CANCELLED'
          })
          this.mostrarExito('Cita cancelada exitosamente')
        } else if (accion === 'eliminar') {
          await api.delete(`/appointments/${cita.id}`)
          this.mostrarExito('Cita eliminada exitosamente')
        }
        
        await this.cargarDatos()
      } catch (error) {
        console.error('Error en la acción:', error)
        this.mostrarError(`Error al ${accion} la cita: ` + (error.response?.data?.message || error.message))
      }
    },

    async marcarComoAtendida(cita) {
      // Obtener nombre del paciente
      const nombrePaciente = cita.patient?.firstName && cita.patient?.lastName 
        ? `${cita.patient.firstName} ${cita.patient.lastName}`
        : 'este paciente'
      
      try {
        this.cargandoTabla = true
        await api.put(`/appointments/${cita.id}`, {
          status: 'ATENDIDO'
        })
        this.mostrarExito(`✅ Cita con ${nombrePaciente} marcada como atendida`)
        await this.cargarDatos()
      } catch (error) {
        console.error('Error al marcar cita como atendida:', error)
        this.mostrarError('Error al marcar la cita como atendida: ' + (error.response?.data?.message || error.message))
      } finally {
        this.cargandoTabla = false
      }
    },

    editarCita(cita) {
      console.log('Editando cita:', cita)
      
      // Formatear la fecha al formato datetime-local (YYYY-MM-DDTHH:mm)
      const fecha = new Date(cita.appointmentDate)
      const year = fecha.getFullYear()
      const mes = String(fecha.getMonth() + 1).padStart(2, '0')
      const dia = String(fecha.getDate()).padStart(2, '0')
      const hora = String(fecha.getHours()).padStart(2, '0')
      const minuto = String(fecha.getMinutes()).padStart(2, '0')
      const fechaFormateada = `${year}-${mes}-${dia}T${hora}:${minuto}`
      
      // Cargar datos de la cita en el formulario de edición
      this.citaEdicion = {
        id: cita.id,
        idPaciente: cita.patient?.id || null,
        fechaCita: fechaFormateada,
        tipoCita: cita.appointmentType,
        duracion: cita.durationMinutes,
        notas: cita.notes || ''
      }
      
      // Abrir el diálogo
      this.dialogoEdicion.mostrar = true
      this.dialogoEdicion.cita = cita
    },

    cerrarDialogoEdicion() {
      this.dialogoEdicion.mostrar = false
      this.citaEdicion = {
        id: null,
        idPaciente: null,
        fechaCita: '',
        tipoCita: '',
        duracion: 60,
        notas: ''
      }
      
      // Resetear validación del formulario
      if (this.$refs.formEdicion) {
        this.$nextTick(() => {
          this.$refs.formEdicion.reset()
        })
      }
    },

    async guardarCambiosCita() {
      // Validar el formulario
      const { valid } = await this.$refs.formEdicion.validate()
      if (!valid) {
        this.mostrarError('Por favor complete todos los campos requeridos')
        return
      }

      try {
        this.cargando = true

        // Validar restricción de minutos (:00 o :30)
        const fechaSeleccionada = new Date(this.citaEdicion.fechaCita)
        const minutos = fechaSeleccionada.getMinutes()
        if (minutos !== 0 && minutos !== 30) {
          this.mostrarError('Las citas solo se pueden agendar en punto (00) o media hora (30)')
          this.cargando = false
          return
        }

        // Validar que no sea fecha pasada
        if (fechaSeleccionada < new Date()) {
          this.mostrarError('No se pueden agendar citas en fechas pasadas')
          this.cargando = false
          return
        }

        // Preparar datos para enviar
        // Convertir fecha local a formato ISO sin cambiar la zona horaria
        const fechaLocal = new Date(this.citaEdicion.fechaCita)
        const year = fechaLocal.getFullYear()
        const mes = String(fechaLocal.getMonth() + 1).padStart(2, '0')
        const dia = String(fechaLocal.getDate()).padStart(2, '0')
        const hora = String(fechaLocal.getHours()).padStart(2, '0')
        const minuto = String(fechaLocal.getMinutes()).padStart(2, '0')
        const segundo = String(fechaLocal.getSeconds()).padStart(2, '0')
        const fechaISO = `${year}-${mes}-${dia}T${hora}:${minuto}:${segundo}`
        
        const datosActualizados = {
          patientId: this.citaEdicion.idPaciente,
          appointmentDate: fechaISO,
          appointmentType: this.citaEdicion.tipoCita,
          durationMinutes: this.citaEdicion.duracion,
          notes: this.citaEdicion.notas || ''
        }

        console.log('Actualizando cita:', this.citaEdicion.id, datosActualizados)

        // Enviar actualización al backend
        await api.put(`/appointments/${this.citaEdicion.id}`, datosActualizados)

        this.mostrarExito('✅ Cita actualizada exitosamente')
        
        // Cerrar el diálogo
        this.cerrarDialogoEdicion()
        
        // Recargar datos
        await this.cargarDatos()
      } catch (error) {
        console.error('Error al actualizar cita:', error)
        this.mostrarError('Error al actualizar la cita: ' + (error.response?.data?.message || error.message))
      } finally {
        this.cargando = false
      }
    },

    limpiarFormulario() {
      this.nuevaCita = {
        idPaciente: null,
        fechaCita: '',
        tipoCita: 'CONSULTATION',
        duracion: 60,
        enviarEmail: true
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

    formatearSoloFecha(fecha) {
      return new Date(fecha).toLocaleDateString('es-ES', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
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
        'NO_SHOW': 'orange',
        'CONFIRMED': 'teal',
        'ATENDIDO': 'green'
      }
      return colors[status] || 'grey'
    },

    traducirEstado(status) {
      const traducciones = {
        'SCHEDULED': 'Programada',
        'CONFIRMED': 'Confirmada',
        'COMPLETED': 'Completada',
        'CANCELLED': 'Cancelada',
        'NO_SHOW': 'No asistió',
        'ATENDIDO': 'Atendida'
      }
      return traducciones[status] || status
    },

    traducirTipoCita(tipo) {
      const traducciones = {
        'CONSULTATION': 'Consulta',
        'FOLLOW_UP': 'Seguimiento',
        'EMERGENCY': 'Emergencia'
      }
      return traducciones[tipo] || tipo
    },

    mostrarExito(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'success' }
    },

    mostrarError(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'error' }
    },

    mostrarInfo(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'info' }
    }
  }
}
</script>

<style scoped>
/* Container principal */
.appointments-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8fafb 0%, #e8f4f8 100%);
  position: relative;
  padding-bottom: 60px;
}

.appointments-container::before {
  content: '';
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: 
    radial-gradient(circle at 20% 80%, rgba(139, 195, 74, 0.08) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(95, 194, 198, 0.08) 0%, transparent 50%);
  pointer-events: none;
  z-index: 0;
}

.appointments-content {
  position: relative;
  z-index: 1;
  padding-top: 30px;
}

/* Header */
.appointments-header {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  padding: 40px 30px;
  box-shadow: 0 8px 32px rgba(139, 195, 74, 0.3);
  position: relative;
  overflow: hidden;
  z-index: 1;
}

.appointments-header::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -10%;
  width: 400px;
  height: 400px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  filter: blur(80px);
}

.header-content {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  gap: 20px;
  position: relative;
  z-index: 2;
}

.header-icon {
  font-size: 4rem;
  filter: drop-shadow(0 4px 12px rgba(0, 0, 0, 0.2));
}

.header-text {
  flex: 1;
}

.header-title {
  color: white;
  font-size: 2.5rem;
  font-weight: 800;
  margin: 0 0 8px 0;
  text-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.header-subtitle {
  color: rgba(255, 255, 255, 0.95);
  font-size: 1.1rem;
  margin: 0;
  font-weight: 500;
}

/* Cards modernas */
.modern-card {
  border-radius: 20px !important;
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  border-left: 5px solid #8bc34a;
}

.modern-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 35px rgba(139, 195, 74, 0.2) !important;
}

.form-card {
  border-left-color: #2196F3;
}

.today-card {
  border-left-color: #5fc2c6;
}

.list-card {
  border-left-color: #ff9800;
}

/* Headers de cards */
.card-header-green {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%) !important;
  color: white !important;
  padding: 20px 24px !important;
  font-size: 1.25rem !important;
  font-weight: 700 !important;
}

.card-header-blue {
  background: linear-gradient(135deg, #5fc2c6 0%, #4fb3b7 100%) !important;
  color: white !important;
  padding: 20px 24px !important;
  font-size: 1.25rem !important;
  font-weight: 700 !important;
}

.card-header-orange {
  background: linear-gradient(135deg, #ff9800 0%, #f57c00 100%) !important;
  color: white !important;
  padding: 20px 24px !important;
  font-size: 1.25rem !important;
  font-weight: 700 !important;
}

/* Botones mejorados */
:deep(.v-btn) {
  border-radius: 12px !important;
  text-transform: none !important;
  font-weight: 600 !important;
  letter-spacing: 0.5px !important;
}

:deep(.v-btn.bg-green) {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%) !important;
}

:deep(.v-btn.bg-green:hover) {
  background: linear-gradient(135deg, #7ab73f 0%, #689f38 100%) !important;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 195, 74, 0.4) !important;
}

/* Campos de formulario */
:deep(.v-input) {
  margin-bottom: 8px;
}

:deep(.v-field) {
  border-radius: 12px !important;
}

:deep(.v-field:hover) {
  background: rgba(139, 195, 74, 0.05);
}

/* Chips */
:deep(.v-chip) {
  border-radius: 12px !important;
  font-weight: 600 !important;
}

/* Lista items */
:deep(.v-list-item) {
  transition: all 0.2s ease;
  border-left: 3px solid transparent;
}

:deep(.v-list-item:hover) {
  background: linear-gradient(90deg, rgba(139, 195, 74, 0.08) 0%, transparent 100%) !important;
  border-left-color: #8bc34a;
  padding-left: 20px !important;
}

/* Avatars */
:deep(.v-avatar) {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* Data table */
:deep(.v-table) {
  border-radius: 16px !important;
}

:deep(.v-table th) {
  background: #f8fafb !important;
  font-weight: 700 !important;
  color: #2c3e50 !important;
}

:deep(.v-table tr:hover) {
  background: linear-gradient(90deg, rgba(139, 195, 74, 0.05) 0%, transparent 100%) !important;
}

/* Botón de volver */
.back-button-container {
  max-width: 1400px;
  margin: 40px auto 0;
  padding: 0 30px;
  text-align: center;
  position: relative;
  z-index: 1;
}

.btn-back {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 14px 32px;
  background: linear-gradient(135deg, #7a7a5a 0%, #6a6a4a 100%);
  color: white;
  text-decoration: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 1rem;
  transition: all 0.3s ease;
  box-shadow: 0 6px 20px rgba(122, 122, 90, 0.3);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.btn-back:hover {
  background: linear-gradient(135deg, #6a6a4a 0%, #5a5a3a 100%);
  transform: translateY(-4px);
  box-shadow: 0 10px 30px rgba(122, 122, 90, 0.4);
}

.btn-icon {
  font-size: 1.2rem;
}

.border-b {
  border-bottom: 1px solid #e0e0e0;
}

/* Responsive */
@media (max-width: 768px) {
  .appointments-header {
    padding: 30px 20px;
  }
  
  .header-content {
    flex-direction: column;
    text-align: center;
  }
  
  .header-title {
    font-size: 2rem;
  }
}
</style>