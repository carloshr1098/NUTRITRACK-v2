<template>
  <v-container fluid class="dashboard-container">
    <!-- Header con bienvenida -->
    <v-row class="mb-4">
      <v-col cols="12">
        <div class="welcome-section">
          <h1 class="text-h3 font-weight-bold mb-2">
            ¡Bienvenido de nuevo, {{ userName }}! 👋
          </h1>
          <p class="text-subtitle-1 text-grey">
            {{ currentDate }} • Panel de Control Nutricional
          </p>
        </div>
      </v-col>
    </v-row>

    <!-- KPI Cards -->
    <v-row class="mb-4">
      <v-col cols="12" md="3" sm="6">
        <stat-card
          icon="mdi-account-group"
          :value="stats.totalPacientes"
          label="Pacientes Activos"
          color="primary"
          :trend="`+${stats.pacientesNuevos} este mes`"
          :trend-up="true"
          :show-progress="true"
          :progress="stats.pacientesProgress"
          subtitle="Total en el sistema"
        />
      </v-col>
      
      <v-col cols="12" md="3" sm="6">
        <stat-card
          icon="mdi-calendar-check"
          :value="stats.citasHoy"
          label="Citas Hoy"
          color="success"
          :subtitle="`${stats.citasSemana} esta semana`"
        />
      </v-col>
      
      <v-col cols="12" md="3" sm="6">
        <stat-card
          icon="mdi-food-apple"
          :value="stats.planesActivos"
          label="Planes Activos"
          color="orange"
          :trend="`${stats.planesCompletados}% completados`"
          :trend-up="stats.planesCompletados > 70"
          :show-progress="true"
          :progress="stats.planesCompletados"
        />
      </v-col>
      
      <v-col cols="12" md="3" sm="6">
        <stat-card
          icon="mdi-chart-line"
          :value="`${stats.progresoPromedio}%`"
          label="Progreso Promedio"
          color="purple"
          :trend="`${stats.pacientesEnMeta} pacientes en meta`"
          :trend-up="true"
          subtitle="De todos los pacientes"
        />
      </v-col>
    </v-row>

    <!-- Gráficas y datos -->
    <v-row>
      <!-- Gráfica de peso promedio -->
      <v-col cols="12" md="8">
        <v-card elevation="2" class="chart-card">
          <v-card-title class="d-flex align-center">
            <v-icon class="mr-2" color="primary">mdi-chart-line</v-icon>
            Progreso de Peso Promedio
            <v-spacer></v-spacer>
            <v-btn-toggle
              v-model="pesoTimeRange"
              mandatory
              density="compact"
              variant="outlined"
            >
              <v-btn value="week" size="small">Semana</v-btn>
              <v-btn value="month" size="small">Mes</v-btn>
              <v-btn value="year" size="small">Año</v-btn>
            </v-btn-toggle>
          </v-card-title>
          <v-card-text>
            <div style="height: 300px;">
              <line-chart 
                v-if="pesoChartData"
                :chart-data="pesoChartData"
                :chart-options="pesoChartOptions"
              />
            </div>
          </v-card-text>
        </v-card>
      </v-col>

      <!-- Distribución de tipos de citas -->
      <v-col cols="12" md="4">
        <v-card elevation="2" class="chart-card">
          <v-card-title class="d-flex align-center">
            <v-icon class="mr-2" color="success">mdi-calendar-multiple</v-icon>
            Tipos de Citas
          </v-card-title>
          <v-card-text>
            <div style="height: 300px;">
              <doughnut-chart 
                v-if="citasChartData"
                :chart-data="citasChartData"
                :chart-options="citasChartOptions"
              />
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Próximas citas y actividad reciente -->
    <v-row class="mt-4">
      <!-- Próximas citas -->
      <v-col cols="12" md="6">
        <v-card elevation="2" class="activity-card">
          <v-card-title class="d-flex align-center bg-primary text-white">
            <v-icon class="mr-2">mdi-clock-outline</v-icon>
            Próximas Citas
            <v-spacer></v-spacer>
            <v-chip size="small" color="white" text-color="primary">
              {{ proximasCitas.length }}
            </v-chip>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text class="pa-0">
            <v-list>
              <v-list-item
                v-for="(cita, index) in proximasCitas"
                :key="index"
                class="appointment-item"
              >
                <template v-slot:prepend>
                  <v-avatar :color="cita.color" size="40">
                    <v-icon color="white">{{ cita.icon }}</v-icon>
                  </v-avatar>
                </template>
                
                <v-list-item-title class="font-weight-medium">
                  {{ cita.paciente }}
                </v-list-item-title>
                <v-list-item-subtitle>
                  {{ cita.tipo }} • {{ cita.hora }}
                </v-list-item-subtitle>
                
                <template v-slot:append>
                  <v-chip :color="cita.urgencia" size="small">
                    {{ cita.tiempo }}
                  </v-chip>
                </template>
              </v-list-item>
              
              <v-list-item v-if="proximasCitas.length === 0">
                <v-list-item-title class="text-center text-grey">
                  No hay citas programadas para hoy
                </v-list-item-title>
              </v-list-item>
            </v-list>
          </v-card-text>
          <v-card-actions>
            <v-btn color="primary" variant="text" block to="/nutricionista/citas">
              Ver todas las citas
              <v-icon end>mdi-arrow-right</v-icon>
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>

      <!-- Actividad reciente -->
      <v-col cols="12" md="6">
        <v-card elevation="2" class="activity-card">
          <v-card-title class="d-flex align-center bg-success text-white">
            <v-icon class="mr-2">mdi-timeline-clock</v-icon>
            Actividad Reciente
            <v-spacer></v-spacer>
            <v-chip size="small" color="white" text-color="success">
              Hoy
            </v-chip>
          </v-card-title>
          <v-divider></v-divider>
          <v-card-text class="pa-0">
            <v-timeline side="end" density="compact" class="pa-4">
              <v-timeline-item
                v-for="(actividad, index) in actividadReciente"
                :key="index"
                :dot-color="actividad.color"
                size="small"
              >
                <template v-slot:opposite>
                  <span class="text-caption text-grey">{{ actividad.tiempo }}</span>
                </template>
                <div>
                  <div class="font-weight-medium">{{ actividad.titulo }}</div>
                  <div class="text-caption text-grey">{{ actividad.descripcion }}</div>
                </div>
              </v-timeline-item>
              
              <v-timeline-item v-if="actividadReciente.length === 0" dot-color="grey" size="small">
                <div class="text-grey">Sin actividad reciente</div>
              </v-timeline-item>
            </v-timeline>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Accesos rápidos -->
    <v-row class="mt-4">
      <v-col cols="12">
        <v-card elevation="2" class="quick-actions-card">
          <v-card-title class="d-flex align-center">
            <v-icon class="mr-2" color="orange">mdi-lightning-bolt</v-icon>
            Accesos Rápidos
          </v-card-title>
          <v-card-text>
            <v-row>
              <v-col cols="6" sm="3" md="2" v-for="(accion, index) in accionesRapidas" :key="index">
                <v-card
                  class="quick-action-btn text-center pa-4"
                  :color="accion.color"
                  variant="tonal"
                  @click="navegarA(accion.ruta)"
                  hover
                >
                  <v-icon size="48" :color="accion.color">{{ accion.icon }}</v-icon>
                  <div class="text-caption font-weight-medium mt-2">{{ accion.nombre }}</div>
                </v-card>
              </v-col>
            </v-row>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import StatCard from '@/components/StatCard.vue'
import LineChart from '@/components/charts/LineChart.vue'
import DoughnutChart from '@/components/charts/DoughnutChart.vue'
import api from '@/services/api'

export default {
  name: 'NutritionistDashboardView',
  components: {
    StatCard,
    LineChart,
    DoughnutChart
  },
  data() {
    return {
      userName: 'Nutricionista',
      pesoTimeRange: 'month',
      stats: {
        totalPacientes: 0,
        pacientesNuevos: 0,
        pacientesProgress: 0,
        citasHoy: 0,
        citasSemana: 0,
        planesActivos: 0,
        planesCompletados: 0,
        progresoPromedio: 0,
        pacientesEnMeta: 0
      },
      proximasCitas: [],
      actividadReciente: [],
      accionesRapidas: [
        { nombre: 'Nueva Cita', icon: 'mdi-calendar-plus', color: '#FF01FF', ruta: '/nutricionista/citas' },
        { nombre: 'Nuevo Paciente', icon: 'mdi-account-plus', color: '#2A071FF', ruta: '/nutricionista/pacientes' },
        { nombre: 'Nuevo Plan', icon: 'mdi-food-apple', color: '#B8D438', ruta: '/nutricionista/planes' },
        { nombre: 'Base de Alimentos', icon: 'mdi-database', color: '#7A7A5A', ruta: '/nutricionista/alimentos' },
        { nombre: 'Reportes', icon: 'mdi-chart-box', color: '#FF0000', ruta: '/admin/reportes' },
        { nombre: 'Seguimiento', icon: 'mdi-chart-line', color: '#FF01FF', ruta: '/nutricionista/pacientes' }
      ],
      pesoChartData: null,
      pesoChartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          },
          tooltip: {
            mode: 'index',
            intersect: false,
            backgroundColor: 'rgba(0,0,0,0.8)',
            padding: 12,
            cornerRadius: 8
          }
        },
        scales: {
          y: {
            beginAtZero: false,
            grid: {
              color: 'rgba(0,0,0,0.05)'
            }
          },
          x: {
            grid: {
              display: false
            }
          }
        }
      },
      citasChartData: null,
      citasChartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'bottom'
          }
        }
      }
    }
  },
  computed: {
    currentDate() {
      const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' }
      return new Date().toLocaleDateString('es-ES', options)
    }
  },
  async mounted() {
    await this.cargarDatos()
    this.obtenerNombreUsuario()
  },
  methods: {
    async cargarDatos() {
      try {
        await Promise.all([
          this.cargarEstadisticas(),
          this.cargarProximasCitas(),
          this.cargarActividadReciente(),
          this.cargarGraficaPeso(),
          this.cargarGraficaCitas()
        ])
      } catch (error) {
        console.error('Error al cargar datos del dashboard:', error)
      }
    },
    
    async cargarEstadisticas() {
      try {
        // Cargar pacientes
        const pacientesResponse = await api.get('/pacientes')
        this.stats.totalPacientes = pacientesResponse.data.length
        this.stats.pacientesNuevos = Math.floor(Math.random() * 5) + 1 // Temporal
        this.stats.pacientesProgress = Math.min((this.stats.totalPacientes / 100) * 100, 100)
        
        // Cargar citas
        const citasResponse = await api.get('/appointments')
        const hoy = new Date().toDateString()
        this.stats.citasHoy = citasResponse.data.filter(c => 
          new Date(c.appointmentDate).toDateString() === hoy
        ).length
        
        const inicioSemana = new Date()
        inicioSemana.setDate(inicioSemana.getDate() - inicioSemana.getDay())
        this.stats.citasSemana = citasResponse.data.filter(c => 
          new Date(c.appointmentDate) >= inicioSemana
        ).length
        
        // Cargar planes
        const planesResponse = await api.get('/diet-plans')
        this.stats.planesActivos = planesResponse.data.length
        this.stats.planesCompletados = Math.floor(Math.random() * 100) // Temporal
        
        // Estadísticas adicionales
        this.stats.progresoPromedio = Math.floor(Math.random() * 30) + 60
        this.stats.pacientesEnMeta = Math.floor(this.stats.totalPacientes * 0.6)
        
      } catch (error) {
        console.error('Error al cargar estadísticas:', error)
      }
    },
    
    async cargarProximasCitas() {
      try {
        const response = await api.get('/appointments')
        const hoy = new Date()
        hoy.setHours(0, 0, 0, 0)
        
        const manana = new Date(hoy)
        manana.setDate(manana.getDate() + 1)
        
        this.proximasCitas = response.data
          .filter(cita => {
            const fechaCita = new Date(cita.appointmentDate)
            return fechaCita >= hoy && fechaCita < manana
          })
          .slice(0, 5)
          .map(cita => {
            const ahora = new Date()
            const fechaCita = new Date(cita.appointmentDate)
            const diff = fechaCita - ahora
            const horas = Math.floor(diff / (1000 * 60 * 60))
            const minutos = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60))
            
            return {
              paciente: cita.patient ? `${cita.patient.firstName} ${cita.patient.lastName}` : 'Paciente',
              tipo: this.formatearTipoCita(cita.appointmentType),
              hora: fechaCita.toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' }),
              tiempo: horas > 0 ? `En ${horas}h ${minutos}m` : `En ${minutos}m`,
              urgencia: horas < 1 ? 'error' : horas < 2 ? 'warning' : 'success',
              color: this.getColorTipoCita(cita.appointmentType),
              icon: this.getIconTipoCita(cita.appointmentType)
            }
          })
      } catch (error) {
        console.error('Error al cargar próximas citas:', error)
      }
    },
    
    async cargarActividadReciente() {
      // Datos de ejemplo - conectar con backend real
      this.actividadReciente = [
        {
          tiempo: 'Hace 10 min',
          titulo: 'Nuevo paciente registrado',
          descripcion: 'Ana María García Pérez',
          color: 'success'
        },
        {
          tiempo: 'Hace 25 min',
          titulo: 'Plan dietético actualizado',
          descripcion: 'Plan 1.0 - Pérdida de peso',
          color: 'primary'
        },
        {
          tiempo: 'Hace 1 hora',
          titulo: 'Cita completada',
          descripcion: 'Consulta de seguimiento',
          color: 'info'
        },
        {
          tiempo: 'Hace 2 horas',
          titulo: 'Nuevo registro de peso',
          descripcion: 'María López - 68.5 kg',
          color: 'orange'
        }
      ]
    },
    
    async cargarGraficaPeso() {
      // Datos de ejemplo - conectar con backend real
      const labels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun']
      const data = [72, 71.5, 70.8, 70, 69.5, 69]
      
      this.pesoChartData = {
        labels,
        datasets: [
          {
            label: 'Peso Promedio (kg)',
            data,
            borderColor: '#4CAF50',
            backgroundColor: 'rgba(76, 175, 80, 0.1)',
            fill: true,
            tension: 0.4,
            pointRadius: 4,
            pointHoverRadius: 6
          }
        ]
      }
    },
    
    async cargarGraficaCitas() {
      // Datos de ejemplo - conectar con backend real
      this.citasChartData = {
        labels: ['Primera Consulta', 'Seguimiento', 'Control', 'Urgente'],
        datasets: [
          {
            data: [35, 40, 20, 5],
            backgroundColor: [
              '#2196F3',
              '#4CAF50',
              '#FF9800',
              '#F44336'
            ],
            borderWidth: 0
          }
        ]
      }
    },
    
    formatearTipoCita(tipo) {
      const tipos = {
        'PRIMERA_CONSULTA': 'Primera Consulta',
        'SEGUIMIENTO': 'Seguimiento',
        'CONTROL': 'Control',
        'URGENTE': 'Urgente'
      }
      return tipos[tipo] || tipo
    },
    
    getColorTipoCita(tipo) {
      const colores = {
        'PRIMERA_CONSULTA': 'primary',
        'SEGUIMIENTO': 'success',
        'CONTROL': 'info',
        'URGENTE': 'error'
      }
      return colores[tipo] || 'grey'
    },
    
    getIconTipoCita(tipo) {
      const iconos = {
        'PRIMERA_CONSULTA': 'mdi-account-plus',
        'SEGUIMIENTO': 'mdi-clipboard-check',
        'CONTROL': 'mdi-calendar-check',
        'URGENTE': 'mdi-alert-circle'
      }
      return iconos[tipo] || 'mdi-calendar'
    },
    
    obtenerNombreUsuario() {
      const user = JSON.parse(localStorage.getItem('user') || '{}')
      this.userName = user.username || 'Nutricionista'
    },
    
    navegarA(ruta) {
      this.$router.push(ruta)
    }
  }
}
</script>

<style scoped>
.dashboard-container {
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: 100vh;
  padding: 24px;
}

.welcome-section {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 32px;
  border-radius: 16px;
  color: white;
  box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
}

.chart-card {
  border-radius: 12px;
  height: 100%;
}

.activity-card {
  border-radius: 12px;
  height: 100%;
}

.appointment-item {
  transition: all 0.2s ease;
}

.appointment-item:hover {
  background-color: rgba(0,0,0,0.02);
}

.quick-actions-card {
  border-radius: 12px;
}

.quick-action-btn {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 12px;
}

.quick-action-btn:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0,0,0,0.1);
}
</style>
