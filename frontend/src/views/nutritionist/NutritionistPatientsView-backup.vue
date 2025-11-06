<template>
  <v-container fluid class="pa-6">
    <!-- Encabezado con botón para agregar paciente -->
    <v-row class="mb-6">
      <v-col cols="12">
        <div class="d-flex justify-space-between align-center">
          <div>
            <h1 class="text-h4 font-weight-bold mb-2">
              <v-icon size="32" color="primary" class="me-3">mdi-account-multiple</v-icon>
              Gestión de Pacientes
            </h1>
            <p class="text-body-1 text-grey-darken-1">
              Administra la información de tus pacientes de manera eficiente
            </p>
          </div>
          <v-btn
            color="primary"
            size="large"
            prepend-icon="mdi-account-plus"
            @click="abrirDialogoNuevoPaciente"
          >
            Nuevo Paciente
          </v-btn>
        </div>
      </v-col>
    </v-row>

    <!-- Barra de búsqueda y filtros -->
    <v-row class="mb-4">
      <v-col cols="12" md="6">
        <v-text-field
          v-model="busqueda"
          prepend-inner-icon="mdi-magnify"
          label="Buscar pacientes..."
          variant="outlined"
          hide-details
          @input="filtrarPacientes"
        ></v-text-field>
      </v-col>
      <v-col cols="12" md="3">
        <v-select
          v-model="filtroGenero"
          :items="opcionesGenero"
          label="Filtrar por género"
          variant="outlined"
          hide-details
          @update:model-value="filtrarPacientes"
        ></v-select>
      </v-col>
      <v-col cols="12" md="3">
        <v-select
          v-model="ordenarPor"
          :items="opcionesOrden"
          label="Ordenar por"
          variant="outlined"
          hide-details
          @update:model-value="ordenarPacientes"
        ></v-select>
      </v-col>
    </v-row>

    <!-- Lista de pacientes -->
    <v-row>
      <v-col cols="12">
        <v-card elevation="2">
          <v-card-title class="bg-primary text-white">
            <v-icon class="me-2">mdi-format-list-bulleted</v-icon>
            Lista de Pacientes ({{ pacientesFiltrados.length }})
          </v-card-title>
          
          <v-data-table
            :headers="encabezadosTabla"
            :items="pacientesFiltrados"
            :loading="cargando"
            loading-text="Cargando pacientes..."
            no-data-text="No hay pacientes registrados"
            items-per-page="10"
            class="elevation-0"
          >
            <!-- Columna de nombre completo -->
            <template v-slot:item.nombreCompleto="{ item }">
              <div class="d-flex align-center">
                <v-avatar color="primary" size="40" class="me-3">
                  <span class="text-white font-weight-bold">
                    {{ obtenerIniciales(item.firstName, item.lastName) }}
                  </span>
                </v-avatar>
                <div>
                  <div class="font-weight-medium">{{ item.firstName }} {{ item.lastName }}</div>
                  <div class="text-caption text-grey-darken-1">ID: {{ item.id }}</div>
                </div>
              </div>
            </template>

            <!-- Columna de edad -->
            <template v-slot:item.edad="{ item }">
              <v-chip
                :color="obtenerColorEdad(calcularEdad(item.dateOfBirth))"
                variant="tonal"
                size="small"
              >
                {{ calcularEdad(item.dateOfBirth) }} años
              </v-chip>
            </template>

            <!-- Columna de género -->
            <template v-slot:item.gender="{ item }">
              <v-chip
                :color="item.gender === 'M' ? 'blue' : 'pink'"
                variant="tonal"
                size="small"
              >
                <v-icon start>{{ item.gender === 'M' ? 'mdi-gender-male' : 'mdi-gender-female' }}</v-icon>
                {{ item.gender === 'M' ? 'Masculino' : 'Femenino' }}
              </v-chip>
            </template>

            <!-- Columna de peso actual -->
            <template v-slot:item.currentWeight="{ item }">
              <div class="text-center">
                <div class="font-weight-medium">{{ item.currentWeight }} kg</div>
                <div class="text-caption text-grey-darken-1">
                  IMC: {{ calcularIMC(item.currentWeight, item.height) }}
                </div>
              </div>
            </template>

            <!-- Columna de acciones -->
            <template v-slot:item.acciones="{ item }">
              <div class="d-flex gap-2">
                <v-btn
                  icon="mdi-eye"
                  size="small"
                  color="info"
                  variant="tonal"
                  @click="verDetallePaciente(item)"
                ></v-btn>
                <v-btn
                  icon="mdi-pencil"
                  size="small"
                  color="warning"
                  variant="tonal"
                  @click="editarPaciente(item)"
                ></v-btn>
                <v-btn
                  icon="mdi-calendar-plus"
                  size="small"
                  color="success"
                  variant="tonal"
                  @click="agendarCita(item)"
                ></v-btn>
                <v-btn
                  icon="mdi-delete"
                  size="small"
                  color="error"
                  variant="tonal"
                  @click="confirmarEliminarPaciente(item)"
                ></v-btn>
              </div>
            </template>
          </v-data-table>
        </v-card>
      </v-col>
    </v-row>

    <!-- Diálogo para nuevo/editar paciente -->
    <v-dialog v-model="dialogoPaciente" max-width="800px" persistent>
      <v-card>
        <v-card-title class="bg-primary text-white">
          <v-icon class="me-2">{{ pacienteEditando ? 'mdi-account-edit' : 'mdi-account-plus' }}</v-icon>
          {{ pacienteEditando ? 'Editar Paciente' : 'Nuevo Paciente' }}
        </v-card-title>
        
        <v-card-text class="pa-6">
          <v-form ref="formPaciente" v-model="formularioValido">
            <v-row>
              <!-- Información básica -->
              <v-col cols="12">
                <h3 class="text-h6 mb-3">Información Personal</h3>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="formularioPaciente.firstName"
                  label="Nombre *"
                  :rules="reglasNombre"
                  variant="outlined"
                  required
                ></v-text-field>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="formularioPaciente.lastName"
                  label="Apellido *"
                  :rules="reglasApellido"
                  variant="outlined"
                  required
                ></v-text-field>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="formularioPaciente.dateOfBirth"
                  label="Fecha de Nacimiento"
                  type="date"
                  variant="outlined"
                ></v-text-field>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-select
                  v-model="formularioPaciente.gender"
                  :items="[{title: 'Masculino', value: 'M'}, {title: 'Femenino', value: 'F'}]"
                  label="Género"
                  variant="outlined"
                ></v-select>
              </v-col>
              
              <!-- Información física -->
              <v-col cols="12">
                <v-divider class="my-4"></v-divider>
                <h3 class="text-h6 mb-3">Información Física</h3>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="formularioPaciente.height"
                  label="Estatura (cm)"
                  type="number"
                  variant="outlined"
                  suffix="cm"
                ></v-text-field>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="formularioPaciente.currentWeight"
                  label="Peso Actual (kg)"
                  type="number"
                  variant="outlined"
                  suffix="kg"
                ></v-text-field>
              </v-col>
              
              <v-col cols="12">
                <v-select
                  v-model="formularioPaciente.activityLevel"
                  :items="nivelesActividad"
                  label="Nivel de Actividad"
                  variant="outlined"
                ></v-select>
              </v-col>
              
              <!-- Información médica -->
              <v-col cols="12">
                <v-divider class="my-4"></v-divider>
                <h3 class="text-h6 mb-3">Información Médica</h3>
              </v-col>
              
              <v-col cols="12">
                <v-textarea
                  v-model="formularioPaciente.medicalConditions"
                  label="Condiciones Médicas"
                  variant="outlined"
                  rows="3"
                  placeholder="Diabetes, hipertensión, etc."
                ></v-textarea>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-textarea
                  v-model="formularioPaciente.allergies"
                  label="Alergias"
                  variant="outlined"
                  rows="3"
                  placeholder="Alergias alimentarias o medicamentosas"
                ></v-textarea>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-textarea
                  v-model="formularioPaciente.dietaryRestrictions"
                  label="Restricciones Dietéticas"
                  variant="outlined"
                  rows="3"
                  placeholder="Vegetariano, vegano, sin gluten, etc."
                ></v-textarea>
              </v-col>
              
              <!-- Contacto de emergencia -->
              <v-col cols="12">
                <v-divider class="my-4"></v-divider>
                <h3 class="text-h6 mb-3">Contacto de Emergencia</h3>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="formularioPaciente.emergencyContactName"
                  label="Nombre del Contacto"
                  variant="outlined"
                ></v-text-field>
              </v-col>
              
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="formularioPaciente.emergencyContactPhone"
                  label="Teléfono de Emergencia"
                  variant="outlined"
                ></v-text-field>
              </v-col>
            </v-row>
          </v-form>
        </v-card-text>
        
        <v-card-actions class="px-6 pb-6">
          <v-spacer></v-spacer>
          <v-btn
            color="grey"
            variant="outlined"
            @click="cerrarDialogoPaciente"
          >
            Cancelar
          </v-btn>
          <v-btn
            color="primary"
            :loading="guardando"
            :disabled="!formularioValido"
            @click="guardarPaciente"
          >
            {{ pacienteEditando ? 'Actualizar' : 'Guardar' }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo de confirmación para eliminar -->
    <v-dialog v-model="dialogoEliminar" max-width="400px">
      <v-card>
        <v-card-title class="bg-error text-white">
          <v-icon class="me-2">mdi-alert-circle</v-icon>
          Confirmar Eliminación
        </v-card-title>
        <v-card-text class="pa-6">
          <p>¿Estás seguro de que deseas eliminar al paciente <strong>{{ pacienteAEliminar?.firstName }} {{ pacienteAEliminar?.lastName }}</strong>?</p>
          <p class="text-caption text-error">Esta acción no se puede deshacer.</p>
        </v-card-text>
        <v-card-actions class="px-6 pb-6">
          <v-spacer></v-spacer>
          <v-btn color="grey" variant="outlined" @click="dialogoEliminar = false">
            Cancelar
          </v-btn>
          <v-btn color="error" :loading="eliminando" @click="eliminarPaciente">
            Eliminar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Snackbar para notificaciones -->
    <v-snackbar
      v-model="snackbar.show"
      :color="snackbar.color"
      :timeout="snackbar.timeout"
    >
      {{ snackbar.text }}
      <template v-slot:actions>
        <v-btn variant="text" @click="snackbar.show = false">
          Cerrar
        </v-btn>
      </template>
    </v-snackbar>
  </v-container>
</template>

<script>
import { ref, reactive, computed, onMounted } from 'vue'
import api from '@/services/api.js'

export default {
  name: 'NutritionistPatientsView',
  setup() {
    // Estado reactivo
    const cargando = ref(false)
    const guardando = ref(false)
    const eliminando = ref(false)
    const pacientes = ref([])
    const busqueda = ref('')
    const filtroGenero = ref('')
    const ordenarPor = ref('nombre')
    
    // Diálogos
    const dialogoPaciente = ref(false)
    const dialogoEliminar = ref(false)
    const pacienteEditando = ref(null)
    const pacienteAEliminar = ref(null)
    
    // Formulario
    const formularioValido = ref(false)
    const formularioPaciente = reactive({
      firstName: '',
      lastName: '',
      dateOfBirth: '',
      gender: '',
      height: '',
      currentWeight: '',
      activityLevel: '',
      medicalConditions: '',
      allergies: '',
      dietaryRestrictions: '',
      emergencyContactName: '',
      emergencyContactPhone: ''
    })
    
    // Snackbar
    const snackbar = reactive({
      show: false,
      text: '',
      color: 'success',
      timeout: 4000
    })

    // Opciones para selects
    const opcionesGenero = [
      { title: 'Todos', value: '' },
      { title: 'Masculino', value: 'M' },
      { title: 'Femenino', value: 'F' }
    ]
    
    const opcionesOrden = [
      { title: 'Nombre', value: 'nombre' },
      { title: 'Fecha de registro', value: 'fecha' },
      { title: 'Edad', value: 'edad' }
    ]
    
    const nivelesActividad = [
      'Sedentario',
      'Ligeramente activo',
      'Moderadamente activo',
      'Muy activo',
      'Extremadamente activo'
    ]

    // Encabezados de la tabla
    const encabezadosTabla = [
      { title: 'Paciente', value: 'nombreCompleto', sortable: false },
      { title: 'Edad', value: 'edad', align: 'center' },
      { title: 'Género', value: 'gender', align: 'center' },
      { title: 'Peso', value: 'currentWeight', align: 'center' },
      { title: 'Acciones', value: 'acciones', sortable: false, align: 'center' }
    ]

    // Reglas de validación
    const reglasNombre = [
      v => !!v || 'El nombre es requerido',
      v => (v && v.length >= 2) || 'El nombre debe tener al menos 2 caracteres'
    ]
    
    const reglasApellido = [
      v => !!v || 'El apellido es requerido',
      v => (v && v.length >= 2) || 'El apellido debe tener al menos 2 caracteres'
    ]

    // Computed properties
    const pacientesFiltrados = computed(() => {
      let resultado = [...pacientes.value]
      
      // Filtro por búsqueda
      if (busqueda.value) {
        const termino = busqueda.value.toLowerCase()
        resultado = resultado.filter(paciente =>
          paciente.firstName.toLowerCase().includes(termino) ||
          paciente.lastName.toLowerCase().includes(termino)
        )
      }
      
      // Filtro por género
      if (filtroGenero.value) {
        resultado = resultado.filter(paciente => paciente.gender === filtroGenero.value)
      }
      
      // Ordenar
      resultado.sort((a, b) => {
        switch (ordenarPor.value) {
          case 'nombre':
            return (a.firstName + ' ' + a.lastName).localeCompare(b.firstName + ' ' + b.lastName)
          case 'fecha':
            return new Date(b.createdAt) - new Date(a.createdAt)
          case 'edad':
            return calcularEdad(a.dateOfBirth) - calcularEdad(b.dateOfBirth)
          default:
            return 0
        }
      })
      
      return resultado
    })

    // Métodos
    const cargarPacientes = async () => {
      cargando.value = true
      try {
        const response = await api.get('/pacientes')
        pacientes.value = response.data
      } catch (error) {
        mostrarError('Error al cargar pacientes: ' + error.message)
      } finally {
        cargando.value = false
      }
    }

    const abrirDialogoNuevoPaciente = () => {
      pacienteEditando.value = null
      limpiarFormulario()
      dialogoPaciente.value = true
    }

    const editarPaciente = (paciente) => {
      pacienteEditando.value = paciente
      Object.assign(formularioPaciente, {
        firstName: paciente.firstName,
        lastName: paciente.lastName,
        dateOfBirth: paciente.dateOfBirth,
        gender: paciente.gender,
        height: paciente.height,
        currentWeight: paciente.currentWeight,
        activityLevel: paciente.activityLevel,
        medicalConditions: paciente.medicalConditions || '',
        allergies: paciente.allergies || '',
        dietaryRestrictions: paciente.dietaryRestrictions || '',
        emergencyContactName: paciente.emergencyContactName || '',
        emergencyContactPhone: paciente.emergencyContactPhone || ''
      })
      dialogoPaciente.value = true
    }

    const guardarPaciente = async () => {
      guardando.value = true
      try {
        if (pacienteEditando.value) {
          // Actualizar paciente existente
          await api.put(`/pacientes/${pacienteEditando.value.id}`, formularioPaciente)
          mostrarExito('Paciente actualizado exitosamente')
        } else {
          // Crear nuevo paciente
          await api.post('/pacientes', formularioPaciente)
          mostrarExito('Paciente creado exitosamente')
        }
        
        cerrarDialogoPaciente()
        await cargarPacientes()
      } catch (error) {
        mostrarError('Error al guardar paciente: ' + error.message)
      } finally {
        guardando.value = false
      }
    }

    const confirmarEliminarPaciente = (paciente) => {
      pacienteAEliminar.value = paciente
      dialogoEliminar.value = true
    }

    const eliminarPaciente = async () => {
      eliminando.value = true
      try {
        await api.delete(`/pacientes/${pacienteAEliminar.value.id}`)
        mostrarExito('Paciente eliminado exitosamente')
        dialogoEliminar.value = false
        await cargarPacientes()
      } catch (error) {
        mostrarError('Error al eliminar paciente: ' + error.message)
      } finally {
        eliminando.value = false
      }
    }

    const cerrarDialogoPaciente = () => {
      dialogoPaciente.value = false
      pacienteEditando.value = null
      limpiarFormulario()
    }

    const limpiarFormulario = () => {
      Object.assign(formularioPaciente, {
        firstName: '',
        lastName: '',
        dateOfBirth: '',
        gender: '',
        height: '',
        currentWeight: '',
        activityLevel: '',
        medicalConditions: '',
        allergies: '',
        dietaryRestrictions: '',
        emergencyContactName: '',
        emergencyContactPhone: ''
      })
    }

    // Métodos auxiliares
    const obtenerIniciales = (nombre, apellido) => {
      return (nombre.charAt(0) + apellido.charAt(0)).toUpperCase()
    }

    const calcularEdad = (fechaNacimiento) => {
      if (!fechaNacimiento) return 0
      const hoy = new Date()
      const nacimiento = new Date(fechaNacimiento)
      let edad = hoy.getFullYear() - nacimiento.getFullYear()
      const mes = hoy.getMonth() - nacimiento.getMonth()
      if (mes < 0 || (mes === 0 && hoy.getDate() < nacimiento.getDate())) {
        edad--
      }
      return edad
    }

    const obtenerColorEdad = (edad) => {
      if (edad < 18) return 'info'
      if (edad < 60) return 'success'
      return 'warning'
    }

    const calcularIMC = (peso, altura) => {
      if (!peso || !altura) return 'N/A'
      const alturaM = altura / 100
      const imc = peso / (alturaM * alturaM)
      return imc.toFixed(1)
    }

    const verDetallePaciente = (paciente) => {
      // TODO: Implementar vista detallada del paciente
      console.log('Ver detalle de:', paciente)
    }

    const agendarCita = (paciente) => {
      // TODO: Redirigir a la vista de agendar cita
      console.log('Agendar cita para:', paciente)
    }

    const filtrarPacientes = () => {
      // Los computed properties se actualizan automáticamente
    }

    const ordenarPacientes = () => {
      // Los computed properties se actualizan automáticamente
    }

    const mostrarExito = (mensaje) => {
      snackbar.text = mensaje
      snackbar.color = 'success'
      snackbar.show = true
    }

    const mostrarError = (mensaje) => {
      snackbar.text = mensaje
      snackbar.color = 'error'
      snackbar.show = true
    }

    // Lifecycle
    onMounted(() => {
      cargarPacientes()
    })

    return {
      // Estado
      cargando,
      guardando,
      eliminando,
      pacientes,
      busqueda,
      filtroGenero,
      ordenarPor,
      dialogoPaciente,
      dialogoEliminar,
      pacienteEditando,
      pacienteAEliminar,
      formularioValido,
      formularioPaciente,
      snackbar,
      
      // Opciones
      opcionesGenero,
      opcionesOrden,
      nivelesActividad,
      encabezadosTabla,
      reglasNombre,
      reglasApellido,
      
      // Computed
      pacientesFiltrados,
      
      // Métodos
      cargarPacientes,
      abrirDialogoNuevoPaciente,
      editarPaciente,
      guardarPaciente,
      confirmarEliminarPaciente,
      eliminarPaciente,
      cerrarDialogoPaciente,
      obtenerIniciales,
      calcularEdad,
      obtenerColorEdad,
      calcularIMC,
      verDetallePaciente,
      agendarCita,
      filtrarPacientes,
      ordenarPacientes
    }
  }
}
</script>

<style scoped>
.v-data-table {
  background-color: transparent;
}

.v-chip {
  font-weight: 500;
}
</style>