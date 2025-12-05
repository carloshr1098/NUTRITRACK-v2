package com.nutritrack.controller;

import com.nutritrack.entity.*;
import com.nutritrack.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/init")
@CrossOrigin(origins = "*")
public class DataInitController {

    @Autowired
    private RoleRepository roleRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PatientRepository patientRepository;
    
    @Autowired
    private FoodRepository foodRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping("/database")
    public ResponseEntity<?> initializeDatabase() {
        try {
            Map<String, Object> result = new HashMap<>();
            
            // Check if already initialized
            if (roleRepository.count() > 0) {
                result.put("message", "Database already initialized");
                result.put("status", "skipped");
                return ResponseEntity.ok(result);
            }

            // Create Roles
            Role adminRole = new Role(ERole.ROLE_ADMIN);
            Role nutriologoRole = new Role(ERole.ROLE_NUTRIOLOGO);
            Role pacienteRole = new Role(ERole.ROLE_PACIENTE);
            
            roleRepository.save(adminRole);
            roleRepository.save(nutriologoRole);
            roleRepository.save(pacienteRole);

            // Create Users
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@nutritrack.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setFirstName("Administrador");
            admin.setLastName("Sistema");
            admin.getRoles().add(adminRole);
            userRepository.save(admin);

            User nutriologo = new User();
            nutriologo.setUsername("nutriologo");
            nutriologo.setEmail("nutriologo@nutritrack.com");
            nutriologo.setPassword(passwordEncoder.encode("nutri123"));
            nutriologo.setFirstName("María");
            nutriologo.setLastName("González");
            nutriologo.setPhone("5512345678");
            nutriologo.setAddress("Av. Reforma 123, CDMX");
            nutriologo.setDegree("Licenciatura en Nutrición");
            nutriologo.setUniversity("Universidad Nacional Autónoma de México");
            nutriologo.setProfessionalLicense("1234567");
            nutriologo.getRoles().add(nutriologoRole);
            userRepository.save(nutriologo);

            User paciente = new User();
            paciente.setUsername("paciente");
            paciente.setEmail("paciente@nutritrack.com");
            paciente.setPassword(passwordEncoder.encode("paciente123"));
            paciente.setFirstName("Juan");
            paciente.setLastName("Pérez");
            paciente.getRoles().add(pacienteRole);
            userRepository.save(paciente);

            // Create Patient
            Patient patient = new Patient();
            patient.setUser(paciente);
            patient.setFirstName("Juan");
            patient.setLastName("Pérez");
            patient.setDateOfBirth(LocalDate.of(1990, 5, 15));
            patient.setGender("Masculino");
            patient.setHeight(new BigDecimal("175.00"));
            patient.setCurrentWeight(new BigDecimal("80.00"));
            patient.setActivityLevel("Moderado");
            patient.setEmail("paciente@nutritrack.com");
            patient.setPhone("5598765432");
            patient.setHealthGoal("MAINTAIN_WEIGHT");
            patientRepository.save(patient);

            // Create Foods
            createFood("Pechuga de pollo", "Carnes", "100g", 165, 31.0, 0.0, 3.6, 0.0, "Pechuga de pollo sin piel cocida");
            createFood("Arroz integral", "Cereales", "100g", 111, 2.6, 23.0, 0.9, 1.8, "Arroz integral cocido");
            createFood("Brócoli", "Verduras", "100g", 34, 2.8, 7.0, 0.4, 2.6, "Brócoli cocido al vapor");
            createFood("Aguacate", "Frutas", "100g", 160, 2.0, 8.5, 14.7, 6.7, "Aguacate fresco tipo Hass");
            createFood("Huevo", "Proteínas", "1 pieza", 78, 6.3, 0.6, 5.3, 0.0, "Huevo entero cocido");
            createFood("Avena", "Cereales", "1 taza", 307, 10.7, 54.8, 5.3, 8.2, "Avena en hojuelas cruda");
            createFood("Plátano", "Frutas", "1 pieza", 105, 1.3, 27.0, 0.4, 3.1, "Plátano mediano fresco");
            createFood("Almendras", "Frutos secos", "30g", 164, 6.0, 6.1, 14.2, 3.5, "Almendras naturales");
            createFood("Salmón", "Pescados", "100g", 208, 20.4, 0.0, 13.4, 0.0, "Salmón cocido al horno");
            createFood("Espinaca", "Verduras", "100g", 23, 2.9, 3.6, 0.4, 2.2, "Espinaca fresca");

            result.put("message", "Database initialized successfully");
            result.put("status", "success");
            result.put("users", 3);
            result.put("roles", 3);
            result.put("patients", 1);
            result.put("foods", 10);
            
            return ResponseEntity.ok(result);
            
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "Failed to initialize database: " + e.getMessage());
            return ResponseEntity.status(500).body(error);
        }
    }

    private void createFood(String name, String category, String servingSize, int calories, 
                           double protein, double carbs, double fat, double fiber, String description) {
        Food food = new Food();
        food.setName(name);
        food.setCategory(category);
        food.setServingSize(servingSize);
        food.setCalories(calories);
        food.setProteinGrams(protein);
        food.setCarbsGrams(carbs);
        food.setFatGrams(fat);
        food.setFiberGrams(fiber);
        food.setDescription(description);
        foodRepository.save(food);
    }
}
