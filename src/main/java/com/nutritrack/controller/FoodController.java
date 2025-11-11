package com.nutritrack.controller;

import com.nutritrack.entity.Food;
import com.nutritrack.repository.FoodRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/foods")
@CrossOrigin(origins = "*", maxAge = 3600)
public class FoodController {

    @Autowired
    private FoodRepository foodRepository;

    // Obtener todos los alimentos
    @GetMapping
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> getAllFoods() {
        try {
            List<Food> foods = foodRepository.findAll();
            return ResponseEntity.ok(foods);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Buscar alimentos por nombre
    @GetMapping("/search")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> searchFoods(@RequestParam String q) {
        try {
            List<Food> foods = foodRepository.searchFoods(q);
            return ResponseEntity.ok(foods);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Obtener alimentos por categoría
    @GetMapping("/category/{category}")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> getFoodsByCategory(@PathVariable String category) {
        try {
            List<Food> foods = foodRepository.findByCategory(category);
            return ResponseEntity.ok(foods);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Obtener todas las categorías
    @GetMapping("/categories")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> getAllCategories() {
        try {
            List<String> categories = foodRepository.findAllCategories();
            return ResponseEntity.ok(categories);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Crear nuevo alimento (opcional, para que el nutriólogo agregue más)
    @PostMapping
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> createFood(@RequestBody Food food) {
        try {
            Food savedFood = foodRepository.save(food);
            return ResponseEntity.ok(savedFood);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Obtener detalles de un alimento
    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> getFoodById(@PathVariable Long id) {
        try {
            Food food = foodRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Alimento no encontrado"));
            return ResponseEntity.ok(food);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Actualizar alimento
    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> updateFood(@PathVariable Long id, @RequestBody Food foodDetails) {
        try {
            Food food = foodRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Alimento no encontrado"));
            
            food.setName(foodDetails.getName());
            food.setCategory(foodDetails.getCategory());
            food.setServingSize(foodDetails.getServingSize());
            food.setCalories(foodDetails.getCalories());
            food.setProteinGrams(foodDetails.getProteinGrams());
            food.setCarbsGrams(foodDetails.getCarbsGrams());
            food.setFatGrams(foodDetails.getFatGrams());
            food.setFiberGrams(foodDetails.getFiberGrams());
            food.setDescription(foodDetails.getDescription());

            Food updatedFood = foodRepository.save(food);
            return ResponseEntity.ok(updatedFood);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Eliminar alimento
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> deleteFood(@PathVariable Long id) {
        try {
            foodRepository.deleteById(id);
            return ResponseEntity.ok(Map.of("message", "Alimento eliminado exitosamente"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }
}
