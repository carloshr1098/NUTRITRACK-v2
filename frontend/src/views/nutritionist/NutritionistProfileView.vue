<template>
  <div class="profile-container">
    <!-- Header elegante -->
    <div class="profile-header">
      <div class="header-content">
        <div class="header-icon">👤</div>
        <div class="header-text">
          <h1 class="header-title">Mi Perfil Profesional</h1>
          <p class="header-subtitle">Actualiza tu información personal y profesional</p>
        </div>
      </div>
    </div>

  <v-container fluid class="profile-content">
    <v-card class="mx-auto modern-card profile-card" max-width="900">
      <v-card-text class="pa-6">
        <v-form ref="form" v-model="valid" lazy-validation>
          <!-- Información Personal -->
          <v-row>
            <v-col cols="12">
              <div class="section-title">
                <div class="section-icon">📋</div>
                <span>Información Personal</span>
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
              <div class="section-title">
                <div class="section-icon">🎓</div>
                <span>Información Profesional</span>
              </div>
              <v-alert type="info" variant="tonal" density="compact" class="mb-4 info-alert">
                💡 Esta información aparecerá en los PDFs generados (planes dietéticos y fichas médicas)
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
              <div class="section-title">
                <div class="section-icon">📄</div>
                <span>Vista Previa en PDFs</span>
              </div>
              <v-card variant="outlined" class="pa-4 preview-card">
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

      <v-card-actions class="pa-4 actions-bar">
        <v-spacer></v-spacer>
        <v-btn
          color="primary"
          :loading="guardando"
          :disabled="!valid || !cambiosRealizados"
          @click="guardarPerfil"
          size="large"
          class="btn-save">
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

  <!-- Botón de volver -->
  <div class="back-button-container">
    <router-link to="/nutritionist/dashboard" class="btn-back">
      <span class="btn-icon">←</span>
      Volver al Dashboard
    </router-link>
  </div>
  </div>
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
/* Container principal */
.profile-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f8fafb 0%, #e8f4f8 100%);
  position: relative;
  padding-bottom: 60px;
}

.profile-container::before {
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

.profile-content {
  position: relative;
  z-index: 1;
  padding-top: 30px;
}

/* Header elegante */
.profile-header {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%);
  padding: 40px 30px;
  box-shadow: 0 8px 32px rgba(139, 195, 74, 0.3);
  position: relative;
  overflow: hidden;
  z-index: 1;
}

.profile-header::before {
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
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0px); }
  50% { transform: translateY(-10px); }
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

/* Card moderna */
.modern-card {
  border-radius: 20px !important;
  overflow: hidden;
  transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  border-left: 5px solid #8bc34a;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1) !important;
}

.profile-card {
  margin-top: 20px;
}

/* Títulos de sección */
.section-title {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 1.3rem;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 3px solid #8bc34a;
}

.section-icon {
  font-size: 1.8rem;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

/* Alerta de información */
.info-alert {
  border-radius: 12px !important;
  border-left: 4px solid #5fc2c6 !important;
  background: linear-gradient(90deg, rgba(95, 194, 198, 0.1) 0%, transparent 100%) !important;
}

/* Card de vista previa */
.preview-card {
  border-radius: 16px !important;
  background: linear-gradient(135deg, #f8fafb 0%, #e8f4f8 100%) !important;
  border: 2px solid #8bc34a !important;
  box-shadow: 0 4px 12px rgba(139, 195, 74, 0.15) !important;
}

/* Barra de acciones */
.actions-bar {
  background: linear-gradient(180deg, transparent 0%, rgba(139, 195, 74, 0.03) 100%);
  border-top: 2px solid rgba(139, 195, 74, 0.2);
}

/* Botón de guardar */
.btn-save {
  background: linear-gradient(135deg, #8bc34a 0%, #7ab73f 100%) !important;
  color: white !important;
  font-weight: 700 !important;
  padding: 12px 40px !important;
  border-radius: 12px !important;
  transition: all 0.3s ease !important;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.btn-save:hover {
  background: linear-gradient(135deg, #7ab73f 0%, #689f38 100%) !important;
  transform: translateY(-2px);
  box-shadow: 0 8px 25px rgba(139, 195, 74, 0.4) !important;
}

.btn-save:disabled {
  opacity: 0.5;
  transform: none !important;
}

/* Campos de formulario */
:deep(.v-field) {
  border-radius: 12px !important;
  transition: all 0.2s ease;
}

:deep(.v-field:hover) {
  background: rgba(139, 195, 74, 0.05);
}

:deep(.v-field--focused) {
  border-color: #8bc34a !important;
}

:deep(.v-text-field input) {
  font-weight: 500;
}

/* Dividers */
:deep(.v-divider) {
  border-color: rgba(139, 195, 74, 0.2);
  border-width: 2px;
  margin: 30px 0 !important;
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

/* Responsive */
@media (max-width: 768px) {
  .profile-header {
    padding: 30px 20px;
  }
  
  .header-content {
    flex-direction: column;
    text-align: center;
  }
  
  .header-title {
    font-size: 2rem;
  }
  
  .header-icon {
    font-size: 3rem;
  }
  
  .section-title {
    font-size: 1.1rem;
  }
}
</style>
