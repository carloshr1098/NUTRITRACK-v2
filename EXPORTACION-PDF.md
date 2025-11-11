# 📄 Exportación de Planes Dietéticos a PDF

## Descripción General

El sistema NutriTrack ahora incluye funcionalidad completa para exportar planes dietéticos a formato PDF profesional. Esta característica permite a los nutricionistas generar documentos imprimibles de alta calidad para entregar a sus pacientes.

## Tecnologías Utilizadas

- **jsPDF**: Librería para generación de PDFs en el navegador
- **jsPDF-AutoTable**: Plugin para crear tablas profesionales en PDFs

## Características del PDF Generado

### 1. Encabezado Profesional
- Logo y nombre de NutriTrack
- Título "Plan Dietético Personalizado"
- Diseño con colores corporativos (verde)

### 2. Información del Paciente
- Nombre completo del paciente
- Email de contacto
- Nombre del plan dietético
- Objetivo del plan
- Fecha de generación

### 3. Resumen Nutricional Diario
Tabla con totales del día:
- Calorías totales (kcal)
- Proteínas (g)
- Carbohidratos (g)
- Grasas (g)
- Fibra (g)
- Total de comidas

### 4. Comidas Organizadas por Tipo
Cada tipo de comida tiene su propia sección con color distintivo:

#### 🌅 Desayuno (Amarillo)
- Tabla con todas las comidas del desayuno
- Información nutricional por comida
- Soporte para porciones múltiples (ej: "2x Huevo")

#### 🍎 Snack (Morado)
- Snacks y colaciones
- Información nutricional detallada

#### 🍽️ Comida (Rojo)
- Comida principal del día
- Detalles nutricionales completos

#### 🌙 Cena (Azul)
- Última comida del día
- Información nutricional completa

### 5. Detalles de Cada Comida
Para cada comida se incluye (cuando está disponible):
- **Descripción**: Detalles de la porción (ej: "1 taza (116g) de calabaza")
- **Ingredientes**: Lista de ingredientes necesarios
- **Instrucciones de Preparación**: Pasos para preparar la comida
- **Tiempo de Preparación**: Minutos requeridos

### 6. Pie de Página
- Número de página (ej: "Página 1 de 3")
- Marca "NutriTrack - Sistema de Gestión Nutricional"

## Cómo Usar

### Para Nutricionistas:

1. **Acceder a un Plan Dietético**
   - Ir a "Planes Dietéticos" en el menú del nutricionista
   - Seleccionar un paciente y abrir su plan

2. **Ver las Comidas del Plan**
   - Se mostrarán todas las comidas organizadas por tipo
   - Aparecerá el resumen nutricional del día

3. **Exportar a PDF**
   - Hacer clic en el botón **"Exportar PDF"** en la parte superior
   - El sistema generará automáticamente el PDF
   - El archivo se descargará con nombre: `Plan_Dietetico_[NombrePlan]_[Timestamp].pdf`

4. **Usar el PDF**
   - Imprimir el documento para entregar al paciente
   - Enviar por email
   - Archivar como respaldo

### Ejemplo de Flujo Completo:

```
1. Nutricionista crea plan dietético para paciente "Juan Pérez"
2. Agrega comidas:
   - Desayuno: 2x Huevo, 1x Avena
   - Snack: 1x Manzana
   - Comida: Pechuga de pollo, Arroz integral
   - Cena: Ensalada, Atún
3. Clic en "Exportar PDF"
4. Se descarga: Plan_Dietetico_Plan_1.0_1699308000000.pdf
5. Nutricionista lo imprime y entrega al paciente
```

## Archivo Generado

**Nombre**: `Plan_Dietetico_[NombrePlan]_[Timestamp].pdf`

**Ejemplo**: `Plan_Dietetico_Plan_Perdida_Peso_1699308000000.pdf`

## Validaciones

El sistema valida antes de generar el PDF:
- ✅ Debe haber al menos una comida en el plan
- ✅ El plan debe existir en la base de datos
- ✅ Se maneja gracefully si no hay información del paciente

## Manejo de Errores

- Si no hay comidas: Muestra mensaje "No hay comidas para exportar"
- Si falla la carga del plan: Muestra "Error al generar el PDF"
- Si no se puede cargar info del paciente: Continúa sin esa información (opcional)

## Características Técnicas

### Paginación Automática
- El sistema detecta cuándo una sección no cabe en la página actual
- Automáticamente crea una nueva página
- Mantiene el formato consistente en todas las páginas

### Soporte para Porciones
- Si una comida tiene `servings > 1`, muestra "2x Huevo" en lugar de solo "Huevo"
- Los valores nutricionales ya vienen multiplicados desde el backend

### Colores Distintivos
- **Desayuno**: RGB(255, 193, 7) - Amarillo
- **Snack**: RGB(156, 39, 176) - Morado
- **Comida**: RGB(244, 67, 54) - Rojo
- **Cena**: RGB(63, 81, 181) - Azul

### Formato de Tablas
- **Theme**: Striped (rayado) para mejor legibilidad
- **Font Size**: 9pt para contenido, 11pt para títulos
- **Padding**: 3pt para celdas
- **Alignment**: Centrado para valores numéricos

## Código de Implementación

### Servicio de PDF (`pdfService.js`)

```javascript
export const generarPDFPlanDietético = (planInfo, comidas, resumen, pacienteInfo) => {
  const doc = new jsPDF()
  
  // 1. Encabezado
  doc.setFillColor(76, 175, 80)
  doc.rect(0, 0, 210, 40, 'F')
  doc.text('NUTRITRACK', 105, 20, { align: 'center' })
  
  // 2. Información del paciente
  doc.text(`Paciente: ${pacienteInfo.nombre}`, 20, yPos)
  
  // 3. Resumen nutricional
  doc.autoTable({ body: resumenData })
  
  // 4. Comidas por tipo
  tiposComida.forEach(({ tipo, nombre, color }) => {
    const comidasTipo = comidas.filter(c => c.mealType === tipo)
    doc.autoTable({
      head: [['Comida', 'Calorías', 'Proteínas', 'Carbohidratos', 'Grasas']],
      body: rows
    })
  })
  
  // 5. Guardar
  doc.save(fileName)
}
```

### Integración en Componente

```javascript
// En GestionComidas.vue
import { generarPDFPlanDietético } from '@/services/pdfService'

async exportarPDF() {
  // Obtener datos del plan y paciente
  const planResponse = await api.get(`/diet-plans/${this.planId}`)
  const pacienteResponse = await api.get(`/users/${planResponse.data.patientId}`)
  
  // Generar PDF
  generarPDFPlanDietético(planInfo, this.comidas, this.resumen, pacienteInfo)
  
  // Notificar éxito
  this.mostrarExito('✅ PDF generado correctamente')
}
```

## Beneficios

1. **Para Nutricionistas**:
   - Genera documentos profesionales en segundos
   - No necesita software externo
   - Formato consistente y de calidad

2. **Para Pacientes**:
   - Reciben documento imprimible claro
   - Pueden tenerlo en casa como referencia
   - Incluye toda la información nutricional necesaria

3. **Para el Sistema**:
   - No requiere procesamiento en servidor
   - Generación instantánea en el navegador
   - Reduce carga del backend

## Mejoras Futuras

- [ ] Agregar gráficas de distribución de macronutrientes
- [ ] Incluir recomendaciones personalizadas
- [ ] Agregar logo personalizado del nutricionista
- [ ] Opción de incluir/excluir secciones
- [ ] Plantillas de diseño alternativas
- [ ] Exportar múltiples días en un solo PDF
- [ ] Incluir código QR con link al plan digital
