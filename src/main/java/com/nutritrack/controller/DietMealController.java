package com.nutritrack.controller;

import com.nutritrack.entity.DietMeal;
import com.nutritrack.entity.DietPlan;
import com.nutritrack.repository.DietMealRepository;
import com.nutritrack.repository.DietPlanRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/diet-meals")
@CrossOrigin(origins = "*", maxAge = 3600)
public class DietMealController {

    @Autowired
    private DietMealRepository dietMealRepository;

    @Autowired
    private DietPlanRepository dietPlanRepository;

    // Obtener todas las comidas de un plan dietético
    @GetMapping("/plan/{planId}")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> getMealsByPlan(@PathVariable Long planId) {
        try {
            DietPlan plan = dietPlanRepository.findById(planId)
                    .orElseThrow(() -> new RuntimeException("Plan no encontrado"));
            
            List<DietMeal> meals = dietMealRepository.findByDietPlanOrderByMealTypeAsc(plan);
            return ResponseEntity.ok(meals);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Obtener comidas por tipo (BREAKFAST, LUNCH, etc.)
    @GetMapping("/plan/{planId}/type/{mealType}")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> getMealsByType(@PathVariable Long planId, @PathVariable String mealType) {
        try {
            DietPlan plan = dietPlanRepository.findById(planId)
                    .orElseThrow(() -> new RuntimeException("Plan no encontrado"));
            
            List<DietMeal> meals = dietMealRepository.findByDietPlanAndMealType(plan, mealType);
            return ResponseEntity.ok(meals);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Crear nueva comida
    @PostMapping
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> createMeal(@RequestBody Map<String, Object> mealData) {
        try {
            Long planId = Long.valueOf(mealData.get("dietPlanId").toString());
            DietPlan plan = dietPlanRepository.findById(planId)
                    .orElseThrow(() -> new RuntimeException("Plan no encontrado"));

            DietMeal meal = new DietMeal();
            meal.setDietPlan(plan);
            meal.setMealType(mealData.get("mealType").toString());
            meal.setMealName(mealData.get("mealName").toString());
            
            if (mealData.containsKey("servings")) {
                meal.setServings(Integer.valueOf(mealData.get("servings").toString()));
            }
            if (mealData.containsKey("description")) {
                meal.setDescription(mealData.get("description").toString());
            }
            if (mealData.containsKey("calories")) {
                meal.setCalories(Integer.valueOf(mealData.get("calories").toString()));
            }
            if (mealData.containsKey("proteinGrams")) {
                meal.setProteinGrams(Double.valueOf(mealData.get("proteinGrams").toString()));
            }
            if (mealData.containsKey("carbsGrams")) {
                meal.setCarbsGrams(Double.valueOf(mealData.get("carbsGrams").toString()));
            }
            if (mealData.containsKey("fatGrams")) {
                meal.setFatGrams(Double.valueOf(mealData.get("fatGrams").toString()));
            }
            if (mealData.containsKey("fiberGrams")) {
                meal.setFiberGrams(Double.valueOf(mealData.get("fiberGrams").toString()));
            }
            if (mealData.containsKey("ingredients")) {
                meal.setIngredients(mealData.get("ingredients").toString());
            }
            if (mealData.containsKey("instructions")) {
                meal.setInstructions(mealData.get("instructions").toString());
            }
            if (mealData.containsKey("preparationTime")) {
                meal.setPreparationTime(Integer.valueOf(mealData.get("preparationTime").toString()));
            }
            if (mealData.containsKey("notes")) {
                meal.setNotes(mealData.get("notes").toString());
            }

            DietMeal savedMeal = dietMealRepository.save(meal);
            return ResponseEntity.ok(savedMeal);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Actualizar comida
    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> updateMeal(@PathVariable Long id, @RequestBody Map<String, Object> mealData) {
        try {
            DietMeal meal = dietMealRepository.findById(id)
                    .orElseThrow(() -> new RuntimeException("Comida no encontrada"));

            if (mealData.containsKey("mealType")) {
                meal.setMealType(mealData.get("mealType").toString());
            }
            if (mealData.containsKey("mealName")) {
                meal.setMealName(mealData.get("mealName").toString());
            }
            if (mealData.containsKey("servings")) {
                meal.setServings(Integer.valueOf(mealData.get("servings").toString()));
            }
            if (mealData.containsKey("description")) {
                meal.setDescription(mealData.get("description").toString());
            }
            if (mealData.containsKey("calories")) {
                meal.setCalories(Integer.valueOf(mealData.get("calories").toString()));
            }
            if (mealData.containsKey("proteinGrams")) {
                meal.setProteinGrams(Double.valueOf(mealData.get("proteinGrams").toString()));
            }
            if (mealData.containsKey("carbsGrams")) {
                meal.setCarbsGrams(Double.valueOf(mealData.get("carbsGrams").toString()));
            }
            if (mealData.containsKey("fatGrams")) {
                meal.setFatGrams(Double.valueOf(mealData.get("fatGrams").toString()));
            }
            if (mealData.containsKey("fiberGrams")) {
                meal.setFiberGrams(Double.valueOf(mealData.get("fiberGrams").toString()));
            }
            if (mealData.containsKey("ingredients")) {
                meal.setIngredients(mealData.get("ingredients").toString());
            }
            if (mealData.containsKey("instructions")) {
                meal.setInstructions(mealData.get("instructions").toString());
            }
            if (mealData.containsKey("preparationTime")) {
                meal.setPreparationTime(Integer.valueOf(mealData.get("preparationTime").toString()));
            }
            if (mealData.containsKey("notes")) {
                meal.setNotes(mealData.get("notes").toString());
            }

            DietMeal updatedMeal = dietMealRepository.save(meal);
            return ResponseEntity.ok(updatedMeal);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Eliminar comida
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> deleteMeal(@PathVariable Long id) {
        try {
            dietMealRepository.deleteById(id);
            return ResponseEntity.ok(Map.of("message", "Comida eliminada exitosamente"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }

    // Obtener resumen nutricional del día
    @GetMapping("/plan/{planId}/summary")
    @PreAuthorize("hasAuthority('ROLE_NUTRIOLOGO') or hasAuthority('ROLE_ADMIN')")
    public ResponseEntity<?> getNutritionalSummary(@PathVariable Long planId) {
        try {
            DietPlan plan = dietPlanRepository.findById(planId)
                    .orElseThrow(() -> new RuntimeException("Plan no encontrado"));
            
            List<DietMeal> meals = dietMealRepository.findByDietPlanOrderByMealTypeAsc(plan);
            
            int totalCalories = 0;
            double totalProtein = 0;
            double totalCarbs = 0;
            double totalFat = 0;
            double totalFiber = 0;
            
            for (DietMeal meal : meals) {
                totalCalories += (meal.getCalories() != null) ? meal.getCalories() : 0;
                totalProtein += (meal.getProteinGrams() != null) ? meal.getProteinGrams() : 0;
                totalCarbs += (meal.getCarbsGrams() != null) ? meal.getCarbsGrams() : 0;
                totalFat += (meal.getFatGrams() != null) ? meal.getFatGrams() : 0;
                totalFiber += (meal.getFiberGrams() != null) ? meal.getFiberGrams() : 0;
            }
            
            return ResponseEntity.ok(Map.of(
                "totalCalories", totalCalories,
                "totalProtein", totalProtein,
                "totalCarbs", totalCarbs,
                "totalFat", totalFat,
                "totalFiber", totalFiber,
                "mealCount", meals.size()
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        }
    }
}
