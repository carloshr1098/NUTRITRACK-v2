package com.nutritrack.repository;

import com.nutritrack.entity.DietPlan;
import com.nutritrack.entity.Patient;
import com.nutritrack.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DietPlanRepository extends JpaRepository<DietPlan, Long> {
    List<DietPlan> findByPatient(Patient patient);
    List<DietPlan> findByNutritionist(User nutritionist);
    List<DietPlan> findByStatus(String status);
    List<DietPlan> findByPatientIdAndStatus(Long patientId, String status);
}
