import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'

export const generarPDFPlanDietético = (planInfo, comidas, resumen, pacienteInfo) => {
  console.log('🎨 === GENERANDO PDF ===')
  console.log('📋 planInfo:', planInfo)
  console.log('🍽️ comidas:', comidas)
  console.log('📊 resumen:', resumen)
  console.log('👤 pacienteInfo:', pacienteInfo)
  
  const doc = new jsPDF()
  
  // Configuración de colores de NutriTrack
  const colorVerde = [139, 195, 74]      // #8BC34A (Verde primario)
  const colorAzul = [95, 195, 228]       // #5FC3E4 (Sky Blue)
  const colorRojo = [231, 76, 60]        // #E74C3C (Rojo)
  const colorNavy = [122, 122, 90]       // #7A7A5A (Navy)
  const colorTexto = [50, 50, 50]
  const colorGris = [120, 120, 120]
  
  let yPos = 15
  
  // ============ ENCABEZADO CON LOGO ============
  // Fondo degradado (simulado con dos rectángulos)
  doc.setFillColor(139, 195, 74)  // Verde
  doc.rect(0, 0, 105, 40, 'F')
  
  doc.setFillColor(95, 195, 228)  // Azul
  doc.rect(105, 0, 105, 40, 'F')
  
  // Borde superior
  doc.setFillColor(56, 142, 60)
  doc.rect(0, 0, 210, 3, 'F')
  
  // Logo simple circular (gota estilizada)
  doc.setFillColor(255, 255, 255)
  doc.circle(25, 20, 8, 'F')
  doc.setFillColor(139, 195, 74)
  doc.circle(25, 20, 6, 'F')
  
  // Texto NutriTrack
  doc.setTextColor(255, 255, 255)
  doc.setFontSize(24)
  doc.setFont('helvetica', 'bold')
  doc.text('NutriTrack', 38, 20)
  
  doc.setFontSize(10)
  doc.setFont('helvetica', 'normal')
  doc.text('MONITOREO NUTRICIONAL', 35, 27)
  
  doc.setFontSize(12)
  doc.setFont('helvetica', 'bold')
  doc.text('Plan Dietético Personalizado', 35, 34)
  
  doc.setFontSize(8)
  doc.setFont('helvetica', 'normal')
  doc.text(new Date().toLocaleDateString('es-ES', { 
    year: 'numeric', month: 'long', day: 'numeric' 
  }), 200, 34, { align: 'right' })
  
  yPos = 47
  
  // ============ INFORMACIÓN DEL PACIENTE Y PLAN (COMPACTA) ============
  doc.setFillColor(245, 245, 245)
  doc.roundedRect(10, yPos, 190, 32, 2, 2, 'F')
  doc.setDrawColor(200, 200, 200)
  doc.setLineWidth(0.2)
  doc.roundedRect(10, yPos, 190, 32, 2, 2, 'S')
  
  yPos += 5
  
  // Columna 1: Datos del paciente
  doc.setTextColor(...colorVerde)
  doc.setFontSize(9)
  doc.setFont('helvetica', 'bold')
  doc.text('PACIENTE', 15, yPos)
  
  yPos += 5
  doc.setTextColor(...colorTexto)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(8)
  
  if (pacienteInfo && pacienteInfo.nombre) {
    doc.text(`Nombre: ${pacienteInfo.nombre}`, 15, yPos)
    yPos += 4
  }
  
  if (pacienteInfo && pacienteInfo.email) {
    doc.text(`Email: ${pacienteInfo.email}`, 15, yPos)
    yPos += 4
  }
  
  if (pacienteInfo && pacienteInfo.peso) {
    doc.setFont('helvetica', 'bold')
    doc.text(`Peso actual: ${pacienteInfo.peso} kg`, 15, yPos)
  }
  
  // Columna 2: Datos del plan
  yPos = 47
  doc.setTextColor(...colorVerde)
  doc.setFontSize(9)
  doc.setFont('helvetica', 'bold')
  doc.text('PLAN DIETETICO', 110, yPos)
  
  yPos += 5
  doc.setTextColor(...colorTexto)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(8)
  
  const planNombre = doc.splitTextToSize(planInfo.nombre || 'Plan Dietetico', 85)
  doc.text(`Plan: ${planNombre[0]}`, 110, yPos)
  yPos += 4
  
  if (planInfo.objetivo) {
    const objetivo = doc.splitTextToSize(planInfo.objetivo, 85)
    doc.text(`Objetivo: ${objetivo[0]}`, 110, yPos)
    yPos += 4
  }
  
  if (planInfo.calorias) {
    doc.setFont('helvetica', 'bold')
    doc.text(`Meta: ${planInfo.calorias} kcal/dia`, 110, yPos)
  }
  
  yPos = 80
  
  // ============ RESUMEN NUTRICIONAL COMPACTO ============
  doc.setFillColor(...colorAzul)
  doc.roundedRect(10, yPos, 190, 8, 2, 2, 'F')
  
  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(10)
  doc.text('RESUMEN NUTRICIONAL DIARIO', 15, yPos + 5.5)
  
  yPos += 12
  
  // Tabla compacta de resumen
  autoTable(doc, {
    startY: yPos,
    body: [[
      `CALORIAS\n${resumen.totalCalories || 0} kcal`,
      `PROTEINAS\n${(resumen.totalProtein || 0).toFixed(1)} g`,
      `CARBOS\n${(resumen.totalCarbs || 0).toFixed(1)} g`,
      `GRASAS\n${(resumen.totalFat || 0).toFixed(1)} g`,
      `FIBRA\n${(resumen.totalFiber || 0).toFixed(1)} g`,
      `COMIDAS\n${comidas.length}`
    ]],
    theme: 'plain',
    margin: { left: 15, right: 15 },
    styles: {
      fontSize: 8,
      cellPadding: 4,
      textColor: colorTexto,
      halign: 'center',
      valign: 'middle',
      fontStyle: 'bold'
    },
    columnStyles: {
      0: { fillColor: [255, 235, 238] },      // Calorías - rosa claro
      1: { fillColor: [232, 245, 233] },      // Proteínas - verde claro
      2: { fillColor: [227, 242, 253] },      // Carbos - azul claro
      3: { fillColor: [255, 243, 224] },      // Grasas - naranja claro
      4: { fillColor: [237, 247, 237] },      // Fibra - verde muy claro
      5: { fillColor: [248, 248, 248] }       // Comidas - gris claro
    }
  })
  
  yPos = doc.lastAutoTable.finalY + 10
  
  // ============ COMIDAS POR TIPO (COMPACTO) ============
  const tiposComida = [
    { tipo: 'BREAKFAST', nombre: 'DESAYUNO', color: [255, 193, 7] },
    { tipo: 'SNACK', nombre: 'SNACK', color: [156, 39, 176] },
    { tipo: 'LUNCH', nombre: 'COMIDA', color: [244, 67, 54] },
    { tipo: 'DINNER', nombre: 'CENA', color: [63, 81, 181] }
  ]
  
  tiposComida.forEach(({ tipo, nombre, color }) => {
    const comidasTipo = comidas.filter(c => c.mealType === tipo)
    
    if (comidasTipo.length === 0) return
    
    // Verificar espacio
    if (yPos > 250) {
      doc.addPage()
      yPos = 20
    }
    
    // Encabezado compacto
    doc.setFillColor(...color)
    doc.roundedRect(10, yPos, 190, 7, 1, 1, 'F')
    
    doc.setTextColor(255, 255, 255)
    doc.setFont('helvetica', 'bold')
    doc.setFontSize(9)
    doc.text(nombre, 15, yPos + 5)
    
    yPos += 10
    
    // Tabla compacta de comidas
    const rows = comidasTipo.map(comida => {
      const servings = comida.servings > 1 ? `${comida.servings}x ` : ''
      return [
        `${servings}${comida.mealName}`,
        `${comida.calories || 0}`,
        `${(comida.proteinGrams || 0).toFixed(1)}`,
        `${(comida.carbsGrams || 0).toFixed(1)}`,
        `${(comida.fatGrams || 0).toFixed(1)}`
      ]
    })
    
    autoTable(doc, {
      startY: yPos,
      head: [['Comida', 'Cal', 'Prot', 'Carb', 'Gras']],
      body: rows,
      theme: 'striped',
      margin: { left: 15, right: 15 },
      headStyles: {
        fillColor: color,
        textColor: [255, 255, 255],
        fontStyle: 'bold',
        fontSize: 8,
        halign: 'center',
        cellPadding: 2
      },
      styles: {
        fontSize: 8,
        cellPadding: 2,
        textColor: colorTexto
      },
      alternateRowStyles: {
        fillColor: [252, 252, 252]
      },
      columnStyles: {
        0: { cellWidth: 90, fontStyle: 'bold' },
        1: { cellWidth: 22, halign: 'center' },
        2: { cellWidth: 22, halign: 'center' },
        3: { cellWidth: 22, halign: 'center' },
        4: { cellWidth: 22, halign: 'center' }
      },
      margin: { left: 20, right: 20 }
    })
    
    yPos = doc.lastAutoTable.finalY + 12
    
    // Agregar detalles de comidas con diseño mejorado
    console.log(`📝 Procesando ${comidasTipo.length} comidas para detalles`)
    comidasTipo.forEach((comida, index) => {
      console.log(`  Comida ${index + 1} - ESTRUCTURA COMPLETA:`, comida)
      console.log(`  Campos disponibles:`, Object.keys(comida))
      console.log(`  Valores específicos:`, {
        mealName: comida.mealName,
        description: comida.description,
        ingredients: comida.ingredients,
        instructions: comida.instructions,
        // Campos alternativos que podrían existir
        foodDescription: comida.foodDescription,
        foodIngredients: comida.foodIngredients,
        foodInstructions: comida.foodInstructions,
        preparationTime: comida.preparationTime,
        notes: comida.notes
      })
      
      if (comida.description || comida.ingredients || comida.instructions || 
          comida.foodDescription || comida.foodIngredients || comida.foodInstructions) {
        // Verificar espacio - más conservador
        if (yPos > 240) {
          doc.addPage()
          yPos = 20
        }
        
        // Título de la comida
        doc.setTextColor(...colorPrimario)
        doc.setFont('helvetica', 'bold')
        doc.setFontSize(10)
        const servings = comida.servings > 1 ? `${comida.servings}x ` : ''
        doc.text(`> ${servings}${comida.mealName}`, 25, yPos)
        yPos += 6
        
        doc.setTextColor(...colorTexto)
        doc.setFont('helvetica', 'normal')
        doc.setFontSize(9)
        
        // Descripción (de la comida en el plan)
        const descripcion = comida.description || comida.foodDescription
        if (descripcion) {
          const descripcionLines = doc.splitTextToSize(descripcion, 165)
          // Verificar si cabe en la página
          if (yPos + (descripcionLines.length * 5) > 280) {
            doc.addPage()
            yPos = 20
          }
          doc.text(descripcionLines, 28, yPos)
          yPos += (descripcionLines.length * 5) + 2
        }
        
        // Ingredientes (del alimento en la base de datos)
        const ingredientes = comida.ingredients || comida.foodIngredients
        if (ingredientes) {
          // Verificar espacio
          if (yPos > 260) {
            doc.addPage()
            yPos = 20
          }
          
          doc.setTextColor(...colorSecundario)
          doc.setFont('helvetica', 'bold')
          doc.setFontSize(8)
          doc.text('INGREDIENTES:', 28, yPos)
          yPos += 5
          
          doc.setTextColor(...colorTexto)
          doc.setFont('helvetica', 'normal')
          const ingredientesLines = doc.splitTextToSize(ingredientes, 160)
          
          // Verificar si cabe
          if (yPos + (ingredientesLines.length * 4) > 280) {
            doc.addPage()
            yPos = 20
          }
          
          doc.text(ingredientesLines, 31, yPos)
          yPos += (ingredientesLines.length * 4) + 2
        }
        
        // Instrucciones (del alimento en la base de datos)
        const instrucciones = comida.instructions || comida.foodInstructions
        if (instrucciones) {
          // Verificar espacio
          if (yPos > 260) {
            doc.addPage()
            yPos = 20
          }
          
          doc.setTextColor(...colorSecundario)
          doc.setFont('helvetica', 'bold')
          doc.setFontSize(8)
          doc.text('PREPARACION:', 28, yPos)
          yPos += 5
          
          doc.setTextColor(...colorTexto)
          doc.setFont('helvetica', 'normal')
          const instruccionesLines = doc.splitTextToSize(instrucciones, 160)
          
          // Verificar si cabe
          if (yPos + (instruccionesLines.length * 4) > 280) {
            doc.addPage()
            yPos = 20
          }
          
          doc.text(instruccionesLines, 31, yPos)
          yPos += (instruccionesLines.length * 4) + 2
        }
        
        // Línea separadora sutil
        if (yPos < 270) {
          doc.setDrawColor(230, 230, 230)
          doc.setLineWidth(0.3)
          doc.line(25, yPos + 2, 190, yPos + 2)
          yPos += 8
        } else {
          yPos += 4
        }
      }
    })
    
    yPos += 8
  })
  
  // ============ PIE DE PÁGINA MEJORADO ============
  const totalPages = doc.internal.getNumberOfPages()
  
  for (let i = 1; i <= totalPages; i++) {
    doc.setPage(i)
    
    // Línea decorativa superior del pie
    doc.setDrawColor(200, 200, 200)
    doc.setLineWidth(0.5)
    doc.line(20, 280, 190, 280)
    
    // Número de página
    doc.setFontSize(8)
    doc.setTextColor(...colorGris)
    doc.setFont('helvetica', 'normal')
    doc.text(
      `Pagina ${i} de ${totalPages}`,
      105,
      286,
      { align: 'center' }
    )
    
    // Nombre del sistema
    doc.setFont('helvetica', 'bold')
    doc.setTextColor(...colorVerde)
    doc.text(
      'NUTRITRACK',
      105,
      291,
      { align: 'center' }
    )
    
    // Subtítulo
    doc.setFont('helvetica', 'normal')
    doc.setFontSize(7)
    doc.setTextColor(...colorGris)
    doc.text(
      'Sistema de Gestion Nutricional',
      105,
      295,
      { align: 'center' }
    )
  }
  
  // ============ GUARDAR PDF ============
  const fileName = `Plan_Dietetico_${planInfo.nombre?.replace(/\s+/g, '_') || 'Plan'}_${new Date().getTime()}.pdf`
  doc.save(fileName)
  
  return fileName
}
