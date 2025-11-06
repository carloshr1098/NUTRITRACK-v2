<template>
  <v-container fluid fill-height class="login-container">
    <v-row align="center" justify="center">
      <v-col cols="12" sm="8" md="6" lg="4">
        <v-card class="elevation-12" rounded="lg">
          <v-card-title class="text-center pa-6">
            <div class="d-flex flex-column align-center">
              <v-icon size="64" color="primary" class="mb-4">
                mdi-food-apple
              </v-icon>
              <h2 class="text-h4 font-weight-bold text-primary">
                NutriTrack
              </h2>
              <p class="text-subtitle-1 text-medium-emphasis mt-2">
                Sistema de Gestión Nutricional
              </p>
            </div>
          </v-card-title>

          <v-card-text class="pa-6">
            <v-form v-model="valid" @submit.prevent="handleLogin">
              <v-text-field
                v-model="form.username"
                :rules="usernameRules"
                label="Usuario o Email"
                prepend-inner-icon="mdi-account"
                variant="outlined"
                :loading="loading"
                :disabled="loading"
                class="mb-4"
              ></v-text-field>

              <v-text-field
                v-model="form.password"
                :rules="passwordRules"
                label="Contraseña"
                prepend-inner-icon="mdi-lock"
                :type="showPassword ? 'text' : 'password'"
                :append-inner-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                @click:append-inner="showPassword = !showPassword"
                variant="outlined"
                :loading="loading"
                :disabled="loading"
                class="mb-4"
              ></v-text-field>

              <v-alert
                v-if="errorMessage"
                type="error"
                variant="tonal"
                class="mb-4"
                closable
                @click:close="errorMessage = ''"
              >
                {{ errorMessage }}
              </v-alert>

              <v-btn
                type="submit"
                color="primary"
                size="large"
                block
                :loading="loading"
                :disabled="!valid || loading"
                class="mb-4"
              >
                Iniciar Sesión
              </v-btn>
            </v-form>

            <v-divider class="my-4"></v-divider>

            <div class="text-center">
              <p class="text-body-2 text-medium-emphasis mb-2">
                ¿No tienes una cuenta?
              </p>
              <v-btn
                variant="outlined"
                color="primary"
                @click="showRegisterDialog = true"
                :disabled="loading"
              >
                Registrarse
              </v-btn>
            </div>
          </v-card-text>
        </v-card>

        <!-- Demo credentials info -->
        <v-card class="mt-4" variant="outlined">
          <v-card-title class="text-body-1">
            <v-icon start>mdi-information</v-icon>
            Credenciales de Demostración
          </v-card-title>
          <v-card-text class="pt-2">
            <v-list dense>
              <v-list-item class="px-0">
                <strong>Admin:</strong> admin / admin123
              </v-list-item>
              <v-list-item class="px-0">
                <strong>Nutricionista:</strong> nutricionista / nutri123
              </v-list-item>
              <v-list-item class="px-0">
                <strong>Paciente:</strong> paciente / paciente123
              </v-list-item>
            </v-list>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Register Dialog -->
    <v-dialog v-model="showRegisterDialog" max-width="600">
      <v-card>
        <v-card-title>
          Registro de Usuario
        </v-card-title>
        <v-card-text>
          <v-form v-model="registerValid">
            <v-row>
              <v-col cols="6">
                <v-text-field
                  v-model="registerForm.firstName"
                  label="Nombres"
                  variant="outlined"
                  :rules="[v => !!v || 'Nombres son requeridos']"
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  v-model="registerForm.lastName"
                  label="Apellidos"
                  variant="outlined"
                  :rules="[v => !!v || 'Apellidos son requeridos']"
                ></v-text-field>
              </v-col>
            </v-row>

            <v-text-field
              v-model="registerForm.username"
              label="Nombre de Usuario"
              variant="outlined"
              :rules="usernameRules"
            ></v-text-field>

            <v-text-field
              v-model="registerForm.email"
              label="Email"
              type="email"
              variant="outlined"
              :rules="emailRules"
            ></v-text-field>

            <v-text-field
              v-model="registerForm.password"
              label="Contraseña"
              type="password"
              variant="outlined"
              :rules="passwordRules"
            ></v-text-field>

            <v-select
              v-model="registerForm.role"
              :items="roleOptions"
              label="Tipo de Usuario"
              variant="outlined"
              :rules="[v => !!v || 'Debe seleccionar un rol']"
            ></v-select>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            text
            @click="showRegisterDialog = false"
          >
            Cancelar
          </v-btn>
          <v-btn
            color="primary"
            :loading="registerLoading"
            :disabled="!registerValid"
            @click="handleRegister"
          >
            Registrarse
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import authService from '../services/auth.js'

export default {
  name: 'LoginView',
  setup() {
    const router = useRouter()
    
    const valid = ref(false)
    const registerValid = ref(false)
    const loading = ref(false)
    const registerLoading = ref(false)
    const showPassword = ref(false)
    const errorMessage = ref('')
    const showRegisterDialog = ref(false)
    
    const form = reactive({
      username: '',
      password: ''
    })

    const registerForm = reactive({
      username: '',
      email: '',
      password: '',
      firstName: '',
      lastName: '',
      role: 'ROLE_PATIENT'
    })

    const roleOptions = [
      { title: 'Paciente', value: 'ROLE_PATIENT' },
      { title: 'Nutricionista', value: 'ROLE_NUTRITIONIST' },
      { title: 'Administrador', value: 'ROLE_ADMIN' }
    ]

    const usernameRules = [
      v => !!v || 'Usuario es requerido',
      v => v.length >= 3 || 'Usuario debe tener al menos 3 caracteres'
    ]

    const passwordRules = [
      v => !!v || 'Contraseña es requerida',
      v => v.length >= 6 || 'Contraseña debe tener al menos 6 caracteres'
    ]

    const emailRules = [
      v => !!v || 'Email es requerido',
      v => /.+@.+\..+/.test(v) || 'Email debe ser válido'
    ]

    const handleLogin = async () => {
      if (!valid.value) return

      loading.value = true
      errorMessage.value = ''

      try {
        await authService.login(form)
        router.push('/')
      } catch (error) {
        console.error('Login error:', error)
        errorMessage.value = error.response?.data?.message || 'Error de autenticación'
      } finally {
        loading.value = false
      }
    }

    const handleRegister = async () => {
      if (!registerValid.value) return

      registerLoading.value = true

      try {
        await authService.register({
          ...registerForm,
          roles: [registerForm.role]
        })
        
        showRegisterDialog.value = false
        // Auto login after registration
        await handleLogin()
      } catch (error) {
        console.error('Register error:', error)
        errorMessage.value = error.response?.data?.message || 'Error en el registro'
      } finally {
        registerLoading.value = false
      }
    }

    return {
      valid,
      registerValid,
      loading,
      registerLoading,
      showPassword,
      errorMessage,
      showRegisterDialog,
      form,
      registerForm,
      roleOptions,
      usernameRules,
      passwordRules,
      emailRules,
      handleLogin,
      handleRegister
    }
  }
}
</script>

<style scoped>
.login-container {
  background: linear-gradient(135deg, #e8f5e8 0%, #f1f8e9 100%);
  min-height: 100vh;
}

.v-card {
  backdrop-filter: blur(10px);
}
</style>