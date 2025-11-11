import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import { mdi } from 'vuetify/iconsets/mdi'
import '@mdi/font/css/materialdesignicons.css'

const lightTheme = {
  dark: false,
  colors: {
    primary: '#8BC34A',      // Verde más cercano a VIBREO110
    secondary: '#5FC3E4',    // Sky Blue
    accent: '#8BC34A',       
    error: '#E74C3C',        // Rojo
    warning: '#FF9800',
    info: '#5FC3E4',         
    success: '#8BC34A',      
    background: '#F5F5F5',
    surface: '#FFFFFF'
  }
}

const darkTheme = {
  dark: true,
  colors: {
    primary: '#8BC34A',
    secondary: '#5FC3E4',
    accent: '#8BC34A',
    error: '#E74C3C',
    warning: '#FFB74D',
    info: '#5FC3E4',
    success: '#8BC34A',
    background: '#1A1A2E',   // Navy oscuro
    surface: '#16213E'
  }
}

export default createVuetify({
  components,
  directives,
  icons: {
    defaultSet: 'mdi',
    sets: {
      mdi,
    }
  },
  theme: {
    defaultTheme: 'lightTheme',
    themes: {
      lightTheme,
      darkTheme
    }
  }
})