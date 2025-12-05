<template>
  <div class="assessment-form-container">
    <form @submit.prevent="submitForm">
      
      <!-- SECCIÓN 1: ANTECEDENTES CLÍNICOS -->
      <div class="form-section">
        <h2 class="section-title">
          <span class="section-icon">🏥</span>
          Antecedentes Clínicos
        </h2>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Enfermedades Crónicas</label>
            <textarea 
              v-model="formData.chronicDiseases" 
              placeholder="Diabetes, hipertensión, enfermedades cardiovasculares, etc."
              rows="3"
            ></textarea>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group half-width">
            <label>Alergias</label>
            <textarea 
              v-model="formData.allergies" 
              placeholder="Alergias conocidas"
              rows="2"
            ></textarea>
          </div>
          
          <div class="form-group half-width">
            <label>Intolerancias Alimentarias</label>
            <textarea 
              v-model="formData.foodIntolerances" 
              placeholder="Lactosa, gluten, etc."
              rows="2"
            ></textarea>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group half-width">
            <label>Medicamentos Actuales</label>
            <textarea 
              v-model="formData.currentMedications" 
              placeholder="Medicamentos y dosis"
              rows="2"
            ></textarea>
          </div>
          
          <div class="form-group half-width">
            <label>Cirugías Previas</label>
            <textarea 
              v-model="formData.previousSurgeries" 
              placeholder="Cirugías realizadas"
              rows="2"
            ></textarea>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group half-width">
            <label>Condiciones Gastrointestinales</label>
            <textarea 
              v-model="formData.gastrointestinalConditions" 
              placeholder="Gastritis, colon irritable, etc."
              rows="2"
            ></textarea>
          </div>
          
          <div class="form-group half-width">
            <label>Historial Familiar</label>
            <textarea 
              v-model="formData.familyHistory" 
              placeholder="Antecedentes familiares relevantes"
              rows="2"
            ></textarea>
          </div>
        </div>
      </div>
      
      <!-- SECCIÓN 2: MEDIDAS ANTROPOMÉTRICAS -->
      <div class="form-section">
        <h2 class="section-title">
          <span class="section-icon">📏</span>
          Medidas Antropométricas
        </h2>
        
        <div class="form-row">
          <div class="form-group">
            <label>Peso (kg) *</label>
            <input 
              type="number" 
              v-model.number="formData.weight" 
              step="0.01" 
              required
              @input="calculateBMI"
            />
          </div>
          
          <div class="form-group">
            <label>Altura (cm) *</label>
            <input 
              type="number" 
              v-model.number="formData.height" 
              step="0.01" 
              required
              @input="calculateBMI"
            />
          </div>
          
          <div class="form-group">
            <label>IMC</label>
            <input 
              type="number" 
              v-model.number="formData.bmi" 
              step="0.01" 
              readonly
              :class="getBMIClass()"
            />
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group">
            <label>Circunferencia de Cintura (cm)</label>
            <input 
              type="number" 
              v-model.number="formData.waistCircumference" 
              step="0.01"
              @input="calculateWaistHipRatio"
            />
          </div>
          
          <div class="form-group">
            <label>Circunferencia de Cadera (cm)</label>
            <input 
              type="number" 
              v-model.number="formData.hipCircumference" 
              step="0.01"
              @input="calculateWaistHipRatio"
            />
          </div>
          
          <div class="form-group">
            <label>Relación Cintura/Cadera</label>
            <input 
              type="number" 
              v-model.number="formData.waistHipRatio" 
              step="0.01" 
              readonly
            />
          </div>
        </div>
        
        <h3 class="subsection-title">Pliegues Cutáneos (mm)</h3>
        <div class="form-row">
          <div class="form-group">
            <label>Pliegue Tricipital</label>
            <input type="number" v-model.number="formData.tricepsSkinfold" step="0.1" />
          </div>
          
          <div class="form-group">
            <label>Pliegue Bicipital</label>
            <input type="number" v-model.number="formData.bicepsSkinfold" step="0.1" />
          </div>
          
          <div class="form-group">
            <label>Pliegue Subescapular</label>
            <input type="number" v-model.number="formData.subscapularSkinfold" step="0.1" />
          </div>
          
          <div class="form-group">
            <label>Pliegue Suprailíaco</label>
            <input type="number" v-model.number="formData.suprailiacSkinfold" step="0.1" />
          </div>
        </div>
      </div>
      
      <!-- SECCIÓN 3: COMPOSICIÓN CORPORAL -->
      <div class="form-section">
        <h2 class="section-title">
          <span class="section-icon">💪</span>
          Composición Corporal
        </h2>
        
        <div class="form-row">
          <div class="form-group">
            <label>% Grasa Corporal</label>
            <input type="number" v-model.number="formData.bodyFatPercentage" step="0.1" />
          </div>
          
          <div class="form-group">
            <label>Masa Muscular (kg)</label>
            <input type="number" v-model.number="formData.muscleMass" step="0.1" />
          </div>
          
          <div class="form-group">
            <label>% Agua Corporal</label>
            <input type="number" v-model.number="formData.bodyWater" step="0.1" />
          </div>
          
          <div class="form-group">
            <label>Masa Ósea (kg)</label>
            <input type="number" v-model.number="formData.boneMass" step="0.1" />
          </div>
        </div>
      </div>
      
      <!-- SECCIÓN 4: HÁBITOS ALIMENTARIOS -->
      <div class="form-section">
        <h2 class="section-title">
          <span class="section-icon">🍽️</span>
          Hábitos Alimentarios
        </h2>
        
        <div class="form-row">
          <div class="form-group">
            <label>Comidas por Día</label>
            <input type="number" v-model.number="formData.mealsPerDay" min="1" max="10" />
          </div>
          
          <div class="form-group">
            <label>Consumo de Agua (litros/día)</label>
            <input type="number" v-model.number="formData.waterIntake" step="0.1" />
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Horario de Comidas</label>
            <textarea 
              v-model="formData.mealSchedule" 
              placeholder="Ej: Desayuno 7:00, Colación 10:00, Comida 14:00..."
              rows="2"
            ></textarea>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group half-width">
            <label>Alimentos Preferidos</label>
            <textarea 
              v-model="formData.preferredFoods" 
              placeholder="Alimentos que le gustan"
              rows="2"
            ></textarea>
          </div>
          
          <div class="form-group half-width">
            <label>Alimentos que No Gustan</label>
            <textarea 
              v-model="formData.dislikedFoods" 
              placeholder="Alimentos que rechaza"
              rows="2"
            ></textarea>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group">
            <label>Consumo de Alcohol</label>
            <textarea 
              v-model="formData.alcoholConsumption" 
              placeholder="Frecuencia y cantidad"
              rows="2"
            ></textarea>
          </div>
          
          <div class="form-group">
            <label>Consumo de Café/Té</label>
            <textarea 
              v-model="formData.coffeTeaConsumption" 
              placeholder="Tazas por día, tipo"
              rows="2"
            ></textarea>
          </div>
          
          <div class="form-group">
            <label>Suplementos</label>
            <textarea 
              v-model="formData.supplements" 
              placeholder="Vitaminas, minerales, etc."
              rows="2"
            ></textarea>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Restricciones Dietéticas</label>
            <textarea 
              v-model="formData.dietaryRestrictions" 
              placeholder="Religiosas, culturales, personales"
              rows="2"
            ></textarea>
          </div>
        </div>
      </div>
      
      <!-- SECCIÓN 5: ESTILO DE VIDA -->
      <div class="form-section">
        <h2 class="section-title">
          <span class="section-icon">🏃</span>
          Estilo de Vida
        </h2>
        
        <div class="form-row">
          <div class="form-group">
            <label>Nivel de Actividad Física</label>
            <select v-model="formData.physicalActivityLevel">
              <option value="">Seleccionar...</option>
              <option value="SEDENTARY">Sedentario</option>
              <option value="LIGHT">Ligero</option>
              <option value="MODERATE">Moderado</option>
              <option value="INTENSE">Intenso</option>
            </select>
          </div>
          
          <div class="form-group">
            <label>Frecuencia de Ejercicio</label>
            <input 
              type="text" 
              v-model="formData.exerciseFrequency" 
              placeholder="Ej: 3 veces por semana"
            />
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Tipo de Ejercicio</label>
            <textarea 
              v-model="formData.exerciseType" 
              placeholder="Cardio, pesas, yoga, etc."
              rows="2"
            ></textarea>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group">
            <label>Horas de Sueño</label>
            <input type="number" v-model.number="formData.sleepHours" step="0.5" min="0" max="24" />
          </div>
          
          <div class="form-group">
            <label>Nivel de Estrés</label>
            <select v-model="formData.stressLevel">
              <option value="">Seleccionar...</option>
              <option value="LOW">Bajo</option>
              <option value="MEDIUM">Medio</option>
              <option value="HIGH">Alto</option>
            </select>
          </div>
          
          <div class="form-group">
            <label>Hábito de Fumar</label>
            <select v-model="formData.smokingHabit">
              <option value="">Seleccionar...</option>
              <option value="NON_SMOKER">No fuma</option>
              <option value="EX_SMOKER">Ex-fumador</option>
              <option value="OCCASIONAL">Fumador ocasional</option>
              <option value="REGULAR">Fumador regular</option>
            </select>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Ocupación/Trabajo</label>
            <input type="text" v-model="formData.occupation" placeholder="Ocupación actual" />
          </div>
        </div>
      </div>
      
      <!-- SECCIÓN 6: OBJETIVOS NUTRICIONALES -->
      <div class="form-section">
        <h2 class="section-title">
          <span class="section-icon">🎯</span>
          Objetivos Nutricionales
        </h2>
        
        <div class="form-row">
          <div class="form-group">
            <label>Meta de Peso</label>
            <select v-model="formData.weightGoal">
              <option value="">Seleccionar...</option>
              <option value="LOSS">Pérdida de peso</option>
              <option value="GAIN">Ganancia de peso</option>
              <option value="MAINTENANCE">Mantenimiento</option>
            </select>
          </div>
          
          <div class="form-group">
            <label>Peso Objetivo (kg)</label>
            <input type="number" v-model.number="formData.targetWeight" step="0.1" />
          </div>
          
          <div class="form-group">
            <label>Nivel de Motivación</label>
            <select v-model="formData.motivationLevel">
              <option value="">Seleccionar...</option>
              <option value="LOW">Baja</option>
              <option value="MEDIUM">Media</option>
              <option value="HIGH">Alta</option>
            </select>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Objetivos de Salud</label>
            <textarea 
              v-model="formData.healthGoals" 
              placeholder="¿Qué desea lograr?"
              rows="3"
            ></textarea>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Condiciones a Mejorar</label>
            <textarea 
              v-model="formData.conditionsToImprove" 
              placeholder="Condiciones de salud que desea mejorar"
              rows="2"
            ></textarea>
          </div>
        </div>
      </div>
      
      <!-- SECCIÓN 7: RECORDATORIO ALIMENTARIO -->
      <div class="form-section">
        <h2 class="section-title">
          <span class="section-icon">📝</span>
          Recordatorio Alimentario
        </h2>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Recordatorio de 24 Horas</label>
            <textarea 
              v-model="formData.foodDiary24h" 
              placeholder="¿Qué comió ayer? (incluir horarios y cantidades)"
              rows="5"
            ></textarea>
          </div>
        </div>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Patrón Alimentario Típico Semanal</label>
            <textarea 
              v-model="formData.typicalWeeklyPattern" 
              placeholder="Describe cómo es una semana típica de alimentación"
              rows="4"
            ></textarea>
          </div>
        </div>
      </div>
      
      <!-- SECCIÓN 8: NOTAS ADICIONALES -->
      <div class="form-section">
        <h2 class="section-title">
          <span class="section-icon">📋</span>
          Notas Adicionales
        </h2>
        
        <div class="form-row">
          <div class="form-group full-width">
            <label>Observaciones</label>
            <textarea 
              v-model="formData.additionalNotes" 
              placeholder="Cualquier información adicional relevante"
              rows="4"
            ></textarea>
          </div>
        </div>
      </div>
      
      <!-- BOTONES DE ACCIÓN -->
      <div class="form-actions">
        <button type="button" @click="cancelForm" class="btn-cancel">
          Cancelar
        </button>
        <button type="submit" class="btn-submit" :disabled="saving">
          {{ saving ? 'Guardando...' : (isEdit ? 'Actualizar' : 'Guardar') }} Evaluación
        </button>
      </div>
    </form>
  </div>
</template>

<script>
import api from '@/services/api'

export default {
  name: 'NutritionalAssessmentForm',
  props: {
    patientId: {
      type: Number,
      required: true
    },
    assessmentId: {
      type: Number,
      default: null
    }
  },
  data() {
    return {
      saving: false,
      isEdit: false,
      formData: {
        // Antecedentes clínicos
        chronicDiseases: '',
        allergies: '',
        foodIntolerances: '',
        currentMedications: '',
        previousSurgeries: '',
        gastrointestinalConditions: '',
        familyHistory: '',
        
        // Medidas antropométricas
        weight: null,
        height: null,
        bmi: null,
        waistCircumference: null,
        hipCircumference: null,
        waistHipRatio: null,
        tricepsSkinfold: null,
        bicepsSkinfold: null,
        subscapularSkinfold: null,
        suprailiacSkinfold: null,
        
        // Composición corporal
        bodyFatPercentage: null,
        muscleMass: null,
        bodyWater: null,
        boneMass: null,
        
        // Hábitos alimentarios
        mealsPerDay: null,
        mealSchedule: '',
        preferredFoods: '',
        dislikedFoods: '',
        waterIntake: null,
        alcoholConsumption: '',
        coffeTeaConsumption: '',
        supplements: '',
        dietaryRestrictions: '',
        
        // Estilo de vida
        physicalActivityLevel: '',
        exerciseType: '',
        exerciseFrequency: '',
        sleepHours: null,
        stressLevel: '',
        occupation: '',
        smokingHabit: '',
        
        // Objetivos
        weightGoal: '',
        targetWeight: null,
        healthGoals: '',
        conditionsToImprove: '',
        motivationLevel: '',
        
        // Recordatorio
        foodDiary24h: '',
        typicalWeeklyPattern: '',
        
        // Notas
        additionalNotes: ''
      }
    }
  },
  mounted() {
    if (this.assessmentId) {
      this.isEdit = true
      this.loadAssessment()
    }
  },
  methods: {
    async loadAssessment() {
      try {
        const response = await api.get(`/nutritional-assessments/${this.assessmentId}`)
        this.formData = { ...this.formData, ...response.data }
      } catch (error) {
        console.error('Error al cargar la evaluación:', error)
        alert('Error al cargar la evaluación')
      }
    },
    
    calculateBMI() {
      if (this.formData.weight && this.formData.height) {
        const heightInMeters = this.formData.height / 100
        this.formData.bmi = (this.formData.weight / (heightInMeters * heightInMeters)).toFixed(2)
      }
    },
    
    calculateWaistHipRatio() {
      if (this.formData.waistCircumference && this.formData.hipCircumference) {
        this.formData.waistHipRatio = (this.formData.waistCircumference / this.formData.hipCircumference).toFixed(2)
      }
    },
    
    getBMIClass() {
      const bmi = parseFloat(this.formData.bmi)
      if (!bmi) return ''
      if (bmi < 18.5) return 'bmi-underweight'
      if (bmi < 25) return 'bmi-normal'
      if (bmi < 30) return 'bmi-overweight'
      return 'bmi-obese'
    },
    
    async submitForm() {
      this.saving = true
      try {
        const nutritionistId = JSON.parse(localStorage.getItem('user')).id
        
        if (this.isEdit) {
          await api.put(`/nutritional-assessments/${this.assessmentId}`, this.formData)
          alert('Evaluación actualizada correctamente')
        } else {
          await api.post(`/nutritional-assessments`, this.formData, {
            params: {
              patientId: this.patientId,
              nutritionistId: nutritionistId
            }
          })
          alert('Evaluación guardada correctamente')
        }
        
        this.$emit('saved')
      } catch (error) {
        console.error('Error al guardar la evaluación:', error)
        alert('Error al guardar la evaluación: ' + (error.response?.data || error.message))
      } finally {
        this.saving = false
      }
    },
    
    cancelForm() {
      this.$emit('cancel')
    }
  }
}
</script>

<style scoped>
.assessment-form-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.form-section {
  background: white;
  border-radius: 12px;
  padding: 25px;
  margin-bottom: 25px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.section-title {
  font-size: 20px;
  font-weight: 600;
  color: #2c3e50;
  margin: 0 0 20px 0;
  padding-bottom: 15px;
  border-bottom: 2px solid #4CAF50;
  display: flex;
  align-items: center;
  gap: 10px;
}

.section-icon {
  font-size: 24px;
}

.subsection-title {
  font-size: 16px;
  font-weight: 600;
  color: #555;
  margin: 20px 0 15px 0;
}

.form-row {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
  flex-wrap: wrap;
}

.form-group {
  flex: 1;
  min-width: 200px;
  display: flex;
  flex-direction: column;
}

.form-group.half-width {
  flex: 1;
  min-width: 300px;
}

.form-group.full-width {
  flex: 1 1 100%;
}

.form-group label {
  font-weight: 500;
  color: #555;
  margin-bottom: 6px;
  font-size: 14px;
}

.form-group input,
.form-group select,
.form-group textarea {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 14px;
  transition: border-color 0.3s;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #4CAF50;
}

.form-group input[readonly] {
  background: #f5f5f5;
  cursor: not-allowed;
}

.form-group textarea {
  resize: vertical;
  font-family: inherit;
}

/* Clases de IMC */
.bmi-underweight {
  background: #fff3cd !important;
  border-color: #ffc107 !important;
}

.bmi-normal {
  background: #d4edda !important;
  border-color: #28a745 !important;
}

.bmi-overweight {
  background: #fff3cd !important;
  border-color: #ffc107 !important;
}

.bmi-obese {
  background: #f8d7da !important;
  border-color: #dc3545 !important;
}

.form-actions {
  display: flex;
  gap: 15px;
  justify-content: flex-end;
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #ddd;
}

.btn-cancel,
.btn-submit {
  padding: 12px 30px;
  border: none;
  border-radius: 6px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-cancel {
  background: #6c757d;
  color: white;
}

.btn-cancel:hover {
  background: #5a6268;
}

.btn-submit {
  background: #4CAF50;
  color: white;
}

.btn-submit:hover:not(:disabled) {
  background: #45a049;
}

.btn-submit:disabled {
  background: #ccc;
  cursor: not-allowed;
}

@media (max-width: 768px) {
  .form-row {
    flex-direction: column;
  }
  
  .form-group {
    min-width: 100%;
  }
}
</style>
