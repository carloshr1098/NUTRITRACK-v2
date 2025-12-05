package com.nutritrack.service;

import com.nutritrack.entity.NutritionalAssessment;
import com.nutritrack.entity.Patient;
import com.nutritrack.entity.User;
import com.nutritrack.repository.NutritionalAssessmentRepository;
import com.nutritrack.repository.PatientRepository;
import com.nutritrack.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class NutritionalAssessmentService {
    
    @Autowired
    private NutritionalAssessmentRepository assessmentRepository;
    
    @Autowired
    private PatientRepository patientRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    public NutritionalAssessment createAssessment(NutritionalAssessment assessment, Long patientId, Long nutritionistId) {
        Patient patient = patientRepository.findById(patientId)
            .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));
        
        User nutritionist = userRepository.findById(nutritionistId)
            .orElseThrow(() -> new RuntimeException("Nutricionista no encontrado"));
        
        assessment.setPatient(patient);
        assessment.setNutritionist(nutritionist);
        assessment.setAssessmentDate(LocalDateTime.now());
        
        return assessmentRepository.save(assessment);
    }
    
    public NutritionalAssessment updateAssessment(Long id, NutritionalAssessment updatedAssessment) {
        NutritionalAssessment existing = assessmentRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Evaluación no encontrada"));
        
        // Actualizar todos los campos
        existing.setChronicDiseases(updatedAssessment.getChronicDiseases());
        existing.setAllergies(updatedAssessment.getAllergies());
        existing.setFoodIntolerances(updatedAssessment.getFoodIntolerances());
        existing.setCurrentMedications(updatedAssessment.getCurrentMedications());
        existing.setPreviousSurgeries(updatedAssessment.getPreviousSurgeries());
        existing.setGastrointestinalConditions(updatedAssessment.getGastrointestinalConditions());
        existing.setFamilyHistory(updatedAssessment.getFamilyHistory());
        
        existing.setWeight(updatedAssessment.getWeight());
        existing.setHeight(updatedAssessment.getHeight());
        existing.setBmi(updatedAssessment.getBmi());
        existing.setWaistCircumference(updatedAssessment.getWaistCircumference());
        existing.setHipCircumference(updatedAssessment.getHipCircumference());
        existing.setWaistHipRatio(updatedAssessment.getWaistHipRatio());
        existing.setTricepsSkinfold(updatedAssessment.getTricepsSkinfold());
        existing.setBicepsSkinfold(updatedAssessment.getBicepsSkinfold());
        existing.setSubscapularSkinfold(updatedAssessment.getSubscapularSkinfold());
        existing.setSuprailiacSkinfold(updatedAssessment.getSuprailiacSkinfold());
        
        existing.setBodyFatPercentage(updatedAssessment.getBodyFatPercentage());
        existing.setMuscleMass(updatedAssessment.getMuscleMass());
        existing.setBodyWater(updatedAssessment.getBodyWater());
        existing.setBoneMass(updatedAssessment.getBoneMass());
        
        existing.setMealsPerDay(updatedAssessment.getMealsPerDay());
        existing.setMealSchedule(updatedAssessment.getMealSchedule());
        existing.setPreferredFoods(updatedAssessment.getPreferredFoods());
        existing.setDislikedFoods(updatedAssessment.getDislikedFoods());
        existing.setWaterIntake(updatedAssessment.getWaterIntake());
        existing.setAlcoholConsumption(updatedAssessment.getAlcoholConsumption());
        existing.setCoffeTeaConsumption(updatedAssessment.getCoffeTeaConsumption());
        existing.setSupplements(updatedAssessment.getSupplements());
        existing.setDietaryRestrictions(updatedAssessment.getDietaryRestrictions());
        
        existing.setPhysicalActivityLevel(updatedAssessment.getPhysicalActivityLevel());
        existing.setExerciseType(updatedAssessment.getExerciseType());
        existing.setExerciseFrequency(updatedAssessment.getExerciseFrequency());
        existing.setSleepHours(updatedAssessment.getSleepHours());
        existing.setStressLevel(updatedAssessment.getStressLevel());
        existing.setOccupation(updatedAssessment.getOccupation());
        existing.setSmokingHabit(updatedAssessment.getSmokingHabit());
        
        existing.setWeightGoal(updatedAssessment.getWeightGoal());
        existing.setTargetWeight(updatedAssessment.getTargetWeight());
        existing.setHealthGoals(updatedAssessment.getHealthGoals());
        existing.setConditionsToImprove(updatedAssessment.getConditionsToImprove());
        existing.setMotivationLevel(updatedAssessment.getMotivationLevel());
        
        existing.setFoodDiary24h(updatedAssessment.getFoodDiary24h());
        existing.setTypicalWeeklyPattern(updatedAssessment.getTypicalWeeklyPattern());
        existing.setAdditionalNotes(updatedAssessment.getAdditionalNotes());
        
        return assessmentRepository.save(existing);
    }
    
    public List<NutritionalAssessment> getAssessmentsByPatient(Long patientId) {
        return assessmentRepository.findByPatientIdOrderByAssessmentDateDesc(patientId);
    }
    
    public Optional<NutritionalAssessment> getLatestAssessmentByPatient(Long patientId) {
        return assessmentRepository.findFirstByPatientIdOrderByAssessmentDateDesc(patientId);
    }
    
    public Optional<NutritionalAssessment> getAssessmentById(Long id) {
        return assessmentRepository.findById(id);
    }
    
    public List<NutritionalAssessment> getAssessmentsByNutritionist(Long nutritionistId) {
        return assessmentRepository.findByNutritionistIdOrderByAssessmentDateDesc(nutritionistId);
    }
    
    public void deleteAssessment(Long id) {
        assessmentRepository.deleteById(id);
    }
}
