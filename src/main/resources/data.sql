-- Datos iniciales para NutriTrack

-- Roles
INSERT INTO roles (name) VALUES ('ROLE_ADMIN');
INSERT INTO roles (name) VALUES ('ROLE_NUTRIOLOGO');
INSERT INTO roles (name) VALUES ('ROLE_PACIENTE');

-- Usuarios (Contraseñas: admin123, nutri123, paciente123)
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('admin', 'admin@nutritrack.com', '$2a$10$PxpWVWfAWnjEncRjrl/5heeAABFpWYLXIbSlvORrdrgmROicSkgre', 'Administrador', 'Sistema');

INSERT INTO users (username, email, password, first_name, last_name, phone, address, degree, university, professional_license) VALUES 
('nutriologo', 'nutriologo@nutritrack.com', '$2a$10$0fb9lfW/TneSTNOy71GQUubCWpQX/ZBvYfKvcSZJQLLB9CJsxDfSq', 'María', 'González', '5512345678', 'Av. Reforma 123, CDMX', 'Licenciatura en Nutrición', 'Universidad Nacional Autónoma de México', '1234567');

INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('paciente', 'paciente@nutritrack.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Juan', 'Pérez');

-- Asignación de roles
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1);
INSERT INTO user_roles (user_id, role_id) VALUES (2, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (3, 3);

-- Paciente
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, health_goal) VALUES 
(3, 'Juan', 'Pérez', '1990-05-15', 'Masculino', 175.00, 80.00, 'Moderado', 'paciente@nutritrack.com', '5598765432', 'MAINTAIN_WEIGHT');

-- Alimentos
INSERT INTO foods (name, category, serving_size, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, description) VALUES
('Pechuga de pollo', 'Carnes', '100g', 165, 31.0, 0.0, 3.6, 0.0, 'Pechuga de pollo sin piel cocida'),
('Arroz integral', 'Cereales', '100g', 111, 2.6, 23.0, 0.9, 1.8, 'Arroz integral cocido'),
('Brócoli', 'Verduras', '100g', 34, 2.8, 7.0, 0.4, 2.6, 'Brócoli cocido al vapor'),
('Aguacate', 'Frutas', '100g', 160, 2.0, 8.5, 14.7, 6.7, 'Aguacate fresco tipo Hass'),
('Huevo', 'Proteínas', '1 pieza', 78, 6.3, 0.6, 5.3, 0.0, 'Huevo entero cocido'),
('Avena', 'Cereales', '1 taza', 307, 10.7, 54.8, 5.3, 8.2, 'Avena en hojuelas cruda'),
('Plátano', 'Frutas', '1 pieza', 105, 1.3, 27.0, 0.4, 3.1, 'Plátano mediano fresco'),
('Almendras', 'Frutos secos', '30g', 164, 6.0, 6.1, 14.2, 3.5, 'Almendras naturales'),
('Salmón', 'Pescados', '100g', 208, 20.4, 0.0, 13.4, 0.0, 'Salmón cocido al horno'),
('Espinaca', 'Verduras', '100g', 23, 2.9, 3.6, 0.4, 2.2, 'Espinaca fresca'),
('Yogurt natural', 'Lácteos', '1 taza', 149, 8.5, 11.4, 8.0, 0.0, 'Yogurt natural sin azúcar'),
('Lentejas', 'Legumbres', '100g', 116, 9.0, 20.1, 0.4, 7.9, 'Lentejas cocidas'),
('Manzana', 'Frutas', '1 pieza', 95, 0.5, 25.0, 0.3, 4.4, 'Manzana mediana con cáscara'),
('Pasta integral', 'Cereales', '100g', 124, 5.3, 26.5, 0.5, 3.5, 'Pasta integral cocida'),
('Pechuga de pavo', 'Carnes', '100g', 135, 30.0, 0.0, 0.7, 0.0, 'Pechuga de pavo sin piel'),
-- Bebidas
('Coca-Cola', 'Bebidas', '355ml (1 lata)', 140, 0.0, 39.0, 0.0, 0.0, 'Refresco de cola regular'),
('Coca-Cola Zero', 'Bebidas', '355ml (1 lata)', 0, 0.0, 0.0, 0.0, 0.0, 'Refresco de cola sin azúcar'),
('Pepsi', 'Bebidas', '355ml (1 lata)', 150, 0.0, 41.0, 0.0, 0.0, 'Refresco de cola regular'),
('Sprite', 'Bebidas', '355ml (1 lata)', 140, 0.0, 38.0, 0.0, 0.0, 'Refresco de limón'),
('Fanta Naranja', 'Bebidas', '355ml (1 lata)', 160, 0.0, 44.0, 0.0, 0.0, 'Refresco sabor naranja'),
('Jugo de naranja', 'Bebidas', '240ml (1 vaso)', 110, 2.0, 26.0, 0.0, 0.5, 'Jugo de naranja natural'),
('Leche entera', 'Lácteos', '240ml (1 vaso)', 149, 7.7, 11.7, 7.9, 0.0, 'Leche de vaca entera'),
('Leche descremada', 'Lácteos', '240ml (1 vaso)', 83, 8.3, 12.2, 0.2, 0.0, 'Leche descremada'),
('Café americano', 'Bebidas', '240ml (1 taza)', 2, 0.3, 0.0, 0.0, 0.0, 'Café negro sin azúcar'),
('Té verde', 'Bebidas', '240ml (1 taza)', 2, 0.0, 0.0, 0.0, 0.0, 'Té verde sin azúcar'),
-- Galletas y Snacks
('Oreo Original', 'Galletas', '3 piezas (34g)', 160, 2.0, 25.0, 7.0, 1.0, 'Galletas de chocolate con crema'),
('Chips Ahoy', 'Galletas', '3 piezas (32g)', 160, 2.0, 21.0, 8.0, 1.0, 'Galletas con chispas de chocolate'),
('Marías', 'Galletas', '5 piezas (30g)', 120, 2.0, 23.0, 2.5, 1.0, 'Galletas tipo María'),
('Ritz', 'Galletas', '5 piezas (16g)', 80, 1.0, 10.0, 4.0, 0.0, 'Galletas saladas'),
('Doritos Nacho', 'Snacks', '1 porción (28g)', 150, 2.0, 18.0, 8.0, 1.0, 'Tortillas de maíz con queso'),
('Cheetos', 'Snacks', '1 porción (28g)', 160, 2.0, 15.0, 10.0, 1.0, 'Frituras de maíz con queso'),
('Papas Fritas Sabritas', 'Snacks', '1 porción (28g)', 150, 2.0, 15.0, 10.0, 1.0, 'Papas fritas sal'),
('Palomitas naturales', 'Snacks', '1 taza', 31, 1.0, 6.2, 0.4, 1.2, 'Palomitas sin mantequilla'),
-- Aceites y Grasas
('Aceite de oliva', 'Aceites', '1 cucharada (15ml)', 119, 0.0, 0.0, 13.5, 0.0, 'Aceite de oliva extra virgen'),
('Aceite vegetal', 'Aceites', '1 cucharada (15ml)', 120, 0.0, 0.0, 14.0, 0.0, 'Aceite vegetal multiusos'),
('Aceite de coco', 'Aceites', '1 cucharada (15ml)', 117, 0.0, 0.0, 13.6, 0.0, 'Aceite de coco virgen'),
('Aceite de aguacate', 'Aceites', '1 cucharada (15ml)', 124, 0.0, 0.0, 14.0, 0.0, 'Aceite de aguacate'),
('Mantequilla', 'Grasas', '1 cucharada (14g)', 102, 0.1, 0.0, 11.5, 0.0, 'Mantequilla regular'),
('Margarina', 'Grasas', '1 cucharada (14g)', 100, 0.0, 0.0, 11.0, 0.0, 'Margarina vegetal'),
-- Cereales y Desayuno
('Corn Flakes', 'Cereales', '1 taza (30g)', 100, 2.0, 24.0, 0.0, 1.0, 'Hojuelas de maíz'),
('Zucaritas', 'Cereales', '1 taza (30g)', 110, 1.5, 26.0, 0.5, 0.5, 'Hojuelas de maíz azucaradas'),
('Cheerios', 'Cereales', '1 taza (30g)', 100, 3.0, 20.0, 2.0, 3.0, 'Cereal de avena'),
('Granola', 'Cereales', '1/2 taza (50g)', 210, 5.0, 37.0, 6.0, 4.0, 'Granola con frutos secos'),
('Pan integral', 'Panadería', '1 rebanada (30g)', 69, 3.6, 11.6, 1.1, 1.9, 'Pan de trigo integral'),
('Pan blanco', 'Panadería', '1 rebanada (30g)', 79, 2.7, 14.8, 1.0, 0.8, 'Pan blanco de caja'),
('Tortilla de maíz', 'Panadería', '1 pieza (30g)', 52, 1.4, 10.7, 0.7, 1.5, 'Tortilla de maíz'),
('Tortilla de harina', 'Panadería', '1 pieza (49g)', 146, 3.9, 24.4, 3.5, 1.6, 'Tortilla de harina de trigo'),
-- Postres y Dulces
('Chocolate con leche', 'Dulces', '1 barra (43g)', 230, 3.0, 26.0, 13.0, 1.0, 'Chocolate con leche tipo Hersheys'),
('Kit Kat', 'Dulces', '1 barra (42g)', 210, 3.0, 27.0, 11.0, 1.0, 'Barra de chocolate con wafer'),
('M&Ms', 'Dulces', '1 porción (45g)', 210, 2.0, 30.0, 9.0, 1.0, 'Chocolates con cubierta de dulce'),
('Snickers', 'Dulces', '1 barra (52g)', 250, 4.0, 33.0, 12.0, 1.0, 'Barra de chocolate con cacahuate'),
('Helado de vainilla', 'Postres', '1/2 taza (66g)', 137, 2.3, 15.6, 7.3, 0.5, 'Helado cremoso de vainilla'),
('Helado de chocolate', 'Postres', '1/2 taza (66g)', 143, 2.5, 18.6, 7.3, 0.8, 'Helado de chocolate'),
-- Comida Rápida
('Hamburguesa simple', 'Comida rápida', '1 pieza', 250, 12.0, 31.0, 9.0, 2.0, 'Hamburguesa con carne, pan y vegetales'),
('Pizza de pepperoni', 'Comida rápida', '1 rebanada', 298, 13.0, 36.0, 11.0, 2.0, 'Pizza estilo italiano'),
('Hot dog', 'Comida rápida', '1 pieza', 314, 11.0, 24.0, 19.0, 1.0, 'Salchicha con pan'),
('Tacos al pastor', 'Comida mexicana', '1 pieza', 200, 10.0, 18.0, 9.0, 2.0, 'Taco con carne al pastor'),
('Burrito de pollo', 'Comida mexicana', '1 pieza', 326, 15.0, 41.0, 10.0, 3.0, 'Burrito con pollo y frijoles'),
-- Frutas adicionales
('Fresa', 'Frutas', '100g', 32, 0.7, 7.7, 0.3, 2.0, 'Fresas frescas'),
('Sandía', 'Frutas', '100g', 30, 0.6, 7.6, 0.2, 0.4, 'Sandía fresca'),
('Melón', 'Frutas', '100g', 34, 0.8, 8.2, 0.2, 0.9, 'Melón cantaloupe'),
('Papaya', 'Frutas', '100g', 43, 0.5, 10.8, 0.3, 1.7, 'Papaya fresca'),
('Piña', 'Frutas', '100g', 50, 0.5, 13.1, 0.1, 1.4, 'Piña fresca'),
('Naranja', 'Frutas', '1 pieza', 62, 1.2, 15.4, 0.2, 3.1, 'Naranja mediana'),
('Uvas', 'Frutas', '100g', 69, 0.7, 18.1, 0.2, 0.9, 'Uvas frescas'),
('Mango', 'Frutas', '100g', 60, 0.8, 15.0, 0.4, 1.6, 'Mango fresco'),
-- Verduras adicionales
('Zanahoria', 'Verduras', '100g', 41, 0.9, 9.6, 0.2, 2.8, 'Zanahoria cruda'),
('Tomate', 'Verduras', '100g', 18, 0.9, 3.9, 0.2, 1.2, 'Tomate rojo fresco'),
('Lechuga', 'Verduras', '100g', 15, 1.4, 2.9, 0.2, 1.3, 'Lechuga romana'),
('Pepino', 'Verduras', '100g', 16, 0.7, 3.6, 0.1, 0.5, 'Pepino con cáscara'),
('Cebolla', 'Verduras', '100g', 40, 1.1, 9.3, 0.1, 1.7, 'Cebolla blanca'),
('Pimiento', 'Verduras', '100g', 31, 1.0, 6.0, 0.3, 2.1, 'Pimiento rojo'),
-- Carnes adicionales
('Carne molida de res', 'Carnes', '100g', 250, 26.0, 0.0, 15.0, 0.0, 'Carne molida 80/20'),
('Bistec de res', 'Carnes', '100g', 271, 25.0, 0.0, 19.0, 0.0, 'Bistec de res'),
('Costillas de cerdo', 'Carnes', '100g', 277, 29.0, 0.0, 17.0, 0.0, 'Costillas de cerdo cocidas'),
('Tocino', 'Carnes', '3 rebanadas (24g)', 120, 9.0, 0.0, 9.0, 0.0, 'Tocino frito'),
('Jamón', 'Carnes', '2 rebanadas (56g)', 91, 14.0, 3.0, 3.0, 0.0, 'Jamón de pavo o cerdo'),
-- Pescados adicionales
('Atún en agua', 'Pescados', '1 lata (85g)', 90, 20.0, 0.0, 1.0, 0.0, 'Atún en agua enlatado'),
('Tilapia', 'Pescados', '100g', 128, 26.0, 0.0, 2.7, 0.0, 'Filete de tilapia'),
('Camarones', 'Pescados', '100g', 99, 24.0, 0.2, 0.3, 0.0, 'Camarones cocidos'),
-- Legumbres y Frijoles
('Frijoles negros', 'Legumbres', '100g', 132, 8.9, 23.7, 0.5, 8.7, 'Frijoles negros cocidos'),
('Garbanzos', 'Legumbres', '100g', 164, 8.9, 27.4, 2.6, 7.6, 'Garbanzos cocidos'),
('Frijoles pintos', 'Legumbres', '100g', 143, 9.0, 26.2, 0.7, 9.0, 'Frijoles pintos cocidos'),
-- Frutos secos adicionales
('Nueces', 'Frutos secos', '30g', 185, 4.3, 3.9, 18.5, 1.9, 'Nueces de Castilla'),
('Cacahuates', 'Frutos secos', '30g', 161, 7.3, 4.6, 14.0, 2.4, 'Cacahuates naturales'),
('Pistaches', 'Frutos secos', '30g', 159, 5.7, 7.7, 12.9, 3.0, 'Pistaches sin sal'),
('Avellanas', 'Frutos secos', '30g', 178, 4.2, 4.7, 17.2, 2.7, 'Avellanas naturales'),
-- Condimentos
('Mayonesa', 'Condimentos', '1 cucharada (15g)', 94, 0.1, 0.1, 10.3, 0.0, 'Mayonesa regular'),
('Catsup', 'Condimentos', '1 cucharada (17g)', 17, 0.2, 4.7, 0.0, 0.0, 'Salsa catsup'),
('Mostaza', 'Condimentos', '1 cucharada (15g)', 10, 0.6, 1.0, 0.6, 0.5, 'Mostaza amarilla'),
('Salsa BBQ', 'Condimentos', '2 cucharadas (34g)', 58, 0.3, 14.1, 0.2, 0.3, 'Salsa barbecue'),
('Aderezo ranch', 'Condimentos', '2 cucharadas (30g)', 129, 0.4, 1.4, 13.8, 0.0, 'Aderezo tipo ranch'),
('Salsa de soya', 'Condimentos', '1 cucharada (18ml)', 11, 1.0, 1.0, 0.0, 0.1, 'Salsa de soya'),
-- Quesos
('Queso panela', 'Lácteos', '30g', 79, 6.3, 0.8, 6.0, 0.0, 'Queso panela fresco'),
('Queso Oaxaca', 'Lácteos', '30g', 85, 6.0, 1.0, 6.5, 0.0, 'Queso Oaxaca'),
('Queso Cheddar', 'Lácteos', '30g', 115, 7.0, 0.4, 9.4, 0.0, 'Queso cheddar amarillo'),
('Queso crema', 'Lácteos', '2 cucharadas (29g)', 100, 2.0, 1.0, 10.0, 0.0, 'Queso crema tipo Philadelphia'),
('Queso cottage', 'Lácteos', '1/2 taza (113g)', 110, 13.0, 4.0, 5.0, 0.0, 'Queso cottage bajo en grasa'),
-- Productos Veganos - Leches Vegetales
('Leche de soya', 'Vegano', '240ml (1 vaso)', 80, 7.0, 4.0, 4.0, 1.0, 'Leche de soya sin azúcar'),
('Leche de almendra', 'Vegano', '240ml (1 vaso)', 30, 1.0, 1.0, 2.5, 1.0, 'Leche de almendra sin azúcar'),
('Leche de coco', 'Vegano', '240ml (1 vaso)', 45, 0.0, 1.0, 4.5, 0.0, 'Bebida de coco sin azúcar'),
('Leche de avena', 'Vegano', '240ml (1 vaso)', 120, 3.0, 16.0, 5.0, 2.0, 'Leche de avena'),
('Leche de arroz', 'Vegano', '240ml (1 vaso)', 113, 0.7, 22.0, 2.3, 0.7, 'Leche de arroz'),
('Leche de anacardo', 'Vegano', '240ml (1 vaso)', 25, 1.0, 1.0, 2.0, 0.0, 'Leche de anacardo sin azúcar'),
-- Proteínas Vegetales
('Tofu firme', 'Vegano', '100g', 144, 17.3, 2.8, 8.7, 2.3, 'Tofu de soya firme'),
('Tofu suave', 'Vegano', '100g', 61, 6.9, 2.0, 3.7, 0.3, 'Tofu de soya suave'),
('Tempeh', 'Vegano', '100g', 193, 20.3, 7.6, 10.8, 0.0, 'Tempeh de soya fermentada'),
('Edamame', 'Vegano', '100g', 122, 11.9, 8.9, 5.2, 5.2, 'Frijoles de soya verdes'),
('Seitán', 'Vegano', '100g', 370, 75.0, 14.0, 1.9, 0.6, 'Gluten de trigo - carne vegetal'),
('Proteína de soya texturizada', 'Vegano', '1/4 taza (25g)', 80, 12.0, 7.0, 0.5, 4.0, 'Soya texturizada seca'),
-- Yogures Veganos
('Yogurt de soya', 'Vegano', '1 taza (240g)', 110, 6.0, 17.0, 3.5, 1.0, 'Yogurt de soya natural'),
('Yogurt de coco', 'Vegano', '1 taza (240g)', 140, 1.0, 25.0, 5.0, 0.0, 'Yogurt de coco'),
('Yogurt de almendra', 'Vegano', '1 taza (240g)', 100, 3.0, 16.0, 3.0, 2.0, 'Yogurt de almendra'),
-- Quesos Veganos
('Queso vegano cheddar', 'Vegano', '30g', 90, 1.0, 1.0, 9.0, 0.0, 'Queso vegano estilo cheddar'),
('Queso crema vegano', 'Vegano', '2 cucharadas (30g)', 90, 1.0, 2.0, 9.0, 0.0, 'Queso crema de anacardo'),
('Parmesano vegano', 'Vegano', '2 cucharadas (10g)', 40, 2.0, 2.0, 3.0, 1.0, 'Queso parmesano de almendras'),
-- Hamburguesas y Carnes Vegetales
('Hamburguesa Beyond Meat', 'Vegano', '1 pieza (113g)', 250, 20.0, 5.0, 18.0, 2.0, 'Hamburguesa vegetal Beyond Burger'),
('Hamburguesa Impossible', 'Vegano', '1 pieza (113g)', 240, 19.0, 9.0, 14.0, 3.0, 'Hamburguesa Impossible Burger'),
('Salchicha vegana', 'Vegano', '1 pieza (75g)', 190, 16.0, 5.0, 12.0, 2.0, 'Salchicha vegetal'),
('Nuggets veganos', 'Vegano', '4 piezas (85g)', 180, 13.0, 13.0, 10.0, 3.0, 'Nuggets de proteína vegetal'),
('Carne molida vegetal', 'Vegano', '100g', 200, 19.0, 8.0, 11.0, 3.0, 'Carne molida de soya'),
-- Mantequillas de Frutos Secos
('Mantequilla de maní', 'Vegano', '2 cucharadas (32g)', 188, 8.0, 6.0, 16.0, 2.0, 'Mantequilla de cacahuate natural'),
('Mantequilla de almendra', 'Vegano', '2 cucharadas (32g)', 196, 6.7, 6.0, 18.0, 3.3, 'Mantequilla de almendra'),
('Mantequilla de anacardo', 'Vegano', '2 cucharadas (32g)', 188, 5.6, 9.0, 16.0, 1.0, 'Mantequilla de anacardo'),
('Tahini', 'Vegano', '2 cucharadas (30g)', 178, 5.1, 6.4, 16.0, 2.8, 'Mantequilla de ajonjolí'),
('Mantequilla de girasol', 'Vegano', '2 cucharadas (32g)', 200, 6.0, 7.0, 18.0, 3.0, 'Mantequilla de semillas de girasol'),
-- Semillas
('Semillas de chía', 'Vegano', '2 cucharadas (28g)', 138, 4.7, 12.3, 8.7, 9.8, 'Semillas de chía'),
('Semillas de linaza', 'Vegano', '2 cucharadas (20g)', 110, 3.8, 6.0, 8.6, 5.6, 'Semillas de linaza molidas'),
('Semillas de hemp', 'Vegano', '3 cucharadas (30g)', 166, 9.5, 2.6, 14.6, 1.2, 'Semillas de cáñamo'),
('Semillas de calabaza', 'Vegano', '1/4 taza (30g)', 180, 9.0, 3.0, 16.0, 2.0, 'Semillas de calabaza'),
('Semillas de girasol', 'Vegano', '1/4 taza (30g)', 186, 6.5, 6.8, 16.0, 3.0, 'Semillas de girasol'),
-- Sustitutos de Huevo
('Just Egg', 'Vegano', '3 cucharadas (45g)', 70, 5.0, 1.0, 5.0, 0.0, 'Huevo líquido vegano de frijol mungo'),
('Aquafaba', 'Vegano', '3 cucharadas (45ml)', 10, 0.5, 1.5, 0.0, 0.0, 'Líquido de garbanzo enlatado'),
-- Postres Veganos
('Helado vegano de vainilla', 'Vegano', '1/2 taza (66g)', 140, 2.0, 18.0, 7.0, 1.0, 'Helado base de coco o almendra'),
('Helado vegano de chocolate', 'Vegano', '1/2 taza (66g)', 150, 2.0, 20.0, 7.0, 2.0, 'Helado vegano de chocolate'),
('Chocolate vegano oscuro', 'Vegano', '30g', 170, 2.0, 13.0, 12.0, 3.0, 'Chocolate 70% cacao sin lácteos'),
-- Condimentos Veganos
('Mayonesa vegana', 'Vegano', '1 cucharada (14g)', 90, 0.0, 0.0, 10.0, 0.0, 'Mayonesa sin huevo'),
('Crema agria vegana', 'Vegano', '2 cucharadas (30g)', 50, 1.0, 2.0, 4.5, 0.0, 'Crema agria de anacardo'),
('Mantequilla vegana', 'Vegano', '1 cucharada (14g)', 100, 0.0, 0.0, 11.0, 0.0, 'Mantequilla de aceites vegetales'),
-- Snacks Veganos
('Hummus', 'Vegano', '2 cucharadas (30g)', 70, 2.0, 4.0, 5.0, 2.0, 'Puré de garbanzos con tahini'),
('Guacamole', 'Vegano', '2 cucharadas (30g)', 50, 0.6, 3.0, 4.5, 2.0, 'Puré de aguacate'),
('Barras de proteína vegana', 'Vegano', '1 barra (50g)', 200, 12.0, 22.0, 8.0, 4.0, 'Barra de proteína de plantas'),
('Chips de kale', 'Vegano', '1 porción (28g)', 130, 2.0, 17.0, 7.0, 2.0, 'Chips de col rizada horneada'),
-- Proteína en Polvo Vegana
('Proteína de chícharo', 'Suplementos', '1 scoop (30g)', 120, 24.0, 1.0, 2.0, 0.0, 'Proteína en polvo de chícharo'),
('Proteína de arroz integral', 'Suplementos', '1 scoop (30g)', 110, 22.0, 3.0, 2.0, 1.0, 'Proteína en polvo de arroz'),
('Proteína vegana mixta', 'Suplementos', '1 scoop (30g)', 130, 20.0, 8.0, 3.0, 5.0, 'Mezcla de proteínas vegetales'),
-- Proteína Whey (Suero de Leche) - Marcas populares en México
('Optimum Nutrition Gold Standard Whey Chocolate', 'Suplementos', '1 scoop (30g)', 120, 24.0, 3.0, 1.0, 1.0, 'Proteína whey - Chocolate'),
('Optimum Nutrition Gold Standard Whey Vainilla', 'Suplementos', '1 scoop (30g)', 120, 24.0, 3.0, 1.0, 1.0, 'Proteína whey - Vainilla'),
('Dymatize ISO 100 Chocolate', 'Suplementos', '1 scoop (31g)', 110, 25.0, 2.0, 0.0, 0.0, 'Proteína aislada - Chocolate'),
('Dymatize ISO 100 Vainilla', 'Suplementos', '1 scoop (31g)', 110, 25.0, 2.0, 0.0, 0.0, 'Proteína aislada - Vainilla'),
('Dymatize ISO 100 Fresa', 'Suplementos', '1 scoop (31g)', 110, 25.0, 2.0, 0.0, 0.0, 'Proteína aislada - Fresa'),
('Dymatize ISO 100 Birthday Cake', 'Suplementos', '1 scoop (31g)', 110, 25.0, 2.0, 0.0, 0.0, 'Proteína aislada - Pastel de cumpleaños'),
('Dymatize ISO 100 Cocoa Pebbles', 'Suplementos', '1 scoop (31g)', 110, 25.0, 2.0, 0.0, 0.0, 'Proteína aislada - Cocoa Pebbles'),
('Dymatize ISO 100 Dona Glaseada', 'Suplementos', '1 scoop (31g)', 110, 25.0, 2.0, 0.0, 0.0, 'Proteína aislada - Dona glaseada'),
('MuscleTech Nitro-Tech Vainilla', 'Suplementos', '1 scoop (44g)', 160, 30.0, 4.0, 2.5, 1.0, 'Proteína whey isolate - Vainilla'),
('MuscleTech Nitro-Tech Chocolate', 'Suplementos', '1 scoop (44g)', 160, 30.0, 4.0, 2.5, 1.0, 'Proteína whey isolate - Chocolate'),
('MuscleTech IsoWhey Vainilla', 'Suplementos', '1 scoop (30g)', 120, 25.0, 2.0, 1.0, 0.0, 'Proteína aislada - Vainilla'),
('Isopure Zero Carb Vainilla', 'Suplementos', '1 scoop (31g)', 110, 25.0, 0.0, 0.0, 0.0, 'Proteína sin carbohidratos - Vainilla'),
('Isopure Low Carb', 'Suplementos', '1 scoop (31g)', 110, 25.0, 3.0, 0.0, 1.0, 'Proteína baja en carbos'),
('GNC Pro Performance 100% Whey Vainilla', 'Suplementos', '1 scoop (30g)', 120, 24.0, 3.0, 1.5, 1.0, 'Proteína whey - Vainilla'),
('GNC Pro Performance 100% Whey Chocolate', 'Suplementos', '1 scoop (30g)', 120, 24.0, 3.0, 1.5, 1.0, 'Proteína whey - Chocolate'),
('GNC AMP Gold 100% Whey Advanced Vainilla', 'Suplementos', '1 scoop (35g)', 130, 25.0, 4.0, 2.0, 1.0, 'Proteína whey avanzada - Vainilla'),
('GNC AMP Gold 100% Whey Advanced Chocolate', 'Suplementos', '1 scoop (35g)', 130, 25.0, 4.0, 2.0, 1.0, 'Proteína whey avanzada - Chocolate'),
('GHOST Whey Cinnabon', 'Suplementos', '1 scoop (32g)', 130, 25.0, 4.0, 2.5, 1.0, 'Proteína whey - Sabor Cinnabon'),
('GHOST Whey Protein', 'Suplementos', '1 scoop (32g)', 130, 25.0, 4.0, 2.5, 1.0, 'Proteína whey - Varios sabores'),
('Optimum Nutrition Platinum Hydrowhey Vainilla', 'Suplementos', '1 scoop (39g)', 140, 30.0, 2.0, 1.0, 0.0, 'Proteína hidrolizada - Vainilla'),
('Optimum Nutrition Platinum Hydrowhey Chocolate', 'Suplementos', '1 scoop (39g)', 140, 30.0, 2.0, 1.0, 0.0, 'Proteína hidrolizada - Chocolate'),
('Beyond Raw Iso Tiramisú', 'Suplementos', '1 scoop (30g)', 110, 25.0, 2.0, 0.5, 0.0, 'Proteína aislada - Tiramisú'),
('Nutrex Isofit Chocolate', 'Suplementos', '1 scoop (36g)', 130, 25.0, 4.0, 2.0, 1.0, 'Proteína aislada - Chocolate'),
('Raw Nutrition CBUM Itholate Menta y Chocolate', 'Suplementos', '1 scoop (30g)', 110, 25.0, 2.0, 0.5, 0.0, 'Proteína aislada Chris Bumstead - Menta chocolate'),
('Raw Nutrition CBUM Itholate Vainilla', 'Suplementos', '1 scoop (30g)', 110, 25.0, 2.0, 0.5, 0.0, 'Proteína aislada Chris Bumstead - Vainilla'),
('Ryse Loaded Protein Fresa', 'Suplementos', '1 scoop (36g)', 130, 25.0, 5.0, 2.0, 1.0, 'Proteína whey - Fresa'),
('Ryse Loaded Protein Brownie', 'Suplementos', '1 scoop (36g)', 130, 25.0, 5.0, 2.0, 1.0, 'Proteína whey - Brownie'),
-- Proteína de Caseína
('Optimum Nutrition Gold Standard Casein Chocolate', 'Suplementos', '1 scoop (34g)', 120, 24.0, 3.0, 1.0, 1.0, 'Caseína micelar - Chocolate'),
('Optimum Nutrition Gold Standard Casein Vainilla', 'Suplementos', '1 scoop (34g)', 120, 24.0, 3.0, 1.0, 1.0, 'Caseína micelar - Vainilla'),
('MuscleTech Phase8 Multi-Phase', 'Suplementos', '1 scoop (47g)', 180, 26.0, 8.0, 4.0, 5.0, 'Mezcla de 8 proteínas'),
-- Proteína Vegana - Marcas en México
('Birdman Falcon Proteína Vegetal Vainilla', 'Suplementos', '1 scoop (30g)', 110, 20.0, 5.0, 2.5, 3.0, 'Proteína vegetal mexicana - Vainilla'),
('Birdman Falcon Proteína Vegetal Chocolate', 'Suplementos', '1 scoop (30g)', 110, 20.0, 5.0, 2.5, 3.0, 'Proteína vegetal mexicana - Chocolate'),
('Orgain Organic Protein Chocolate', 'Suplementos', '1 scoop (46g)', 150, 21.0, 15.0, 4.0, 7.0, 'Proteína vegana orgánica - Chocolate'),
('Vega Sport Protein', 'Suplementos', '1 scoop (44g)', 160, 30.0, 6.0, 2.5, 2.0, 'Proteína vegana deportiva'),
-- Proteína de Carne (Beef & Bone Broth)
('MuscleMeds Carnivor', 'Suplementos', '1 scoop (36g)', 120, 23.0, 0.0, 0.5, 0.0, 'Proteína de carne de res'),
('ZAMMEX Bone Broth Vainilla', 'Suplementos', '1 scoop (28g)', 100, 20.0, 2.0, 1.0, 0.0, 'Proteína de caldo de hueso - Vainilla'),
('ZAMMEX Calostro Bovino', 'Suplementos', '1 scoop (10g)', 35, 6.0, 3.0, 0.5, 0.0, 'Calostro bovino'),
-- Mass Gainers (Ganadores de Masa)
('Mutant Mass Chocolate', 'Suplementos', '4 scoops (260g)', 1060, 52.0, 182.0, 18.0, 10.0, 'Ganador de masa - Chocolate'),
('Mutant Mass Vainilla Ice Cream', 'Suplementos', '4 scoops (260g)', 1060, 52.0, 182.0, 18.0, 10.0, 'Ganador de masa - Vainilla'),
('Mutant Mass Fresa Plátano', 'Suplementos', '4 scoops (260g)', 1060, 52.0, 182.0, 18.0, 10.0, 'Ganador de masa - Fresa plátano'),
('GNC Pro Performance Bulk 1340 Chocolate', 'Suplementos', '4 scoops (334g)', 1340, 50.0, 277.0, 9.0, 7.0, 'Ganador de masa - Chocolate'),
('GNC Pro Performance Bulk 1340 Vainilla', 'Suplementos', '4 scoops (334g)', 1340, 50.0, 277.0, 9.0, 7.0, 'Ganador de masa - Vainilla'),
('GNC AMP Mass XXX Vainilla', 'Suplementos', '4 scoops (205g)', 820, 40.0, 160.0, 6.0, 8.0, 'Ganador de masa avanzado - Vainilla'),
('Optimum Nutrition Serious Mass', 'Suplementos', '2 scoops (334g)', 1250, 50.0, 252.0, 4.5, 3.0, 'Ganador de masa alto en calorías'),
('BSN True Mass', 'Suplementos', '1 scoop (165g)', 640, 46.0, 90.0, 8.0, 6.0, 'Ganador de masa premium'),
-- Otros Productos Veganos
('Levadura nutricional', 'Vegano', '2 cucharadas (10g)', 40, 5.0, 5.0, 1.0, 2.0, 'Levadura nutricional con vitamina B12'),
('Natto', 'Vegano', '100g', 212, 19.4, 12.7, 11.0, 5.4, 'Soya fermentada japonesa'),
('Alga nori', 'Vegano', '1 hoja (2.5g)', 5, 1.0, 1.0, 0.0, 0.3, 'Alga marina seca para sushi'),
('Espirulina', 'Vegano', '1 cucharada (7g)', 20, 4.0, 1.7, 0.5, 0.3, 'Alga espirulina en polvo'),
('Proteína de cáñamo', 'Vegano', '3 cucharadas (30g)', 90, 15.0, 8.0, 3.0, 8.0, 'Proteína de semilla de cáñamo'),
-- Bebidas de Proteína (Listas para tomar)
('Alani Nu Bebida Proteína Munchies', 'Suplementos', '1 lata (355ml)', 150, 30.0, 5.0, 3.0, 1.0, 'Bebida proteica lista - Munchies'),
('Alani Nu Bebida Proteína Fruity Cereal', 'Suplementos', '1 lata (355ml)', 150, 30.0, 5.0, 3.0, 1.0, 'Bebida proteica lista - Fruity Cereal'),
('Alani Nu Bebida Proteína Cookies & Cream', 'Suplementos', '1 lata (355ml)', 150, 30.0, 5.0, 3.0, 1.0, 'Bebida proteica lista - Cookies & Cream'),
('Muscle Milk RTD Chocolate', 'Suplementos', '1 botella (330ml)', 160, 20.0, 9.0, 6.0, 1.0, 'Bebida proteica lista - Chocolate'),
('Premier Protein Shake Chocolate', 'Suplementos', '1 botella (325ml)', 160, 30.0, 5.0, 3.0, 1.0, 'Batido proteico - Chocolate'),
('Premier Protein Shake Vainilla', 'Suplementos', '1 botella (325ml)', 160, 30.0, 4.0, 3.0, 1.0, 'Batido proteico - Vainilla'),
-- Barras de Proteína
('ONE Bar Reese''s Crema de cacahuate', 'Suplementos', '1 barra (60g)', 210, 20.0, 23.0, 8.0, 9.0, 'Barra proteica - Reese''s'),
('ONE Bar Birthday Cake', 'Suplementos', '1 barra (60g)', 210, 20.0, 23.0, 8.0, 9.0, 'Barra proteica - Pastel de cumpleaños'),
('BSN Barra Proteína Chocolate', 'Suplementos', '1 barra (55g)', 190, 20.0, 20.0, 6.0, 3.0, 'Barra proteica BSN - Chocolate'),
('BSN Barra Proteína Vainilla', 'Suplementos', '1 barra (55g)', 190, 20.0, 20.0, 6.0, 3.0, 'Barra proteica BSN - Vainilla'),
('BSN Barra Proteína Peanut Butter', 'Suplementos', '1 barra (55g)', 190, 20.0, 20.0, 6.0, 3.0, 'Barra proteica BSN - Mantequilla de cacahuate'),
('Pro Bar Chocolate Crema de cacahuate', 'Suplementos', '1 barra (70g)', 280, 20.0, 24.0, 13.0, 5.0, 'Barra proteica - Chocolate y cacahuate'),
('Pro Bar Galleta con chispas chocolate', 'Suplementos', '1 barra (70g)', 280, 20.0, 25.0, 12.0, 5.0, 'Barra proteica - Cookie'),
('Pro Bar Chocolate Brownie', 'Suplementos', '1 barra (70g)', 280, 20.0, 24.0, 13.0, 5.0, 'Barra proteica - Brownie'),
('Quest Bar Chocolate Chip Cookie Dough', 'Suplementos', '1 barra (60g)', 200, 21.0, 22.0, 9.0, 14.0, 'Barra proteica Quest - Cookie dough'),
('Quest Bar Cookies and Cream', 'Suplementos', '1 barra (60g)', 190, 21.0, 21.0, 9.0, 15.0, 'Barra proteica Quest - Cookies & cream'),
('RX Bar Chocolate Sea Salt', 'Suplementos', '1 barra (52g)', 210, 12.0, 24.0, 9.0, 5.0, 'Barra proteica natural - Chocolate'),
('Kind Protein Bar', 'Suplementos', '1 barra (50g)', 250, 12.0, 17.0, 16.0, 6.0, 'Barra proteica con nueces');
