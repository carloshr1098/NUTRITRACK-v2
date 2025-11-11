package com.nutritrack.repository;

import com.nutritrack.entity.Food;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FoodRepository extends JpaRepository<Food, Long> {
    
    List<Food> findByCategory(String category);
    
    @Query("SELECT f FROM Food f WHERE LOWER(f.name) LIKE LOWER(CONCAT('%', :search, '%'))")
    List<Food> searchByName(@Param("search") String search);
    
    @Query("SELECT f FROM Food f WHERE LOWER(f.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "OR LOWER(f.category) LIKE LOWER(CONCAT('%', :search, '%'))")
    List<Food> searchFoods(@Param("search") String search);
    
    @Query("SELECT DISTINCT f.category FROM Food f ORDER BY f.category")
    List<String> findAllCategories();
}
