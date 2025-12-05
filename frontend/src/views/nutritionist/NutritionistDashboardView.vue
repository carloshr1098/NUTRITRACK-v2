<template>
  <v-container fluid class="dashboard-container">
    <!-- Header con bienvenida -->
    <v-row class="mb-4">
      <v-col cols="12">
        <div class="welcome-section">
          <h1 class="text-h3 font-weight-bold mb-2">
            Bienvenido, {{ userFullName }} 👋
          </h1>
          <p class="text-subtitle-1 user-role">
            ROL: {{ userRole }}
          </p>
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

    <!-- Reportes y Análisis Detallado -->
    <v-row class="mt-4">
      <v-col cols="12">
        <v-card elevation="2" class="reports-card">
          <v-card-title class="d-flex align-center bg-gradient-purple text-white">
            <v-icon class="mr-2">mdi-chart-box-outline</v-icon>
            Reportes y Análisis
            <v-spacer></v-spacer>
            <v-btn 
              color="white" 
              variant="outlined" 
              size="small"
              @click="exportarReportes"
              prepend-icon="mdi-download"
            >
              Exportar
            </v-btn>
          </v-card-title>
          <v-card-text>
            <v-row>
              <!-- Usuarios Nuevos Registrados -->
              <v-col cols="12" md="6">
                <div class="report-section">
                  <h3 class="section-title">
                    <v-icon color="success" class="mr-2">mdi-account-multiple-plus</v-icon>
                    Usuarios Nuevos Registrados
                  </h3>
                  <div style="height: 300px;">
                    <line-chart 
                      v-if="usuariosNuevosChartData"
                      :chart-data="usuariosNuevosChartData"
                      :chart-options="usuariosNuevosChartOptions"
                    />
                  </div>
                  <v-row class="mt-4">
                    <v-col cols="4" class="text-center">
                      <div class="stat-number text-primary">{{ stats.nuevosEsteMes }}</div>
                      <div class="stat-label">Este Mes</div>
                    </v-col>
                    <v-col cols="4" class="text-center">
                      <div class="stat-number text-success">{{ stats.nuevosEstaSemana }}</div>
                      <div class="stat-label">Esta Semana</div>
                    </v-col>
                    <v-col cols="4" class="text-center">
                      <div class="stat-number text-info">{{ stats.totalUsuarios }}</div>
                      <div class="stat-label">Total</div>
                    </v-col>
                  </v-row>
                </div>
              </v-col>

              <!-- Citas por Mes -->
              <v-col cols="12" md="6">
                <div class="report-section">
                  <h3 class="section-title">
                    <v-icon color="primary" class="mr-2">mdi-calendar-month</v-icon>
                    Citas por Mes
                  </h3>
                  <div style="height: 300px;">
                    <line-chart 
                      v-if="citasPorMesChartData"
                      :chart-data="citasPorMesChartData"
                      :chart-options="citasPorMesChartOptions"
                    />
                  </div>
                  <v-row class="mt-4">
                    <v-col cols="4" class="text-center">
                      <div class="stat-number text-success">{{ stats.citasEsteMes }}</div>
                      <div class="stat-label">Este Mes</div>
                    </v-col>
                    <v-col cols="4" class="text-center">
                      <div class="stat-number text-warning">{{ stats.citasPendientes }}</div>
                      <div class="stat-label">Pendientes</div>
                    </v-col>
                    <v-col cols="4" class="text-center">
                      <div class="stat-number text-info">{{ stats.citasCompletadas }}</div>
                      <div class="stat-label">Completadas</div>
                    </v-col>
                  </v-row>
                </div>
              </v-col>
            </v-row>

            <!-- Planes de Dieta Generados -->
            <v-row class="mt-4">
              <v-col cols="12">
                <div class="report-section">
                  <h3 class="section-title">
                    <v-icon color="orange" class="mr-2">mdi-food-apple</v-icon>
                    Planes de Dieta Generados
                  </h3>
                  <v-row>
                    <!-- Gráfico de barras -->
                    <v-col cols="12" md="8">
                      <div style="height: 300px;">
                        <line-chart 
                          v-if="planesDietaChartData"
                          :chart-data="planesDietaChartData"
                          :chart-options="planesDietaChartOptions"
                        />
                      </div>
                    </v-col>
                    
                    <!-- Estadísticas de planes -->
                    <v-col cols="12" md="4">
                      <v-row>
                        <v-col cols="6" md="12" v-for="(tipo, index) in tiposPlanes" :key="index">
                          <v-card class="plan-stat-card" :class="`border-left-${tipo.color}`">
                            <v-card-text class="pa-3">
                              <div class="d-flex align-center">
                                <v-icon :color="tipo.color" size="32" class="mr-3">{{ tipo.icon }}</v-icon>
                                <div>
                                  <div class="plan-stat-value" :class="`text-${tipo.color}`">{{ tipo.cantidad }}</div>
                                  <div class="plan-stat-label">{{ tipo.nombre }}</div>
                                </div>
                              </div>
                            </v-card-text>
                          </v-card>
                        </v-col>
                      </v-row>
                    </v-col>
                  </v-row>
                </div>
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
      userFullName: 'Nutricionista',
      userRole: 'NUTRIÓLOGO',
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
        pacientesEnMeta: 0,
        pacientesEnProgreso: 0,
        pacientesRetrasados: 0,
        nuevosEsteMes: 0,
        nuevosEstaSemana: 0,
        totalUsuarios: 0,
        citasEsteMes: 0,
        citasPendientes: 0,
        citasCompletadas: 0
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
      tiposPlanes: [
        {
          nombre: 'Pérdida de Peso',
          cantidad: 28,
          icon: 'mdi-weight-lifter',
          color: 'success'
        },
        {
          nombre: 'Ganancia Muscular',
          cantidad: 15,
          icon: 'mdi-dumbbell',
          color: 'primary'
        },
        {
          nombre: 'Mantenimiento',
          cantidad: 22,
          icon: 'mdi-heart-pulse',
          color: 'info'
        },
        {
          nombre: 'Especiales',
          cantidad: 8,
          icon: 'mdi-star',
          color: 'warning'
        }
      ],
      usuariosNuevosChartData: null,
      usuariosNuevosChartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          },
          tooltip: {
            mode: 'index',
            intersect: false
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              stepSize: 1
            }
          }
        }
      },
      citasPorMesChartData: null,
      citasPorMesChartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              stepSize: 5
            }
          }
        }
      },
      planesDietaChartData: null,
      planesDietaChartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: true,
            position: 'top'
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              stepSize: 2
            }
          }
        }
      },
      objetivosChartData: {
        labels: ['En Meta', 'En Progreso', 'Retrasados'],
        datasets: [{
          data: [15, 12, 8],
          backgroundColor: [
            'rgba(76, 175, 80, 0.8)',
            'rgba(255, 152, 0, 0.8)',
            'rgba(244, 67, 54, 0.8)'
          ],
          borderColor: [
            'rgba(76, 175, 80, 1)',
            'rgba(255, 152, 0, 1)',
            'rgba(244, 67, 54, 1)'
          ],
          borderWidth: 2
        }]
      },
      objetivosChartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              padding: 15,
              font: {
                size: 13
              }
            }
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                const label = context.label || '';
                const value = context.parsed || 0;
                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                const percentage = ((value / total) * 100).toFixed(1);
                return `${label}: ${value} pacientes (${percentage}%)`;
              }
            }
          }
        }
      },
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
    },
    objetivosChartDataComputed() {
      return {
        labels: ['En Meta', 'En Progreso', 'Retrasados'],
        datasets: [{
          data: [
            this.stats.pacientesEnMeta,
            this.stats.pacientesEnProgreso,
            this.stats.pacientesRetrasados
          ],
          backgroundColor: [
            'rgba(76, 175, 80, 0.8)',
            'rgba(255, 152, 0, 0.8)',
            'rgba(244, 67, 54, 0.8)'
          ],
          borderColor: [
            'rgba(76, 175, 80, 1)',
            'rgba(255, 152, 0, 1)',
            'rgba(244, 67, 54, 1)'
          ],
          borderWidth: 2
        }]
      }
    }
  },
  async mounted() {
    this.obtenerNombreUsuario()
    await this.cargarDatos()
  },
  activated() {
    // Se ejecuta cada vez que la vista se activa (útil con keep-alive)
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
          this.cargarGraficaCitas(),
          this.cargarGraficaUsuariosNuevos(),
          this.cargarGraficaCitasPorMes(),
          this.cargarGraficaPlanesDieta()
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
        this.stats.pacientesEnMeta = Math.floor(this.stats.totalPacientes * 0.43)
        this.stats.pacientesEnProgreso = Math.floor(this.stats.totalPacientes * 0.34)
        this.stats.pacientesRetrasados = Math.floor(this.stats.totalPacientes * 0.23)
        
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
    
    async cargarGraficaUsuariosNuevos() {
      try {
        const response = await api.get('/pacientes')
        const pacientes = response.data
        
        // Calcular usuarios nuevos por mes (últimos 6 meses)
        const hoy = new Date()
        const meses = []
        const conteoMeses = []
        
        for (let i = 5; i >= 0; i--) {
          const fecha = new Date(hoy.getFullYear(), hoy.getMonth() - i, 1)
          const nombreMes = fecha.toLocaleDateString('es-ES', { month: 'long' })
          meses.push(nombreMes.charAt(0).toUpperCase() + nombreMes.slice(1))
          
          // Contar pacientes creados en ese mes
          const pacientesMes = pacientes.filter(p => {
            if (!p.createdAt) return false
            const fechaCreacion = new Date(p.createdAt)
            return fechaCreacion.getMonth() === fecha.getMonth() && 
                   fechaCreacion.getFullYear() === fecha.getFullYear()
          }).length
          
          conteoMeses.push(pacientesMes)
        }
        
        this.usuariosNuevosChartData = {
          labels: meses,
          datasets: [
            {
              label: 'Usuarios Nuevos',
              data: conteoMeses,
              borderColor: '#4CAF50',
              backgroundColor: 'rgba(76, 175, 80, 0.2)',
              fill: true,
              tension: 0.4,
              pointRadius: 5,
              pointHoverRadius: 7,
              pointBackgroundColor: '#4CAF50',
              pointBorderColor: '#fff',
              pointBorderWidth: 2
            }
          ]
        }
        
        // Calcular stats
        const inicioMes = new Date(hoy.getFullYear(), hoy.getMonth(), 1)
        const inicioSemana = new Date(hoy)
        inicioSemana.setDate(hoy.getDate() - hoy.getDay())
        
        this.stats.nuevosEsteMes = pacientes.filter(p => 
          p.createdAt && new Date(p.createdAt) >= inicioMes
        ).length
        
        this.stats.nuevosEstaSemana = pacientes.filter(p => 
          p.createdAt && new Date(p.createdAt) >= inicioSemana
        ).length
        
        this.stats.totalUsuarios = pacientes.length
        
      } catch (error) {
        console.error('Error al cargar gráfica de usuarios nuevos:', error)
      }
    },
    
    async cargarGraficaCitasPorMes() {
      try {
        const response = await api.get('/appointments')
        const citas = response.data
        
        // Calcular citas por mes (últimos 6 meses)
        const hoy = new Date()
        const meses = []
        const completadasMes = []
        const pendientesMes = []
        
        for (let i = 5; i >= 0; i--) {
          const fecha = new Date(hoy.getFullYear(), hoy.getMonth() - i, 1)
          const nombreMes = fecha.toLocaleDateString('es-ES', { month: 'long' })
          meses.push(nombreMes.charAt(0).toUpperCase() + nombreMes.slice(1))
          
          // Contar citas del mes
          const citasMes = citas.filter(c => {
            if (!c.appointmentDate) return false
            const fechaCita = new Date(c.appointmentDate)
            return fechaCita.getMonth() === fecha.getMonth() && 
                   fechaCita.getFullYear() === fecha.getFullYear()
          })
          
          const completadas = citasMes.filter(c => c.status === 'COMPLETADA').length
          const pendientes = citasMes.filter(c => c.status === 'PENDIENTE' || c.status === 'CONFIRMADA').length
          
          completadasMes.push(completadas)
          pendientesMes.push(pendientes)
        }
        
        this.citasPorMesChartData = {
          labels: meses,
          datasets: [
            {
              label: 'Completadas',
              data: completadasMes,
              borderColor: '#4CAF50',
              backgroundColor: 'rgba(76, 175, 80, 0.2)',
              fill: true,
              tension: 0.4
            },
            {
              label: 'Pendientes',
              data: pendientesMes,
              borderColor: '#FF9800',
              backgroundColor: 'rgba(255, 152, 0, 0.2)',
              fill: true,
              tension: 0.4
            }
          ]
        }
        
        // Calcular stats del mes actual
        const inicioMes = new Date(hoy.getFullYear(), hoy.getMonth(), 1)
        const citasEsteMes = citas.filter(c => {
          if (!c.appointmentDate) return false
          return new Date(c.appointmentDate) >= inicioMes
        })
        
        this.stats.citasEsteMes = citasEsteMes.length
        this.stats.citasPendientes = citasEsteMes.filter(c => 
          c.status === 'PENDIENTE' || c.status === 'CONFIRMADA'
        ).length
        this.stats.citasCompletadas = citasEsteMes.filter(c => 
          c.status === 'COMPLETADA'
        ).length
        
      } catch (error) {
        console.error('Error al cargar gráfica de citas por mes:', error)
      }
    },
    
    async cargarGraficaPlanesDieta() {
      try {
        const response = await api.get('/diet-plans')
        const planes = response.data
        
        // Calcular planes por mes (últimos 6 meses)
        const hoy = new Date()
        const meses = []
        const perdidaPeso = []
        const gananciaMuscular = []
        const mantenimiento = []
        
        // Contadores totales por tipo
        let totalPerdida = 0
        let totalGanancia = 0
        let totalMantenimiento = 0
        let totalEspeciales = 0
        
        for (let i = 5; i >= 0; i--) {
          const fecha = new Date(hoy.getFullYear(), hoy.getMonth() - i, 1)
          const nombreMes = fecha.toLocaleDateString('es-ES', { month: 'long' })
          meses.push(nombreMes.charAt(0).toUpperCase() + nombreMes.slice(1))
          
          // Contar planes del mes por tipo (basado en goals)
          const planesMes = planes.filter(p => {
            if (!p.createdAt) return false
            const fechaCreacion = new Date(p.createdAt)
            return fechaCreacion.getMonth() === fecha.getMonth() && 
                   fechaCreacion.getFullYear() === fecha.getFullYear()
          })
          
          const perdida = planesMes.filter(p => 
            p.goals && (p.goals.toLowerCase().includes('perder') || 
                       p.goals.toLowerCase().includes('pérdida') ||
                       p.goals.toLowerCase().includes('bajar peso'))
          ).length
          
          const ganancia = planesMes.filter(p => 
            p.goals && (p.goals.toLowerCase().includes('ganar') || 
                       p.goals.toLowerCase().includes('músculo') ||
                       p.goals.toLowerCase().includes('masa'))
          ).length
          
          const manten = planesMes.filter(p => 
            p.goals && (p.goals.toLowerCase().includes('mantener') || 
                       p.goals.toLowerCase().includes('mantenimiento'))
          ).length
          
          const otros = planesMes.length - perdida - ganancia - manten
          
          perdidaPeso.push(perdida)
          gananciaMuscular.push(ganancia)
          mantenimiento.push(manten)
          
          totalPerdida += perdida
          totalGanancia += ganancia
          totalMantenimiento += manten
          totalEspeciales += otros
        }
        
        this.planesDietaChartData = {
          labels: meses,
          datasets: [
            {
              label: 'Pérdida de Peso',
              data: perdidaPeso,
              borderColor: '#4CAF50',
              backgroundColor: 'rgba(76, 175, 80, 0.2)',
              fill: true,
              tension: 0.4
            },
            {
              label: 'Ganancia Muscular',
              data: gananciaMuscular,
              borderColor: '#2196F3',
              backgroundColor: 'rgba(33, 150, 243, 0.2)',
              fill: true,
              tension: 0.4
            },
            {
              label: 'Mantenimiento',
              data: mantenimiento,
              borderColor: '#00BCD4',
              backgroundColor: 'rgba(0, 188, 212, 0.2)',
              fill: true,
              tension: 0.4
            }
          ]
        }
        
        // Actualizar contadores en las tarjetas
        this.tiposPlanes[0].cantidad = totalPerdida
        this.tiposPlanes[1].cantidad = totalGanancia
        this.tiposPlanes[2].cantidad = totalMantenimiento
        this.tiposPlanes[3].cantidad = totalEspeciales
        
      } catch (error) {
        console.error('Error al cargar gráfica de planes de dieta:', error)
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
      try {
        const userString = localStorage.getItem('user')
        console.log('📝 Raw user string:', userString)
        
        if (!userString || userString === 'null' || userString === 'undefined') {
          console.warn('⚠️ No hay usuario en localStorage')
          return
        }
        
        const user = JSON.parse(userString)
        console.log('👤 Usuario parseado:', user)
        console.log('📋 firstName:', user.firstName)
        console.log('📋 lastName:', user.lastName)
        
        this.userName = user.username || 'Nutricionista'
        
        // Obtener nombre completo
        const firstName = user.firstName || ''
        const lastName = user.lastName || ''
        const fullName = `${firstName} ${lastName}`.trim()
        
        console.log('✅ Nombre completo construido:', fullName)
        
        this.userFullName = fullName || user.username || 'Nutricionista'
        
        console.log('✅ userFullName final:', this.userFullName)
        
        // Formatear el rol - puede venir en roles[] o role
        let role = 'NUTRIÓLOGO'
        if (user.roles && user.roles.length > 0) {
          role = user.roles[0].replace('ROLE_', '').replace('_', ' ')
        } else if (user.role) {
          role = user.role.replace('ROLE_', '').replace('_', ' ')
        }
        this.userRole = role
        
        console.log('✅ userRole final:', this.userRole)
      } catch (error) {
        console.error('❌ Error al obtener nombre de usuario:', error)
      }
    },
    
    navegarA(ruta) {
      this.$router.push(ruta)
    },
    
    exportarReportes() {
      // Preparar datos para exportación
      const fecha = new Date().toLocaleDateString('es-ES')
      const reporte = {
        fecha,
        estadisticas: this.stats,
        topPacientes: this.topPacientes,
        metricasMensuales: this.metricasMensuales,
        objetivos: {
          enMeta: this.stats.pacientesEnMeta,
          enProgreso: this.stats.pacientesEnProgreso,
          retrasados: this.stats.pacientesRetrasados
        }
      }
      
      // Simular descarga (en producción conectar con servicio de exportación)
      console.log('📊 Exportando reporte:', reporte)
      
      // Crear blob con datos JSON como ejemplo
      const dataStr = JSON.stringify(reporte, null, 2)
      const dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr)
      
      const exportFileDefaultName = `reporte_nutritrack_${fecha.replace(/\//g, '-')}.json`
      
      const linkElement = document.createElement('a')
      linkElement.setAttribute('href', dataUri)
      linkElement.setAttribute('download', exportFileDefaultName)
      linkElement.click()
    }
  }
}
</script>

<style scoped>
.dashboard-container {
  background: linear-gradient(135deg, #f8fafb 0%, #e8f4f8 100%);
  min-height: 100vh;
  padding: 24px;
  position: relative;
}

.dashboard-container::before {
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

.dashboard-container > * {
  position: relative;
  z-index: 1;
}

.welcome-section {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  padding: 40px;
  border-radius: 20px;
  color: white;
  box-shadow: 0 12px 35px rgba(139, 195, 74, 0.35);
  border: 2px solid rgba(255, 255, 255, 0.3);
  position: relative;
  overflow: hidden;
}

.welcome-section::before {
  content: '';
  position: absolute;
  top: -50%;
  right: -20%;
  width: 300px;
  height: 300px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  filter: blur(60px);
}

.welcome-section h1 {
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.user-role {
  color: rgba(255, 255, 255, 0.95) !important;
  font-weight: 600;
  font-size: 16px !important;
  letter-spacing: 1.5px;
  margin-bottom: 8px;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.chart-card {
  border-radius: 16px;
  height: 100%;
  border-left: 4px solid #8bc34a;
  transition: all 0.3s ease;
  background: white;
}

.chart-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(139, 195, 74, 0.15);
  border-left-width: 6px;
}

.activity-card {
  border-radius: 16px;
  height: 100%;
  overflow: hidden;
  border-left: 4px solid #5fc2c6;
  transition: all 0.3s ease;
  background: white;
}

.activity-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(95, 194, 198, 0.15);
  border-left-width: 6px;
}

.appointment-item {
  transition: all 0.2s ease;
  border-left: 3px solid transparent;
  padding: 12px 16px;
}

.appointment-item:hover {
  background: linear-gradient(90deg, rgba(139, 195, 74, 0.08) 0%, transparent 100%);
  border-left-color: #8bc34a;
  padding-left: 20px;
}

.quick-actions-card {
  border-radius: 16px;
  border-top: 4px solid #8bc34a;
  background: white;
}

.quick-action-btn {
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 16px;
  border: 2px solid transparent;
  background: linear-gradient(135deg, #ffffff 0%, #f8fafb 100%);
}

.quick-action-btn:hover {
  transform: translateY(-8px) scale(1.02);
  box-shadow: 0 16px 32px rgba(139, 195, 74, 0.25);
  border-color: #8bc34a;
  background: white;
}

/* Colores personalizados de la paleta NutriTrack */
:deep(.v-card-title.bg-primary) {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%) !important;
  box-shadow: 0 2px 8px rgba(139, 195, 74, 0.2);
}

:deep(.v-card-title.bg-success) {
  background: linear-gradient(135deg, #5fc2c6 0%, #4fb3b7 100%) !important;
  box-shadow: 0 2px 8px rgba(95, 194, 198, 0.2);
}

:deep(.text-primary) {
  color: #8bc34a !important;
}

:deep(.text-success) {
  color: #5fc2c6 !important;
}

:deep(.v-btn.text-primary) {
  color: #8bc34a !important;
}

:deep(.v-btn.text-primary:hover) {
  background: rgba(139, 195, 74, 0.08) !important;
}

:deep(.v-avatar) {
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

:deep(.v-timeline-item) {
  padding-bottom: 16px;
}

/* Estilos para la nueva sección de reportes */
.reports-card {
  border-radius: 16px;
  border-top: 4px solid #9c27b0;
  background: white;
  overflow: hidden;
}

.bg-gradient-purple {
  background: linear-gradient(135deg, #9c27b0 0%, #7b1fa2 100%) !important;
  border-radius: 12px 12px 0 0;
  padding: 16px 20px;
}

.report-section {
  padding: 16px;
  border-radius: 12px;
  background: linear-gradient(135deg, #ffffff 0%, #f8fafb 100%);
  height: 100%;
}

.section-title {
  font-size: 1.1rem;
  font-weight: 600;
  margin-bottom: 20px;
  color: #333;
  display: flex;
  align-items: center;
}

.progress-list {
  background: transparent !important;
}

.progress-item {
  background: white;
  border-radius: 12px;
  margin-bottom: 12px;
  padding: 12px;
  transition: all 0.3s ease;
  border: 2px solid transparent;
}

.progress-item:hover {
  transform: translateX(8px);
  border-color: #8bc34a;
  box-shadow: 0 8px 16px rgba(139, 195, 74, 0.15);
}

.rank-badge {
  font-weight: 700;
  font-size: 1.2rem;
}

.rank-number {
  color: white;
  font-weight: 700;
}

.metric-card {
  border-radius: 12px;
  transition: all 0.3s ease;
  border: 2px solid #f0f0f0;
  background: white;
}

.metric-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
}

.metric-value {
  font-size: 2rem;
  font-weight: 700;
  margin: 8px 0;
}

.metric-label {
  font-size: 0.9rem;
  color: #666;
  font-weight: 500;
}

.border-primary {
  border-top: 4px solid #2196F3 !important;
}

.border-success {
  border-top: 4px solid #4CAF50 !important;
}

.border-info {
  border-top: 4px solid #00BCD4 !important;
}

.border-orange {
  border-top: 4px solid #FF9800 !important;
}

.stat-number {
  font-size: 2.5rem;
  font-weight: 700;
  line-height: 1;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 0.9rem;
  color: #666;
  font-weight: 500;
}

:deep(.v-list-item-subtitle) {
  opacity: 0.7;
  font-size: 0.85rem;
}

:deep(.v-chip) {
  font-weight: 600;
}

.plan-stat-card {
  border-radius: 12px;
  border-left: 4px solid;
  transition: all 0.3s ease;
  background: white;
  margin-bottom: 12px;
}

.plan-stat-card:hover {
  transform: translateX(4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.border-left-success {
  border-left-color: #4CAF50 !important;
}

.border-left-primary {
  border-left-color: #2196F3 !important;
}

.border-left-info {
  border-left-color: #00BCD4 !important;
}

.border-left-warning {
  border-left-color: #FF9800 !important;
}

.plan-stat-value {
  font-size: 1.8rem;
  font-weight: 700;
  line-height: 1;
}

.plan-stat-label {
  font-size: 0.85rem;
  color: #666;
  margin-top: 4px;
}
</style>
