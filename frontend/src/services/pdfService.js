import jsPDF from 'jspdf'
import autoTable from 'jspdf-autotable'

// Función para cargar logo PNG optimizada
const cargarLogoOptimizado = async () => {
  const rutasLogo = [
    '/logo/nutritrack-logo.png',               // Logo principal
    '/logo/logos_tampeq/nutritrack-logo.png',  // Logo principal optimizado
    '/logo/logos_tampeq/nutritrack-icon.png',  // Alternativa: icono optimizado
    '/logo/nutritrack-icon.png'                // Última opción: icono
  ]
  
  for (const ruta of rutasLogo) {
    try {
      console.log(`🔄 Intentando cargar: ${ruta}`)
      
      const response = await fetch(ruta, {
        cache: 'no-cache',
        mode: 'cors'
      })
      
      if (response.ok) {
        const blob = await response.blob()
        console.log(`📏 Logo cargado desde ${ruta} - Tamaño: ${(blob.size / 1024).toFixed(1)}KB`)
        
        // Verificar que sea una imagen válida
        if (blob.type.startsWith('image/')) {
          return new Promise((resolve, reject) => {
            const reader = new FileReader()
            reader.onloadend = () => {
              console.log('✅ Logo PNG cargado exitosamente')
              resolve(reader.result)
            }
            reader.onerror = () => {
              console.error('❌ Error al leer archivo PNG')
              reject(new Error('Error al leer imagen'))
            }
            reader.readAsDataURL(blob)
          })
        } else {
          console.warn(`⚠️ Archivo no es una imagen válida: ${blob.type}`)
        }
      } else {
        console.log(`❌ No encontrado (${response.status}): ${ruta}`)
      }
    } catch (error) {
      console.warn(`❌ Error con ${ruta}:`, error.message)
    }
  }
  
  console.warn('❌ No se pudo cargar ningún logo PNG')
  return null
}

// Función de respaldo para dibujar logo vectorial
const dibujarLogoVectorial = (doc) => {
  // Logo NutriTrack vectorial basado en tu diseño real
  const logoX = 25
  const logoY = 22
  
  // Fondo del logo
  doc.setFillColor(255, 255, 255)
  doc.circle(logoX, logoY, 12, 'F')
  
  // Gota/hoja principal (tu diseño)
  doc.setFillColor(168, 216, 60)  // Verde lado izquierdo
  doc.ellipse(logoX - 3, logoY, 5, 8, 'F')
  
  doc.setFillColor(93, 173, 226)   // Azul lado derecho
  doc.ellipse(logoX + 3, logoY, 5, 8, 'F')
  
  // Línea divisoria central
  doc.setFillColor(44, 62, 80)
  doc.rect(logoX - 0.5, logoY - 8, 1, 16, 'F')
  
  // Flecha de crecimiento roja
  doc.setFillColor(255, 107, 107)
  doc.setLineWidth(3)
  
  // Línea principal de la flecha (zigzag como en tu diseño)
  doc.line(logoX - 6, logoY + 4, logoX - 2, logoY - 2)
  doc.line(logoX - 2, logoY - 2, logoX + 2, logoY + 1)
  doc.line(logoX + 2, logoY + 1, logoX + 6, logoY - 6)
  
  // Punta de la flecha
  doc.line(logoX + 4, logoY - 4, logoX + 6, logoY - 6)
  doc.line(logoX + 6, logoY - 6, logoX + 8, logoY - 4)
  
  // Contorno negro
  doc.setDrawColor(44, 62, 80)
  doc.setLineWidth(2)
  doc.circle(logoX, logoY, 12, 'D')
}

// Función para generar encabezado estandarizado
export const generarEncabezadoPDF = async (doc, subtitulo, nutricionistaInfo = null) => {
  // Fondo principal
  doc.setFillColor(139, 195, 74)  // Verde NutriTrack
  doc.rect(0, 0, 210, 50, 'F')
  
  // Borde superior elegante
  doc.setFillColor(44, 62, 80)  // Navy
  doc.rect(0, 0, 210, 4, 'F')
  
  // Cargar logo
  const logoPNG = await cargarLogoOptimizado()
  
  if (logoPNG) {
    try {
      doc.addImage(logoPNG, 'PNG', 3, 7, 75, 37)
    } catch (error) {
      console.warn('Logo PNG falló, usando vectorial')
      dibujarLogoVectorial(doc)
    }
  } else {
    dibujarLogoVectorial(doc)
  }
  
  // Texto principal del encabezado
  doc.setTextColor(255, 255, 255)
  doc.setFontSize(16)
  doc.setFont('helvetica', 'bold')
  doc.text('Sistema NutriTrack - Gestión Nutricional', 85, 18)
  
  // Subtítulo
  doc.setFontSize(13)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(255, 255, 255)
  doc.text(subtitulo, 85, 27)
  
  // Información profesional del nutricionista
  if (nutricionistaInfo) {
    doc.setFontSize(9)
    doc.setFont('helvetica', 'normal')
    let yNutri = 31
    
    // Nombre del nutricionista
    if (nutricionistaInfo.firstName || nutricionistaInfo.lastName) {
      yNutri += 4.5
      const nombreCompleto = `${nutricionistaInfo.firstName || ''} ${nutricionistaInfo.lastName || ''}`.trim()
      doc.setFont('helvetica', 'bold')
      doc.text(nombreCompleto, 85, yNutri)
      doc.setFont('helvetica', 'normal')
    }
    
    if (nutricionistaInfo.degree) {
      yNutri += 3.5
      doc.text(nutricionistaInfo.degree, 85, yNutri)
    }
    
    if (nutricionistaInfo.university || nutricionistaInfo.professionalLicense) {
      yNutri += 3.5
      const infoExtra = []
      if (nutricionistaInfo.university) infoExtra.push(nutricionistaInfo.university)
      if (nutricionistaInfo.professionalLicense) infoExtra.push(`Cédula: ${nutricionistaInfo.professionalLicense}`)
      doc.text(infoExtra.join(' | '), 85, yNutri)
    }
    
    // Teléfono y dirección
    if (nutricionistaInfo.phone || nutricionistaInfo.address) {
      yNutri += 3.5
      if (nutricionistaInfo.phone) {
        doc.text(`Tel: ${nutricionistaInfo.phone}`, 85, yNutri)
      }
      if (nutricionistaInfo.address) {
        if (nutricionistaInfo.phone) yNutri += 3.5
        doc.text(nutricionistaInfo.address, 85, yNutri)
      }
    }
  }
  
  // Fecha
  doc.setFontSize(9)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(255, 255, 255)
  doc.text(new Date().toLocaleDateString('es-ES', { 
    year: 'numeric', month: 'long', day: 'numeric' 
  }), 195, 47, { align: 'right' })
}

export const generarPDFPlanDietético = async (planInfo, comidas, resumen, pacienteInfo, nutricionistaInfo = null) => {
  console.log('🎨 === GENERANDO PDF ===')
  console.log('📋 planInfo:', planInfo)
  console.log('🍽️ comidas:', comidas)
  console.log('📊 resumen:', resumen)
  console.log('👤 pacienteInfo:', pacienteInfo)
  console.log('👨‍⚕️ nutricionistaInfo:', nutricionistaInfo)
  
  const doc = new jsPDF()
  
  // Configuración de colores de NutriTrack
  const colorVerde = [139, 195, 74]      // #8BC34A (Verde primario)
  const colorAzul = [95, 195, 228]       // #5FC3E4 (Sky Blue)
  const colorRojo = [231, 76, 60]        // #E74C3C (Rojo)
  const colorNavy = [122, 122, 90]       // #7A7A5A (Navy)
  const colorTexto = [50, 50, 50]
  const colorGris = [120, 120, 120]
  
  // ============ ENCABEZADO ESTANDARIZADO ============
  await generarEncabezadoPDF(doc, 'Plan Dietético Personalizado', nutricionistaInfo)
  
  let yPos = 55
  
  // ============ INFORMACIÓN DEL PACIENTE Y PLAN (COMPACTA) ============
  doc.setFillColor(245, 245, 245)
  doc.roundedRect(10, yPos, 190, 28, 2, 2, 'F')
  doc.setDrawColor(200, 200, 200)
  doc.setLineWidth(0.2)
  doc.roundedRect(10, yPos, 190, 28, 2, 2, 'S')
  
  const yBase = yPos + 5
  
  // Columna 1: Datos del paciente
  let yPaciente = yBase
  doc.setTextColor(...colorVerde)
  doc.setFontSize(9)
  doc.setFont('helvetica', 'bold')
  doc.text('PACIENTE', 15, yPaciente)
  
  yPaciente += 5
  doc.setTextColor(...colorTexto)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(8)
  
  if (pacienteInfo && pacienteInfo.nombre) {
    doc.text(`Nombre: ${pacienteInfo.nombre}`, 15, yPaciente)
    yPaciente += 4
  }
  
  if (pacienteInfo && pacienteInfo.email) {
    doc.text(`Email: ${pacienteInfo.email}`, 15, yPaciente)
    yPaciente += 4
  }
  
  if (pacienteInfo && pacienteInfo.peso) {
    doc.setFont('helvetica', 'bold')
    doc.text(`Peso actual: ${pacienteInfo.peso} kg`, 15, yPaciente)
  }
  
  // Columna 2: Datos del plan
  let yPlan = yBase
  doc.setTextColor(...colorVerde)
  doc.setFontSize(9)
  doc.setFont('helvetica', 'bold')
  doc.text('PLAN DIETETICO', 110, yPlan)
  
  yPlan += 5
  doc.setTextColor(...colorTexto)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(8)
  
  const planNombre = doc.splitTextToSize(planInfo.nombre || 'Plan Dietetico', 85)
  doc.text(`Plan: ${planNombre[0]}`, 110, yPlan)
  yPlan += 4
  
  if (planInfo.objetivo) {
    const objetivo = doc.splitTextToSize(planInfo.objetivo, 85)
    doc.text(`Objetivo: ${objetivo[0]}`, 110, yPlan)
    yPlan += 4
  }
  
  if (planInfo.calorias) {
    doc.setFont('helvetica', 'bold')
    doc.text(`Meta: ${planInfo.calorias} kcal/dia`, 110, yPlan)
  }
  
  yPos = 90
  
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
        doc.setTextColor(...colorVerde)
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
          
          doc.setTextColor(...colorAzul)
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
          
          doc.setTextColor(...colorAzul)
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
    
    // Página web
    doc.setFontSize(7)
    doc.setTextColor(...colorAzul)
    doc.text(
      'www.nutritrack.com',
      195,
      295,
      { align: 'right' }
    )
  }
  
  // ============ GUARDAR PDF ============
  const fileName = `Plan_Dietetico_${planInfo.nombre?.replace(/\s+/g, '_') || 'Plan'}_${new Date().getTime()}.pdf`
  doc.save(fileName)
  
  return fileName
}
