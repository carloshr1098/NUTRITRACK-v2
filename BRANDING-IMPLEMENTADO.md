# 🎨 Guía de Implementación de Branding NutriTrack

## ✅ Cambios Implementados

### 1. Paleta de Colores Integrada

Se han actualizado todos los componentes para usar la paleta oficial de NutriTrack:

**Colores Principales:**
- **Verde Vibrante (#2A071FF)**: Color primario, usado en botones principales y logos
- **Sky Blue (#FF01FF)**: Color secundario, usado en acentos y hover states
- **Verde Claro (#B8D438)**: Color de acento, usado en cards y highlights
- **Navy (#7A7A5A)**: Color neutro oscuro, usado en texto y fondos
- **Rojo (#FF0000)**: Color de error y alertas

**Archivos Modificados:**
- ✅ `frontend/src/assets/main.css` - Variables CSS globales
- ✅ `frontend/src/plugins/vuetify.js` - Temas light y dark
- ✅ `frontend/src/views/nutritionist/NutritionistDashboardView.vue` - Colores de KPIs y acciones rápidas

### 2. Navbar con Logo

Se creó un componente de navegación profesional:

**Características:**
- Logo de NutriTrack (o ícono placeholder si no existe la imagen)
- Texto de marca con gradiente de colores oficial
- Menú de usuario con avatar
- Navegación responsive (desktop y mobile)
- Menús dinámicos según rol (Nutricionista/Paciente)

**Archivo Creado:**
- ✅ `frontend/src/components/NavBar.vue`

### 3. App.vue Actualizado

El archivo principal ahora usa:
- Estructura v-app de Vuetify
- NavBar integrado (oculto en login)
- Contenedor fluid responsive

**Archivo Actualizado:**
- ✅ `frontend/src/App.vue`

---

## 📋 Para Completar la Integración del Logo

### Paso 1: Agregar el Logo

1. Guarda tu logo de NutriTrack como PNG con transparencia
2. Colócalo en: `frontend/public/logo/nutritrack-logo.png`
3. Dimensiones recomendadas: 200x200px

### Paso 2: Logo Alternativo para Favicon

1. Crea una versión de 32x32px del ícono (solo la gota)
2. Colócalo en: `frontend/public/favicon.ico`

### Paso 3: Configurar index.html

Actualiza el `<head>` del archivo `frontend/index.html`:

```html
<head>
  <meta charset="UTF-8">
  <link rel="icon" type="image/png" href="/logo/nutritrack-logo.png">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>NutriTrack - Monitoreo Nutricional</title>
  <meta name="description" content="Sistema de monitoreo nutricional profesional">
</head>
```

---

## 🎨 Uso de Colores en Componentes

### En Templates de Vue

```vue
<!-- Usando colores directos -->
<v-btn color="#2A071FF">Botón Verde</v-btn>
<v-btn color="#FF01FF">Botón Sky Blue</v-btn>

<!-- Usando clases de Vuetify (configuradas en plugins/vuetify.js) -->
<v-btn color="primary">Primario (Verde)</v-btn>
<v-btn color="secondary">Secundario (Sky Blue)</v-btn>
<v-btn color="accent">Acento (Verde Claro)</v-btn>
<v-btn color="error">Error (Rojo)</v-btn>
```

### En CSS

```css
/* Usando variables CSS */
.mi-componente {
  color: var(--nutritrack-green);
  background: var(--nutritrack-sky-blue);
  border-color: var(--nutritrack-navy);
}

/* Gradiente de marca */
.brand-gradient {
  background: linear-gradient(135deg, #2A071FF 0%, #FF01FF 50%, #B8D438 100%);
}
```

---

## 🔧 Personalización Adicional

### Cambiar Colores del Dashboard

Edita `NutritionistDashboardView.vue`:

```javascript
kpiCards: [
  { titulo: 'Pacientes Activos', color: '#2A071FF' },  // Verde
  { titulo: 'Citas del Día', color: '#FF01FF' },       // Sky Blue
  { titulo: 'Planes Activos', color: '#B8D438' },      // Verde Claro
  { titulo: 'Progreso', color: '#7A7A5A' }             // Navy
]
```

### Personalizar el Navbar

Edita `NavBar.vue` para:
- Cambiar altura: `height="70"`
- Modificar el gradiente del borde
- Ajustar tamaño del logo
- Cambiar posición de elementos

---

## 🚀 Próximas Mejoras Estéticas

1. **Dark Mode Toggle**
   - Botón en el navbar para cambiar tema
   - Persistencia en localStorage
   - Transiciones suaves

2. **Animaciones**
   - Page transitions con vue-router
   - Skeleton loaders
   - Micro-interacciones en botones

3. **Landing Page**
   - Hero section con logo grande
   - Características del sistema
   - CTA para login/registro

4. **Mejoras de Perfil**
   - Avatar upload
   - Banner personalizado
   - Badges de logros

---

## 📱 Responsive Design

El sistema ahora es completamente responsive:

- **Desktop (>960px)**: Navbar completo con menú horizontal
- **Tablet (600-960px)**: Navbar simplificado
- **Mobile (<600px)**: Menú hamburguesa con drawer lateral

---

## ✨ Resultado Final

Con estos cambios, NutriTrack ahora tiene:
- ✅ Identidad visual consistente
- ✅ Paleta de colores unificada
- ✅ Navegación profesional
- ✅ Logo integrado en toda la app
- ✅ Diseño responsive
- ✅ Preparado para dark mode

**Para ver los cambios:** Inicia sesión en el sistema y navega por las diferentes secciones.
