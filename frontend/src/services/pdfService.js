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

// Función para generar encabezado compacto y moderno
export const generarEncabezadoPDF = async (doc, subtitulo, nutricionistaInfo = null) => {
  // Fondo principal más compacto
  doc.setFillColor(139, 195, 74)  // Verde NutriTrack
  doc.rect(0, 0, 210, 48, 'F')
  
  // Borde superior elegante
  doc.setFillColor(44, 62, 80)  // Navy
  doc.rect(0, 0, 210, 3, 'F')
  
  // Cargar logo más pequeño
  const logoPNG = await cargarLogoOptimizado()
  
  if (logoPNG) {
    try {
      doc.addImage(logoPNG, 'PNG', 5, 6, 70, 35)
    } catch (error) {
      console.warn('Logo PNG falló, usando vectorial')
      dibujarLogoVectorial(doc)
    }
  } else {
    dibujarLogoVectorial(doc)
  }
  
  // Texto principal del encabezado más compacto
  doc.setTextColor(255, 255, 255)
  doc.setFontSize(14)
  doc.setFont('helvetica', 'bold')
  doc.text('Sistema NutriTrack - Gestión Nutricional', 82, 15)
  
  // Subtítulo
  doc.setFontSize(11)
  doc.setFont('helvetica', 'bold')
  doc.setTextColor(255, 255, 255)
  doc.text(subtitulo, 82, 22)
  
  // Información profesional del nutricionista más compacta
  if (nutricionistaInfo) {
    doc.setFontSize(7.5)
    doc.setFont('helvetica', 'normal')
    let yNutri = 26
    
    // Nombre del nutricionista
    if (nutricionistaInfo.firstName || nutricionistaInfo.lastName) {
      yNutri += 3.5
      const nombreCompleto = `${nutricionistaInfo.firstName || ''} ${nutricionistaInfo.lastName || ''}`.trim()
      doc.setFont('helvetica', 'bold')
      doc.text(nombreCompleto, 82, yNutri)
      doc.setFont('helvetica', 'normal')
    }
    
    if (nutricionistaInfo.degree) {
      yNutri += 3
      doc.text(nutricionistaInfo.degree, 82, yNutri)
    }
    
    if (nutricionistaInfo.university || nutricionistaInfo.professionalLicense) {
      yNutri += 3
      const infoExtra = []
      if (nutricionistaInfo.university) infoExtra.push(nutricionistaInfo.university)
      if (nutricionistaInfo.professionalLicense) infoExtra.push(`Cédula: ${nutricionistaInfo.professionalLicense}`)
      const textoCompleto = infoExtra.join(' | ')
      const textoRecortado = doc.splitTextToSize(textoCompleto, 110)
      doc.text(textoRecortado[0], 82, yNutri)
    }
    
    // Teléfono y dirección en línea compacta
    if (nutricionistaInfo.phone || nutricionistaInfo.address) {
      yNutri += 3
      const contacto = []
      if (nutricionistaInfo.phone) contacto.push(`Tel: ${nutricionistaInfo.phone}`)
      if (nutricionistaInfo.address) contacto.push(nutricionistaInfo.address)
      const textoContacto = contacto.join(' • ')
      const contactoRecortado = doc.splitTextToSize(textoContacto, 110)
      doc.text(contactoRecortado[0], 82, yNutri)
    }
  }
  
  // Fecha más compacta
  doc.setFontSize(7.5)
  doc.setFont('helvetica', 'normal')
  doc.setTextColor(255, 255, 255)
  doc.text(new Date().toLocaleDateString('es-ES', { 
    year: 'numeric', month: 'long', day: 'numeric' 
  }), 198, 45, { align: 'right' })
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
  
  let yPos = 52
  
  // ============ INFORMACIÓN DEL PACIENTE Y PLAN (ULTRA COMPACTA) ============
  doc.setFillColor(248, 248, 248)
  doc.roundedRect(10, yPos, 190, 22, 2, 2, 'F')
  doc.setDrawColor(139, 195, 74)
  doc.setLineWidth(0.3)
  doc.roundedRect(10, yPos, 190, 22, 2, 2, 'S')
  
  const yBase = yPos + 4
  
  // Columna 1: Datos del paciente (más compacta)
  let yPaciente = yBase
  doc.setTextColor(...colorVerde)
  doc.setFontSize(8)
  doc.setFont('helvetica', 'bold')
  doc.text('PACIENTE', 14, yPaciente)
  
  yPaciente += 4
  doc.setTextColor(...colorTexto)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(7.5)
  
  if (pacienteInfo && pacienteInfo.nombre) {
    doc.text(`Nombre: ${pacienteInfo.nombre}`, 14, yPaciente)
    yPaciente += 3.5
  }
  
  if (pacienteInfo && pacienteInfo.email) {
    doc.text(`Email: ${pacienteInfo.email}`, 14, yPaciente)
    yPaciente += 3.5
  }
  
  if (pacienteInfo && pacienteInfo.peso) {
    doc.setFont('helvetica', 'bold')
    doc.text(`Peso actual: ${pacienteInfo.peso} kg`, 14, yPaciente)
  }
  
  // Columna 2: Datos del plan (más compacta)
  let yPlan = yBase
  doc.setTextColor(...colorVerde)
  doc.setFontSize(8)
  doc.setFont('helvetica', 'bold')
  doc.text('PLAN DIETÉTICO', 105, yPlan)
  
  yPlan += 4
  doc.setTextColor(...colorTexto)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(7.5)
  
  const planNombre = doc.splitTextToSize(planInfo.nombre || 'Plan Dietético', 90)
  doc.text(`Plan: ${planNombre[0]}`, 105, yPlan)
  yPlan += 3.5
  
  if (planInfo.objetivo) {
    const objetivo = doc.splitTextToSize(planInfo.objetivo, 90)
    doc.text(`Objetivo: ${objetivo[0]}`, 105, yPlan)
    yPlan += 3.5
  }
  
  if (planInfo.calorias) {
    doc.setFont('helvetica', 'bold')
    doc.text(`Meta: ${planInfo.calorias} kcal/día`, 105, yPlan)
  }
  
  yPos = 77
  
  // ============ RESUMEN NUTRICIONAL ULTRA COMPACTO ============
  doc.setFillColor(...colorAzul)
  doc.roundedRect(10, yPos, 190, 6, 2, 2, 'F')
  
  doc.setTextColor(255, 255, 255)
  doc.setFont('helvetica', 'bold')
  doc.setFontSize(9)
  doc.text('RESUMEN NUTRICIONAL DIARIO', 15, yPos + 4.5)
  
  yPos += 9
  
  // Tabla ultra compacta de resumen con diseño moderno
  autoTable(doc, {
    startY: yPos,
    body: [[
      `CALORÍAS\n${resumen.totalCalories || 0} kcal`,
      `PROTEÍNAS\n${(resumen.totalProtein || 0).toFixed(1)} g`,
      `CARBOS\n${(resumen.totalCarbs || 0).toFixed(1)} g`,
      `GRASAS\n${(resumen.totalFat || 0).toFixed(1)} g`,
      `FIBRA\n${(resumen.totalFiber || 0).toFixed(1)} g`,
      `COMIDAS\n${comidas.length}`
    ]],
    theme: 'plain',
    margin: { left: 12, right: 12 },
    styles: {
      fontSize: 7.5,
      cellPadding: 3,
      textColor: colorTexto,
      halign: 'center',
      valign: 'middle',
      fontStyle: 'bold',
      lineWidth: 0.1,
      lineColor: [220, 220, 220]
    },
    columnStyles: {
      0: { fillColor: [255, 239, 243], textColor: [194, 24, 91] },      // Calorías - rosa
      1: { fillColor: [232, 245, 233], textColor: [76, 175, 80] },      // Proteínas - verde
      2: { fillColor: [227, 242, 253], textColor: [33, 150, 243] },     // Carbos - azul
      3: { fillColor: [255, 243, 224], textColor: [255, 152, 0] },      // Grasas - naranja
      4: { fillColor: [237, 247, 237], textColor: [104, 159, 56] },     // Fibra - verde olivo
      5: { fillColor: [245, 245, 245], textColor: [97, 97, 97] }        // Comidas - gris
    }
  })
  
  yPos = doc.lastAutoTable.finalY + 8
  
  // ============ COMIDAS POR TIPO (ULTRA COMPACTO Y MODERNO) ============
  const tiposComida = [
    { tipo: 'DESAYUNO', nombre: 'DESAYUNO', color: [255, 193, 7] },
    { tipo: 'COLACION_AM', nombre: 'COLACIÓN AM', color: [156, 39, 176] },
    { tipo: 'ALMUERZO', nombre: 'ALMUERZO', color: [244, 67, 54] },
    { tipo: 'COLACION_PM', nombre: 'COLACIÓN PM', color: [103, 58, 183] },
    { tipo: 'CENA', nombre: 'CENA', color: [63, 81, 181] }
  ]
  
  tiposComida.forEach(({ tipo, nombre, color }) => {
    const comidasTipo = comidas.filter(c => c.mealType === tipo)
    
    if (comidasTipo.length === 0) return
    
    // Verificar espacio
    if (yPos > 255) {
      doc.addPage()
      yPos = 15
    }
    
    // Encabezado ultra compacto con gradiente visual
    doc.setFillColor(...color)
    doc.roundedRect(10, yPos, 190, 5.5, 1, 1, 'F')
    
    doc.setTextColor(255, 255, 255)
    doc.setFont('helvetica', 'bold')
    doc.setFontSize(8.5)
    doc.text(nombre, 14, yPos + 4)
    
    yPos += 7.5
    
    // Tabla ultra compacta de comidas con diseño moderno
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
      head: [['Alimento', 'Cal', 'Prot', 'Carb', 'Gras']],
      body: rows,
      theme: 'striped',
      margin: { left: 12, right: 12 },
      headStyles: {
        fillColor: color,
        textColor: [255, 255, 255],
        fontStyle: 'bold',
        fontSize: 7.5,
        halign: 'center',
        cellPadding: 1.5
      },
      styles: {
        fontSize: 7.5,
        cellPadding: 1.8,
        textColor: colorTexto,
        lineWidth: 0.1,
        lineColor: [230, 230, 230]
      },
      alternateRowStyles: {
        fillColor: [250, 250, 250]
      },
      columnStyles: {
        0: { cellWidth: 100, fontStyle: 'bold', fontSize: 7.5 },
        1: { cellWidth: 18, halign: 'center' },
        2: { cellWidth: 18, halign: 'center' },
        3: { cellWidth: 18, halign: 'center' },
        4: { cellWidth: 18, halign: 'center' }
      }
    })
    
    yPos = doc.lastAutoTable.finalY + 4
    
    // Agregar detalles de comidas con diseño ultra compacto y moderno
    console.log(`📝 Procesando ${comidasTipo.length} comidas para detalles`)
    comidasTipo.forEach((comida, index) => {
      console.log(`  Comida ${index + 1} - ESTRUCTURA COMPLETA:`, comida)
      console.log(`  Campos disponibles:`, Object.keys(comida))
      console.log(`  Valores específicos:`, {
        mealName: comida.mealName,
        description: comida.description,
        ingredients: comida.ingredients,
        instructions: comida.instructions,
        foodDescription: comida.foodDescription,
        foodIngredients: comida.foodIngredients,
        foodInstructions: comida.foodInstructions,
        preparationTime: comida.preparationTime,
        notes: comida.notes
      })
      
      if (comida.description || comida.ingredients || comida.instructions || 
          comida.foodDescription || comida.foodIngredients || comida.foodInstructions) {
        // Verificar espacio de forma más eficiente
        if (yPos > 250) {
          doc.addPage()
          yPos = 15
        }
        
        // Título de la comida más compacto
        doc.setTextColor(...colorVerde)
        doc.setFont('helvetica', 'bold')
        doc.setFontSize(8)
        const servings = comida.servings > 1 ? `${comida.servings}x ` : ''
        doc.text(`${servings}${comida.mealName}`, 20, yPos)
        yPos += 4.5
        
        doc.setTextColor(...colorTexto)
        doc.setFont('helvetica', 'normal')
        doc.setFontSize(7.5)
        
        // Descripción compacta
        const descripcion = comida.description || comida.foodDescription
        if (descripcion) {
          const descripcionLines = doc.splitTextToSize(descripcion, 173)
          if (yPos + (descripcionLines.length * 3.5) > 275) {
            doc.addPage()
            yPos = 15
          }
          doc.text(descripcionLines, 23, yPos)
          yPos += (descripcionLines.length * 3.5) + 1.5
        }
        
        // Ingredientes compactos
        const ingredientes = comida.ingredients || comida.foodIngredients
        if (ingredientes) {
          if (yPos > 265) {
            doc.addPage()
            yPos = 15
          }
          
          doc.setTextColor(...colorAzul)
          doc.setFont('helvetica', 'bold')
          doc.setFontSize(7)
          doc.text('Ingredientes:', 23, yPos)
          yPos += 3.5
          
          doc.setTextColor(...colorTexto)
          doc.setFont('helvetica', 'normal')
          const ingredientesLines = doc.splitTextToSize(ingredientes, 170)
          
          if (yPos + (ingredientesLines.length * 3.2) > 275) {
            doc.addPage()
            yPos = 15
          }
          
          doc.text(ingredientesLines, 26, yPos)
          yPos += (ingredientesLines.length * 3.2) + 1.5
        }
        
        // Instrucciones compactas
        const instrucciones = comida.instructions || comida.foodInstructions
        if (instrucciones) {
          if (yPos > 265) {
            doc.addPage()
            yPos = 15
          }
          
          doc.setTextColor(...colorAzul)
          doc.setFont('helvetica', 'bold')
          doc.setFontSize(7)
          doc.text('Preparacion:', 23, yPos)
          yPos += 3.5
          
          doc.setTextColor(...colorTexto)
          doc.setFont('helvetica', 'normal')
          const instruccionesLines = doc.splitTextToSize(instrucciones, 170)
          
          if (yPos + (instruccionesLines.length * 3.2) > 275) {
            doc.addPage()
            yPos = 15
          }
          
          doc.text(instruccionesLines, 26, yPos)
          yPos += (instruccionesLines.length * 3.2) + 1.5
        }
        
        // Línea separadora ultra sutil
        if (yPos < 268) {
          doc.setDrawColor(240, 240, 240)
          doc.setLineWidth(0.2)
          doc.line(18, yPos + 1, 192, yPos + 1)
          yPos += 4
        } else {
          yPos += 2
        }
      }
    })
    
    yPos += 3
  })
  
  // ============ SECCIÓN DE FIRMA (ÚLTIMA PÁGINA) ============
  const totalPages = doc.internal.getNumberOfPages()
  doc.setPage(totalPages)
  
  // Verificar si hay espacio en la última página
  if (yPos < 240) {
    // Hay espacio en la página actual
  } else {
    // Agregar nueva página para la firma
    doc.addPage()
    yPos = 20
  }
  
  // Agregar espacio antes de la firma
  yPos = Math.max(yPos + 10, 220)
  
  // Línea para la firma
  doc.setDrawColor(100, 100, 100)
  doc.setLineWidth(0.5)
  doc.line(70, yPos, 140, yPos)
  
  // Texto "Firma del Nutriólogo"
  yPos += 5
  doc.setTextColor(80, 80, 80)
  doc.setFont('helvetica', 'normal')
  doc.setFontSize(9)
  doc.text('Firma del Nutriólogo', 105, yPos, { align: 'center' })
  
  // Nombre del nutriólogo
  if (nutricionistaInfo && (nutricionistaInfo.firstName || nutricionistaInfo.lastName)) {
    yPos += 5
    const nombreCompleto = `${nutricionistaInfo.firstName || ''} ${nutricionistaInfo.lastName || ''}`.trim()
    doc.setFont('helvetica', 'bold')
    doc.setFontSize(10)
    doc.setTextColor(...colorVerde)
    doc.text(nombreCompleto, 105, yPos, { align: 'center' })
    
    // Cédula profesional si existe
    if (nutricionistaInfo.professionalLicense) {
      yPos += 4
      doc.setFont('helvetica', 'normal')
      doc.setFontSize(8)
      doc.setTextColor(100, 100, 100)
      doc.text(`Cédula Profesional: ${nutricionistaInfo.professionalLicense}`, 105, yPos, { align: 'center' })
    }
  }
  
  // ============ PIE DE PÁGINA MODERNO Y COMPACTO ============
  for (let i = 1; i <= totalPages; i++) {
    doc.setPage(i)
    
    // Línea decorativa superior del pie con gradiente visual
    doc.setDrawColor(...colorVerde)
    doc.setLineWidth(0.8)
    doc.line(15, 281, 195, 281)
    
    // Barra de color sutil
    doc.setFillColor(248, 248, 248)
    doc.rect(0, 282, 210, 15, 'F')
    
    // Número de página (izquierda)
    doc.setFontSize(7)
    doc.setTextColor(...colorGris)
    doc.setFont('helvetica', 'normal')
    doc.text(
      `Página ${i} de ${totalPages}`,
      18,
      287
    )
    
    // Nombre del sistema (centro) - más destacado
    doc.setFont('helvetica', 'bold')
    doc.setFontSize(8.5)
    doc.setTextColor(...colorVerde)
    doc.text(
      'NUTRITRACK',
      105,
      286.5,
      { align: 'center' }
    )
    
    // Subtítulo (centro)
    doc.setFont('helvetica', 'normal')
    doc.setFontSize(6.5)
    doc.setTextColor(...colorGris)
    doc.text(
      'Sistema de Gestión Nutricional',
      105,
      290.5,
      { align: 'center' }
    )
    
    // Información de contacto (derecha)
    doc.setFontSize(6.5)
    doc.setTextColor(...colorAzul)
    doc.text(
      'www.nutritrack.com',
      192,
      287,
      { align: 'right' }
    )
    
    doc.setTextColor(...colorGris)
    doc.text(
      'contacto@nutritrack.com',
      192,
      290.5,
      { align: 'right' }
    )
  }
  
  // ============ GUARDAR PDF ============
  const fileName = `Plan_Dietetico_${planInfo.nombre?.replace(/\s+/g, '_') || 'Plan'}_${new Date().getTime()}.pdf`
  doc.save(fileName)
  
  return fileName
}
