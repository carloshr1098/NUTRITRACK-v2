package com.nutritrack.repository;

import com.nutritrack.entity.DietMeal;
import com.nutritrack.entity.DietPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DietMealRepository extends JpaRepository<DietMeal, Long> {
    List<DietMeal> findByDietPlanOrderByMealTypeAsc(DietPlan dietPlan);
    List<DietMeal> findByDietPlanAndMealType(DietPlan dietPlan, String mealType);
    void deleteByDietPlan(DietPlan dietPlan);
}
