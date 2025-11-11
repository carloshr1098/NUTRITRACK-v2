package com.nutritrack.service;

import com.nutritrack.entity.Food;
import com.nutritrack.repository.FoodRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class FoodDataInitializer implements CommandLineRunner {

    @Autowired
    private FoodRepository foodRepository;

    @Override
    public void run(String... args) throws Exception {
        // Solo cargar si la base de datos está vacía
        if (foodRepository.count() == 0) {
            System.out.println("Cargando alimentos básicos en la base de datos...");
            loadBasicFoods();
            System.out.println("Alimentos básicos cargados exitosamente: " + foodRepository.count() + " alimentos");
        }
    }

    private void loadBasicFoods() {
        // FRUTAS
        foodRepository.save(new Food("Manzana", "Frutas", "1 pieza (182g)", 95, 0.5, 25.0, 0.3, 4.4));
        foodRepository.save(new Food("Plátano", "Frutas", "1 pieza (118g)", 105, 1.3, 27.0, 0.4, 3.1));
        foodRepository.save(new Food("Naranja", "Frutas", "1 pieza (140g)", 62, 1.2, 15.4, 0.2, 3.1));
        foodRepository.save(new Food("Fresa", "Frutas", "1 taza (152g)", 49, 1.0, 11.7, 0.5, 3.0));
        foodRepository.save(new Food("Sandía", "Frutas", "1 taza (154g)", 46, 0.9, 11.5, 0.2, 0.6));
        foodRepository.save(new Food("Papaya", "Frutas", "1 taza (145g)", 55, 0.9, 13.7, 0.2, 2.5));
        foodRepository.save(new Food("Mango", "Frutas", "1 pieza (207g)", 135, 1.1, 35.2, 0.6, 3.7));
        foodRepository.save(new Food("Piña", "Frutas", "1 taza (165g)", 83, 0.9, 21.6, 0.2, 2.3));
        foodRepository.save(new Food("Uva", "Frutas", "1 taza (151g)", 104, 1.1, 27.3, 0.2, 1.4));
        foodRepository.save(new Food("Pera", "Frutas", "1 pieza (178g)", 101, 0.6, 27.1, 0.2, 5.5));

        // VERDURAS
        foodRepository.save(new Food("Brócoli", "Verduras", "1 taza (91g)", 31, 2.6, 6.0, 0.3, 2.4));
        foodRepository.save(new Food("Zanahoria", "Verduras", "1 taza (128g)", 52, 1.2, 12.3, 0.3, 3.6));
        foodRepository.save(new Food("Espinaca", "Verduras", "1 taza (30g)", 7, 0.9, 1.1, 0.1, 0.7));
        foodRepository.save(new Food("Tomate", "Verduras", "1 pieza (123g)", 22, 1.1, 4.8, 0.2, 1.5));
        foodRepository.save(new Food("Lechuga", "Verduras", "1 taza (36g)", 5, 0.5, 1.0, 0.1, 0.5));
        foodRepository.save(new Food("Pepino", "Verduras", "1 taza (104g)", 16, 0.7, 3.6, 0.1, 0.5));
        foodRepository.save(new Food("Cebolla", "Verduras", "1 taza (160g)", 64, 1.8, 14.9, 0.2, 2.7));
        foodRepository.save(new Food("Pimiento", "Verduras", "1 taza (149g)", 39, 1.5, 9.0, 0.4, 3.1));
        foodRepository.save(new Food("Calabaza", "Verduras", "1 taza (116g)", 30, 1.1, 7.5, 0.1, 0.6));
        foodRepository.save(new Food("Ejotes", "Verduras", "1 taza (100g)", 31, 1.8, 7.0, 0.2, 2.7));

        // CARNES Y PROTEÍNAS
        foodRepository.save(new Food("Pechuga de pollo", "Carnes", "100g", 165, 31.0, 0.0, 3.6, 0.0));
        foodRepository.save(new Food("Carne de res magra", "Carnes", "100g", 250, 26.0, 0.0, 15.0, 0.0));
        foodRepository.save(new Food("Salmón", "Pescados", "100g", 208, 20.0, 0.0, 13.0, 0.0));
        foodRepository.save(new Food("Atún", "Pescados", "100g", 132, 28.0, 0.0, 1.3, 0.0));
        foodRepository.save(new Food("Camarón", "Pescados", "100g", 99, 24.0, 0.2, 0.3, 0.0));
        foodRepository.save(new Food("Huevo", "Carnes", "1 pieza (50g)", 78, 6.3, 0.6, 5.3, 0.0));
        foodRepository.save(new Food("Carne de puerco", "Carnes", "100g", 242, 27.0, 0.0, 14.0, 0.0));
        foodRepository.save(new Food("Pavo", "Carnes", "100g", 135, 30.0, 0.0, 0.7, 0.0));

        // LÁCTEOS
        foodRepository.save(new Food("Leche descremada", "Lácteos", "1 taza (240ml)", 83, 8.3, 12.2, 0.2, 0.0));
        foodRepository.save(new Food("Leche entera", "Lácteos", "1 taza (240ml)", 149, 7.7, 11.7, 7.9, 0.0));
        foodRepository.save(new Food("Yogurt natural", "Lácteos", "1 taza (245g)", 149, 8.5, 11.4, 8.0, 0.0));
        foodRepository.save(new Food("Queso panela", "Lácteos", "100g", 321, 28.0, 1.3, 23.0, 0.0));
        foodRepository.save(new Food("Queso Oaxaca", "Lácteos", "100g", 268, 20.0, 2.8, 19.0, 0.0));
        foodRepository.save(new Food("Requesón", "Lácteos", "1 taza (226g)", 206, 25.0, 8.0, 9.0, 0.0));

        // CEREALES Y GRANOS
        foodRepository.save(new Food("Arroz blanco cocido", "Cereales", "1 taza (158g)", 205, 4.3, 45.0, 0.4, 0.6));
        foodRepository.save(new Food("Arroz integral cocido", "Cereales", "1 taza (195g)", 216, 5.0, 45.0, 1.8, 3.5));
        foodRepository.save(new Food("Pasta cocida", "Cereales", "1 taza (140g)", 221, 8.1, 43.0, 1.3, 2.5));
        foodRepository.save(new Food("Pan integral", "Cereales", "1 rebanada (28g)", 69, 3.6, 11.6, 1.2, 1.9));
        foodRepository.save(new Food("Tortilla de maíz", "Cereales", "1 pieza (24g)", 52, 1.4, 10.7, 0.7, 1.5));
        foodRepository.save(new Food("Tortilla de harina", "Cereales", "1 pieza (49g)", 146, 3.9, 25.3, 3.2, 1.6));
        foodRepository.save(new Food("Avena cruda", "Cereales", "1/2 taza (40g)", 150, 5.3, 27.0, 2.6, 4.0));
        foodRepository.save(new Food("Quinoa cocida", "Cereales", "1 taza (185g)", 222, 8.1, 39.4, 3.6, 5.2));

        // LEGUMBRES
        foodRepository.save(new Food("Frijoles negros cocidos", "Legumbres", "1 taza (172g)", 227, 15.2, 40.8, 0.9, 15.0));
        foodRepository.save(new Food("Lentejas cocidas", "Legumbres", "1 taza (198g)", 230, 17.9, 39.9, 0.8, 15.6));
        foodRepository.save(new Food("Garbanzos cocidos", "Legumbres", "1 taza (164g)", 269, 14.5, 45.0, 4.3, 12.5));
        foodRepository.save(new Food("Habas cocidas", "Legumbres", "1 taza (170g)", 187, 12.9, 33.4, 0.7, 9.2));

        // FRUTOS SECOS Y SEMILLAS
        foodRepository.save(new Food("Almendras", "Frutos secos", "1 onza (28g)", 164, 6.0, 6.1, 14.2, 3.5));
        foodRepository.save(new Food("Nueces", "Frutos secos", "1 onza (28g)", 185, 4.3, 3.9, 18.5, 1.9));
        foodRepository.save(new Food("Cacahuates", "Frutos secos", "1 onza (28g)", 161, 7.3, 4.6, 14.0, 2.4));
        foodRepository.save(new Food("Semillas de chía", "Semillas", "1 onza (28g)", 138, 4.7, 12.3, 8.7, 9.8));
        foodRepository.save(new Food("Semillas de linaza", "Semillas", "1 onza (28g)", 150, 5.1, 8.1, 12.0, 7.6));

        // ACEITES Y GRASAS
        foodRepository.save(new Food("Aguacate", "Grasas saludables", "1/2 pieza (100g)", 160, 2.0, 8.5, 14.7, 6.7));
        foodRepository.save(new Food("Aceite de oliva", "Aceites", "1 cucharada (14g)", 119, 0.0, 0.0, 13.5, 0.0));
        foodRepository.save(new Food("Aceite de coco", "Aceites", "1 cucharada (14g)", 121, 0.0, 0.0, 13.5, 0.0));

        // BEBIDAS
        foodRepository.save(new Food("Agua natural", "Bebidas", "1 taza (240ml)", 0, 0.0, 0.0, 0.0, 0.0));
        foodRepository.save(new Food("Té verde", "Bebidas", "1 taza (240ml)", 2, 0.0, 0.0, 0.0, 0.0));
        foodRepository.save(new Food("Café negro", "Bebidas", "1 taza (240ml)", 2, 0.3, 0.0, 0.0, 0.0));

        // ENDULZANTES
        foodRepository.save(new Food("Miel", "Endulzantes", "1 cucharada (21g)", 64, 0.1, 17.3, 0.0, 0.0));
    }
}
