package com.nutritrack.repository;

import com.nutritrack.entity.NutritionalAssessment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NutritionalAssessmentRepository extends JpaRepository<NutritionalAssessment, Long> {
    
    List<NutritionalAssessment> findByPatientIdOrderByAssessmentDateDesc(Long patientId);
    
    Optional<NutritionalAssessment> findFirstByPatientIdOrderByAssessmentDateDesc(Long patientId);
    
    List<NutritionalAssessment> findByNutritionistIdOrderByAssessmentDateDesc(Long nutritionistId);
}
