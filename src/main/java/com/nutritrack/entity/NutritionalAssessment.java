package com.nutritrack.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "nutritional_assessments")
public class NutritionalAssessment {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;
    
    @ManyToOne
    @JoinColumn(name = "nutritionist_id")
    private User nutritionist;
    
    @Column(name = "assessment_date")
    private LocalDateTime assessmentDate;
    
    // ==================== ANTECEDENTES CLÍNICOS ====================
    @Column(name = "chronic_diseases", length = 1000)
    private String chronicDiseases; // Diabetes, hipertensión, etc.
    
    @Column(name = "allergies", length = 1000)
    private String allergies;
    
    @Column(name = "food_intolerances", length = 1000)
    private String foodIntolerances;
    
    @Column(name = "current_medications", length = 1000)
    private String currentMedications;
    
    @Column(name = "previous_surgeries", length = 1000)
    private String previousSurgeries;
    
    @Column(name = "gastrointestinal_conditions", length = 1000)
    private String gastrointestinalConditions;
    
    @Column(name = "family_history", length = 1000)
    private String familyHistory;
    
    // ==================== MEDIDAS ANTROPOMÉTRICAS ====================
    @Column(name = "weight", precision = 5, scale = 2)
    private BigDecimal weight; // kg
    
    @Column(name = "height", precision = 5, scale = 2)
    private BigDecimal height; // cm
    
    @Column(name = "bmi", precision = 5, scale = 2)
    private BigDecimal bmi;
    
    @Column(name = "waist_circumference", precision = 5, scale = 2)
    private BigDecimal waistCircumference; // cm
    
    @Column(name = "hip_circumference", precision = 5, scale = 2)
    private BigDecimal hipCircumference; // cm
    
    @Column(name = "waist_hip_ratio", precision = 5, scale = 2)
    private BigDecimal waistHipRatio;
    
    // Pliegues cutáneos (con pinzas)
    @Column(name = "triceps_skinfold", precision = 5, scale = 2)
    private BigDecimal tricepsSkinfold; // mm
    
    @Column(name = "biceps_skinfold", precision = 5, scale = 2)
    private BigDecimal bicepsSkinfold; // mm
    
    @Column(name = "subscapular_skinfold", precision = 5, scale = 2)
    private BigDecimal subscapularSkinfold; // mm
    
    @Column(name = "suprailiac_skinfold", precision = 5, scale = 2)
    private BigDecimal suprailiacSkinfold; // mm
    
    // ==================== COMPOSICIÓN CORPORAL ====================
    @Column(name = "body_fat_percentage", precision = 5, scale = 2)
    private BigDecimal bodyFatPercentage;
    
    @Column(name = "muscle_mass", precision = 5, scale = 2)
    private BigDecimal muscleMass; // kg
    
    @Column(name = "body_water", precision = 5, scale = 2)
    private BigDecimal bodyWater; // %
    
    @Column(name = "bone_mass", precision = 5, scale = 2)
    private BigDecimal boneMass; // kg
    
    // ==================== HÁBITOS ALIMENTARIOS ====================
    @Column(name = "meals_per_day")
    private Integer mealsPerDay;
    
    @Column(name = "meal_schedule", length = 500)
    private String mealSchedule;
    
    @Column(name = "preferred_foods", length = 1000)
    private String preferredFoods;
    
    @Column(name = "disliked_foods", length = 1000)
    private String dislikedFoods;
    
    @Column(name = "water_intake", precision = 5, scale = 2)
    private BigDecimal waterIntake; // litros por día
    
    @Column(name = "alcohol_consumption", length = 500)
    private String alcoholConsumption;
    
    @Column(name = "coffee_tea_consumption", length = 500)
    private String coffeTeaConsumption;
    
    @Column(name = "supplements", length = 1000)
    private String supplements;
    
    @Column(name = "dietary_restrictions", length = 1000)
    private String dietaryRestrictions; // Religiosas, culturales, personales
    
    // ==================== ESTILO DE VIDA ====================
    @Column(name = "physical_activity_level")
    private String physicalActivityLevel; // Sedentario, Ligero, Moderado, Intenso
    
    @Column(name = "exercise_type", length = 500)
    private String exerciseType;
    
    @Column(name = "exercise_frequency", length = 200)
    private String exerciseFrequency; // veces por semana
    
    @Column(name = "sleep_hours", precision = 3, scale = 1)
    private BigDecimal sleepHours;
    
    @Column(name = "stress_level")
    private String stressLevel; // Bajo, Medio, Alto
    
    @Column(name = "occupation", length = 200)
    private String occupation;
    
    @Column(name = "smoking_habit")
    private String smokingHabit; // No fuma, Ex-fumador, Fumador ocasional, Fumador regular
    
    // ==================== OBJETIVOS NUTRICIONALES ====================
    @Column(name = "weight_goal")
    private String weightGoal; // Pérdida, Ganancia, Mantenimiento
    
    @Column(name = "target_weight", precision = 5, scale = 2)
    private BigDecimal targetWeight; // kg
    
    @Column(name = "health_goals", length = 1000)
    private String healthGoals;
    
    @Column(name = "conditions_to_improve", length = 1000)
    private String conditionsToImprove;
    
    @Column(name = "motivation_level")
    private String motivationLevel; // Baja, Media, Alta
    
    // ==================== RECORDATORIO DE 24 HORAS ====================
    @Column(name = "food_diary_24h", length = 2000)
    private String foodDiary24h; // Lo que comió ayer
    
    @Column(name = "typical_weekly_pattern", length = 2000)
    private String typicalWeeklyPattern;
    
    // ==================== NOTAS ADICIONALES ====================
    @Column(name = "additional_notes", length = 2000)
    private String additionalNotes;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // ==================== CONSTRUCTORES ====================
    public NutritionalAssessment() {
        this.assessmentDate = LocalDateTime.now();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
    
    // ==================== GETTERS Y SETTERS ====================
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Patient getPatient() {
        return patient;
    }
    
    public void setPatient(Patient patient) {
        this.patient = patient;
    }
    
    public User getNutritionist() {
        return nutritionist;
    }
    
    public void setNutritionist(User nutritionist) {
        this.nutritionist = nutritionist;
    }
    
    public LocalDateTime getAssessmentDate() {
        return assessmentDate;
    }
    
    public void setAssessmentDate(LocalDateTime assessmentDate) {
        this.assessmentDate = assessmentDate;
    }
    
    public String getChronicDiseases() {
        return chronicDiseases;
    }
    
    public void setChronicDiseases(String chronicDiseases) {
        this.chronicDiseases = chronicDiseases;
    }
    
    public String getAllergies() {
        return allergies;
    }
    
    public void setAllergies(String allergies) {
        this.allergies = allergies;
    }
    
    public String getFoodIntolerances() {
        return foodIntolerances;
    }
    
    public void setFoodIntolerances(String foodIntolerances) {
        this.foodIntolerances = foodIntolerances;
    }
    
    public String getCurrentMedications() {
        return currentMedications;
    }
    
    public void setCurrentMedications(String currentMedications) {
        this.currentMedications = currentMedications;
    }
    
    public String getPreviousSurgeries() {
        return previousSurgeries;
    }
    
    public void setPreviousSurgeries(String previousSurgeries) {
        this.previousSurgeries = previousSurgeries;
    }
    
    public String getGastrointestinalConditions() {
        return gastrointestinalConditions;
    }
    
    public void setGastrointestinalConditions(String gastrointestinalConditions) {
        this.gastrointestinalConditions = gastrointestinalConditions;
    }
    
    public String getFamilyHistory() {
        return familyHistory;
    }
    
    public void setFamilyHistory(String familyHistory) {
        this.familyHistory = familyHistory;
    }
    
    public BigDecimal getWeight() {
        return weight;
    }
    
    public void setWeight(BigDecimal weight) {
        this.weight = weight;
    }
    
    public BigDecimal getHeight() {
        return height;
    }
    
    public void setHeight(BigDecimal height) {
        this.height = height;
    }
    
    public BigDecimal getBmi() {
        return bmi;
    }
    
    public void setBmi(BigDecimal bmi) {
        this.bmi = bmi;
    }
    
    public BigDecimal getWaistCircumference() {
        return waistCircumference;
    }
    
    public void setWaistCircumference(BigDecimal waistCircumference) {
        this.waistCircumference = waistCircumference;
    }
    
    public BigDecimal getHipCircumference() {
        return hipCircumference;
    }
    
    public void setHipCircumference(BigDecimal hipCircumference) {
        this.hipCircumference = hipCircumference;
    }
    
    public BigDecimal getWaistHipRatio() {
        return waistHipRatio;
    }
    
    public void setWaistHipRatio(BigDecimal waistHipRatio) {
        this.waistHipRatio = waistHipRatio;
    }
    
    public BigDecimal getTricepsSkinfold() {
        return tricepsSkinfold;
    }
    
    public void setTricepsSkinfold(BigDecimal tricepsSkinfold) {
        this.tricepsSkinfold = tricepsSkinfold;
    }
    
    public BigDecimal getBicepsSkinfold() {
        return bicepsSkinfold;
    }
    
    public void setBicepsSkinfold(BigDecimal bicepsSkinfold) {
        this.bicepsSkinfold = bicepsSkinfold;
    }
    
    public BigDecimal getSubscapularSkinfold() {
        return subscapularSkinfold;
    }
    
    public void setSubscapularSkinfold(BigDecimal subscapularSkinfold) {
        this.subscapularSkinfold = subscapularSkinfold;
    }
    
    public BigDecimal getSuprailiacSkinfold() {
        return suprailiacSkinfold;
    }
    
    public void setSuprailiacSkinfold(BigDecimal suprailiacSkinfold) {
        this.suprailiacSkinfold = suprailiacSkinfold;
    }
    
    public BigDecimal getBodyFatPercentage() {
        return bodyFatPercentage;
    }
    
    public void setBodyFatPercentage(BigDecimal bodyFatPercentage) {
        this.bodyFatPercentage = bodyFatPercentage;
    }
    
    public BigDecimal getMuscleMass() {
        return muscleMass;
    }
    
    public void setMuscleMass(BigDecimal muscleMass) {
        this.muscleMass = muscleMass;
    }
    
    public BigDecimal getBodyWater() {
        return bodyWater;
    }
    
    public void setBodyWater(BigDecimal bodyWater) {
        this.bodyWater = bodyWater;
    }
    
    public BigDecimal getBoneMass() {
        return boneMass;
    }
    
    public void setBoneMass(BigDecimal boneMass) {
        this.boneMass = boneMass;
    }
    
    public Integer getMealsPerDay() {
        return mealsPerDay;
    }
    
    public void setMealsPerDay(Integer mealsPerDay) {
        this.mealsPerDay = mealsPerDay;
    }
    
    public String getMealSchedule() {
        return mealSchedule;
    }
    
    public void setMealSchedule(String mealSchedule) {
        this.mealSchedule = mealSchedule;
    }
    
    public String getPreferredFoods() {
        return preferredFoods;
    }
    
    public void setPreferredFoods(String preferredFoods) {
        this.preferredFoods = preferredFoods;
    }
    
    public String getDislikedFoods() {
        return dislikedFoods;
    }
    
    public void setDislikedFoods(String dislikedFoods) {
        this.dislikedFoods = dislikedFoods;
    }
    
    public BigDecimal getWaterIntake() {
        return waterIntake;
    }
    
    public void setWaterIntake(BigDecimal waterIntake) {
        this.waterIntake = waterIntake;
    }
    
    public String getAlcoholConsumption() {
        return alcoholConsumption;
    }
    
    public void setAlcoholConsumption(String alcoholConsumption) {
        this.alcoholConsumption = alcoholConsumption;
    }
    
    public String getCoffeTeaConsumption() {
        return coffeTeaConsumption;
    }
    
    public void setCoffeTeaConsumption(String coffeTeaConsumption) {
        this.coffeTeaConsumption = coffeTeaConsumption;
    }
    
    public String getSupplements() {
        return supplements;
    }
    
    public void setSupplements(String supplements) {
        this.supplements = supplements;
    }
    
    public String getDietaryRestrictions() {
        return dietaryRestrictions;
    }
    
    public void setDietaryRestrictions(String dietaryRestrictions) {
        this.dietaryRestrictions = dietaryRestrictions;
    }
    
    public String getPhysicalActivityLevel() {
        return physicalActivityLevel;
    }
    
    public void setPhysicalActivityLevel(String physicalActivityLevel) {
        this.physicalActivityLevel = physicalActivityLevel;
    }
    
    public String getExerciseType() {
        return exerciseType;
    }
    
    public void setExerciseType(String exerciseType) {
        this.exerciseType = exerciseType;
    }
    
    public String getExerciseFrequency() {
        return exerciseFrequency;
    }
    
    public void setExerciseFrequency(String exerciseFrequency) {
        this.exerciseFrequency = exerciseFrequency;
    }
    
    public BigDecimal getSleepHours() {
        return sleepHours;
    }
    
    public void setSleepHours(BigDecimal sleepHours) {
        this.sleepHours = sleepHours;
    }
    
    public String getStressLevel() {
        return stressLevel;
    }
    
    public void setStressLevel(String stressLevel) {
        this.stressLevel = stressLevel;
    }
    
    public String getOccupation() {
        return occupation;
    }
    
    public void setOccupation(String occupation) {
        this.occupation = occupation;
    }
    
    public String getSmokingHabit() {
        return smokingHabit;
    }
    
    public void setSmokingHabit(String smokingHabit) {
        this.smokingHabit = smokingHabit;
    }
    
    public String getWeightGoal() {
        return weightGoal;
    }
    
    public void setWeightGoal(String weightGoal) {
        this.weightGoal = weightGoal;
    }
    
    public BigDecimal getTargetWeight() {
        return targetWeight;
    }
    
    public void setTargetWeight(BigDecimal targetWeight) {
        this.targetWeight = targetWeight;
    }
    
    public String getHealthGoals() {
        return healthGoals;
    }
    
    public void setHealthGoals(String healthGoals) {
        this.healthGoals = healthGoals;
    }
    
    public String getConditionsToImprove() {
        return conditionsToImprove;
    }
    
    public void setConditionsToImprove(String conditionsToImprove) {
        this.conditionsToImprove = conditionsToImprove;
    }
    
    public String getMotivationLevel() {
        return motivationLevel;
    }
    
    public void setMotivationLevel(String motivationLevel) {
        this.motivationLevel = motivationLevel;
    }
    
    public String getFoodDiary24h() {
        return foodDiary24h;
    }
    
    public void setFoodDiary24h(String foodDiary24h) {
        this.foodDiary24h = foodDiary24h;
    }
    
    public String getTypicalWeeklyPattern() {
        return typicalWeeklyPattern;
    }
    
    public void setTypicalWeeklyPattern(String typicalWeeklyPattern) {
        this.typicalWeeklyPattern = typicalWeeklyPattern;
    }
    
    public String getAdditionalNotes() {
        return additionalNotes;
    }
    
    public void setAdditionalNotes(String additionalNotes) {
        this.additionalNotes = additionalNotes;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
