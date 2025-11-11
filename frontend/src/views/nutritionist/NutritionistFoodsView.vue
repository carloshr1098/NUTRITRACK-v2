<template>
  <v-container fluid>
    <!-- Header con título y botón agregar -->
    <v-row class="mb-4">
      <v-col cols="12" md="8">
        <h1 class="text-h4 font-weight-bold">
          <v-icon color="primary" size="large" class="mr-2">mdi-database</v-icon>
          Base de Datos de Alimentos
        </h1>
        <p class="text-subtitle-1 text-grey">
          Gestiona tu colección personal de alimentos y valores nutricionales
        </p>
      </v-col>
      <v-col cols="12" md="4" class="text-right">
        <v-btn
          color="primary"
          size="large"
          prepend-icon="mdi-plus"
          @click="abrirDialogoNuevoAlimento"
        >
          Agregar Alimento
        </v-btn>
      </v-col>
    </v-row>

    <!-- Estadísticas -->
    <v-row class="mb-4">
      <v-col cols="12" md="3" sm="6">
        <v-card color="primary" variant="tonal">
          <v-card-text>
            <div class="text-h4 font-weight-bold">{{ totalAlimentos }}</div>
            <div class="text-subtitle-2">Total de Alimentos</div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="3" sm="6">
        <v-card color="success" variant="tonal">
          <v-card-text>
            <div class="text-h4 font-weight-bold">{{ totalCategorias }}</div>
            <div class="text-subtitle-2">Categorías</div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="3" sm="6">
        <v-card color="info" variant="tonal">
          <v-card-text>
            <div class="text-h4 font-weight-bold">{{ alimentosMasUsados }}</div>
            <div class="text-subtitle-2">Más Usados</div>
          </v-card-text>
        </v-card>
      </v-col>
      <v-col cols="12" md="3" sm="6">
        <v-card color="warning" variant="tonal">
          <v-card-text>
            <div class="text-h4 font-weight-bold">{{ alimentosRecientes }}</div>
            <div class="text-subtitle-2">Agregados Hoy</div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- Búsqueda y filtros -->
    <v-card class="mb-4">
      <v-card-text>
        <v-row>
          <v-col cols="12" md="6">
            <v-text-field
              v-model="busqueda"
              prepend-inner-icon="mdi-magnify"
              label="Buscar alimento"
              placeholder="Busca por nombre o categoría"
              variant="outlined"
              clearable
              hide-details
              @input="buscarAlimentos"
            ></v-text-field>
          </v-col>
          <v-col cols="12" md="4">
            <v-select
              v-model="categoriaFiltro"
              :items="['Todas', ...categorias]"
              label="Filtrar por categoría"
              prepend-inner-icon="mdi-filter"
              variant="outlined"
              hide-details
              @update:model-value="filtrarPorCategoria"
            ></v-select>
          </v-col>
          <v-col cols="12" md="2">
            <v-select
              v-model="ordenamiento"
              :items="opcionesOrden"
              label="Ordenar por"
              variant="outlined"
              hide-details
              @update:model-value="ordenarAlimentos"
            ></v-select>
          </v-col>
        </v-row>
      </v-card-text>
    </v-card>

    <!-- Chips de categorías -->
    <div class="mb-4">
      <v-chip-group v-model="categoriaSeleccionada" column>
        <v-chip
          filter
          variant="outlined"
          @click="categoriaFiltro = 'Todas'; filtrarPorCategoria()"
        >
          <v-icon start>mdi-all-inclusive</v-icon>
          Todas
        </v-chip>
        <v-chip
          v-for="categoria in categorias"
          :key="categoria"
          filter
          variant="outlined"
          @click="categoriaFiltro = categoria; filtrarPorCategoria()"
        >
          <v-icon start>{{ getIconoCategoria(categoria) }}</v-icon>
          {{ categoria }}
        </v-chip>
      </v-chip-group>
    </div>

    <!-- Tabla de alimentos -->
    <v-card>
      <v-card-text>
        <v-data-table
          :headers="headers"
          :items="alimentosFiltrados"
          :loading="cargando"
          :search="busqueda"
          items-per-page="10"
          class="elevation-0"
        >
          <template v-slot:item.name="{ item }">
            <div class="d-flex align-center">
              <v-avatar color="primary" size="32" class="mr-3">
                <v-icon size="small">mdi-food</v-icon>
              </v-avatar>
              <div>
                <div class="font-weight-medium">{{ item.name }}</div>
                <div class="text-caption text-grey">{{ item.servingSize }}</div>
              </div>
            </div>
          </template>

          <template v-slot:item.category="{ item }">
            <v-chip size="small" color="primary" variant="tonal">
              <v-icon start size="small">{{ getIconoCategoria(item.category) }}</v-icon>
              {{ item.category }}
            </v-chip>
          </template>

          <template v-slot:item.calories="{ item }">
            <div class="text-center">
              <div class="font-weight-bold">{{ item.calories }}</div>
              <div class="text-caption">kcal</div>
            </div>
          </template>

          <template v-slot:item.proteinGrams="{ item }">
            <div class="text-center">{{ item.proteinGrams }}g</div>
          </template>

          <template v-slot:item.carbsGrams="{ item }">
            <div class="text-center">{{ item.carbsGrams }}g</div>
          </template>

          <template v-slot:item.fatGrams="{ item }">
            <div class="text-center">{{ item.fatGrams }}g</div>
          </template>

          <template v-slot:item.actions="{ item }">
            <v-btn
              icon="mdi-eye"
              size="small"
              variant="text"
              @click="verDetalles(item)"
            ></v-btn>
            <v-btn
              icon="mdi-pencil"
              size="small"
              variant="text"
              color="primary"
              @click="editarAlimento(item)"
            ></v-btn>
            <v-btn
              icon="mdi-delete"
              size="small"
              variant="text"
              color="error"
              @click="eliminarAlimento(item)"
            ></v-btn>
          </template>

          <template v-slot:loading>
            <v-skeleton-loader type="table-row@5"></v-skeleton-loader>
          </template>

          <template v-slot:no-data>
            <div class="text-center py-8">
              <v-icon size="64" color="grey">mdi-food-off</v-icon>
              <div class="text-h6 mt-4">No hay alimentos registrados</div>
              <div class="text-caption text-grey">Agrega tu primer alimento para comenzar</div>
            </div>
          </template>
        </v-data-table>
      </v-card-text>
    </v-card>

    <!-- Diálogo para agregar/editar alimento -->
    <v-dialog v-model="dialogoAlimento" max-width="800" persistent>
      <v-card>
        <v-card-title class="text-h5 bg-primary">
          <v-icon class="mr-2">{{ alimentoEditando ? 'mdi-pencil' : 'mdi-plus' }}</v-icon>
          {{ alimentoEditando ? 'Editar Alimento' : 'Nuevo Alimento' }}
        </v-card-title>

        <v-card-text class="pt-6">
          <v-form ref="formulario">
            <v-row>
              <!-- Información básica -->
              <v-col cols="12" md="6">
                <v-text-field
                  v-model="nuevoAlimento.name"
                  label="Nombre del Alimento *"
                  prepend-icon="mdi-food"
                  :rules="[v => !!v || 'El nombre es requerido']"
                  variant="outlined"
                  required
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-select
                  v-model="nuevoAlimento.category"
                  :items="categorias"
                  label="Categoría *"
                  prepend-icon="mdi-tag"
                  :rules="[v => !!v || 'La categoría es requerida']"
                  variant="outlined"
                  required
                >
                  <template v-slot:item="{ props, item }">
                    <v-list-item v-bind="props">
                      <template v-slot:prepend>
                        <v-icon>{{ getIconoCategoria(item.value) }}</v-icon>
                      </template>
                    </v-list-item>
                  </template>
                </v-select>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model="nuevoAlimento.servingSize"
                  label="Tamaño de Porción *"
                  prepend-icon="mdi-scale"
                  placeholder="Ej: 100g, 1 taza, 1 pieza"
                  :rules="[v => !!v || 'La porción es requerida']"
                  variant="outlined"
                  required
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="6">
                <v-text-field
                  v-model.number="nuevoAlimento.calories"
                  label="Calorías (kcal) *"
                  prepend-icon="mdi-fire"
                  type="number"
                  min="0"
                  :rules="[
                    v => v !== null && v !== '' || 'Las calorías son requeridas',
                    v => v >= 0 || 'Debe ser mayor o igual a 0'
                  ]"
                  variant="outlined"
                  required
                ></v-text-field>
              </v-col>

              <!-- Macronutrientes -->
              <v-col cols="12">
                <v-divider></v-divider>
                <div class="text-subtitle-1 font-weight-bold mt-4 mb-2">
                  <v-icon class="mr-2">mdi-nutrition</v-icon>
                  Macronutrientes
                </div>
              </v-col>

              <v-col cols="12" md="3">
                <v-text-field
                  v-model.number="nuevoAlimento.proteinGrams"
                  label="Proteínas (g)"
                  prepend-icon="mdi-food-steak"
                  type="number"
                  min="0"
                  step="0.1"
                  :rules="[v => v === null || v === '' || v >= 0 || 'Debe ser mayor o igual a 0']"
                  variant="outlined"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="3">
                <v-text-field
                  v-model.number="nuevoAlimento.carbsGrams"
                  label="Carbohidratos (g)"
                  prepend-icon="mdi-bread-slice"
                  type="number"
                  min="0"
                  step="0.1"
                  :rules="[v => v === null || v === '' || v >= 0 || 'Debe ser mayor o igual a 0']"
                  variant="outlined"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="3">
                <v-text-field
                  v-model.number="nuevoAlimento.fatGrams"
                  label="Grasas (g)"
                  prepend-icon="mdi-water"
                  type="number"
                  min="0"
                  step="0.1"
                  :rules="[v => v === null || v === '' || v >= 0 || 'Debe ser mayor o igual a 0']"
                  variant="outlined"
                ></v-text-field>
              </v-col>

              <v-col cols="12" md="3">
                <v-text-field
                  v-model.number="nuevoAlimento.fiberGrams"
                  label="Fibra (g)"
                  prepend-icon="mdi-leaf"
                  type="number"
                  min="0"
                  step="0.1"
                  :rules="[v => v === null || v === '' || v >= 0 || 'Debe ser mayor o igual a 0']"
                  variant="outlined"
                ></v-text-field>
              </v-col>

              <!-- Descripción -->
              <v-col cols="12">
                <v-textarea
                  v-model="nuevoAlimento.description"
                  label="Descripción / Notas"
                  prepend-icon="mdi-text"
                  placeholder="Información adicional sobre el alimento"
                  variant="outlined"
                  rows="3"
                ></v-textarea>
              </v-col>
            </v-row>
          </v-form>
        </v-card-text>

        <v-card-actions class="px-6 pb-4">
          <v-spacer></v-spacer>
          <v-btn
            variant="text"
            @click="cerrarDialogo"
          >
            Cancelar
          </v-btn>
          <v-btn
            color="primary"
            variant="elevated"
            :loading="guardando"
            @click="guardarAlimento"
          >
            {{ alimentoEditando ? 'Actualizar' : 'Guardar' }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo de detalles -->
    <v-dialog v-model="dialogoDetalles" max-width="600">
      <v-card v-if="alimentoDetalle">
        <v-card-title class="text-h5 bg-primary">
          <v-icon class="mr-2">mdi-information</v-icon>
          Detalles del Alimento
        </v-card-title>

        <v-card-text class="pt-6">
          <v-row>
            <v-col cols="12">
              <div class="d-flex align-center mb-4">
                <v-avatar color="primary" size="64" class="mr-4">
                  <v-icon size="32">mdi-food</v-icon>
                </v-avatar>
                <div>
                  <div class="text-h5 font-weight-bold">{{ alimentoDetalle.name }}</div>
                  <v-chip size="small" color="primary" variant="tonal" class="mt-1">
                    {{ alimentoDetalle.category }}
                  </v-chip>
                </div>
              </div>
            </v-col>

            <v-col cols="12">
              <v-list density="compact">
                <v-list-item prepend-icon="mdi-scale">
                  <v-list-item-title>Porción</v-list-item-title>
                  <v-list-item-subtitle>{{ alimentoDetalle.servingSize }}</v-list-item-subtitle>
                </v-list-item>
                <v-divider></v-divider>
                <v-list-item prepend-icon="mdi-fire">
                  <v-list-item-title>Calorías</v-list-item-title>
                  <v-list-item-subtitle>{{ alimentoDetalle.calories }} kcal</v-list-item-subtitle>
                </v-list-item>
                <v-divider></v-divider>
                <v-list-item prepend-icon="mdi-food-steak">
                  <v-list-item-title>Proteínas</v-list-item-title>
                  <v-list-item-subtitle>{{ alimentoDetalle.proteinGrams }}g</v-list-item-subtitle>
                </v-list-item>
                <v-divider></v-divider>
                <v-list-item prepend-icon="mdi-bread-slice">
                  <v-list-item-title>Carbohidratos</v-list-item-title>
                  <v-list-item-subtitle>{{ alimentoDetalle.carbsGrams }}g</v-list-item-subtitle>
                </v-list-item>
                <v-divider></v-divider>
                <v-list-item prepend-icon="mdi-water">
                  <v-list-item-title>Grasas</v-list-item-title>
                  <v-list-item-subtitle>{{ alimentoDetalle.fatGrams }}g</v-list-item-subtitle>
                </v-list-item>
                <v-divider></v-divider>
                <v-list-item prepend-icon="mdi-leaf">
                  <v-list-item-title>Fibra</v-list-item-title>
                  <v-list-item-subtitle>{{ alimentoDetalle.fiberGrams }}g</v-list-item-subtitle>
                </v-list-item>
                <v-divider v-if="alimentoDetalle.description"></v-divider>
                <v-list-item v-if="alimentoDetalle.description" prepend-icon="mdi-text">
                  <v-list-item-title>Descripción</v-list-item-title>
                  <v-list-item-subtitle>{{ alimentoDetalle.description }}</v-list-item-subtitle>
                </v-list-item>
              </v-list>
            </v-col>
          </v-row>
        </v-card-text>

        <v-card-actions class="px-6 pb-4">
          <v-spacer></v-spacer>
          <v-btn variant="text" @click="dialogoDetalles = false">Cerrar</v-btn>
          <v-btn color="primary" variant="elevated" @click="editarAlimento(alimentoDetalle); dialogoDetalles = false">
            Editar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Snackbar de notificaciones -->
    <v-snackbar
      v-model="notificacion.mostrar"
      :color="notificacion.color"
      timeout="3000"
    >
      {{ notificacion.mensaje }}
    </v-snackbar>
  </v-container>
</template>

<script>
import api from '@/services/api'

export default {
  name: 'NutritionistFoodsView',
  
  data() {
    return {
      // Datos
      alimentos: [],
      alimentosFiltrados: [],
      categorias: [],
      
      // Estados
      cargando: false,
      guardando: false,
      
      // Filtros y búsqueda
      busqueda: '',
      categoriaFiltro: 'Todas',
      categoriaSeleccionada: null,
      ordenamiento: 'Nombre A-Z',
      opcionesOrden: ['Nombre A-Z', 'Nombre Z-A', 'Calorías ↑', 'Calorías ↓', 'Recientes'],
      
      // Diálogos
      dialogoAlimento: false,
      dialogoDetalles: false,
      
      // Formulario
      alimentoEditando: null,
      alimentoDetalle: null,
      nuevoAlimento: {
        name: '',
        category: '',
        servingSize: '',
        calories: null,
        proteinGrams: null,
        carbsGrams: null,
        fatGrams: null,
        fiberGrams: null,
        description: ''
      },
      
      // Tabla
      headers: [
        { title: 'Alimento', key: 'name', sortable: true, width: '25%' },
        { title: 'Categoría', key: 'category', sortable: true, align: 'center' },
        { title: 'Calorías', key: 'calories', sortable: true, align: 'center' },
        { title: 'Proteínas', key: 'proteinGrams', sortable: true, align: 'center' },
        { title: 'Carbos', key: 'carbsGrams', sortable: true, align: 'center' },
        { title: 'Grasas', key: 'fatGrams', sortable: true, align: 'center' },
        { title: 'Acciones', key: 'actions', sortable: false, align: 'center' }
      ],
      
      // Notificaciones
      notificacion: {
        mostrar: false,
        mensaje: '',
        color: 'success'
      }
    }
  },

  computed: {
    totalAlimentos() {
      return this.alimentos.length
    },
    
    totalCategorias() {
      return this.categorias.length
    },
    
    alimentosMasUsados() {
      // Por ahora retornamos un valor fijo, después se puede implementar con estadísticas reales
      return Math.floor(this.totalAlimentos * 0.3)
    },
    
    alimentosRecientes() {
      const hoy = new Date().toDateString()
      return this.alimentos.filter(a => {
        if (a.createdAt) {
          return new Date(a.createdAt).toDateString() === hoy
        }
        return false
      }).length
    }
  },

  mounted() {
    this.cargarAlimentos()
    this.cargarCategorias()
  },

  methods: {
    async cargarAlimentos() {
      try {
        this.cargando = true
        const response = await api.get('/foods')
        this.alimentos = response.data
        this.alimentosFiltrados = [...this.alimentos]
        this.ordenarAlimentos()
      } catch (error) {
        console.error('Error al cargar alimentos:', error)
        this.mostrarError('Error al cargar los alimentos')
      } finally {
        this.cargando = false
      }
    },

    async cargarCategorias() {
      try {
        const response = await api.get('/foods/categories')
        this.categorias = response.data
      } catch (error) {
        console.error('Error al cargar categorías:', error)
      }
    },

    buscarAlimentos() {
      if (!this.busqueda) {
        this.filtrarPorCategoria()
        return
      }
      
      const busquedaLower = this.busqueda.toLowerCase()
      this.alimentosFiltrados = this.alimentos.filter(alimento =>
        alimento.name.toLowerCase().includes(busquedaLower) ||
        alimento.category.toLowerCase().includes(busquedaLower)
      )
    },

    filtrarPorCategoria() {
      if (this.categoriaFiltro === 'Todas') {
        this.alimentosFiltrados = [...this.alimentos]
      } else {
        this.alimentosFiltrados = this.alimentos.filter(
          alimento => alimento.category === this.categoriaFiltro
        )
      }
      
      if (this.busqueda) {
        this.buscarAlimentos()
      }
      
      this.ordenarAlimentos()
    },

    ordenarAlimentos() {
      switch (this.ordenamiento) {
        case 'Nombre A-Z':
          this.alimentosFiltrados.sort((a, b) => a.name.localeCompare(b.name))
          break
        case 'Nombre Z-A':
          this.alimentosFiltrados.sort((a, b) => b.name.localeCompare(a.name))
          break
        case 'Calorías ↑':
          this.alimentosFiltrados.sort((a, b) => a.calories - b.calories)
          break
        case 'Calorías ↓':
          this.alimentosFiltrados.sort((a, b) => b.calories - a.calories)
          break
        case 'Recientes':
          this.alimentosFiltrados.sort((a, b) => {
            if (!a.createdAt) return 1
            if (!b.createdAt) return -1
            return new Date(b.createdAt) - new Date(a.createdAt)
          })
          break
      }
    },

    getIconoCategoria(categoria) {
      const iconos = {
        'Frutas': 'mdi-fruit-cherries',
        'Verduras': 'mdi-carrot',
        'Carnes': 'mdi-food-steak',
        'Pescados': 'mdi-fish',
        'Lácteos': 'mdi-cheese',
        'Cereales': 'mdi-barley',
        'Legumbres': 'mdi-seed',
        'Frutos secos': 'mdi-peanut',
        'Grasas saludables': 'mdi-avocado',
        'Aceites': 'mdi-bottle-tonic-plus',
        'Bebidas': 'mdi-cup-water',
        'Endulzantes': 'mdi-spoon-sugar'
      }
      return iconos[categoria] || 'mdi-food'
    },

    abrirDialogoNuevoAlimento() {
      this.alimentoEditando = null
      this.nuevoAlimento = {
        name: '',
        category: '',
        servingSize: '',
        calories: null,
        proteinGrams: null,
        carbsGrams: null,
        fatGrams: null,
        fiberGrams: null,
        description: ''
      }
      this.dialogoAlimento = true
    },

    editarAlimento(alimento) {
      this.alimentoEditando = alimento
      this.nuevoAlimento = {
        name: alimento.name,
        category: alimento.category,
        servingSize: alimento.servingSize,
        calories: alimento.calories,
        proteinGrams: alimento.proteinGrams,
        carbsGrams: alimento.carbsGrams,
        fatGrams: alimento.fatGrams,
        fiberGrams: alimento.fiberGrams,
        description: alimento.description || ''
      }
      this.dialogoAlimento = true
    },

    verDetalles(alimento) {
      this.alimentoDetalle = alimento
      this.dialogoDetalles = true
    },

    async guardarAlimento() {
      const { valid } = await this.$refs.formulario.validate()
      if (!valid) {
        this.mostrarError('Por favor corrige los errores en el formulario')
        return
      }

      // Validar que los valores numéricos sean >= 0
      if (this.nuevoAlimento.calories < 0) {
        this.mostrarError('Las calorías deben ser mayor o igual a 0')
        return
      }

      // Validar macronutrientes opcionales
      if (this.nuevoAlimento.proteinGrams !== null && this.nuevoAlimento.proteinGrams < 0) {
        this.mostrarError('Las proteínas deben ser mayor o igual a 0')
        return
      }
      if (this.nuevoAlimento.carbsGrams !== null && this.nuevoAlimento.carbsGrams < 0) {
        this.mostrarError('Los carbohidratos deben ser mayor o igual a 0')
        return
      }
      if (this.nuevoAlimento.fatGrams !== null && this.nuevoAlimento.fatGrams < 0) {
        this.mostrarError('Las grasas deben ser mayor o igual a 0')
        return
      }
      if (this.nuevoAlimento.fiberGrams !== null && this.nuevoAlimento.fiberGrams < 0) {
        this.mostrarError('La fibra debe ser mayor o igual a 0')
        return
      }

      try {
        this.guardando = true
        
        // Debug: ver qué se está enviando
        console.log('📤 Guardando alimento:', {
          id: this.alimentoEditando?.id,
          datos: this.nuevoAlimento
        })
        
        if (this.alimentoEditando) {
          const response = await api.put(`/foods/${this.alimentoEditando.id}`, this.nuevoAlimento)
          console.log('✅ Respuesta del servidor:', response.data)
          this.mostrarExito('✅ Alimento actualizado correctamente')
        } else {
          const response = await api.post('/foods', this.nuevoAlimento)
          console.log('✅ Respuesta del servidor:', response.data)
          this.mostrarExito('✅ Alimento agregado correctamente')
        }

        this.cerrarDialogo()
        await this.cargarAlimentos()
        await this.cargarCategorias()
      } catch (error) {
        console.error('❌ Error completo al guardar alimento:', error)
        console.error('❌ Respuesta del servidor:', error.response)
        
        if (error.response?.status === 401) {
          this.mostrarError('⚠️ Tu sesión expiró. Por favor, inicia sesión nuevamente.')
          // No redirigir automáticamente, dar tiempo al usuario
          setTimeout(() => {
            this.$router.push('/login')
          }, 3000)
        } else if (error.response?.data?.message) {
          this.mostrarError(error.response.data.message)
        } else {
          this.mostrarError('Error al guardar el alimento')
        }
      } finally {
        this.guardando = false
      }
    },

    async eliminarAlimento(alimento) {
      if (!confirm(`¿Estás seguro de eliminar "${alimento.name}"?`)) {
        return
      }

      try {
        await api.delete(`/foods/${alimento.id}`)
        this.mostrarExito('🗑️ Alimento eliminado')
        await this.cargarAlimentos()
      } catch (error) {
        console.error('Error al eliminar alimento:', error)
        this.mostrarError('Error al eliminar el alimento')
      }
    },

    cerrarDialogo() {
      this.dialogoAlimento = false
      this.alimentoEditando = null
    },

    mostrarExito(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'success' }
    },

    mostrarError(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'error' }
    }
  }
}
</script>

<style scoped>
.v-data-table {
  border-radius: 8px;
}
</style>
