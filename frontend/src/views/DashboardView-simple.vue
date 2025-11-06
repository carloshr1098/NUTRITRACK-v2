<template>
  <div style="padding: 20px; max-width: 1200px; margin: 0 auto;">
    <h1 style="color: #2c3e50; margin-bottom: 20px;">Dashboard - NutriTrack</h1>
    
    <div v-if="user" style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 30px;">
      <h2 style="margin: 0 0 10px 0;">Bienvenido, {{ user.username }}</h2>
      <p style="margin: 0; color: #666;">Rol: {{ user.roles ? user.roles.join(', ') : 'N/A' }}</p>
    </div>
    
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px;">
      
      <!-- Card para Pacientes -->
      <div style="border: 1px solid #ddd; border-radius: 8px; padding: 20px; background: white;">
        <h3 style="color: #007bff; margin: 0 0 15px 0;">📋 Gestión de Pacientes</h3>
        <p style="color: #666; margin-bottom: 15px;">Administrar información de pacientes</p>
        <router-link 
          to="/nutritionist/patients" 
          style="display: inline-block; padding: 10px 20px; background: #007bff; color: white; text-decoration: none; border-radius: 4px;"
        >
          Ver Pacientes
        </router-link>
      </div>
      
      <!-- Card para Citas -->
      <div style="border: 1px solid #ddd; border-radius: 8px; padding: 20px; background: white;">
        <h3 style="color: #28a745; margin: 0 0 15px 0;">📅 Gestión de Citas</h3>
        <p style="color: #666; margin-bottom: 15px;">Programar y gestionar citas</p>
        <router-link 
          to="/nutritionist/appointments" 
          style="display: inline-block; padding: 10px 20px; background: #28a745; color: white; text-decoration: none; border-radius: 4px;"
        >
          Ver Citas
        </router-link>
      </div>
      
      <!-- Card para Planes Dietéticos -->
      <div style="border: 1px solid #ddd; border-radius: 8px; padding: 20px; background: white;">
        <h3 style="color: #ffc107; margin: 0 0 15px 0;">🍎 Planes Dietéticos</h3>
        <p style="color: #666; margin-bottom: 15px;">Crear y administrar dietas</p>
        <router-link 
          to="/nutritionist/diet-plans" 
          style="display: inline-block; padding: 10px 20px; background: #ffc107; color: #212529; text-decoration: none; border-radius: 4px;"
        >
          Ver Planes
        </router-link>
      </div>
      
    </div>
    
    <div style="margin-top: 30px; text-align: center;">
      <button 
        @click="logout" 
        style="padding: 10px 30px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px;"
      >
        Cerrar Sesión
      </button>
    </div>
  </div>
</template>

<script>
import authService from '../services/auth.js'

export default {
  name: 'DashboardView',
  data() {
    return {
      user: null
    }
  },
  mounted() {
    this.user = authService.getUser()
    if (!this.user) {
      this.$router.push('/login')
    }
  },
  methods: {
    logout() {
      authService.logout()
      this.$router.push('/login')
    }
  }
}
</script>