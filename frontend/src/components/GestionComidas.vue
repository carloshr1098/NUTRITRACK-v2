<template>
  <v-card>
    <v-card-title class="bg-green text-white">
      <v-icon class="mr-2">mdi-food</v-icon>
      Comidas del Plan
      <v-spacer></v-spacer>
      <v-btn
        color="white"
        variant="text"
        @click="dialogoNuevaComida = true"
        size="small"
      >
        <v-icon>mdi-plus</v-icon>
        Agregar Comida
      </v-btn>
    </v-card-title>

    <v-card-text class="pa-4">
      <!-- Resumen nutricional -->
      <v-card variant="outlined" class="mb-4" v-if="resumen">
        <v-card-title class="text-subtitle-1">
          <v-icon class="mr-2" color="primary">mdi-chart-box</v-icon>
          Resumen Nutricional del Día
        </v-card-title>
        <v-card-text>
          <v-row>
            <v-col cols="6" md="2">
              <div class="text-center">
                <div class="text-h6 text-primary">{{ resumen.totalCalories }}</div>
                <div class="text-caption">Calorías</div>
              </div>
            </v-col>
            <v-col cols="6" md="2">
              <div class="text-center">
                <div class="text-h6 text-success">{{ resumen.totalProtein?.toFixed(1) }}</div>
                <div class="text-caption">Proteínas (g)</div>
              </div>
            </v-col>
            <v-col cols="6" md="2">
              <div class="text-center">
                <div class="text-h6 text-warning">{{ resumen.totalCarbs?.toFixed(1) }}</div>
                <div class="text-caption">Carbohidratos (g)</div>
              </div>
            </v-col>
            <v-col cols="6" md="2">
              <div class="text-center">
                <div class="text-h6 text-error">{{ resumen.totalFat?.toFixed(1) }}</div>
                <div class="text-caption">Grasas (g)</div>
              </div>
            </v-col>
            <v-col cols="6" md="2">
              <div class="text-center">
                <div class="text-h6 text-info">{{ resumen.totalFiber?.toFixed(1) }}</div>
                <div class="text-caption">Fibra (g)</div>
              </div>
            </v-col>
            <v-col cols="6" md="2">
              <div class="text-center">
                <div class="text-h6">{{ resumen.mealCount }}</div>
                <div class="text-caption">Comidas</div>
              </div>
            </v-col>
          </v-row>
        </v-card-text>
      </v-card>

      <!-- Tabs por tipo de comida -->
      <v-tabs v-model="tabActual" color="green">
        <v-tab value="BREAKFAST">
          <v-icon class="mr-2">mdi-weather-sunny</v-icon>
          Desayuno
        </v-tab>
        <v-tab value="SNACK">
          <v-icon class="mr-2">mdi-food-apple</v-icon>
          Snack
        </v-tab>
        <v-tab value="LUNCH">
          <v-icon class="mr-2">mdi-silverware-fork-knife</v-icon>
          Comida
        </v-tab>
        <v-tab value="DINNER">
          <v-icon class="mr-2">mdi-moon-waning-crescent</v-icon>
          Cena
        </v-tab>
      </v-tabs>

      <v-window v-model="tabActual" class="mt-4">
        <v-window-item
          v-for="tipo in ['BREAKFAST', 'SNACK', 'LUNCH', 'DINNER']"
          :key="tipo"
          :value="tipo"
        >
          <v-row>
            <v-col
              v-for="comida in comidasPorTipo(tipo)"
              :key="comida.id"
              cols="12"
              md="6"
            >
              <v-card variant="outlined" hover>
                <v-card-title class="text-subtitle-1">
                  <span v-if="comida.servings && comida.servings > 1" class="text-primary">
                    {{ comida.servings }}x
                  </span>
                  {{ comida.mealName }}
                  <v-spacer></v-spacer>
                  <v-chip size="small" color="primary">
                    {{ comida.calories }} kcal
                  </v-chip>
                </v-card-title>
                <v-card-text>
                  <p v-if="comida.description" class="text-body-2 mb-2">
                    {{ comida.description }}
                  </p>
                  <v-row dense class="text-caption">
                    <v-col cols="3" v-if="comida.proteinGrams">
                      <strong>Proteínas:</strong> {{ comida.proteinGrams }}g
                    </v-col>
                    <v-col cols="3" v-if="comida.carbsGrams">
                      <strong>Carbos:</strong> {{ comida.carbsGrams }}g
                    </v-col>
                    <v-col cols="3" v-if="comida.fatGrams">
                      <strong>Grasas:</strong> {{ comida.fatGrams }}g
                    </v-col>
                    <v-col cols="3" v-if="comida.fiberGrams">
                      <strong>Fibra:</strong> {{ comida.fiberGrams }}g
                    </v-col>
                  </v-row>
                  <div v-if="comida.ingredients" class="mt-2">
                    <strong>Ingredientes:</strong> {{ comida.ingredients }}
                  </div>
                </v-card-text>
                <v-card-actions>
                  <v-btn
                    color="info"
                    size="small"
                    variant="text"
                    @click="verDetalleComida(comida)"
                  >
                    <v-icon>mdi-eye</v-icon>
                  </v-btn>
                  <v-btn
                    color="primary"
                    size="small"
                    variant="text"
                    @click="editarComida(comida)"
                  >
                    <v-icon>mdi-pencil</v-icon>
                  </v-btn>
                  <v-btn
                    color="error"
                    size="small"
                    variant="text"
                    @click="eliminarComida(comida)"
                  >
                    <v-icon>mdi-delete</v-icon>
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-col>
            <v-col cols="12" v-if="comidasPorTipo(tipo).length === 0">
              <v-alert type="info" variant="tonal">
                No hay comidas registradas para {{ nombreTipo(tipo) }}
              </v-alert>
            </v-col>
          </v-row>
        </v-window-item>
      </v-window>
    </v-card-text>

    <!-- Diálogo para nueva/editar comida -->
    <v-dialog v-model="dialogoNuevaComida" max-width="700">
      <v-card>
        <v-card-title class="bg-green text-white">
          <v-icon class="mr-2">{{ comidaEditando ? 'mdi-pencil' : 'mdi-plus' }}</v-icon>
          {{ comidaEditando ? 'Editar Comida' : 'Nueva Comida' }}
        </v-card-title>
        <v-card-text class="pt-4">
          <v-form @submit.prevent="guardarComida">
            <v-select
              v-model="nuevaComida.mealType"
              :items="tiposComida"
              label="Tipo de Comida"
              required
            ></v-select>

            <!-- Buscador de alimentos -->
            <v-autocomplete
              v-model="alimentoSeleccionado"
              v-model:search="busquedaAlimento"
              :items="alimentosBuscados"
              :loading="buscandoAlimentos"
              @update:search="buscarAlimentos"
              @update:modelValue="onAlimentoSeleccionado"
              label="🔍 Buscar alimento en la base de datos"
              prepend-icon="mdi-database-search"
              item-title="displayText"
              item-value="id"
              return-object
              clearable
              no-filter
              hint="Busca un alimento para autocompletar información nutricional"
              persistent-hint
              class="mb-4"
            >
              <template v-slot:item="{ props, item }">
                <v-list-item 
                  v-bind="props"
                  :title="item.raw.name"
                  :subtitle="`${item.raw.category} - ${item.raw.servingSize} - ${item.raw.calories} kcal`"
                >
                  <template v-slot:prepend>
                    <v-icon color="primary">mdi-food</v-icon>
                  </template>
                </v-list-item>
              </template>
              <template v-slot:no-data>
                <v-list-item>
                  <v-list-item-title>
                    Escribe para buscar alimentos...
                  </v-list-item-title>
                </v-list-item>
              </template>
            </v-autocomplete>

            <v-text-field
              v-model="nuevaComida.mealName"
              label="Nombre de la Comida"
              prepend-icon="mdi-food"
              required
              :disabled="alimentoBloqueado"
              :hint="alimentoBloqueado ? 'Alimento de la base de datos' : ''"
              persistent-hint
            ></v-text-field>

            <v-text-field
              v-model.number="nuevaComida.servings"
              label="Cantidad/Porciones"
              prepend-icon="mdi-counter"
              type="number"
              min="1"
              hint="Ej: 2 huevos, 3 rebanadas, 1 taza"
              persistent-hint
              class="mb-2"
              @input="onServingsChange"
            ></v-text-field>

            <v-textarea
              v-model="nuevaComida.description"
              label="Descripción"
              prepend-icon="mdi-text"
              rows="2"
            ></v-textarea>

            <v-row>
              <v-col cols="6" md="3">
                <v-text-field
                  v-model.number="nuevaComida.calories"
                  label="Calorías"
                  type="number"
                  min="0"
                  suffix="kcal"
                  :disabled="alimentoBloqueado"
                  :prepend-icon="alimentoBloqueado ? 'mdi-lock' : 'mdi-fire'"
                  :hint="alimentoBloqueado ? 'Valores de la base de datos' : ''"
                  persistent-hint
                ></v-text-field>
              </v-col>
              <v-col cols="6" md="3">
                <v-text-field
                  v-model.number="nuevaComida.proteinGrams"
                  label="Proteínas"
                  type="number"
                  min="0"
                  step="0.1"
                  suffix="g"
                  :disabled="alimentoBloqueado"
                  :prepend-icon="alimentoBloqueado ? 'mdi-lock' : 'mdi-food-drumstick'"
                  :hint="alimentoBloqueado ? 'Valores de la base de datos' : ''"
                  persistent-hint
                ></v-text-field>
              </v-col>
              <v-col cols="6" md="3">
                <v-text-field
                  v-model.number="nuevaComida.carbsGrams"
                  label="Carbohidratos"
                  type="number"
                  min="0"
                  step="0.1"
                  suffix="g"
                  :disabled="alimentoBloqueado"
                  :prepend-icon="alimentoBloqueado ? 'mdi-lock' : 'mdi-bread-slice'"
                  :hint="alimentoBloqueado ? 'Valores de la base de datos' : ''"
                  persistent-hint
                ></v-text-field>
              </v-col>
              <v-col cols="6" md="3">
                <v-text-field
                  v-model.number="nuevaComida.fatGrams"
                  label="Grasas"
                  type="number"
                  min="0"
                  step="0.1"
                  suffix="g"
                  :disabled="alimentoBloqueado"
                  :prepend-icon="alimentoBloqueado ? 'mdi-lock' : 'mdi-butter'"
                  :hint="alimentoBloqueado ? 'Valores de la base de datos' : ''"
                  persistent-hint
                ></v-text-field>
              </v-col>
            </v-row>

            <v-row>
              <v-col cols="6">
                <v-text-field
                  v-model.number="nuevaComida.fiberGrams"
                  label="Fibra"
                  type="number"
                  min="0"
                  step="0.1"
                  suffix="g"
                  :disabled="alimentoBloqueado"
                  :prepend-icon="alimentoBloqueado ? 'mdi-lock' : 'mdi-sprout'"
                  :hint="alimentoBloqueado ? 'Valores de la base de datos' : ''"
                  persistent-hint
                ></v-text-field>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  v-model.number="nuevaComida.preparationTime"
                  label="Tiempo de Preparación"
                  type="number"
                  min="0"
                  suffix="min"
                ></v-text-field>
              </v-col>
            </v-row>

            <v-textarea
              v-model="nuevaComida.ingredients"
              label="Ingredientes"
              prepend-icon="mdi-format-list-bulleted"
              rows="3"
              hint="Lista de ingredientes separados por comas"
            ></v-textarea>

            <v-textarea
              v-model="nuevaComida.instructions"
              label="Instrucciones de Preparación"
              prepend-icon="mdi-chef-hat"
              rows="3"
            ></v-textarea>

            <v-textarea
              v-model="nuevaComida.notes"
              label="Notas Adicionales"
              prepend-icon="mdi-note-text"
              rows="2"
            ></v-textarea>
          </v-form>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" variant="text" @click="cerrarDialogo">
            Cancelar
          </v-btn>
          <v-btn color="green" variant="flat" @click="guardarComida" :loading="guardando">
            <v-icon class="mr-2">mdi-content-save</v-icon>
            Guardar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Diálogo de detalle de comida -->
    <v-dialog v-model="dialogoDetalle" max-width="600">
      <v-card v-if="comidaDetalle">
        <v-card-title class="bg-primary text-white">
          <v-icon class="mr-2">mdi-food</v-icon>
          {{ comidaDetalle.mealName }}
        </v-card-title>
        <v-card-text class="pt-4">
          <v-row>
            <v-col cols="12" v-if="comidaDetalle.description">
              <p><strong>Descripción:</strong></p>
              <p class="ml-4">{{ comidaDetalle.description }}</p>
            </v-col>
            <v-col cols="12" v-if="comidaDetalle.ingredients">
              <p><strong>Ingredientes:</strong></p>
              <p class="ml-4">{{ comidaDetalle.ingredients }}</p>
            </v-col>
            <v-col cols="12" v-if="comidaDetalle.instructions">
              <p><strong>Instrucciones:</strong></p>
              <p class="ml-4">{{ comidaDetalle.instructions }}</p>
            </v-col>
            <v-col cols="12" v-if="comidaDetalle.preparationTime">
              <p><strong>Tiempo de Preparación:</strong> {{ comidaDetalle.preparationTime }} minutos</p>
            </v-col>
            <v-col cols="12" v-if="comidaDetalle.notes">
              <p><strong>Notas:</strong></p>
              <p class="ml-4">{{ comidaDetalle.notes }}</p>
            </v-col>
          </v-row>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="grey" variant="text" @click="dialogoDetalle = false">
            Cerrar
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <!-- Snackbar -->
    <v-snackbar v-model="notificacion.mostrar" :color="notificacion.color" timeout="3000">
      {{ notificacion.mensaje }}
    </v-snackbar>
  </v-card>
</template>

<script>
import api from '@/services/api'
import { generarPDFPlanDietético } from '@/services/pdfService'

export default {
  name: 'GestionComidas',
  props: {
    planId: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      tabActual: 'BREAKFAST',
      comidas: [],
      resumen: null,
      dialogoNuevaComida: false,
      dialogoDetalle: false,
      comidaDetalle: null,
      comidaEditando: null,
      guardando: false,
      // Buscador de alimentos
      alimentoSeleccionado: null,
      alimentosBuscados: [],
      busquedaAlimento: '',
      buscandoAlimentos: false,
      alimentoBloqueado: false, // Indica si los valores nutricionales están bloqueados
      // Valores nutricionales base (por 1 porción)
      valoresBase: {
        calories: null,
        proteinGrams: null,
        carbsGrams: null,
        fatGrams: null,
        fiberGrams: null
      },
      nuevaComida: {
        mealType: 'BREAKFAST',
        mealName: '',
        servings: 1,
        description: '',
        calories: null,
        proteinGrams: null,
        carbsGrams: null,
        fatGrams: null,
        fiberGrams: null,
        preparationTime: null,
        ingredients: '',
        instructions: '',
        notes: ''
      },
      tiposComida: [
        { title: 'Desayuno', value: 'BREAKFAST' },
        { title: 'Snack', value: 'SNACK' },
        { title: 'Comida', value: 'LUNCH' },
        { title: 'Cena', value: 'DINNER' }
      ],
      notificacion: {
        mostrar: false,
        mensaje: '',
        color: 'success'
      }
    }
  },
  mounted() {
    this.cargarComidas()
    this.cargarResumen()
  },
  methods: {
    onAlimentoSeleccionado(alimento) {
      if (alimento) {
        console.log('🍎 Alimento seleccionado:', alimento.name)
        
        // Guardar los valores base (por 1 porción)
        this.valoresBase = {
          calories: alimento.calories,
          proteinGrams: alimento.proteinGrams,
          carbsGrams: alimento.carbsGrams,
          fatGrams: alimento.fatGrams,
          fiberGrams: alimento.fiberGrams
        }
        
        console.log('💾 Valores base guardados:', this.valoresBase)
        
        // Bloquear campos nutricionales porque vienen de la base de datos
        this.alimentoBloqueado = true
        console.log('🔒 Campos nutricionales bloqueados')
        
        // Llenar el formulario
        this.nuevaComida.mealName = alimento.name
        this.nuevaComida.description = `${alimento.servingSize} de ${alimento.name.toLowerCase()}`
        
        // Aplicar valores según las porciones actuales
        const servings = this.nuevaComida.servings || 1
        this.multiplicarValoresNutricionales(servings)
      }
    },

    onServingsChange() {
      // Cuando el usuario cambia las porciones, recalcular
      const servings = this.nuevaComida.servings || 1
      console.log('🔢 Porciones cambiadas a:', servings)
      this.multiplicarValoresNutricionales(servings)
    },

    async verificarSiEsAlimentoDeBaseDatos(nombreAlimento, servings) {
      try {
        console.log('🔍 Verificando si el alimento existe en la base de datos:', nombreAlimento)
        const response = await api.get(`/foods/search?q=${nombreAlimento}`)
        
        // Buscar coincidencia exacta por nombre
        const alimentoEncontrado = response.data.find(
          food => food.name.toLowerCase() === nombreAlimento.toLowerCase()
        )
        
        if (alimentoEncontrado) {
          console.log('✅ Alimento encontrado en la base de datos:', alimentoEncontrado.name)
          
          // Guardar valores base (por 1 porción)
          this.valoresBase = {
            calories: alimentoEncontrado.calories,
            proteinGrams: alimentoEncontrado.proteinGrams,
            carbsGrams: alimentoEncontrado.carbsGrams,
            fatGrams: alimentoEncontrado.fatGrams,
            fiberGrams: alimentoEncontrado.fiberGrams
          }
          
          // Bloquear campos porque proviene de la base de datos
          this.alimentoBloqueado = true
          console.log('🔒 Campos bloqueados - alimento de base de datos')
        } else {
          console.log('ℹ️ Alimento no encontrado en la base de datos - entrada manual')
          this.alimentoBloqueado = false
        }
      } catch (error) {
        console.error('Error al verificar alimento:', error)
        this.alimentoBloqueado = false
      }
    },

    async cargarComidas() {
      try {
        console.log('📥 Cargando comidas del plan:', this.planId)
        const response = await api.get(`/diet-meals/plan/${this.planId}`)
        this.comidas = response.data
        console.log('✅ Comidas cargadas:', this.comidas.length, 'comidas')
      } catch (error) {
        console.error('❌ Error al cargar comidas:', error)
        this.mostrarError('Error al cargar las comidas')
      }
    },

    async cargarResumen() {
      try {
        const response = await api.get(`/diet-meals/plan/${this.planId}/summary`)
        this.resumen = response.data
      } catch (error) {
        console.error('Error al cargar resumen:', error)
      }
    },

    comidasPorTipo(tipo) {
      return this.comidas.filter(c => c.mealType === tipo)
    },

    nombreTipo(tipo) {
      const nombres = {
        'BREAKFAST': 'el desayuno',
        'SNACK': 'los snacks',
        'LUNCH': 'la comida',
        'DINNER': 'la cena'
      }
      return nombres[tipo] || tipo
    },

    verDetalleComida(comida) {
      this.comidaDetalle = comida
      this.dialogoDetalle = true
    },

    editarComida(comida) {
      this.comidaEditando = comida
      this.nuevaComida = {
        mealType: comida.mealType,
        mealName: comida.mealName,
        servings: comida.servings || 1,
        description: comida.description || '',
        calories: comida.calories,
        proteinGrams: comida.proteinGrams,
        carbsGrams: comida.carbsGrams,
        fatGrams: comida.fatGrams,
        fiberGrams: comida.fiberGrams,
        preparationTime: comida.preparationTime,
        ingredients: comida.ingredients || '',
        instructions: comida.instructions || '',
        notes: comida.notes || ''
      }
      
      // Verificar si esta comida proviene de la base de datos
      // buscando el alimento por nombre
      this.verificarSiEsAlimentoDeBaseDatos(comida.mealName, comida.servings || 1)
      
      this.dialogoNuevaComida = true
    },

    async guardarComida() {
      if (!this.nuevaComida.mealName) {
        this.mostrarError('Ingrese el nombre de la comida')
        return
      }

      try {
        this.guardando = true
        
        // Limpiar datos: remover campos null o vacíos
        const datos = {
          dietPlanId: this.planId,
          mealType: this.nuevaComida.mealType,
          mealName: this.nuevaComida.mealName
        }

        // Agregar porciones (valor por defecto 1 si no se especifica)
        if (this.nuevaComida.servings && this.nuevaComida.servings > 0) {
          datos.servings = this.nuevaComida.servings
        }

        // Solo agregar campos que tengan valores
        if (this.nuevaComida.description) {
          datos.description = this.nuevaComida.description
        }
        if (this.nuevaComida.calories !== null && this.nuevaComida.calories !== '') {
          datos.calories = this.nuevaComida.calories
        }
        if (this.nuevaComida.proteinGrams !== null && this.nuevaComida.proteinGrams !== '') {
          datos.proteinGrams = this.nuevaComida.proteinGrams
        }
        if (this.nuevaComida.carbsGrams !== null && this.nuevaComida.carbsGrams !== '') {
          datos.carbsGrams = this.nuevaComida.carbsGrams
        }
        if (this.nuevaComida.fatGrams !== null && this.nuevaComida.fatGrams !== '') {
          datos.fatGrams = this.nuevaComida.fatGrams
        }
        if (this.nuevaComida.fiberGrams !== null && this.nuevaComida.fiberGrams !== '') {
          datos.fiberGrams = this.nuevaComida.fiberGrams
        }
        if (this.nuevaComida.preparationTime !== null && this.nuevaComida.preparationTime !== '') {
          datos.preparationTime = this.nuevaComida.preparationTime
        }
        if (this.nuevaComida.ingredients) {
          datos.ingredients = this.nuevaComida.ingredients
        }
        if (this.nuevaComida.instructions) {
          datos.instructions = this.nuevaComida.instructions
        }
        if (this.nuevaComida.notes) {
          datos.notes = this.nuevaComida.notes
        }

        console.log('📤 Guardando comida:', {
          editando: !!this.comidaEditando,
          id: this.comidaEditando?.id,
          datos: datos
        })

        if (this.comidaEditando) {
          const response = await api.put(`/diet-meals/${this.comidaEditando.id}`, datos)
          console.log('✅ Comida actualizada:', response.data)
          this.mostrarExito('✅ Comida actualizada')
        } else {
          const response = await api.post('/diet-meals', datos)
          console.log('✅ Comida creada:', response.data)
          this.mostrarExito('✅ Comida agregada')
        }

        // Cerrar el diálogo primero
        this.cerrarDialogo()
        
        // Recargar las comidas y el resumen
        console.log('🔄 Recargando comidas...')
        await this.cargarComidas()
        console.log('🔄 Recargando resumen...')
        await this.cargarResumen()
        console.log('✅ Datos recargados')
      } catch (error) {
        console.error('❌ Error completo al guardar comida:', error)
        console.error('❌ Status:', error.response?.status)
        console.error('❌ Data:', error.response?.data)
        
        if (error.response?.status === 401) {
          this.mostrarError('⚠️ Tu sesión expiró. Inicia sesión nuevamente.')
        } else {
          this.mostrarError('Error al guardar la comida')
        }
      } finally {
        this.guardando = false
      }
    },

    async eliminarComida(comida) {
      if (!confirm(`¿Eliminar ${comida.mealName}?`)) return

      try {
        await api.delete(`/diet-meals/${comida.id}`)
        this.mostrarExito('🗑️ Comida eliminada')
        await this.cargarComidas()
        await this.cargarResumen()
      } catch (error) {
        console.error('Error al eliminar comida:', error)
        this.mostrarError('Error al eliminar la comida')
      }
    },

    multiplicarValoresNutricionales(servings) {
      console.log('🔄 multiplicarValoresNutricionales llamado con:', servings)
      console.log('📊 Valores base actuales:', this.valoresBase)
      
      // Solo multiplicar si hay valores base guardados
      if (!this.valoresBase.calories && !this.valoresBase.proteinGrams) {
        console.warn('⚠️ No hay valores base - no se puede multiplicar')
        return
      }
      
      const factor = servings || 1
      console.log('✖️ Multiplicando por factor:', factor)
      
      // Aplicar el factor de multiplicación a cada valor nutricional
      if (this.valoresBase.calories !== null) {
        this.nuevaComida.calories = Math.round(this.valoresBase.calories * factor)
      }
      if (this.valoresBase.proteinGrams !== null) {
        this.nuevaComida.proteinGrams = Math.round(this.valoresBase.proteinGrams * factor * 10) / 10
      }
      if (this.valoresBase.carbsGrams !== null) {
        this.nuevaComida.carbsGrams = Math.round(this.valoresBase.carbsGrams * factor * 10) / 10
      }
      if (this.valoresBase.fatGrams !== null) {
        this.nuevaComida.fatGrams = Math.round(this.valoresBase.fatGrams * factor * 10) / 10
      }
      if (this.valoresBase.fiberGrams !== null) {
        this.nuevaComida.fiberGrams = Math.round(this.valoresBase.fiberGrams * factor * 10) / 10
      }
      
      console.log(`✅ Valores multiplicados por ${factor}:`, {
        calories: this.nuevaComida.calories,
        protein: this.nuevaComida.proteinGrams,
        carbs: this.nuevaComida.carbsGrams
      })
    },

    async buscarAlimentos(searchText) {
      if (!searchText || searchText.length < 2) {
        this.alimentosBuscados = []
        return
      }
      
      try {
        this.buscandoAlimentos = true
        const response = await api.get(`/foods/search?q=${searchText}`)
        this.alimentosBuscados = response.data.map(food => ({
          ...food,
          displayText: `${food.name} - ${food.category} (${food.servingSize})`
        }))
      } catch (error) {
        console.error('Error buscando alimentos:', error)
        this.alimentosBuscados = []
      } finally {
        this.buscandoAlimentos = false
      }
    },

    cerrarDialogo() {
      this.dialogoNuevaComida = false
      this.comidaEditando = null
      this.alimentoSeleccionado = null
      this.alimentoBloqueado = false // Desbloquear para el siguiente uso
      // Limpiar valores base
      this.valoresBase = {
        calories: null,
        proteinGrams: null,
        carbsGrams: null,
        fatGrams: null,
        fiberGrams: null
      }
      this.nuevaComida = {
        mealType: 'BREAKFAST',
        mealName: '',
        servings: 1,
        description: '',
        calories: null,
        proteinGrams: null,
        carbsGrams: null,
        fatGrams: null,
        fiberGrams: null,
        preparationTime: null,
        ingredients: '',
        instructions: '',
        notes: ''
      }
    },

    mostrarExito(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'success' }
    },

    mostrarError(mensaje) {
      this.notificacion = { mostrar: true, mensaje, color: 'error' }
    },

    async exportarPDF() {
      try {
        if (this.comidas.length === 0) {
          this.mostrarError('No hay comidas para exportar')
          return
        }

        // Obtener información del plan
        const planResponse = await api.get(`/diet-plans/${this.planId}`)
        const planInfo = {
          nombre: planResponse.data.name || 'Plan Dietético',
          objetivo: planResponse.data.goal || ''
        }

        // Obtener información del paciente
        let pacienteInfo = null
        if (planResponse.data.patientId) {
          try {
            const pacienteResponse = await api.get(`/users/${planResponse.data.patientId}`)
            pacienteInfo = {
              nombre: pacienteResponse.data.fullName || pacienteResponse.data.username,
              email: pacienteResponse.data.email
            }
          } catch (error) {
            console.log('No se pudo cargar info del paciente:', error)
          }
        }

        // Generar PDF
        const fileName = generarPDFPlanDietético(
          planInfo,
          this.comidas,
          this.resumen,
          pacienteInfo
        )

        this.mostrarExito(`✅ PDF generado: ${fileName}`)
      } catch (error) {
        console.error('Error al exportar PDF:', error)
        this.mostrarError('Error al generar el PDF')
      }
    }
  },

  watch: {
    alimentoSeleccionado(food) {
      if (food) {
        // Autocompletar información nutricional desde la base de datos
        this.nuevaComida.mealName = food.name
        this.nuevaComida.calories = food.calories
        this.nuevaComida.proteinGrams = food.proteinGrams
        this.nuevaComida.carbsGrams = food.carbsGrams
        this.nuevaComida.fatGrams = food.fatGrams
        this.nuevaComida.fiberGrams = food.fiberGrams
        this.nuevaComida.description = `${food.servingSize} de ${food.name.toLowerCase()}`
        
        // Notificar al usuario
        this.mostrarExito(`✅ Datos nutricionales cargados: ${food.name}`)
      }
    }
  }
}
</script>
