<template>
  <v-container>
    <v-row>
      <v-col cols="12">
        <h2 class="text-h4 mb-4">
          <v-icon class="mr-2">mdi-food-apple</v-icon>
          Gestión de Planes Dietéticos
        </h2>
      </v-col>
    </v-row>

    <!-- Formulario para nuevo plan -->
    <v-row>
      <v-col cols="12" md="6">
        <v-card elevation="2">
          <v-card-title class="bg-green text-white">
            <v-icon class="mr-2">mdi-plus</v-icon>
            Nuevo Plan Dietético
          </v-card-title>
          <v-card-text class="pa-4">
            <v-form @submit.prevent="crearPlan">
              <v-select
                v-model="nuevoPlan.idPaciente"
                :items="pacientes"
                item-title="fullName"
                item-value="id"
                label="Paciente"
                prepend-icon="mdi-account"
                required
              ></v-select>

              <v-text-field
                v-model="nuevoPlan.nombrePlan"
                label="Nombre del Plan"
                prepend-icon="mdi-file-document"
                required
                hint="Ej: Plan Reducción de Peso, Plan Deportivo"
                persistent-hint
              ></v-text-field>

              <v-textarea
                v-model="nuevoPlan.descripcion"
                label="Descripción"
                prepend-icon="mdi-text"
                rows="3"
                hint="Descripción general del plan dietético"
              ></v-textarea>

              <v-text-field
                v-model="nuevoPlan.fechaInicio"
                label="Fecha de Inicio"
                type="date"
                prepend-icon="mdi-calendar-start"
                required
              ></v-text-field>

              <v-text-field
                v-model="nuevoPlan.fechaFin"
                label="Fecha de Fin"
                type="date"
                prepend-icon="mdi-calendar-end"
                required
              ></v-text-field>

              <v-text-field
                v-model.number="nuevoPlan.caloriasDiarias"
                label="Calorías Diarias"
                type="number"
                min="0"
                step="1"
                prepend-icon="mdi-fire"
                suffix="kcal"
                required
                @keypress="soloNumerosEnteros"
              ></v-text-field>

              <v-textarea
                v-model="nuevoPlan.objetivos"
                label="Objetivos"
                prepend-icon="mdi-target"
                rows="3"
                hint="Objetivos que se buscan alcanzar con este plan"
              ></v-textarea>

              <v-btn
                type="submit"
                color="green"
                block
                size="large"
                :loading="cargando"
                class="mt-3"
              >
                <v-icon class="mr-2">mdi-plus</v-icon>
                Crear Plan
              </v-btn>
            </v-form>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Planes activos -->
      <v-col cols="12" md="6">
        <v-card elevation="2">
          <v-card-title class="bg-blue text-white">
            <v-icon class="mr-2">mdi-clipboard-check</v-icon>
            Planes Activos ({{ planesActivos.length }})
          </v-card-title>
          <v-card-text>
            <div v-if="cargandoPlanes" class="text-center pa-4">
              <v-progress-circular indeterminate color="blue"></v-progress-circular>
            </div>
            <div v-else-if="planesActivos.length === 0" class="text-center pa-4 text-grey">
              No hay planes activos
            </div>
            <v-list v-else>
              <v-list-item
                v-for="plan in planesActivos"
                :key="plan.id"
                class="mb-2 border rounded"
              >
                <template v-slot:prepend>
                  <v-avatar color="green" size="40">
                    <v-icon color="white">mdi-food-apple</v-icon>
                  </v-avatar>
                </template>
                <v-list-item-title class="font-weight-bold">
                  {{ plan.planName }}
                </v-list-item-title>
                <v-list-item-subtitle>
                  {{ plan.patient?.firstName }} {{ plan.patient?.lastName }}
                </v-list-item-subtitle>
                <v-list-item-subtitle>
                  <v-icon size="small">mdi-calendar</v-icon>
                  {{ formatearFecha(plan.startDate) }} - {{ formatearFecha(plan.endDate) }}
                </v-list-item-subtitle>
                <v-list-item-subtitle>
                  <v-icon size="small">mdi-fire</v-icon>
                  {{ plan.dailyCalories }} kcal/día
                </v-list-item-subtitle>
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Tabla de todos los planes -->
    <v-row class="mt-4">
      <v-col cols="12">
        <v-card elevation="2">
          <v-card-title class="bg-primary text-white">
            <v-icon class="mr-2">mdi-view-list</v-icon>
            Todos los Planes Dietéticos
          </v-card-title>
          <v-card-text>
            <v-data-table
              :headers="encabezados"
              :items="todosLosPlanes"
              :loading="cargandoTabla"
              loading-text="Cargando planes..."
              no-data-text="No hay planes registrados"
              items-per-page="10"
              class="elevation-1"
            >
              <template v-slot:item.patient="{ item }">
                <div class="d-flex align-center">
                  <v-avatar color="primary" size="32" class="mr-2">
                    <span class="text-white text-caption">
                      {{ item.patient?.firstName?.[0] }}{{ item.patient?.lastName?.[0] }}
                    </span>
                  </v-avatar>
                  <span>{{ item.patient?.firstName }} {{ item.patient?.lastName }}</span>
                </div>
              </template>

              <template v-slot:item.startDate="{ item }">
                {{ formatearFecha(item.startDate) }}
              </template>

              <template v-slot:item.endDate="{ item }">
                {{ formatearFecha(item.endDate) }}
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
                  color="info"
                  variant="text"
                  size="small"
                  @click="verDetalle(item)"
                  title="Ver detalle"
                >
                  <v-icon>mdi-eye</v-icon>
                </v-btn>
                <v-btn
                  color="primary"
                  variant="text"
                  size="small"
                  @click="editarPlan(item)"
                  v-if="item.status === 'ACTIVE' || item.status === 'PAUSED'"
                  title="Editar"
                >
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
                <v-btn
                  color="deep-purple"
                  variant="text"
                  size="small"
                  @click="exportarPDFPlan(item)"
                  title="Exportar PDF"
                >
                  <v-icon>mdi-file-pdf-box</v-icon>
                </v-btn>
                <v-btn
                  color="warning"
                  variant="text"
                  size="small"
                  @click="pausarPlan(item)"
                  v-if="item.status === 'ACTIVE'"
                  title="Pausar"
                >
                  <v-icon>mdi-pause</v-icon>
                </v-btn>
                <v-btn
                  color="success"
                  variant="text"
                  size="small"
                  @click="reanudarPlan(item)"
                  v-if="item.status === 'PAUSED'"
                  title="Reanudar"
                >
                  <v-icon>mdi-play</v-icon>
                </v-btn>
                <v-btn
                  color="success"
                  variant="text"
                  size="small"
                  @click="completarPlan(item)"
                  v-if="item.status === 'ACTIVE'"
                  title="Completar"
                >
                  <v-icon>mdi-check-circle</v-icon>
                </v-btn>
                <v-btn
                  color="error"
                  variant="text"
                  size="small"
                  @click="cancelarPlan(item)"
                  v-if="item.status !== 'CANCELLED'"
                  title="Cancelar"
                >
                  <v-icon>mdi-cancel</v-icon>
                </v-btn>
              </template>
            </v-data-table>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Diálogo de detalle -->
    <v-dialog v-model="dialogoDetalle.mostrar" max-width="1000" scrollable>
      <v-card v-if="dialogoDetalle.plan">
        <v-card-title class="text-h5 bg-primary text-white">
          <v-icon class="mr-2">mdi-food-apple</v-icon>
          {{ dialogoDetalle.plan.planName }}
        </v-card-title>
        <v-card-text class="pa-0">
          <v-tabs v-model="tabDetalle" color="primary" grow>
            <v-tab value="info">
              <v-icon class="mr-2">mdi-information</v-icon>
              Información
            </v-tab>
            <v-tab value="meals">
              <v-icon class="mr-2">mdi-food</v-icon>
              Comidas
            </v-tab>
          </v-tabs>

          <v-window v-model="tabDetalle">
            <v-window-item value="info" class="pa-4">
              <v-row>
                <v-col cols="12" md="6">
                  <p><strong>Paciente:</strong></p>
                  <p class="ml-4">{{ dialogoDetalle.plan.patient?.firstName }} {{ dialogoDetalle.plan.patient?.lastName }}</p>
                </v-col>
                <v-col cols="12" md="6">
                  <p><strong>Estado:</strong></p>
                  <v-chip :color="getStatusColor(dialogoDetalle.plan.status)" size="small" class="ml-4">
                    {{ traducirEstado(dialogoDetalle.plan.status) }}
                  </v-chip>
                </v-col>
                <v-col cols="12" md="6">
                  <p><strong>Fecha Inicio:</strong></p>
                  <p class="ml-4">{{ formatearFecha(dialogoDetalle.plan.startDate) }}</p>
                </v-col>
                <v-col cols="12" md="6">
                  <p><strong>Fecha Fin:</strong></p>
                  <p class="ml-4">{{ formatearFecha(dialogoDetalle.plan.endDate) }}</p>
                </v-col>
                <v-col cols="12">
                  <p><strong>Calorías Diarias:</strong></p>
                  <p class="ml-4">{{ dialogoDetalle.plan.dailyCalories }} kcal</p>
                </v-col>
                <v-col cols="12" v-if="dialogoDetalle.plan.description">
                  <p><strong>Descripción:</strong></p>
                  <p class="ml-4">{{ dialogoDetalle.plan.description }}</p>
                </v-col>
                <v-col cols="12" v-if="dialogoDetalle.plan.goals">
                  <p><strong>Objetivos:</strong></p>
                  <p class="ml-4">{{ dialogoDetalle.plan.goals }}</p>
                </v-col>
              </v-row>
            </v-window-item>

            <v-window-item value="meals" class="pa-4">
              <GestionComidas v-if="dialogoDetalle.plan.id" :planId="dialogoDetalle.plan.id" />
            </v-window-item>
          </v-window>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" variant="text" @click="dialogoDetalle.mostrar = false">
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo de edición -->
    <v-dialog v-model="dialogoEdicion.mostrar" max-width="600">
      <v-card>
        <v-card-title class="text-h5 bg-primary text-white">
          <v-icon class="mr-2">mdi-pencil</v-icon>
          Editar Plan Dietético
        </v-card-title>
        <v-card-text class="pt-4">
          <v-form @submit.prevent="guardarEdicion">
            <v-text-field
              v-model="dialogoEdicion.plan.planName"
              label="Nombre del Plan"
              prepend-icon="mdi-file-document"
              required
            ></v-text-field>

            <v-textarea
              v-model="dialogoEdicion.plan.description"
              label="Descripción"
              prepend-icon="mdi-text"
              rows="3"
            ></v-textarea>

            <v-text-field
              v-model="dialogoEdicion.plan.startDate"
              label="Fecha de Inicio"
              type="date"
              prepend-icon="mdi-calendar-start"
              required
            ></v-text-field>

            <v-text-field
              v-model="dialogoEdicion.plan.endDate"
              label="Fecha de Fin"
              type="date"
              prepend-icon="mdi-calendar-end"
              required
            ></v-text-field>

            <v-text-field
              v-model.number="dialogoEdicion.plan.dailyCalories"
              label="Calorías Diarias"
              type="number"
              min="0"
              step="1"
              prepend-icon="mdi-fire"
              suffix="kcal"
              required
              @keypress="soloNumerosEnteros"
            ></v-text-field>

            <v-textarea
              v-model="dialogoEdicion.plan.goals"
              label="Objetivos"
              prepend-icon="mdi-target"
              rows="3"
            ></v-textarea>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" variant="text" @click="dialogoEdicion.mostrar = false">
            Cancelar
          </v-btn>
          <v-btn color="primary" variant="flat" @click="guardarEdicion" :loading="dialogoEdicion.guardando">
            <v-icon class="mr-2">mdi-content-save</v-icon>
            Guardar
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
</template>

<script>
import api from '@/services/api'
import GestionComidas from '@/components/GestionComidas.vue'
import { generarPDFPlanDietético } from '@/services/pdfService'

export default {
  name: 'NutritionistDietPlansView',
  components: {
    GestionComidas
  },
  data() {
    return {
      cargando: false,
      cargandoTabla: false,
      cargandoPlanes: false,
      tabDetalle: 'info',
      pacientes: [],
      planesActivos: [],
      todosLosPlanes: [],
      nuevoPlan: {
        idPaciente: null,
        nombrePlan: '',
        descripcion: '',
        fechaInicio: '',
        fechaFin: '',
        caloriasDiarias: null,
        objetivos: ''
      },
      encabezados: [
        { title: 'Paciente', key: 'patient', sortable: true },
        { title: 'Plan', key: 'planName', sortable: true },
        { title: 'Inicio', key: 'startDate', sortable: true },
        { title: 'Fin', key: 'endDate', sortable: true },
        { title: 'Calorías', key: 'dailyCalories', sortable: true },
        { title: 'Estado', key: 'status', sortable: true },
        { title: 'Acciones', key: 'actions', sortable: false }
      ],
      notificacion: {
        mostrar: false,
        mensaje: '',
        color: 'success'
      },
      dialogoDetalle: {
        mostrar: false,
        plan: null
      },
      dialogoEdicion: {
        mostrar: false,
        guardando: false,
        plan: {
          id: null,
          planName: '',
          description: '',
          startDate: '',
          endDate: '',
          dailyCalories: null,
          goals: ''
        }
      }
    }
  },
  mounted() {
    this.cargarDatos()
  },
  methods: {
    async cargarDatos() {
      await Promise.all([
        this.cargarPacientes(),
        this.cargarPlanesActivos(),
        this.cargarTodosLosPlanes()
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
        console.error('Error al cargar pacientes:', error)
        this.mostrarError('Error al cargar pacientes')
      }
    },

    async cargarPlanesActivos() {
      try {
        this.cargandoPlanes = true
        const response = await api.get('/diet-plans')
        this.planesActivos = response.data.filter(p => p.status === 'ACTIVE')
      } catch (error) {
        console.error('Error al cargar planes activos:', error)
      } finally {
        this.cargandoPlanes = false
      }
    },

    async cargarTodosLosPlanes() {
      try {
        this.cargandoTabla = true
        const response = await api.get('/diet-plans')
        // Forzar reactividad limpiando el array primero
        this.todosLosPlanes = []
        this.$nextTick(() => {
          this.todosLosPlanes = response.data
        })
      } catch (error) {
        console.error('Error al cargar planes:', error)
        this.mostrarError('Error al cargar planes')
      } finally {
        this.cargandoTabla = false
      }
    },

    async crearPlan() {
      // Validar campos requeridos
      if (!this.nuevoPlan.idPaciente) {
        this.mostrarError('Seleccione un paciente')
        return
      }
      if (!this.nuevoPlan.nombrePlan) {
        this.mostrarError('Ingrese el nombre del plan')
        return
      }
      if (!this.nuevoPlan.fechaInicio) {
        this.mostrarError('Seleccione fecha de inicio')
        return
      }
      if (!this.nuevoPlan.fechaFin) {
        this.mostrarError('Seleccione fecha de fin')
        return
      }
      if (!this.nuevoPlan.caloriasDiarias) {
        this.mostrarError('Ingrese calorías diarias')
        return
      }
      
      // Validaciones adicionales
      if (this.nuevoPlan.caloriasDiarias && this.nuevoPlan.caloriasDiarias < 0) {
        this.mostrarError('Las calorías no pueden ser negativas')
        return
      }
      
      if (this.nuevoPlan.caloriasDiarias && !Number.isInteger(this.nuevoPlan.caloriasDiarias)) {
        this.mostrarError('Las calorías deben ser un número entero')
        return
      }

      try {
        this.cargando = true

        const datos = {
          patientId: this.nuevoPlan.idPaciente,
          planName: this.nuevoPlan.nombrePlan,
          description: this.nuevoPlan.descripcion || '',
          startDate: this.nuevoPlan.fechaInicio,
          endDate: this.nuevoPlan.fechaFin,
          dailyCalories: this.nuevoPlan.caloriasDiarias,
          goals: this.nuevoPlan.objetivos || ''
        }

        console.log('Enviando datos del plan:', datos)

        await api.post('/diet-plans', datos)
        this.mostrarExito('✅ Plan dietético creado exitosamente')
        this.limpiarFormulario()
        await this.cargarDatos()
      } catch (error) {
        console.error('Error al crear plan:', error)
        console.error('Respuesta del servidor:', error.response?.data)
        this.mostrarError('Error al crear el plan: ' + (error.response?.data?.message || error.response?.data || error.message))
      } finally {
        this.cargando = false
      }
    },

    verDetalle(plan) {
      this.dialogoDetalle.plan = plan
      this.dialogoDetalle.mostrar = true
    },

    editarPlan(plan) {
      // Copiar los datos del plan al diálogo de edición
      // Asegurar que las fechas estén en formato YYYY-MM-DD para el input type="date"
      this.dialogoEdicion.plan = {
        id: plan.id,
        planName: plan.planName,
        description: plan.description || '',
        startDate: this.formatearFechaParaInput(plan.startDate),
        endDate: this.formatearFechaParaInput(plan.endDate),
        dailyCalories: plan.dailyCalories,
        goals: plan.goals || ''
      }
      this.dialogoEdicion.mostrar = true
    },

    async guardarEdicion() {
      // Validaciones
      if (!this.dialogoEdicion.plan.planName) {
        this.mostrarError('Ingrese el nombre del plan')
        return
      }
      if (!this.dialogoEdicion.plan.startDate) {
        this.mostrarError('Seleccione fecha de inicio')
        return
      }
      if (!this.dialogoEdicion.plan.endDate) {
        this.mostrarError('Seleccione fecha de fin')
        return
      }
      if (!this.dialogoEdicion.plan.dailyCalories) {
        this.mostrarError('Ingrese calorías diarias')
        return
      }

      // Validaciones adicionales
      if (this.dialogoEdicion.plan.dailyCalories < 0) {
        this.mostrarError('Las calorías no pueden ser negativas')
        return
      }

      if (!Number.isInteger(this.dialogoEdicion.plan.dailyCalories)) {
        this.mostrarError('Las calorías deben ser un número entero')
        return
      }

      // Validar que la fecha de fin sea mayor o igual a la fecha de inicio
      if (new Date(this.dialogoEdicion.plan.endDate) < new Date(this.dialogoEdicion.plan.startDate)) {
        this.mostrarError('La fecha de fin debe ser posterior a la fecha de inicio')
        return
      }

      try {
        this.dialogoEdicion.guardando = true

        const datos = {
          planName: this.dialogoEdicion.plan.planName,
          description: this.dialogoEdicion.plan.description || '',
          startDate: this.dialogoEdicion.plan.startDate,
          endDate: this.dialogoEdicion.plan.endDate,
          dailyCalories: this.dialogoEdicion.plan.dailyCalories,
          goals: this.dialogoEdicion.plan.goals || ''
        }

        console.log('Actualizando plan con datos:', datos)
        await api.put(`/diet-plans/${this.dialogoEdicion.plan.id}`, datos)
        console.log('Plan actualizado, recargando datos...')
        this.dialogoEdicion.mostrar = false
        this.mostrarExito('✅ Plan actualizado exitosamente')
        await this.cargarDatos()
        console.log('Datos recargados')
      } catch (error) {
        console.error('Error al actualizar plan:', error)
        this.mostrarError('Error al actualizar el plan: ' + (error.response?.data?.message || error.message))
      } finally {
        this.dialogoEdicion.guardando = false
      }
    },

    async pausarPlan(plan) {
      try {
        await api.put(`/diet-plans/${plan.id}`, { status: 'PAUSED' })
        this.mostrarExito('⏸️ Plan pausado')
        await this.cargarDatos()
      } catch (error) {
        console.error('Error:', error)
        this.mostrarError('Error al pausar el plan')
      }
    },

    async reanudarPlan(plan) {
      try {
        await api.put(`/diet-plans/${plan.id}`, { status: 'ACTIVE' })
        this.mostrarExito('▶️ Plan reanudado')
        await this.cargarDatos()
      } catch (error) {
        console.error('Error:', error)
        this.mostrarError('Error al reanudar el plan')
      }
    },

    async completarPlan(plan) {
      try {
        await api.put(`/diet-plans/${plan.id}`, { status: 'COMPLETED' })
        this.mostrarExito('✅ Plan completado')
        await this.cargarDatos()
      } catch (error) {
        console.error('Error:', error)
        this.mostrarError('Error al completar el plan')
      }
    },

    async cancelarPlan(plan) {
      try {
        await api.put(`/diet-plans/${plan.id}`, { status: 'CANCELLED' })
        this.mostrarExito('❌ Plan cancelado')
        await this.cargarDatos()
      } catch (error) {
        console.error('Error:', error)
        this.mostrarError('Error al cancelar el plan')
      }
    },

    limpiarFormulario() {
      this.nuevoPlan = {
        idPaciente: null,
        nombrePlan: '',
        descripcion: '',
        fechaInicio: '',
        fechaFin: '',
        caloriasDiarias: null,
        objetivos: ''
      }
    },

    formatearFecha(fecha) {
      if (!fecha) return ''
      
      let year, month, day
      
      // Si viene como array [2025, 11, 6] del backend
      if (Array.isArray(fecha) && fecha.length >= 3) {
        year = fecha[0]
        month = fecha[1]
        day = fecha[2]
      } 
      // Si viene como string YYYY-MM-DD
      else if (typeof fecha === 'string') {
        const match = fecha.match(/^(\d{4})-(\d{2})-(\d{2})/)
        if (match) {
          year = parseInt(match[1])
          month = parseInt(match[2])
          day = parseInt(match[3])
        } else {
          return fecha
        }
      } else {
        return ''
      }
      
      // Formatear manualmente sin usar Date para evitar problemas de zona horaria
      const meses = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic']
      return `${day} ${meses[month - 1]} ${year}`
    },

    getStatusColor(status) {
      const colors = {
        'ACTIVE': 'green',
        'COMPLETED': 'blue',
        'PAUSED': 'orange',
        'CANCELLED': 'red'
      }
      return colors[status] || 'grey'
    },

    traducirEstado(status) {
      const traducciones = {
        'ACTIVE': 'Activo',
        'COMPLETED': 'Completado',
        'PAUSED': 'Pausado',
        'CANCELLED': 'Cancelado'
      }
      return traducciones[status] || status
    },

    mostrarExito(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'success' }
    },

    mostrarError(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'error' }
    },

    mostrarInfo(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'info' }
    },

    async exportarPDFPlan(plan) {
      try {
        console.log('📦 Plan completo recibido:', plan)
        
        // Obtener las comidas del plan
        const comidasResponse = await api.get(`/diet-meals/plan/${plan.id}`)
        const comidas = comidasResponse.data
        console.log('🍽️ Comidas del plan:', comidas)

        if (!comidas || comidas.length === 0) {
          this.mostrarError('Este plan no tiene comidas para exportar')
          return
        }

        // Obtener el resumen nutricional
        const resumenResponse = await api.get(`/diet-meals/plan/${plan.id}/summary`)
        const resumen = resumenResponse.data
        console.log('📊 Resumen nutricional:', resumen)

        // Obtener información del paciente con peso
        let pacienteInfo = null
        const idPaciente = plan.patientId || plan.patient?.id || plan.userId
        console.log('🔍 ID del paciente detectado:', idPaciente)
        
        if (idPaciente) {
          try {
            const pacienteResponse = await api.get(`/pacientes/${idPaciente}`)
            const paciente = pacienteResponse.data
            console.log('📋 Datos del paciente:', paciente)
            
            // Obtener último peso registrado
            let ultimoPeso = null
            try {
              const pesoResponse = await api.get(`/weight-records/user/${idPaciente}`)
              console.log('⚖️ Registros de peso:', pesoResponse.data)
              if (pesoResponse.data && pesoResponse.data.length > 0) {
                // Ordenar por fecha y tomar el más reciente
                const pesos = pesoResponse.data.sort((a, b) => 
                  new Date(b.recordDate) - new Date(a.recordDate)
                )
                ultimoPeso = pesos[0].weight
                console.log('✅ Último peso de registros:', ultimoPeso)
              }
            } catch (error) {
              console.log('❌ No se pudo cargar peso de registros:', error)
            }
            
            // Si no hay peso en los registros, intentar obtenerlo del perfil del paciente
            if (!ultimoPeso && paciente.currentWeight) {
              ultimoPeso = paciente.currentWeight
              console.log('✅ Peso del perfil del paciente:', ultimoPeso)
            }
            
            pacienteInfo = {
              nombre: paciente.fullName || `${paciente.firstName} ${paciente.lastName}`,
              email: paciente.email,
              peso: ultimoPeso
            }
            console.log('👤 Info del paciente para PDF:', pacienteInfo)
          } catch (error) {
            console.log('❌ No se pudo cargar info del paciente:', error)
          }
        } else {
          console.warn('⚠️ No se encontró ID del paciente en el plan')
        }

        // Generar PDF
        const planInfo = {
          nombre: plan.planName || plan.name || 'Plan Dietético',
          objetivo: plan.goals || plan.goal || '',
          calorias: plan.dailyCalories
        }

        const fileName = generarPDFPlanDietético(planInfo, comidas, resumen, pacienteInfo)
        this.mostrarExito(`✅ PDF generado: ${fileName}`)
      } catch (error) {
        console.error('Error al exportar PDF:', error)
        this.mostrarError('Error al generar el PDF')
      }
    },

    soloNumerosEnteros(event) {
      const char = String.fromCharCode(event.keyCode)
      // Solo permitir números (0-9)
      if (!/[0-9]/.test(char)) {
        event.preventDefault()
      }
    },

    formatearFechaParaInput(fecha) {
      if (!fecha) return ''
      
      // Si la fecha ya está en formato YYYY-MM-DD, devolverla tal cual
      if (typeof fecha === 'string' && fecha.match(/^\d{4}-\d{2}-\d{2}$/)) {
        return fecha
      }
      
      // Si viene como array [2025, 11, 6] del backend
      if (Array.isArray(fecha) && fecha.length >= 3) {
        const year = fecha[0]
        const month = String(fecha[1]).padStart(2, '0')
        const day = String(fecha[2]).padStart(2, '0')
        return `${year}-${month}-${day}`
      }
      
      // Si es una cadena de fecha ISO, extraer solo la parte de la fecha
      if (typeof fecha === 'string') {
        const match = fecha.match(/^(\d{4})-(\d{2})-(\d{2})/)
        if (match) {
          return `${match[1]}-${match[2]}-${match[3]}`
        }
      }
      
      return ''
    }
  }
}
</script>

<style scoped>
.border {
  border: 1px solid #e0e0e0;
}
</style>