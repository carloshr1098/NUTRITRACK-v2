import axios from 'axios'

// Usar variable de entorno para producción, localhost para desarrollo
const API_BASE_URL = import.meta.env.VITE_API_URL 
  ? `${import.meta.env.VITE_API_URL}/api` 
  : 'http://localhost:8080/api'

console.log('🌐 API URL:', API_BASE_URL)

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    } else {
      console.warn('⚠️ No hay token en localStorage para:', config.method?.toUpperCase(), config.url)
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Response interceptor to handle errors
api.interceptors.response.use(
  (response) => {
    return response
  },
  (error) => {
    // Solo loguear el error, no redirigir automáticamente
    if (error.response?.status === 401) {
      console.error('❌ Error 401 - No autorizado:', error.config?.url)
    }
    return Promise.reject(error)
  }
)

export default api