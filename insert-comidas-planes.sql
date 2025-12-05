-- ============================================================================
-- SCRIPT PARA INSERTAR COMIDAS EN LOS PLANES DE DIETA
-- ============================================================================
-- Agrega comidas específicas para cada plan de dieta de los pacientes
-- Cada plan incluye: Desayuno, Colación AM, Almuerzo, Colación PM, Cena
-- ============================================================================

-- ============================================================================
-- PLAN 1: Ana Martínez - Plan Vegetariano Balanceado (1600 cal/día)
-- ============================================================================

-- Desayuno (400 cal)
INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(1, 'DESAYUNO', 'Avena con Frutas y Almendras', 'Bowl de avena nutritivo y energizante', 'Avena en hojuelas 1 taza, Plátano 1 pieza, Almendras 30g, Leche descremada 1 taza, Canela al gusto', '1. Cocinar la avena con leche descremada\n2. Agregar plátano en rodajas\n3. Espolvorear almendras troceadas\n4. Añadir canela al gusto', 400, 15, 68, 12, 10, 1, 15, NOW());

-- Colación AM (150 cal)
INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(1, 'COLACION_AM', 'Manzana con Yogurt', 'Snack ligero y refrescante', 'Manzana 1 pieza, Yogurt natural sin azúcar 1/2 taza', '1. Cortar la manzana en rebanadas\n2. Servir con yogurt natural', 150, 5, 30, 2, 5, 1, 5, NOW());

-- Almuerzo (500 cal)
INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(1, 'ALMUERZO', 'Ensalada de Lentejas con Vegetales', 'Plato principal vegetariano completo', 'Lentejas cocidas 150g, Espinaca fresca 100g, Aguacate 1/4 pieza, Brócoli al vapor 100g, Aceite de oliva 1 cucharada, Limón al gusto', '1. Mezclar lentejas cocidas con espinaca fresca\n2. Agregar brócoli al vapor\n3. Añadir aguacate en cubos\n4. Aliñar con aceite de oliva y limón', 500, 25, 60, 15, 15, 1, 20, NOW());

-- Colación PM (200 cal)
INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(1, 'COLACION_PM', 'Smoothie Verde', 'Bebida nutritiva y energizante', 'Espinaca 50g, Plátano 1/2 pieza, Leche de almendras 1 taza, Proteína vegetal 1 scoop', '1. Licuar todos los ingredientes\n2. Servir frío', 200, 15, 25, 5, 4, 1, 5, NOW());

-- Cena (350 cal)
INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(1, 'CENA', 'Tofu al Horno con Verduras', 'Cena ligera y nutritiva', 'Tofu 150g, Brócoli 100g, Pimientos asados 100g, Aceite de oliva 1 cucharadita, Especias al gusto', '1. Marinar el tofu con especias\n2. Hornear a 180°C por 20 minutos\n3. Servir con brócoli y pimientos asados', 350, 20, 25, 18, 8, 1, 30, NOW());

-- ============================================================================
-- PLAN 2: Roberto Sánchez - Plan DASH Modificado (1800 cal/día)
-- ============================================================================

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(2, 'DESAYUNO', 'Huevos Revueltos con Avena', 'Desayuno alto en proteína y bajo en sodio', 'Huevos 2 piezas, Avena 1/2 taza, Espinaca 50g, Pan integral 1 rebanada', '1. Revolver huevos con espinaca\n2. Cocinar sin sal, usar especias\n3. Servir con avena cocida y pan integral', 420, 25, 45, 15, 7, 1, 15, NOW()),
(2, 'COLACION_AM', 'Naranja y Almendras', 'Snack saludable bajo en sodio', 'Naranja 1 pieza, Almendras sin sal 20g', '1. Pelar y comer la naranja\n2. Acompañar con almendras', 180, 5, 20, 10, 5, 1, 2, NOW()),
(2, 'ALMUERZO', 'Pechuga de Pollo con Arroz Integral', 'Comida balanceada baja en sodio', 'Pechuga de pollo 150g, Arroz integral 100g cocido, Brócoli al vapor 150g, Aceite de oliva 1 cucharadita', '1. Cocinar pollo sin sal, usar limón y especias\n2. Servir con arroz integral y brócoli\n3. Rociar con aceite de oliva', 550, 45, 55, 12, 8, 1, 30, NOW()),
(2, 'COLACION_PM', 'Yogurt con Fresas', 'Colación refrescante', 'Yogurt natural sin azúcar 1 taza, Fresas 100g', '1. Lavar y cortar fresas\n2. Mezclar con yogurt', 150, 10, 20, 3, 3, 1, 5, NOW()),
(2, 'CENA', 'Salmón al Horno con Vegetales', 'Cena rica en omega-3', 'Salmón 120g, Espárragos 100g, Tomate 100g, Limón 1 pieza', '1. Hornear salmón con limón a 180°C por 15 min\n2. Asar vegetales sin sal\n3. Servir caliente', 500, 40, 20, 28, 5, 1, 25, NOW());

-- ============================================================================
-- PLAN 3: María López - Plan Hipercalórico sin Lactosa (2200 cal/día)
-- ============================================================================

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(3, 'DESAYUNO', 'Pan con Aguacate y Huevo', 'Desayuno energético sin lactosa', 'Pan integral 2 rebanadas, Aguacate 1/2 pieza, Huevos 2 piezas, Aceite de oliva 1 cucharadita', '1. Tostar el pan\n2. Untar aguacate\n3. Cocinar huevos al gusto\n4. Servir junto', 520, 20, 50, 28, 8, 1, 15, NOW()),
(3, 'COLACION_AM', 'Smoothie de Proteína', 'Batido energizante', 'Plátano 1 pieza, Leche de almendras 1 taza, Mantequilla de cacahuate 2 cucharadas, Avena 1/4 taza', '1. Licuar todos los ingredientes\n2. Agregar hielo si se desea', 380, 15, 48, 16, 6, 1, 5, NOW()),
(3, 'ALMUERZO', 'Pasta Integral con Pollo y Vegetales', 'Comida completa y abundante', 'Pasta integral 120g, Pechuga de pollo 150g, Brócoli 100g, Aceite de oliva 2 cucharadas, Almendras 30g', '1. Cocinar pasta al dente\n2. Saltear pollo con vegetales\n3. Mezclar y agregar almendras', 680, 50, 70, 22, 10, 1, 25, NOW()),
(3, 'COLACION_PM', 'Granola con Frutas', 'Snack nutritivo', 'Granola sin lactosa 60g, Plátano 1 pieza, Leche de coco 1/2 taza', '1. Servir granola con leche de coco\n2. Agregar plátano en rodajas', 320, 8, 55, 10, 5, 1, 3, NOW()),
(3, 'CENA', 'Res con Camote y Ensalada', 'Cena nutritiva para ganancia', 'Carne magra de res 150g, Camote horneado 200g, Ensalada verde 100g, Aceite de oliva 1 cucharada', '1. Cocinar carne a la plancha\n2. Hornear camote\n3. Preparar ensalada fresca', 620, 42, 60, 22, 10, 1, 35, NOW());

-- ============================================================================
-- PLAN 4: Carlos Ramírez - Plan Alto en Proteínas (2800 cal/día)
-- ============================================================================

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(4, 'DESAYUNO', 'Omelette con Avena', 'Desayuno rico en proteínas', 'Huevos 4 piezas, Avena 1 taza, Plátano 1 pieza, Almendras 40g, Espinaca 50g', '1. Preparar omelette con espinaca\n2. Cocinar avena con plátano\n3. Agregar almendras', 650, 40, 65, 22, 12, 1, 20, NOW()),
(4, 'COLACION_AM', 'Batido Post-Entrenamiento', 'Recuperación muscular', 'Proteína whey 2 scoops, Plátano 1 pieza, Avena 1/2 taza, Leche 2 tazas, Mantequilla de maní 2 cucharadas', '1. Licuar todos los ingredientes\n2. Consumir después del entrenamiento', 580, 50, 55, 15, 6, 1, 5, NOW()),
(4, 'ALMUERZO', 'Pollo al Horno con Arroz y Ensalada', 'Comida principal alta en proteína', 'Pechuga de pollo 200g, Arroz integral 150g, Brócoli 150g, Aguacate 1/2 pieza, Aceite de oliva 2 cucharadas', '1. Hornear pollo con especias\n2. Cocinar arroz integral\n3. Preparar vegetales al vapor', 750, 60, 75, 20, 10, 1, 35, NOW()),
(4, 'COLACION_PM', 'Atún con Galletas Integrales', 'Snack alto en proteína', 'Atún en agua 1 lata, Galletas integrales 6 piezas, Aguacate 1/4 pieza', '1. Escurrir atún\n2. Servir sobre galletas\n3. Agregar aguacate', 320, 35, 30, 8, 4, 1, 5, NOW()),
(4, 'CENA', 'Salmón con Quinoa y Vegetales', 'Cena completa y nutritiva', 'Salmón 180g, Quinoa 100g, Espárragos 150g, Aceite de oliva 1 cucharada', '1. Cocinar salmón a la plancha\n2. Preparar quinoa\n3. Asar espárragos', 520, 45, 40, 20, 8, 1, 30, NOW());

-- ============================================================================
-- PLAN 5: Laura Hernández - Plan para Diabetes Tipo 2 (1700 cal/día)
-- ============================================================================

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(5, 'DESAYUNO', 'Huevos con Vegetales y Pan Integral', 'Desayuno bajo índice glucémico', 'Huevos 2 piezas, Pan integral 1 rebanada, Tomate 100g, Espinaca 50g, Aguacate 1/4 pieza', '1. Preparar huevos revueltos con vegetales\n2. Tostar pan integral\n3. Servir con aguacate', 380, 20, 35, 18, 8, 1, 15, NOW()),
(5, 'COLACION_AM', 'Almendras y Fresas', 'Snack bajo en azúcar', 'Almendras 25g, Fresas 100g', '1. Lavar fresas\n2. Servir con almendras', 180, 6, 15, 12, 5, 1, 2, NOW()),
(5, 'ALMUERZO', 'Pechuga de Pavo con Vegetales', 'Comida balanceada para control glucémico', 'Pechuga de pavo 150g, Brócoli 150g, Coliflor 100g, Arroz integral 80g, Aceite de oliva 1 cucharadita', '1. Cocinar pavo a la plancha\n2. Cocer vegetales al vapor\n3. Servir con porción controlada de arroz', 480, 45, 45, 12, 10, 1, 25, NOW()),
(5, 'COLACION_PM', 'Yogurt Griego con Nueces', 'Colación rica en proteína', 'Yogurt griego natural 150g, Nueces 15g', '1. Servir yogurt\n2. Agregar nueces troceadas', 200, 15, 10, 12, 2, 1, 3, NOW()),
(5, 'CENA', 'Pescado al Vapor con Ensalada', 'Cena ligera y saludable', 'Tilapia 150g, Ensalada verde mixta 200g, Limón 1 pieza, Aceite de oliva 1 cucharada', '1. Cocinar pescado al vapor con limón\n2. Preparar ensalada fresca\n3. Aliñar con aceite de oliva', 360, 35, 15, 18, 6, 1, 20, NOW());

-- ============================================================================
-- PLAN 6: Diego Torres - Plan de Mantenimiento (2000 cal/día)
-- ============================================================================

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(6, 'DESAYUNO', 'Yogurt con Granola y Frutas', 'Desayuno equilibrado', 'Yogurt natural 1 taza, Granola 50g, Fresas 100g, Plátano 1/2 pieza', '1. Servir yogurt en bowl\n2. Agregar granola y frutas', 420, 15, 60, 12, 6, 1, 5, NOW()),
(6, 'COLACION_AM', 'Manzana con Mantequilla de Almendras', 'Snack energizante', 'Manzana 1 pieza, Mantequilla de almendras 1 cucharada', '1. Cortar manzana en rebanadas\n2. Untar con mantequilla de almendras', 200, 4, 28, 9, 5, 1, 3, NOW()),
(6, 'ALMUERZO', 'Pollo con Quinoa y Vegetales Mixtos', 'Comida balanceada', 'Pechuga de pollo 150g, Quinoa 100g, Brócoli 100g, Zanahoria 100g, Aceite de oliva 1 cucharada', '1. Cocinar pollo a la plancha\n2. Preparar quinoa\n3. Saltear vegetales', 580, 45, 55, 18, 10, 1, 30, NOW()),
(6, 'COLACION_PM', 'Hummus con Vegetales', 'Colación mediterránea', 'Hummus 80g, Zanahoria baby 100g, Pepino 100g', '1. Cortar vegetales en bastones\n2. Servir con hummus', 180, 8, 18, 9, 6, 1, 5, NOW()),
(6, 'CENA', 'Tacos de Pescado Light', 'Cena ligera y sabrosa', 'Tilapia 120g, Tortillas de maíz 2 piezas, Repollo rallado 100g, Aguacate 1/4 pieza, Limón y cilantro', '1. Cocinar pescado con especias\n2. Calentar tortillas\n3. Armar tacos con vegetales', 420, 32, 40, 14, 8, 1, 20, NOW());

-- ============================================================================
-- PLAN 7: Sofía Flores - Plan Fitness Mujer (2100 cal/día)
-- ============================================================================

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(7, 'DESAYUNO', 'Tostadas de Aguacate con Huevo', 'Desayuno fitness completo', 'Pan integral 2 rebanadas, Aguacate 1/2 pieza, Huevos 2 piezas, Tomate cherry 50g', '1. Tostar pan\n2. Machacar aguacate\n3. Preparar huevos pochados\n4. Ensamblar tostadas', 450, 22, 42, 22, 10, 1, 15, NOW()),
(7, 'COLACION_AM', 'Batido de Proteína con Frutas', 'Post-entrenamiento', 'Proteína en polvo 1 scoop, Fresas 100g, Plátano 1/2 pieza, Leche de almendras 1 taza, Espinaca 30g', '1. Licuar todos los ingredientes\n2. Servir frío', 280, 25, 35, 5, 6, 1, 5, NOW()),
(7, 'ALMUERZO', 'Bowl de Arroz con Pollo Teriyaki', 'Comida completa y energizante', 'Pechuga de pollo 150g, Arroz integral 120g, Brócoli 100g, Zanahoria 50g, Salsa teriyaki 2 cucharadas', '1. Cocinar pollo con salsa teriyaki\n2. Preparar arroz\n3. Saltear vegetales\n4. Armar bowl', 620, 48, 70, 14, 8, 1, 30, NOW()),
(7, 'COLACION_PM', 'Cottage Cheese con Nueces', 'Snack alto en proteína', 'Queso cottage 150g, Nueces 20g, Arándanos 50g', '1. Servir queso cottage\n2. Agregar nueces y arándanos', 280, 22, 18, 14, 3, 1, 3, NOW()),
(7, 'CENA', 'Salmón con Camote y Espárragos', 'Cena nutritiva fitness', 'Salmón 140g, Camote 150g, Espárragos 150g, Aceite de oliva 1 cucharadita', '1. Hornear salmón y camote\n2. Asar espárragos\n3. Servir con limón', 470, 38, 42, 18, 8, 1, 35, NOW());

-- ============================================================================
-- PLAN 8: Fernando Vargas - Plan de Pérdida Intensiva (1500 cal/día)
-- ============================================================================

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(8, 'DESAYUNO', 'Omelette de Claras con Verduras', 'Desayuno bajo en calorías', 'Claras de huevo 4 piezas, Espinaca 50g, Tomate 50g, Champiñones 50g, Pan integral 1 rebanada', '1. Batir claras\n2. Cocinar con vegetales\n3. Servir con pan tostado', 280, 25, 28, 4, 6, 1, 15, NOW()),
(8, 'COLACION_AM', 'Pepino con Limón y Chile', 'Snack bajo en calorías', 'Pepino 200g, Limón 1 pieza, Chile piquín al gusto', '1. Cortar pepino en rodajas\n2. Rociar con limón\n3. Espolvorear chile', 60, 2, 12, 0, 2, 1, 3, NOW()),
(8, 'ALMUERZO', 'Ensalada de Pollo y Vegetales', 'Comida baja en grasas', 'Pechuga de pollo 150g, Lechuga mixta 200g, Tomate 100g, Pepino 100g, Vinagre balsámico 1 cucharada', '1. Cocinar pollo a la plancha\n2. Preparar ensalada abundante\n3. Aliñar con vinagre balsámico', 380, 42, 25, 8, 8, 1, 20, NOW()),
(8, 'COLACION_PM', 'Gelatina con Fresas', 'Colación ligera', 'Gelatina light 1 taza, Fresas 100g', '1. Preparar gelatina light\n2. Agregar fresas picadas', 80, 3, 15, 0, 2, 1, 5, NOW()),
(8, 'CENA', 'Pescado al Vapor con Brócoli', 'Cena ligera y nutritiva', 'Tilapia 150g, Brócoli al vapor 200g, Limón 1 pieza, Especias al gusto', '1. Cocinar pescado al vapor con limón\n2. Preparar brócoli al vapor\n3. Servir con especias', 300, 40, 15, 6, 8, 1, 20, NOW());

-- ============================================================================
-- PLAN 9: Patricia Castro - Plan sin Gluten (1900 cal/día)
-- ============================================================================

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(9, 'DESAYUNO', 'Yogurt con Frutas y Semillas', 'Desayuno sin gluten', 'Yogurt natural 1 taza, Plátano 1 pieza, Semillas de chía 2 cucharadas, Miel 1 cucharadita', '1. Servir yogurt en bowl\n2. Agregar frutas y semillas\n3. Endulzar con miel', 380, 15, 55, 10, 8, 1, 5, NOW()),
(9, 'COLACION_AM', 'Aguacate con Sal Marina', 'Snack saludable', 'Aguacate 1/2 pieza, Sal marina al gusto', '1. Cortar aguacate\n2. Espolvorear sal marina', 160, 2, 9, 15, 7, 1, 2, NOW()),
(9, 'ALMUERZO', 'Pollo con Arroz y Vegetales Mixtos', 'Comida completa sin gluten', 'Pechuga de pollo 150g, Arroz blanco 120g, Brócoli 100g, Zanahoria 100g, Aceite de oliva 1 cucharada', '1. Cocinar pollo a la plancha\n2. Preparar arroz\n3. Cocer vegetales al vapor', 580, 45, 65, 14, 8, 1, 30, NOW()),
(9, 'COLACION_PM', 'Frutas Mixtas', 'Colación refrescante', 'Papaya 150g, Sandía 150g', '1. Cortar frutas en cubos\n2. Mezclar y servir frío', 100, 2, 24, 0, 4, 1, 5, NOW()),
(9, 'CENA', 'Tacos de Lechuga con Pavo', 'Cena ligera sin gluten', 'Carne molida de pavo 150g, Hojas de lechuga 4 piezas, Tomate 100g, Aguacate 1/4 pieza', '1. Cocinar carne de pavo con especias\n2. Usar hojas de lechuga como tortillas\n3. Agregar vegetales frescos', 380, 35, 18, 20, 6, 1, 20, NOW());

-- ============================================================================
-- PLAN 10: Miguel Ángel Reyes - Plan Deportivo Avanzado (2700 cal/día)
-- ============================================================================

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
(10, 'DESAYUNO', 'Desayuno Deportista Completo', 'Desayuno alto rendimiento', 'Huevos 3 piezas, Avena 1 taza, Plátano 1 pieza, Mantequilla de maní 2 cucharadas, Pan integral 2 rebanadas', '1. Preparar huevos revueltos\n2. Cocinar avena con plátano\n3. Tostar pan con mantequilla de maní', 700, 38, 85, 22, 12, 1, 20, NOW()),
(10, 'COLACION_AM', 'Batido Pre-Entrenamiento', 'Energía para entrenamiento', 'Plátano 1 pieza, Avena 1/2 taza, Proteína whey 1 scoop, Leche 2 tazas, Miel 1 cucharada', '1. Licuar todos los ingredientes\n2. Consumir 1 hora antes del entrenamiento', 480, 35, 65, 8, 6, 1, 5, NOW()),
(10, 'ALMUERZO', 'Bowl Power de Res', 'Comida completa deportiva', 'Carne magra de res 180g, Arroz integral 150g, Frijoles negros 100g, Aguacate 1/2 pieza, Vegetales mixtos 150g', '1. Cocinar carne a la plancha\n2. Preparar arroz y frijoles\n3. Armar bowl con todos los ingredientes', 820, 60, 85, 25, 15, 1, 35, NOW()),
(10, 'COLACION_PM', 'Batido Post-Entrenamiento', 'Recuperación muscular', 'Proteína whey 2 scoops, Plátano 1 pieza, Mantequilla de maní 2 cucharadas, Leche 2 tazas', '1. Licuar inmediatamente después del entrenamiento\n2. Consumir dentro de 30 minutos', 520, 55, 45, 15, 4, 1, 5, NOW()),
(10, 'CENA', 'Salmón con Pasta Integral', 'Cena de recuperación', 'Salmón 160g, Pasta integral 100g, Brócoli 150g, Aceite de oliva 1 cucharada, Ajo y especias', '1. Cocinar salmón al horno\n2. Preparar pasta al dente\n3. Saltear brócoli con ajo', 580, 48, 55, 20, 10, 1, 30, NOW());

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
-- Total insertado: 50 comidas (5 comidas × 10 planes de dieta)
-- - Cada plan incluye: Desayuno, Colación AM, Almuerzo, Colación PM y Cena
-- - Todas las comidas con información nutricional completa
-- - Instrucciones detalladas de preparación
-- ============================================================================
