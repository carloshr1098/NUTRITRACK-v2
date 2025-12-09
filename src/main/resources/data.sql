-- Datos iniciales para NutriTrack

-- Roles
INSERT INTO roles (name) VALUES ('ROLE_ADMIN');
INSERT INTO roles (name) VALUES ('ROLE_NUTRIOLOGO');
INSERT INTO roles (name) VALUES ('ROLE_PACIENTE');

-- Usuarios (Contrasenas: admin123, nutri123, paciente123)
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('admin', 'admin@nutritrack.com', '$2a$10$PxpWVWfAWnjEncRjrl/5heeAABFpWYLXIbSlvORrdrgmROicSkgre', 'Administrador', 'Sistema');

INSERT INTO users (username, email, password, first_name, last_name, phone, address, degree, university, professional_license) VALUES 
('nutriologo', 'nutriologo@nutritrack.com', '$2a$10$0fb9lfW/TneSTNOy71GQUubCWpQX/ZBvYfKvcSZJQLLB9CJsxDfSq', 'Maria', 'Gonzalez', '5512345678', 'Av. Reforma 123, CDMX', 'Licenciatura en Nutricion', 'Universidad Nacional Autonoma de Mexico', '1234567');

INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('paciente', 'paciente@nutritrack.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Juan', 'Perez');

-- Asignación de roles
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1);
INSERT INTO user_roles (user_id, role_id) VALUES (2, 2);
INSERT INTO user_roles (user_id, role_id) VALUES (3, 3);

-- Paciente
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, health_goal) VALUES 
(3, 'Juan', 'Perez', '1990-05-15', 'Masculino', 175.00, 80.00, 'Moderado', 'paciente@nutritrack.com', '5598765432', 'MAINTAIN_WEIGHT');

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
-- ============================================================================
-- SCRIPT PARA INSERTAR 10 PACIENTES CON DATOS COMPLETOS
-- ============================================================================
-- Genera 10 pacientes con toda su información:
-- - Usuarios y roles
-- - Datos personales y médicos
-- - Registros de peso
-- - Citas programadas
-- - Planes de dieta
-- ============================================================================

-- USUARIOS Y PACIENTES (IDs: 4-13)
-- Contraseña para todos: paciente123 ($2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2)

-- Paciente 1: Ana Martínez
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('ana.martinez', 'ana.martinez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Ana', 'Martínez');
INSERT INTO user_roles (user_id, role_id) VALUES (4, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(4, 'Ana', 'Martínez', '1995-03-22', 'Femenino', 165.00, 68.00, 'Moderado', 'ana.martinez@email.com', '5512345001', 'Carlos Martínez', '5598765001', 'LOSE_WEIGHT', 'Ninguna', 'Ninguna', 'Vegetariana', '2025-09-15 10:30:00');

-- Paciente 2: Roberto Sánchez
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('roberto.sanchez', 'roberto.sanchez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Roberto', 'Sánchez');
INSERT INTO user_roles (user_id, role_id) VALUES (5, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(5, 'Roberto', 'Sánchez', '1988-07-10', 'Masculino', 178.00, 95.00, 'Sedentario', 'roberto.sanchez@email.com', '5512345002', 'Laura Sánchez', '5598765002', 'LOSE_WEIGHT', 'Hipertensión', 'Ninguna', 'Bajo en sodio', '2025-08-20 14:15:00');

-- Paciente 3: María López
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('maria.lopez', 'maria.lopez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'María', 'López');
INSERT INTO user_roles (user_id, role_id) VALUES (6, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(6, 'María', 'López', '1992-11-05', 'Femenino', 160.00, 55.00, 'Activo', 'maria.lopez@email.com', '5512345003', 'José López', '5598765003', 'GAIN_WEIGHT', 'Ninguna', 'Lactosa', 'Sin lactosa', '2025-10-01 09:00:00');

-- Paciente 4: Carlos Ramírez
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('carlos.ramirez', 'carlos.ramirez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Carlos', 'Ramírez');
INSERT INTO user_roles (user_id, role_id) VALUES (7, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(7, 'Carlos', 'Ramírez', '1985-01-18', 'Masculino', 182.00, 88.00, 'Muy activo', 'carlos.ramirez@email.com', '5512345004', 'Ana Ramírez', '5598765004', 'GAIN_MUSCLE', 'Ninguna', 'Ninguna', 'Alta en proteínas', '2025-09-05 11:20:00');

-- Paciente 5: Laura Hernández
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('laura.hernandez', 'laura.hernandez@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Laura', 'Hernández');
INSERT INTO user_roles (user_id, role_id) VALUES (8, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(8, 'Laura', 'Hernández', '1990-06-30', 'Femenino', 168.00, 72.00, 'Moderado', 'laura.hernandez@email.com', '5512345005', 'Pedro Hernández', '5598765005', 'LOSE_WEIGHT', 'Diabetes tipo 2', 'Ninguna', 'Bajo en azúcares', '2025-07-12 16:45:00');

-- Paciente 6: Diego Torres
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('diego.torres', 'diego.torres@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Diego', 'Torres');
INSERT INTO user_roles (user_id, role_id) VALUES (9, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(9, 'Diego', 'Torres', '1993-04-12', 'Masculino', 175.00, 70.00, 'Moderado', 'diego.torres@email.com', '5512345006', 'Sofia Torres', '5598765006', 'MAINTAIN_WEIGHT', 'Ninguna', 'Mariscos', 'Sin mariscos', '2025-10-15 13:30:00');

-- Paciente 7: Sofía Flores
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('sofia.flores', 'sofia.flores@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Sofía', 'Flores');
INSERT INTO user_roles (user_id, role_id) VALUES (10, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(10, 'Sofía', 'Flores', '1997-09-28', 'Femenino', 162.00, 58.00, 'Activo', 'sofia.flores@email.com', '5512345007', 'Miguel Flores', '5598765007', 'GAIN_MUSCLE', 'Ninguna', 'Ninguna', 'Alta en proteínas', '2025-11-01 10:00:00');

-- Paciente 8: Fernando Vargas
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('fernando.vargas', 'fernando.vargas@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Fernando', 'Vargas');
INSERT INTO user_roles (user_id, role_id) VALUES (11, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(11, 'Fernando', 'Vargas', '1987-12-03', 'Masculino', 180.00, 102.00, 'Sedentario', 'fernando.vargas@email.com', '5512345008', 'Patricia Vargas', '5598765008', 'LOSE_WEIGHT', 'Obesidad, Colesterol alto', 'Ninguna', 'Bajo en grasas', '2025-08-08 15:20:00');

-- Paciente 9: Patricia Castro
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('patricia.castro', 'patricia.castro@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Patricia', 'Castro');
INSERT INTO user_roles (user_id, role_id) VALUES (12, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(12, 'Patricia', 'Castro', '1991-02-14', 'Femenino', 158.00, 62.00, 'Moderado', 'patricia.castro@email.com', '5512345009', 'Jorge Castro', '5598765009', 'MAINTAIN_WEIGHT', 'Ninguna', 'Gluten', 'Sin gluten', '2025-10-20 12:00:00');

-- Paciente 10: Miguel Ángel Reyes
INSERT INTO users (username, email, password, first_name, last_name) VALUES 
('miguel.reyes', 'miguel.reyes@email.com', '$2a$10$hp7AYXdlOy7JGby9.FvDhufAqioNaprHsQdZOJIvmr8cG2a3m8zc2', 'Miguel Ángel', 'Reyes');
INSERT INTO user_roles (user_id, role_id) VALUES (13, 3);
INSERT INTO patients (user_id, first_name, last_name, date_of_birth, gender, height, current_weight, activity_level, email, phone, emergency_contact_name, emergency_contact_phone, health_goal, medical_conditions, allergies, dietary_restrictions, created_at) VALUES 
(13, 'Miguel Ángel', 'Reyes', '1994-08-25', 'Masculino', 172.00, 65.00, 'Muy activo', 'miguel.reyes@email.com', '5512345010', 'Carmen Reyes', '5598765010', 'GAIN_MUSCLE', 'Ninguna', 'Ninguna', 'Alta en proteínas', '2025-11-10 14:30:00');

-- ============================================================================
-- REGISTROS DE PESO HISTÓRICOS
-- ============================================================================

-- Ana Martínez (Paciente ID: 1) - Progreso de pérdida de peso
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(1, 72.50, '2025-09-15', 'Peso inicial', '2025-09-15 10:30:00'),
(1, 71.20, '2025-09-30', 'Buena adherencia al plan', '2025-09-30 10:00:00'),
(1, 70.00, '2025-10-15', 'Perdiendo peso consistentemente', '2025-10-15 10:30:00'),
(1, 69.00, '2025-10-30', 'Excelente progreso', '2025-10-30 10:15:00'),
(1, 68.00, '2025-11-15', 'Peso actual', '2025-11-15 10:45:00');

-- Roberto Sánchez (Paciente ID: 2) - Progreso de pérdida de peso
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(2, 98.50, '2025-08-20', 'Peso inicial', '2025-08-20 14:15:00'),
(2, 97.00, '2025-09-05', 'Iniciando cambios de hábitos', '2025-09-05 14:00:00'),
(2, 96.20, '2025-09-20', 'Buena respuesta', '2025-09-20 14:30:00'),
(2, 95.50, '2025-10-05', 'Progreso constante', '2025-10-05 14:15:00'),
(2, 95.00, '2025-11-01', 'Peso actual', '2025-11-01 14:00:00');

-- María López (Paciente ID: 3) - Progreso de ganancia de peso
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(3, 52.00, '2025-10-01', 'Peso inicial, necesita ganar masa', '2025-10-01 09:00:00'),
(3, 53.00, '2025-10-15', 'Aumentando calorías', '2025-10-15 09:30:00'),
(3, 54.00, '2025-11-01', 'Buen progreso', '2025-11-01 09:15:00'),
(3, 55.00, '2025-11-15', 'Peso actual', '2025-11-15 09:00:00');

-- Carlos Ramírez (Paciente ID: 4) - Ganancia muscular
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(4, 85.00, '2025-09-05', 'Inicio entrenamiento fuerza', '2025-09-05 11:20:00'),
(4, 86.00, '2025-09-20', 'Aumentando masa muscular', '2025-09-20 11:00:00'),
(4, 87.00, '2025-10-10', 'Progreso notable', '2025-10-10 11:30:00'),
(4, 88.00, '2025-11-05', 'Peso actual', '2025-11-05 11:15:00');

-- Laura Hernández (Paciente ID: 5) - Control de diabetes
INSERT INTO weight_entries (patient_id, weight, entry_date, notes, created_at) VALUES
(5, 75.00, '2025-07-12', 'Peso inicial, control glicémico', '2025-07-12 16:45:00'),
(5, 74.00, '2025-08-01', 'Mejorando control', '2025-08-01 16:30:00'),
(5, 73.00, '2025-09-01', 'Progreso estable', '2025-09-01 16:15:00'),
(5, 72.00, '2025-10-15', 'Peso actual', '2025-10-15 16:00:00');

-- ============================================================================
-- PLANES DE DIETA
-- ============================================================================

-- Plan para Ana Martínez - Pérdida de peso vegetariano
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(1, 2, 'Plan Vegetariano Balanceado', 'Plan enfocado en pérdida de peso saludable con opciones vegetarianas', 'Perder 5kg de forma saludable manteniendo nutrientes esenciales', 1600, '2025-09-15', '2025-12-15', 'ACTIVO', '2025-09-15 10:30:00');

-- Plan para Roberto Sánchez - Pérdida de peso y control de hipertensión
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(2, 2, 'Plan DASH Modificado', 'Plan bajo en sodio para controlar hipertensión y perder peso', 'Reducir peso y controlar presión arterial', 1800, '2025-08-20', '2025-12-20', 'ACTIVO', '2025-08-20 14:15:00');

-- Plan para María López - Ganancia de peso sin lactosa
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(3, 2, 'Plan Hipercalórico sin Lactosa', 'Plan para aumentar peso de forma saludable sin productos lácteos', 'Ganar 3kg de masa magra', 2200, '2025-10-01', '2026-01-01', 'ACTIVO', '2025-10-01 09:00:00');

-- Plan para Carlos Ramírez - Ganancia muscular
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(4, 2, 'Plan Alto en Proteínas', 'Plan deportivo para aumentar masa muscular', 'Ganar 5kg de músculo', 2800, '2025-09-05', '2025-12-05', 'ACTIVO', '2025-09-05 11:20:00');

-- Plan para Laura Hernández - Control de diabetes
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(5, 2, 'Plan para Diabetes Tipo 2', 'Plan bajo en azúcares simples y carbohidratos controlados', 'Control glicémico y pérdida de peso gradual', 1700, '2025-07-12', '2025-10-12', 'COMPLETADO', '2025-07-12 16:45:00');

-- Plan para Diego Torres - Mantenimiento
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(6, 2, 'Plan de Mantenimiento', 'Mantener peso saludable con alimentación balanceada', 'Mantener peso y buena salud', 2000, '2025-10-15', '2026-01-15', 'ACTIVO', '2025-10-15 13:30:00');

-- Plan para Sofía Flores - Ganancia muscular
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(7, 2, 'Plan Fitness Mujer', 'Plan para tonificación y ganancia de masa magra', 'Aumentar masa muscular y definición', 2100, '2025-11-01', '2026-02-01', 'ACTIVO', '2025-11-01 10:00:00');

-- Plan para Fernando Vargas - Pérdida de peso significativa
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(8, 2, 'Plan de Pérdida Intensiva', 'Plan bajo en grasas para pérdida de peso significativa', 'Perder 15kg en 4 meses de forma saludable', 1500, '2025-08-08', '2025-12-08', 'ACTIVO', '2025-08-08 15:20:00');

-- Plan para Patricia Castro - Mantenimiento sin gluten
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(9, 2, 'Plan sin Gluten', 'Plan de mantenimiento libre de gluten', 'Mantener peso y evitar síntomas de intolerancia', 1900, '2025-10-20', '2026-01-20', 'ACTIVO', '2025-10-20 12:00:00');

-- Plan para Miguel Ángel Reyes - Rendimiento deportivo
INSERT INTO diet_plans (patient_id, nutritionist_id, plan_name, description, goals, daily_calories, start_date, end_date, status, created_at) VALUES
(10, 2, 'Plan Deportivo Avanzado', 'Plan para optimizar rendimiento y ganancia muscular', 'Aumentar fuerza y masa muscular', 2700, '2025-11-10', '2026-02-10', 'ACTIVO', '2025-11-10 14:30:00');

-- ============================================================================
-- CITAS PROGRAMADAS
-- ============================================================================

-- Citas pasadas (completadas)
INSERT INTO appointments (patient_id, nutritionist_id, appointment_date, appointment_type, status, duration_minutes, notes, created_at) VALUES
-- Ana Martínez
(1, 2, '2025-09-15 10:30:00', 'PRIMERA_CONSULTA', 'COMPLETADA', 60, 'Evaluación inicial, medidas antropométricas', '2025-09-10 10:00:00'),
(1, 2, '2025-10-15 10:30:00', 'SEGUIMIENTO', 'COMPLETADA', 45, 'Revisión de progreso, ajuste de plan', '2025-10-10 09:00:00'),
(1, 2, '2025-11-15 10:30:00', 'SEGUIMIENTO', 'COMPLETADA', 45, 'Excelente adherencia, continuar plan', '2025-11-10 08:30:00'),

-- Roberto Sánchez
(2, 2, '2025-08-20 14:00:00', 'PRIMERA_CONSULTA', 'COMPLETADA', 60, 'Evaluación inicial, análisis de presión arterial', '2025-08-15 11:00:00'),
(2, 2, '2025-09-20 14:00:00', 'SEGUIMIENTO', 'COMPLETADA', 45, 'Buena respuesta al plan DASH', '2025-09-15 10:30:00'),
(2, 2, '2025-10-20 14:00:00', 'CONTROL', 'COMPLETADA', 30, 'Control de presión, ajuste de sodio', '2025-10-15 09:00:00'),

-- María López
(3, 2, '2025-10-01 09:00:00', 'PRIMERA_CONSULTA', 'COMPLETADA', 60, 'Evaluación nutricional, plan hipercalórico', '2025-09-25 14:00:00'),
(3, 2, '2025-11-01 09:00:00', 'SEGUIMIENTO', 'COMPLETADA', 45, 'Ganancia progresiva de peso', '2025-10-28 10:00:00'),

-- Citas próximas (confirmadas y pendientes)
-- Citas para diciembre 2024
-- Citas para diciembre 2024
(1, 2, '2025-12-15 10:30:00', 'SEGUIMIENTO', 'CONFIRMADA', 45, 'Evaluación final del plan', '2025-11-20 10:00:00'),
(2, 2, '2025-12-05 14:00:00', 'CONTROL', 'CONFIRMADA', 30, 'Control de presión arterial', '2025-11-25 09:00:00'),
(3, 2, '2025-12-01 09:00:00', 'SEGUIMIENTO', 'CONFIRMADA', 45, 'Revisión de progreso', '2025-11-20 11:00:00'),
(4, 2, '2025-12-10 11:00:00', 'SEGUIMIENTO', 'PENDIENTE', 45, 'Evaluación de masa muscular', '2025-11-22 14:00:00'),
(5, 2, '2025-12-08 16:00:00', 'CONTROL', 'CONFIRMADA', 45, 'Revisión de glucosa', '2025-11-23 10:30:00'),
(6, 2, '2025-12-12 13:30:00', 'SEGUIMIENTO', 'PENDIENTE', 30, 'Control de mantenimiento', '2025-11-24 09:00:00'),
(7, 2, '2025-12-03 10:00:00', 'SEGUIMIENTO', 'CONFIRMADA', 45, 'Evaluación de progreso fitness', '2025-11-26 11:00:00'),
(8, 2, '2025-12-06 15:00:00', 'CONTROL', 'CONFIRMADA', 45, 'Control de peso y colesterol', '2025-11-27 10:00:00'),
(9, 2, '2025-12-14 12:00:00', 'SEGUIMIENTO', 'PENDIENTE', 30, 'Revisión plan sin gluten', '2025-11-28 14:00:00'),
(10, 2, '2025-12-04 14:30:00', 'PRIMERA_CONSULTA', 'CONFIRMADA', 60, 'Evaluación inicial deportiva', '2025-11-29 09:00:00'),
-- Citas adicionales: 2 para hoy + 1 cita futura por paciente (11-20)
(3, 2, '2025-12-04 10:00:00', 'CONTROL', 'CONFIRMADA', 45, 'Control de progreso en pérdida de peso', '2025-11-30 09:00:00'),
(4, 2, '2025-12-04 15:30:00', 'SEGUIMIENTO', 'CONFIRMADA', 30, 'Ajuste de plan bajo en sodio', '2025-11-30 10:00:00'),
(3, 2, '2025-12-15 09:00:00', 'SEGUIMIENTO', 'PENDIENTE', 45, 'Evaluación mensual vegetariana', '2025-12-01 09:00:00'),
(4, 2, '2025-12-16 14:00:00', 'CONTROL', 'PENDIENTE', 30, 'Medición de presión arterial', '2025-12-01 10:00:00'),
(5, 2, '2025-12-17 10:30:00', 'SEGUIMIENTO', 'PENDIENTE', 45, 'Revisión de aumento de peso', '2025-12-01 11:00:00'),
(6, 2, '2025-12-18 16:00:00', 'CONTROL', 'PENDIENTE', 45, 'Control de masa muscular', '2025-12-01 14:00:00'),
(7, 2, '2025-12-19 11:00:00', 'SEGUIMIENTO', 'PENDIENTE', 45, 'Ajuste de plan diabético', '2025-12-01 15:00:00'),
(8, 2, '2025-12-20 13:30:00', 'CONTROL', 'PENDIENTE', 30, 'Revisión de mantenimiento', '2025-12-01 16:00:00'),
(9, 2, '2025-12-21 10:00:00', 'SEGUIMIENTO', 'PENDIENTE', 45, 'Evaluación fitness femenina', '2025-12-02 09:00:00'),
(10, 2, '2025-12-22 15:00:00', 'CONTROL', 'PENDIENTE', 45, 'Control de pérdida de peso intensiva', '2025-12-02 10:00:00'),
(1, 2, '2025-12-23 12:00:00', 'SEGUIMIENTO', 'PENDIENTE', 30, 'Control de peso vegetariano', '2025-12-02 11:00:00'),
(2, 2, '2025-12-24 14:30:00', 'CONTROL', 'PENDIENTE', 60, 'Evaluación de presión arterial', '2025-12-02 14:00:00');

-- ============================================================================
-- COMIDAS PARA LOS PLANES ALIMENTICIOS
-- ============================================================================
-- 50 comidas totales (5 comidas por cada uno de los 10 planes)
-- Cada plan incluye: DESAYUNO, COLACION_AM, ALMUERZO, COLACION_PM, CENA

INSERT INTO diet_meals (diet_plan_id, meal_type, meal_name, description, ingredients, instructions, calories, protein_grams, carbs_grams, fat_grams, fiber_grams, servings, preparation_time, created_at) VALUES
-- Plan 1: Ana Martínez - Vegetariano Balanceado (1600 cal)
(1, 'DESAYUNO', 'Avena con Frutas y Almendras', 'Bowl de avena integral con frutas frescas y almendras', 'Avena integral (60g), Leche de almendras (200ml), Plátano (1 mediano), Fresas (100g), Almendras laminadas (20g), Miel (1 cucharadita), Canela', '1. Cocinar la avena con la leche de almendras a fuego medio durante 5 minutos. 2. Agregar la canela y endulzar con miel. 3. Servir en un bowl y decorar con plátano en rodajas, fresas y almendras.', 400, 15, 65, 12, 10, 1, 10, NOW()),
(1, 'COLACION_AM', 'Smoothie Verde Energético', 'Batido verde con espinaca, manzana y jengibre', 'Espinacas frescas (1 taza), Manzana verde (1 pieza), Pepino (1/2 pieza), Jengibre fresco (1cm), Jugo de limón (1 cucharada), Agua (200ml), Semillas de chía (1 cucharada)', '1. Lavar todas las verduras y frutas. 2. Colocar todos los ingredientes en la licuadora. 3. Licuar hasta obtener una consistencia suave. 4. Servir inmediatamente.', 120, 3, 25, 2, 5, 1, 5, NOW()),
(1, 'ALMUERZO', 'Ensalada de Lentejas con Vegetales', 'Ensalada completa con lentejas cocidas y vegetales frescos', 'Lentejas cocidas (150g), Tomate cherry (100g), Pepino (1 pieza), Pimiento rojo (1 pieza), Cebolla morada (1/4 pieza), Espinacas baby (1 taza), Aceite de oliva (1 cucharada), Vinagre balsámico (1 cucharada), Sal y pimienta', '1. Cocinar las lentejas hasta que estén tiernas. 2. Cortar todos los vegetales en cubos pequeños. 3. Mezclar todos los ingredientes en un bowl grande. 4. Aderezar con aceite de oliva y vinagre balsámico. 5. Sazonar con sal y pimienta al gusto.', 500, 25, 70, 10, 15, 1, 20, NOW()),
(1, 'COLACION_PM', 'Yogurt con Granola y Arándanos', 'Yogurt natural con granola casera y arándanos frescos', 'Yogurt griego natural (150g), Granola sin azúcar (30g), Arándanos frescos (50g), Nueces picadas (15g), Miel de agave (1 cucharadita)', '1. Servir el yogurt en un vaso o bowl. 2. Agregar la granola encima. 3. Decorar con arándanos y nueces. 4. Rociar con miel de agave.', 230, 12, 30, 8, 4, 1, 3, NOW()),
(1, 'CENA', 'Tofu al Horno con Verduras Asadas', 'Tofu marinado al horno acompañado de vegetales asados', 'Tofu firme (200g), Brócoli (150g), Zanahoria (1 pieza), Calabacín (1 pieza), Aceite de oliva (1 cucharada), Salsa de soja (2 cucharadas), Ajo en polvo (1 cucharadita), Jengibre molido (1/2 cucharadita), Semillas de ajonjolí', '1. Cortar el tofu en cubos y marinar con salsa de soja, ajo y jengibre por 30 minutos. 2. Cortar las verduras en trozos medianos. 3. Colocar el tofu y las verduras en una bandeja para hornear. 4. Rociar con aceite de oliva. 5. Hornear a 200°C por 25 minutos. 6. Espolvorear con ajonjolí antes de servir.', 350, 25, 30, 18, 8, 1, 35, NOW()),

-- Plan 2: Roberto Sánchez - Plan DASH Bajo en Sodio (1800 cal)
(2, 'DESAYUNO', 'Huevos Revueltos con Avena y Frutas', 'Huevos revueltos sin sal con avena y fruta fresca', 'Huevos (2 piezas), Avena cocida (40g), Espinacas (1/2 taza), Naranja (1 pieza), Aceite de oliva (1 cucharadita), Pimienta negra', '1. Batir los huevos y cocinarlos con las espinacas en aceite de oliva. 2. Sazonar solo con pimienta. 3. Servir con avena cocida sin sal. 4. Acompañar con naranja en gajos.', 420, 20, 45, 18, 6, 1, 12, NOW()),
(2, 'COLACION_AM', 'Plátano con Mantequilla de Almendras', 'Plátano natural con mantequilla de almendras sin sal', 'Plátano (1 pieza grande), Mantequilla de almendras sin sal (2 cucharadas), Canela en polvo', '1. Cortar el plátano por la mitad a lo largo. 2. Untar la mantequilla de almendras. 3. Espolvorear con canela.', 280, 8, 42, 12, 5, 1, 2, NOW()),
(2, 'ALMUERZO', 'Pechuga de Pollo con Arroz Integral', 'Pechuga de pollo a la plancha con arroz integral y ensalada', 'Pechuga de pollo (150g), Arroz integral (80g crudo), Lechuga (1 taza), Tomate (1 pieza), Limón (1 pieza), Hierbas frescas (perejil, cilantro), Aceite de oliva (1 cucharada)', '1. Sazonar el pollo solo con hierbas frescas y pimienta (sin sal). 2. Cocinar la pechuga a la plancha. 3. Cocer el arroz integral sin sal. 4. Preparar ensalada fresca con limón y aceite de oliva. 5. Servir todo junto.', 550, 45, 60, 12, 8, 1, 25, NOW()),
(2, 'COLACION_PM', 'Zanahorias con Hummus Casero', 'Bastones de zanahoria con hummus sin sal añadida', 'Zanahorias (200g), Garbanzos cocidos (100g), Tahini (1 cucharada), Jugo de limón (2 cucharadas), Ajo (1 diente), Comino (1/2 cucharadita), Aceite de oliva (1 cucharada)', '1. Preparar el hummus licuando garbanzos, tahini, limón, ajo y comino sin sal. 2. Cortar las zanahorias en bastones. 3. Servir las zanahorias con el hummus.', 250, 10, 35, 8, 8, 1, 10, NOW()),
(2, 'CENA', 'Salmón al Horno con Verduras al Vapor', 'Filete de salmón con vegetales al vapor y hierbas', 'Salmón fresco (150g), Brócoli (150g), Ejotes (100g), Limón (1 pieza), Eneldo fresco, Pimienta, Aceite de oliva (1 cucharadita)', '1. Sazonar el salmón con limón, eneldo y pimienta (sin sal). 2. Hornear a 180°C por 15 minutos. 3. Cocinar las verduras al vapor sin sal. 4. Servir el salmón sobre las verduras con un chorrito de limón.', 500, 40, 25, 25, 7, 1, 20, NOW()),

-- Plan 3: María López - Hipercalórico sin Lactosa (2200 cal)
(3, 'DESAYUNO', 'Pancakes de Avena con Crema de Cacahuate', 'Pancakes integrales con crema de cacahuate y plátano', 'Avena molida (80g), Huevo (2 piezas), Leche de coco (100ml), Plátano (1 pieza), Crema de cacahuate (3 cucharadas), Miel de maple (2 cucharadas), Polvo de hornear (1 cucharadita)', '1. Mezclar avena molida, huevos, leche de coco y polvo de hornear. 2. Cocinar los pancakes en sartén antiadherente. 3. Servir con crema de cacahuate, plátano en rodajas y miel de maple.', 620, 25, 75, 25, 8, 1, 15, NOW()),
(3, 'COLACION_AM', 'Batido Hipercalórico de Frutas', 'Smoothie denso con frutas, avena y mantequilla de almendras', 'Leche de almendras (300ml), Plátano (1 grande), Mango (1 taza), Avena (40g), Mantequilla de almendras (2 cucharadas), Dátiles (3 piezas), Semillas de linaza (1 cucharada)', '1. Colocar todos los ingredientes en la licuadora. 2. Licuar hasta obtener consistencia cremosa. 3. Servir frío.', 480, 12, 82, 15, 10, 1, 5, NOW()),
(3, 'ALMUERZO', 'Arroz con Pollo y Aguacate', 'Arroz integral con pollo, frijoles y aguacate', 'Pechuga de pollo (180g), Arroz integral (100g crudo), Frijoles negros (100g), Aguacate (1 pieza), Tomate (1 pieza), Cebolla (1/2 pieza), Aceite de oliva (2 cucharadas), Especias', '1. Cocinar el pollo sazonado con especias. 2. Preparar el arroz integral. 3. Calentar los frijoles negros. 4. Servir todo junto con aguacate en rebanadas y pico de gallo.', 720, 48, 85, 22, 15, 1, 30, NOW()),
(3, 'COLACION_PM', 'Pan Integral con Aguacate y Semillas', 'Tostadas integrales con aguacate y mix de semillas', 'Pan integral (2 rebanadas), Aguacate (1/2 pieza), Semillas de girasol (10g), Semillas de calabaza (10g), Aceite de oliva (1 cucharadita), Limón, Pimienta', '1. Tostar el pan integral. 2. Machacar el aguacate con limón y pimienta. 3. Untar en el pan. 4. Espolvorear con las semillas. 5. Rociar con aceite de oliva.', 380, 12, 42, 22, 12, 1, 5, NOW()),
(3, 'CENA', 'Lentejas con Vegetales al Curry', 'Curry vegetariano de lentejas con vegetales', 'Lentejas (150g), Leche de coco (100ml), Espinacas (1 taza), Tomate (2 piezas), Cebolla (1 pieza), Curry en polvo (2 cucharaditas), Ajo (2 dientes), Arroz integral (60g crudo), Aceite de coco (1 cucharadita)', '1. Cocinar las lentejas hasta que estén tiernas. 2. Saltear cebolla y ajo en aceite de coco. 3. Agregar tomate, curry y leche de coco. 4. Incorporar lentejas y espinacas. 5. Cocinar el arroz integral. 6. Servir el curry sobre el arroz.', 400, 20, 65, 10, 14, 1, 30, NOW()),

-- Plan 4: Carlos Ramírez - Ganancia Muscular Alto en Proteínas (2800 cal)
(4, 'DESAYUNO', 'Omelette con Avena y Frutas', 'Omelette de 4 huevos con avena y batido de proteína', 'Huevos (4 piezas), Espinacas (1 taza), Champiñones (50g), Avena cocida (60g), Plátano (1 grande), Nueces (20g), Aceite de oliva (1 cucharada)', '1. Preparar omelette con los huevos, espinacas y champiñones. 2. Cocinar la avena con agua. 3. Servir todo junto con plátano y nueces encima de la avena.', 650, 42, 65, 25, 9, 1, 15, NOW()),
(4, 'COLACION_AM', 'Batido Post-Entrenamiento', 'Batido alto en proteínas y carbohidratos', 'Proteína en polvo (2 scoops/60g), Leche entera (300ml), Plátano (2 piezas), Mantequilla de maní (3 cucharadas), Avena (40g), Miel (1 cucharada)', '1. Colocar todos los ingredientes en la licuadora. 2. Licuar hasta consistencia suave. 3. Consumir inmediatamente después del entrenamiento.', 580, 50, 70, 15, 6, 1, 5, NOW()),
(4, 'ALMUERZO', 'Pollo al Horno con Arroz y Ensalada', 'Pechuga de pollo con arroz integral y ensalada abundante', 'Pechuga de pollo (250g), Arroz integral (120g crudo), Brócoli (200g), Aguacate (1 pieza), Aceite de oliva (2 cucharadas), Ajo, Especias', '1. Sazonar y hornear el pollo con ajo y especias. 2. Cocinar el arroz integral. 3. Cocinar el brócoli al vapor. 4. Servir con aguacate en rebanadas y aceite de oliva.', 750, 60, 85, 20, 12, 1, 30, NOW()),
(4, 'COLACION_PM', 'Atún con Galletas Integrales', 'Atún en agua con galletas y verduras', 'Atún en agua (2 latas/150g), Galletas integrales (6 piezas), Tomate (1 pieza), Pepino (1/2 pieza), Aceite de oliva (1 cucharada), Limón', '1. Escurrir el atún. 2. Mezclar con tomate y pepino picados. 3. Aderezar con aceite de oliva y limón. 4. Servir con galletas integrales.', 400, 45, 38, 8, 5, 1, 5, NOW()),
(4, 'CENA', 'Res con Camote y Vegetales', 'Carne magra de res con camote asado y vegetales', 'Carne de res magra (200g), Camote (250g), Espárragos (150g), Aceite de oliva (1 cucharada), Ajo, Romero, Sal y pimienta', '1. Sazonar y cocinar la carne a término medio. 2. Hornear el camote en cubos con aceite de oliva y romero. 3. Cocinar los espárragos a la plancha con ajo. 4. Servir todo junto.', 820, 55, 80, 28, 12, 1, 35, NOW()),

-- Plan 5: Laura Hernández - Control de Diabetes (1700 cal)
(5, 'DESAYUNO', 'Huevos con Aguacate y Pan Integral', 'Huevos revueltos con aguacate en pan integral', 'Huevos (2 piezas), Pan integral (2 rebanadas), Aguacate (1/2 pieza), Tomate (1 pieza), Espinacas (1/2 taza), Aceite de oliva (1 cucharadita)', '1. Preparar huevos revueltos con espinacas. 2. Tostar el pan integral. 3. Servir los huevos sobre el pan con aguacate y tomate en rodajas.', 420, 20, 42, 20, 10, 1, 12, NOW()),
(5, 'COLACION_AM', 'Nueces con Manzana', 'Mix de nueces naturales con manzana verde', 'Nueces mixtas (30g: almendras, nueces, pistaches), Manzana verde (1 pieza)', '1. Lavar y cortar la manzana en rebanadas. 2. Servir con el mix de nueces.', 220, 6, 28, 12, 6, 1, 2, NOW()),
(5, 'ALMUERZO', 'Pescado con Quinoa y Vegetales', 'Filete de pescado blanco con quinoa y verduras al vapor', 'Pescado blanco (150g), Quinoa (60g cruda), Brócoli (150g), Zanahoria (1 pieza), Ejotes (100g), Limón (1 pieza), Aceite de oliva (1 cucharada), Eneldo', '1. Cocinar el pescado a la plancha con limón y eneldo. 2. Preparar la quinoa. 3. Cocinar las verduras al vapor. 4. Servir todo junto con aceite de oliva.', 500, 40, 55, 12, 10, 1, 25, NOW()),
(5, 'COLACION_PM', 'Yogurt Griego con Almendras', 'Yogurt griego natural con almendras y canela', 'Yogurt griego sin azúcar (150g), Almendras (20g), Canela en polvo (1/2 cucharadita)', '1. Servir el yogurt en un bowl. 2. Agregar almendras picadas. 3. Espolvorear con canela.', 200, 15, 12, 12, 3, 1, 3, NOW()),
(5, 'CENA', 'Pollo con Ensalada Grande', 'Pechuga de pollo con ensalada mixta abundante', 'Pechuga de pollo (150g), Lechuga romana (2 tazas), Espinacas (1 taza), Pepino (1 pieza), Tomate cherry (100g), Aceite de oliva (1 cucharada), Vinagre balsámico (1 cucharada), Semillas de girasol (10g)', '1. Cocinar el pollo a la plancha. 2. Preparar una ensalada abundante con todas las verduras. 3. Cortar el pollo en tiras. 4. Aderezar con aceite de oliva y vinagre balsámico. 5. Espolvorear con semillas de girasol.', 360, 40, 20, 15, 8, 1, 15, NOW()),

-- Plan 6: Diego Torres - Mantenimiento sin Mariscos (2000 cal)
(6, 'DESAYUNO', 'Tostadas Francesas con Frutas', 'French toast con frutas frescas y yogurt', 'Pan integral (2 rebanadas), Huevo (1 pieza), Leche (50ml), Fresas (100g), Arándanos (50g), Yogurt natural (100g), Miel (1 cucharada), Canela', '1. Batir huevo con leche y canela. 2. Sumergir el pan y cocinar en sartén hasta dorar. 3. Servir con frutas frescas, yogurt y miel.', 450, 18, 68, 12, 8, 1, 12, NOW()),
(6, 'COLACION_AM', 'Smoothie de Mango y Espinaca', 'Batido verde con mango y espinacas', 'Mango (1 taza), Espinacas (1 taza), Plátano (1 pieza), Leche de almendras (200ml), Semillas de chía (1 cucharada)', '1. Colocar todos los ingredientes en la licuadora. 2. Licuar hasta consistencia suave. 3. Servir frío.', 250, 5, 52, 4, 8, 1, 5, NOW()),
(6, 'ALMUERZO', 'Pechuga de Pavo con Arroz y Verduras', 'Pechuga de pavo con arroz integral y vegetales salteados', 'Pechuga de pavo (180g), Arroz integral (80g crudo), Calabacín (1 pieza), Pimiento rojo (1 pieza), Cebolla (1/2 pieza), Ajo (2 dientes), Aceite de oliva (1 cucharada)', '1. Cocinar la pechuga de pavo a la plancha. 2. Preparar el arroz integral. 3. Saltear las verduras con ajo en aceite de oliva. 4. Servir todo junto.', 580, 48, 65, 12, 9, 1, 25, NOW()),
(6, 'COLACION_PM', 'Pan Pita con Hummus', 'Pan pita integral con hummus y vegetales', 'Pan pita integral (1 pieza), Hummus (80g), Zanahoria (1 pieza), Pepino (1/2 pieza), Pimiento (1/2 pieza)', '1. Cortar los vegetales en bastones. 2. Servir el hummus con el pan pita y los vegetales para dipear.', 320, 12, 48, 10, 8, 1, 5, NOW()),
(6, 'CENA', 'Pollo Teriyaki con Vegetales', 'Pollo en salsa teriyaki con vegetales al wok', 'Pechuga de pollo (150g), Brócoli (150g), Zanahoria (1 pieza), Pimiento (1 pieza), Salsa teriyaki baja en sodio (2 cucharadas), Aceite de ajonjolí (1 cucharadita), Arroz integral (60g crudo)', '1. Cortar el pollo en cubos y marinar con salsa teriyaki. 2. Saltear el pollo con los vegetales en aceite de ajonjolí. 3. Cocinar el arroz integral. 4. Servir el pollo teriyaki sobre el arroz.', 400, 38, 45, 8, 7, 1, 20, NOW()),

-- Plan 7: Sofía Flores - Plan Fitness Mujer (2100 cal)
(7, 'DESAYUNO', 'Bowl de Proteína con Frutas', 'Bowl energético con proteína, avena y frutas', 'Avena cocida (50g), Proteína en polvo sabor vainilla (1 scoop/30g), Plátano (1 pieza), Fresas (100g), Mantequilla de almendras (1 cucharada), Semillas de hemp (1 cucharada), Coco rallado (10g)', '1. Cocinar la avena y mezclar con la proteína en polvo. 2. Servir en un bowl. 3. Decorar con frutas, mantequilla de almendras, semillas y coco.', 480, 32, 62, 14, 9, 1, 10, NOW()),
(7, 'COLACION_AM', 'Tortitas de Arroz con Aguacate', 'Tortitas de arroz integral con aguacate y huevo', 'Tortitas de arroz (2 piezas), Aguacate (1/2 pieza), Huevo (1 pieza), Tomate cherry (5 piezas), Sal rosa del Himalaya', '1. Preparar huevo cocido. 2. Machacar el aguacate. 3. Untar aguacate en las tortitas. 4. Agregar el huevo rebanado y tomates cherry.', 280, 12, 28, 15, 6, 1, 8, NOW()),
(7, 'ALMUERZO', 'Ensalada de Pollo con Quinoa', 'Ensalada completa con pollo, quinoa y vegetales', 'Pechuga de pollo (150g), Quinoa cocida (80g), Lechuga mixta (2 tazas), Aguacate (1/2 pieza), Tomate cherry (100g), Pepino (1/2 pieza), Aceite de oliva (1 cucharada), Limón (1 pieza), Semillas de girasol (10g)', '1. Cocinar el pollo a la plancha y cortar en tiras. 2. Preparar la quinoa. 3. Mezclar todas las verduras. 4. Agregar el pollo y la quinoa. 5. Aderezar con aceite de oliva y limón. 6. Espolvorear con semillas de girasol.', 520, 42, 48, 20, 10, 1, 20, NOW()),
(7, 'COLACION_PM', 'Batido de Proteína con Bayas', 'Smoothie de proteína con frutos rojos', 'Proteína en polvo (1 scoop/30g), Leche de almendras (250ml), Fresas (100g), Arándanos (50g), Espinacas (1 taza), Plátano (1/2 pieza), Semillas de linaza (1 cucharada)', '1. Colocar todos los ingredientes en la licuadora. 2. Licuar hasta consistencia cremosa. 3. Servir inmediatamente.', 300, 28, 38, 5, 8, 1, 5, NOW()),
(7, 'CENA', 'Salmón con Camote y Espárragos', 'Filete de salmón con camote asado y espárragos', 'Salmón (150g), Camote (200g), Espárragos (150g), Aceite de oliva (1 cucharada), Limón (1 pieza), Ajo (2 dientes), Eneldo fresco', '1. Sazonar el salmón con limón, ajo y eneldo. 2. Hornear a 180°C por 15 minutos. 3. Asar el camote en cubos. 4. Cocinar los espárragos a la plancha. 5. Servir todo junto con aceite de oliva.', 520, 38, 52, 18, 10, 1, 30, NOW()),

-- Plan 8: Fernando Vargas - Pérdida de Peso Intensiva (1500 cal)
(8, 'DESAYUNO', 'Omelette de Claras con Verduras', 'Omelette de claras de huevo con vegetales', 'Claras de huevo (4 piezas), Espinacas (1 taza), Champiñones (50g), Tomate (1 pieza), Cebolla (1/4 pieza), Pimienta, Spray de aceite', '1. Batir las claras de huevo. 2. Cocinar las verduras en sartén antiadherente. 3. Agregar las claras y cocinar hasta cuajar. 4. Sazonar con pimienta.', 280, 25, 18, 8, 5, 1, 10, NOW()),
(8, 'COLACION_AM', 'Pepino con Limón', 'Pepino fresco con limón y chile en polvo', 'Pepino (1 grande), Limón (1 pieza), Chile en polvo (al gusto), Sal baja en sodio (pizca)', '1. Cortar el pepino en rodajas o bastones. 2. Rociar con jugo de limón. 3. Espolvorear con chile en polvo y una pizca de sal.', 60, 2, 12, 0, 3, 1, 2, NOW()),
(8, 'ALMUERZO', 'Pescado al Vapor con Brócoli', 'Filete de pescado blanco al vapor con brócoli y limón', 'Pescado blanco (180g), Brócoli (200g), Calabacín (1 pieza), Limón (1 pieza), Ajo (2 dientes), Hierbas frescas (perejil, cilantro), Spray de aceite', '1. Cocinar el pescado al vapor con limón y hierbas. 2. Cocinar el brócoli y calabacín al vapor. 3. Servir todo junto con más limón y ajo picado.', 300, 40, 20, 5, 8, 1, 15, NOW()),
(8, 'COLACION_PM', 'Gelatina Light con Fresas', 'Gelatina sin azúcar con fresas frescas', 'Gelatina sin azúcar (1 porción), Fresas (100g)', '1. Preparar la gelatina según instrucciones del paquete. 2. Refrigerar hasta cuajar. 3. Servir con fresas en rodajas.', 80, 3, 12, 0, 2, 1, 5, NOW()),
(8, 'CENA', 'Pechuga de Pollo con Ensalada Verde', 'Pechuga de pollo a la plancha con ensalada abundante', 'Pechuga de pollo (150g), Lechuga romana (2 tazas), Espinacas (1 taza), Pepino (1 pieza), Rábanos (50g), Limón (1 pieza), Vinagre de manzana (1 cucharada), Sal y pimienta', '1. Cocinar la pechuga de pollo a la plancha sin aceite. 2. Preparar una ensalada abundante con todas las verduras. 3. Aderezar solo con limón y vinagre de manzana. 4. Cortar el pollo y servir sobre la ensalada.', 280, 42, 15, 5, 6, 1, 12, NOW()),

-- Plan 9: Patricia Castro - Plan sin Gluten (1900 cal)
(9, 'DESAYUNO', 'Smoothie Bowl sin Gluten', 'Bowl de smoothie con frutas y toppings sin gluten', 'Plátano congelado (1 pieza), Mango (1 taza), Leche de coco (150ml), Proteína en polvo sin gluten (1 scoop/30g), Granola sin gluten (30g), Coco rallado (10g), Fresas (50g), Semillas de chía (1 cucharada)', '1. Licuar el plátano, mango, leche de coco y proteína hasta consistencia espesa. 2. Servir en un bowl. 3. Decorar con granola sin gluten, coco, fresas y chía.', 450, 25, 65, 12, 10, 1, 8, NOW()),
(9, 'COLACION_AM', 'Manzana con Mantequilla de Almendras', 'Manzana en rebanadas con mantequilla de almendras', 'Manzana (1 grande), Mantequilla de almendras (2 cucharadas), Canela en polvo', '1. Cortar la manzana en rebanadas. 2. Servir con mantequilla de almendras para dipear. 3. Espolvorear con canela.', 260, 6, 38, 12, 6, 1, 3, NOW()),
(9, 'ALMUERZO', 'Tacos de Lechuga con Pollo', 'Tacos sin tortilla usando hojas de lechuga', 'Pechuga de pollo (150g), Lechuga romana (6 hojas grandes), Arroz integral (60g crudo), Frijoles negros (80g), Aguacate (1/2 pieza), Tomate (1 pieza), Cebolla (1/4 pieza), Cilantro, Limón', '1. Cocinar el pollo sazonado y desmenuzar. 2. Preparar arroz integral y frijoles. 3. Usar hojas de lechuga como tortillas. 4. Rellenar con pollo, arroz, frijoles, aguacate y pico de gallo. 5. Servir con limón.', 520, 42, 58, 15, 12, 1, 25, NOW()),
(9, 'COLACION_PM', 'Chips de Camote Horneados', 'Chips caseros de camote al horno', 'Camote (1 grande), Aceite de coco (1 cucharadita), Sal marina (pizca), Paprika (1/2 cucharadita)', '1. Cortar el camote en rebanadas finas. 2. Rociar con aceite de coco. 3. Espolvorear con sal y paprika. 4. Hornear a 200°C por 20 minutos hasta crujientes.', 270, 3, 52, 6, 8, 1, 25, NOW()),
(9, 'CENA', 'Salmón con Quinoa y Verduras', 'Filete de salmón con quinoa y vegetales asados', 'Salmón (140g), Quinoa (50g cruda), Calabacín (1 pieza), Berenjena (1/2 pieza), Pimiento rojo (1 pieza), Aceite de oliva (1 cucharada), Limón (1 pieza), Ajo (2 dientes)', '1. Cocinar la quinoa. 2. Sazonar el salmón con limón y ajo, hornear a 180°C por 15 minutos. 3. Asar las verduras con aceite de oliva. 4. Servir todo junto.', 400, 35, 42, 12, 9, 1, 30, NOW()),

-- Plan 10: Miguel Ángel Reyes - Rendimiento Atlético (2700 cal)
(10, 'DESAYUNO', 'Desayuno del Campeón', 'Desayuno completo alto en calorías y proteínas', 'Huevos (3 piezas), Avena cocida (80g), Plátano (2 piezas), Mantequilla de maní (3 cucharadas), Tocino de pavo (3 tiras), Pan integral tostado (2 rebanadas), Miel (1 cucharada)', '1. Preparar huevos revueltos. 2. Cocinar el tocino de pavo. 3. Preparar la avena. 4. Tostar el pan. 5. Servir todo junto con plátanos y mantequilla de maní sobre la avena.', 780, 45, 92, 28, 12, 1, 20, NOW()),
(10, 'COLACION_AM', 'Batido de Recuperación', 'Batido post-entrenamiento con carbohidratos y proteínas', 'Proteína en polvo (2 scoops/60g), Leche entera (350ml), Plátano (2 piezas), Avena (50g), Mantequilla de almendras (2 cucharadas), Miel (2 cucharadas), Canela', '1. Colocar todos los ingredientes en la licuadora. 2. Licuar hasta consistencia cremosa. 3. Consumir inmediatamente después del entrenamiento.', 620, 55, 78, 16, 8, 1, 5, NOW()),
(10, 'ALMUERZO', 'Bowl Power de Res', 'Bowl atlético con carne de res, arroz y vegetales', 'Carne de res magra (220g), Arroz integral (120g crudo), Camote (200g), Brócoli (150g), Aguacate (1 pieza), Frijoles negros (100g), Aceite de oliva (2 cucharadas)', '1. Cocinar la carne de res a la plancha. 2. Preparar el arroz integral. 3. Hornear el camote en cubos. 4. Cocinar el brócoli al vapor. 5. Calentar los frijoles. 6. Servir todo en un bowl grande con aguacate.', 820, 60, 95, 25, 18, 1, 35, NOW()),
(10, 'COLACION_PM', 'Sándwich de Pavo con Frutas', 'Sándwich completo con pavo y frutas', 'Pan integral (2 rebanadas), Pechuga de pavo (100g), Queso bajo en grasa (1 rebanada), Lechuga (2 hojas), Tomate (2 rebanadas), Mostaza, Manzana (1 grande), Almendras (30g)', '1. Armar el sándwich con todos los ingredientes. 2. Servir con manzana y almendras al lado.', 480, 35, 55, 15, 9, 1, 5, NOW()),
(10, 'CENA', 'Pasta Integral con Pollo y Vegetales', 'Pasta integral con pechuga de pollo y vegetales salteados', 'Pasta integral (100g cruda), Pechuga de pollo (200g), Brócoli (150g), Tomate cherry (100g), Espinacas (2 tazas), Ajo (3 dientes), Aceite de oliva (2 cucharadas), Queso parmesano (20g)', '1. Cocinar la pasta integral según instrucciones. 2. Cocinar el pollo en cubos con ajo. 3. Saltear las verduras. 4. Mezclar la pasta con el pollo y las verduras. 5. Servir con queso parmesano rallado.', 680, 58, 75, 18, 12, 1, 25, NOW());

-- ============================================================================
-- FIN DEL SCRIPT
-- ============================================================================
-- Total insertado:
-- - 10 usuarios nuevos (IDs 4-13)
-- - 10 pacientes con información completa
-- - 24 registros de peso históricos
-- - 10 planes de dieta (9 activos, 1 completado)
-- - 30 citas totales (8 completadas del pasado, 12 nuevas: 2 para hoy + 10 futuras)
-- - 50 comidas completas (5 comidas por cada plan alimenticio)
-- ============================================================================
