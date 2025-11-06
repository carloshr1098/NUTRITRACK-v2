// Versión ultraminimal sin router
import { createApp } from 'vue'

// Componente simple en línea
const SimpleApp = {
  template: `
    <div>
      <h1>NutriTrack está funcionando!</h1>
      <p>Vue.js está cargado correctamente.</p>
      <button @click="counter++">Contador: {{ counter }}</button>
    </div>
  `,
  data() {
    return {
      counter: 0
    }
  }
}

createApp(SimpleApp).mount('#app')