<template>
  <v-container fluid>
    <v-card class="mx-auto" max-width="800">
      <v-card-title class="text-h5 bg-green-lighten-1 white--text">
        <v-icon left color="white">mdi-account-circle</v-icon>
        Mi Perfil Profesional
      </v-card-title>

      <v-card-text class="pa-6">
        <v-form ref="form" v-model="valid" lazy-validation>
          <!-- Información Personal -->
          <v-row>
            <v-col cols="12">
              <div class="text-h6 mb-4 text-green-darken-2">
                <v-icon left>mdi-account</v-icon>
                Información Personal
              </div>
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                v-model="perfil.firstName"
                label="Nombre"
                :rules="[rules.required]"
                outlined
                dense
                prepend-inner-icon="mdi-account"
              ></v-text-field>
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                v-model="perfil.lastName"
                label="Apellido"
                :rules="[rules.required]"
                outlined
                dense
                prepend-inner-icon="mdi-account"
              ></v-text-field>
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                v-model="perfil.username"
                label="Usuario"
                outlined
                dense
                disabled
                prepend-inner-icon="mdi-account-circle"
              ></v-text-field>
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                v-model="perfil.email"
                label="Correo Electrónico"
                outlined
                dense
                disabled
                prepend-inner-icon="mdi-email"
              ></v-text-field>
            </v-col>
          </v-row>

          <v-divider class="my-6"></v-divider>

          <!-- Información Profesional -->
          <v-row>
            <v-col cols="12">
              <div class="text-h6 mb-4 text-green-darken-2">
                <v-icon left>mdi-school</v-icon>
                Información Profesional
              </div>
              <v-alert type="info" variant="tonal" density="compact" class="mb-4">
                Esta información aparecerá en los PDFs generados (planes dietéticos y fichas médicas)
              </v-alert>
            </v-col>

            <v-col cols="12">
              <v-select
                v-model="degreeSeleccionado"
                :items="licenciaturas"
                label="Título Profesional"
                outlined
                dense
                prepend-inner-icon="mdi-school"
                hint="Selecciona tu título profesional"
                persistent-hint
                @update:modelValue="onDegreeChange"
              ></v-select>
            </v-col>

            <v-col cols="12" v-if="degreeSeleccionado === 'Otro'">
              <v-text-field
                v-model="perfil.degree"
                label="Especifica tu Título Profesional"
                placeholder="Ej: Lic. en Ciencias de la Salud"
                outlined
                dense
                prepend-inner-icon="mdi-pencil"
                hint="Escribe tu título profesional"
                persistent-hint
              ></v-text-field>
            </v-col>

            <v-col cols="12">
              <v-autocomplete
                v-model="universidadSeleccionada"
                :items="universidades"
                label="Universidad de Egreso"
                outlined
                dense
                prepend-inner-icon="mdi-bank"
                hint="Busca o selecciona tu universidad"
                persistent-hint
                @update:modelValue="onUniversityChange"
              ></v-autocomplete>
            </v-col>

            <v-col cols="12" v-if="universidadSeleccionada === 'Otra'">
              <v-text-field
                v-model="perfil.university"
                label="Especifica tu Universidad"
                placeholder="Ej: Instituto Tecnológico de Estudios Superiores"
                outlined
                dense
                prepend-inner-icon="mdi-pencil"
                hint="Escribe el nombre de tu universidad"
                persistent-hint
              ></v-text-field>
            </v-col>

            <v-col cols="12">
              <v-text-field
                v-model="perfil.professionalLicense"
                label="Cédula Profesional"
                placeholder="Ej: 1234567"
                outlined
                dense
                prepend-inner-icon="mdi-card-account-details"
                hint="Debe tener exactamente 7 dígitos"
                persistent-hint
                :rules="[rules.cedula]"
                type="text"
                inputmode="numeric"
                maxlength="7"
                @input="limitarCedula"
              ></v-text-field>
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                v-model="perfil.phone"
                label="Teléfono"
                placeholder="Ej: 2221234567"
                outlined
                dense
                prepend-inner-icon="mdi-phone"
                hint="Debe tener exactamente 10 dígitos"
                persistent-hint
                :rules="[rules.telefono]"
                type="text"
                inputmode="numeric"
                maxlength="10"
                @input="limitarTelefono"
              ></v-text-field>
            </v-col>

            <v-col cols="12" md="6">
              <v-text-field
                v-model="perfil.address"
                label="Dirección del Consultorio"
                placeholder="Ej: Calle 5 de Mayo #123, Col. Centro"
                outlined
                dense
                prepend-inner-icon="mdi-map-marker"
                hint="Dirección para los PDFs"
                persistent-hint
              ></v-text-field>
            </v-col>
          </v-row>

          <v-divider class="my-6"></v-divider>

          <!-- Vista Previa -->
          <v-row v-if="perfil.degree || perfil.university || perfil.professionalLicense">
            <v-col cols="12">
              <div class="text-h6 mb-4 text-green-darken-2">
                <v-icon left>mdi-file-document</v-icon>
                Vista Previa en PDFs
              </div>
              <v-card variant="outlined" class="pa-4 bg-grey-lighten-4">
                <div class="text-caption text-grey-darken-1 mb-2">Encabezado del documento:</div>
                <div class="font-weight-bold text-body-1">Sistema NutriTrack - Gestión Nutricional</div>
                <div class="text-body-2 mt-1">Plan Dietético Personalizado / Expediente Médico</div>
                <div v-if="perfil.degree" class="text-caption mt-2">{{ perfil.degree }}</div>
                <div v-if="perfil.university || perfil.professionalLicense" class="text-caption">
                  {{ [perfil.university, perfil.professionalLicense ? `Cédula: ${perfil.professionalLicense}` : ''].filter(Boolean).join(' | ') }}
                </div>
              </v-card>
            </v-col>
          </v-row>
        </v-form>
      </v-card-text>

      <v-card-actions class="pa-4">
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          :loading="guardando"
          :disabled="!valid || !cambiosRealizados"
          @click="guardarPerfil"
          size="large"
        >
          <v-icon left>mdi-content-save</v-icon>
          Guardar Cambios
        </v-btn>
      </v-card-actions>
    </v-card>

    <!-- Snackbar para mensajes -->
    <v-snackbar
      v-model="snackbar"
      :color="snackbarColor"
      :timeout="3000"
      top
    >
      {{ snackbarText }}
      <template v-slot:actions>
        <v-btn variant="text" @click="snackbar = false">Cerrar</v-btn>
      </template>
    </v-snackbar>
  </v-container>
</template>

<script>
import api from '@/services/api'
import authService from '@/services/auth'

export default {
  name: 'NutritionistProfileView',
  data() {
    return {
      valid: false,
      guardando: false,
      perfil: {
        username: '',
        email: '',
        firstName: '',
        lastName: '',
        degree: '',
        university: '',
        professionalLicense: '',
        phone: '',
        address: ''
      },
      perfilOriginal: null,
      degreeSeleccionado: '',
      universidadSeleccionada: '',
      licenciaturas: [
        'Lic. en Nutrición',
        'Lic. en Nutrición y Ciencias de los Alimentos',
        'Lic. en Nutrición Clínica',
        'Lic. en Nutrición y Dietética',
        'Lic. en Nutriología',
        'Lic. en Gastronomía y Nutrición',
        'Lic. en Ciencias de la Nutrición Humana',
        'Lic. en Nutrición Deportiva',
        'Maestría en Nutrición Clínica',
        'Maestría en Ciencias de la Nutrición',
        'Otro'
      ],
      universidades: [
        'Universidad Nacional Autónoma de México (UNAM)',
        'Instituto Politécnico Nacional (IPN)',
        'Universidad Autónoma Metropolitana (UAM)',
        'Universidad de Guadalajara (UDG)',
        'Universidad Autónoma de Nuevo León (UANL)',
        'Benemérita Universidad Autónoma de Puebla (BUAP)',
        'Universidad Veracruzana (UV)',
        'Universidad Autónoma de Yucatán (UADY)',
        'Universidad Autónoma de San Luis Potosí (UASLP)',
        'Universidad de Sonora (UNISON)',
        'Instituto Tecnológico y de Estudios Superiores de Monterrey (ITESM)',
        'Universidad Iberoamericana (UIA)',
        'Universidad Anáhuac',
        'Universidad del Valle de México (UVM)',
        'Universidad La Salle',
        'Universidad Panamericana (UP)',
        'Universidad Autónoma de Chihuahua (UACH)',
        'Universidad Autónoma de Coahuila (UAdeC)',
        'Universidad Autónoma de Baja California (UABC)',
        'Universidad Autónoma de Querétaro (UAQ)',
        'Universidad Autónoma del Estado de México (UAEMex)',
        'Universidad Autónoma de Aguascalientes (UAA)',
        'Universidad Michoacana de San Nicolás de Hidalgo (UMSNH)',
        'Universidad Autónoma de Sinaloa (UAS)',
        'Universidad Juárez del Estado de Durango (UJED)',
        'Universidad Autónoma de Zacatecas (UAZ)',
        'Universidad Autónoma de Tamaulipas (UAT)',
        'Universidad Autónoma de Tlaxcala (UATx)',
        'Universidad Autónoma Benito Juárez de Oaxaca (UABJO)',
        'Universidad Autónoma de Guerrero (UAGro)',
        'Universidad Autónoma de Nayarit (UAN)',
        'Universidad Autónoma de Campeche (UACAM)',
        'Universidad Juárez Autónoma de Tabasco (UJAT)',
        'Universidad Autónoma de Chiapas (UNACH)',
        'Universidad de Quintana Roo (UQROO)',
        'Universidad Tecnológica de México (UNITEC)',
        'Universidad del Claustro de Sor Juana',
        'Centro Universitario de Ciencias de la Salud (CUCS)',
        'Escuela Superior de Medicina (ESM-IPN)',
        'Otra'
      ],
      rules: {
        required: value => !!value || 'Campo requerido',
        cedula: value => !value || /^\d{7}$/.test(value) || 'La cédula debe tener exactamente 7 dígitos',
        telefono: value => !value || /^\d{10}$/.test(value) || 'El teléfono debe tener exactamente 10 dígitos'
      },
      snackbar: false,
      snackbarText: '',
      snackbarColor: 'success'
    }
  },
  computed: {
    cambiosRealizados() {
      if (!this.perfilOriginal) return false
      return JSON.stringify(this.perfil) !== JSON.stringify(this.perfilOriginal)
    }
  },
  mounted() {
    this.cargarPerfil()
  },
  methods: {
    cargarPerfil() {
      const user = authService.currentUser.value
      if (user) {
        this.perfil = {
          username: user.username || '',
          email: user.email || '',
          firstName: user.firstName || '',
          lastName: user.lastName || '',
          degree: user.degree || '',
          university: user.university || '',
          professionalLicense: user.professionalLicense || '',
          phone: user.phone || '',
          address: user.address || ''
        }
        
        // Configurar selects basados en datos existentes
        if (this.perfil.degree) {
          const degreeEncontrado = this.licenciaturas.find(lic => lic === this.perfil.degree)
          this.degreeSeleccionado = degreeEncontrado || 'Otro'
        }
        
        if (this.perfil.university) {
          const universityEncontrada = this.universidades.find(uni => uni === this.perfil.university)
          this.universidadSeleccionada = universityEncontrada || 'Otra'
        }
        
        this.perfilOriginal = JSON.parse(JSON.stringify(this.perfil))
      }
    },
    onDegreeChange(value) {
      if (value && value !== 'Otro') {
        this.perfil.degree = value
      } else if (value !== 'Otro') {
        this.perfil.degree = ''
      }
    },
    onUniversityChange(value) {
      if (value && value !== 'Otra') {
        this.perfil.university = value
      } else if (value !== 'Otra') {
        this.perfil.university = ''
      }
    },
    limitarCedula(event) {
      // Bloquear caracteres no numéricos y limitar a 7 dígitos
      this.perfil.professionalLicense = this.perfil.professionalLicense.replace(/\D/g, '').slice(0, 7)
    },
    limitarTelefono(event) {
      // Bloquear caracteres no numéricos y limitar a 10 dígitos
      this.perfil.phone = this.perfil.phone.replace(/\D/g, '').slice(0, 10)
    },
    async guardarPerfil() {
      if (!this.$refs.form.validate()) return

      this.guardando = true
      try {
        console.log('💾 Guardando perfil...')
        console.log('🔑 Token en localStorage:', localStorage.getItem('token') ? 'SÍ' : 'NO')
        
        const response = await api.put('/auth/profile', {
          firstName: this.perfil.firstName,
          lastName: this.perfil.lastName,
          degree: this.perfil.degree,
          university: this.perfil.university,
          professionalLicense: this.perfil.professionalLicense,
          phone: this.perfil.phone,
          address: this.perfil.address
        })

        // Actualizar el usuario en localStorage y en authService
        const userData = response.data
        const token = localStorage.getItem('token')
        
        // Crear objeto de usuario actualizado
        const updatedUser = {
          id: userData.id,
          username: userData.username,
          email: userData.email,
          firstName: userData.firstName,
          lastName: userData.lastName,
          degree: userData.degree,
          university: userData.university,
          professionalLicense: userData.professionalLicense,
          phone: userData.phone,
          address: userData.address,
          roles: userData.roles
        }

        // Actualizar en localStorage y authService
        localStorage.setItem('user', JSON.stringify(updatedUser))
        authService.currentUser.value = updatedUser

        // Actualizar el perfil original para el tracking de cambios
        this.perfilOriginal = JSON.parse(JSON.stringify(this.perfil))

        this.mostrarMensaje('Perfil actualizado correctamente', 'success')
      } catch (error) {
        console.error('Error al guardar perfil:', error)
        this.mostrarMensaje('Error al guardar el perfil', 'error')
      } finally {
        this.guardando = false
      }
    },
    mostrarMensaje(texto, color) {
      this.snackbarText = texto
      this.snackbarColor = color
      this.snackbar = true
    }
  }
}
</script>

<style scoped>
.v-card-title {
  font-weight: 600;
}
</style>
