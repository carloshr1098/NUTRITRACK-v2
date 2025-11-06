<template>
  <div style="max-width: 400px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
    <h1 style="text-align: center; color: #2c3e50;">NutriTrack</h1>
    <p style="text-align: center; color: #666; margin-bottom: 30px;">Sistema de Gestión Nutricional</p>
    
    <div v-if="error" style="background: #f8d7da; color: #721c24; padding: 10px; border-radius: 4px; margin-bottom: 15px;">
      {{ error }}
    </div>
    
    <form @submit.prevent="login" style="display: flex; flex-direction: column; gap: 15px;">
      <div>
        <label style="display: block; margin-bottom: 5px; font-weight: bold;">Usuario:</label>
        <input 
          type="text" 
          v-model="form.username" 
          required
          style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;"
        />
      </div>
      
      <div>
        <label style="display: block; margin-bottom: 5px; font-weight: bold;">Contraseña:</label>
        <input 
          type="password" 
          v-model="form.password" 
          required
          style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;"
        />
      </div>
      
      <button 
        type="submit" 
        :disabled="loading"
        style="padding: 12px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px;"
      >
        {{ loading ? 'Iniciando sesión...' : 'Iniciar Sesión' }}
      </button>
    </form>
    
    <div style="margin-top: 20px; padding: 15px; background: #e8f4f8; border-radius: 4px;">
      <h4 style="margin: 0 0 10px 0;">Usuarios de prueba:</h4>
      <p style="margin: 5px 0;"><strong>Nutriólogo:</strong> nutriologo / 123456</p>
      <p style="margin: 5px 0;"><strong>Paciente:</strong> paciente / 123456</p>
      <p style="margin: 5px 0;"><strong>Admin:</strong> admin / 123456</p>
    </div>
  </div>
</template>

<script>
import authService from '../services/auth.js'

export default {
  name: 'LoginView',
  data() {
    return {
      form: {
        username: '',
        password: ''
      },
      loading: false,
      error: null
    }
  },
  methods: {
    async login() {
      if (this.loading) return
      
      this.loading = true
      this.error = null
      
      try {
        const response = await authService.login(this.form.username, this.form.password)
        
        if (response && response.token) {
          authService.saveToken(response.token)
          authService.saveUser(response)
          this.$router.push('/dashboard')
        } else {
          this.error = 'Credenciales inválidas'
        }
      } catch (error) {
        console.error('Error en login:', error)
        this.error = error.message || 'Error al iniciar sesión'
      } finally {
        this.loading = false
      }
    }
  }
}
</script>