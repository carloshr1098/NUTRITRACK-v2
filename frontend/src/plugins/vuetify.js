import 'vuetify/styles'
import { createVuetify } from 'vuetify'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import { mdi } from 'vuetify/iconsets/mdi'
import '@mdi/font/css/materialdesignicons.css'

const lightTheme = {
  dark: false,
  colors: {
    primary: '#2E7D32',
    secondary: '#388E3C',
    accent: '#4CAF50',
    error: '#F44336',
    warning: '#FF9800',
    info: '#2196F3',
    success: '#4CAF50',
    background: '#F5F5F5',
    surface: '#FFFFFF'
  }
}

const darkTheme = {
  dark: true,
  colors: {
    primary: '#4CAF50',
    secondary: '#66BB6A',
    accent: '#81C784',
    error: '#CF6679',
    warning: '#FFB74D',
    info: '#64B5F6',
    success: '#81C784',
    background: '#121212',
    surface: '#1E1E1E'
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