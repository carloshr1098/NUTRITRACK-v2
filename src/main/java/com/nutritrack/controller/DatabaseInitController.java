package com.nutritrack.controller;

import com.nutritrack.entity.ERole;
import com.nutritrack.entity.Role;
import com.nutritrack.entity.User;
import com.nutritrack.entity.Patient;
import com.nutritrack.repository.RoleRepository;
import com.nutritrack.repository.UserRepository;
import com.nutritrack.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/init")
@CrossOrigin(origins = "*", maxAge = 3600)
public class DatabaseInitController {

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/database")
    public ResponseEntity<?> initializeDatabase() {
        try {
            // Check if already initialized
            if (userRepository.count() > 0) {
                return ResponseEntity.ok().body("{\"message\": \"Database already initialized\", \"users\": " + userRepository.count() + "}");
            }

            // Create roles
            Role adminRole = roleRepository.findByName(ERole.ROLE_ADMIN)
                    .orElseGet(() -> roleRepository.save(new Role(ERole.ROLE_ADMIN)));
            
            Role nutriologoRole = roleRepository.findByName(ERole.ROLE_NUTRIOLOGO)
                    .orElseGet(() -> roleRepository.save(new Role(ERole.ROLE_NUTRIOLOGO)));
            
            Role pacienteRole = roleRepository.findByName(ERole.ROLE_PACIENTE)
                    .orElseGet(() -> roleRepository.save(new Role(ERole.ROLE_PACIENTE)));

            // Create admin user
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@nutritrack.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setFirstName("Administrador");
            admin.setLastName("Sistema");
            Set<Role> adminRoles = new HashSet<>();
            adminRoles.add(adminRole);
            admin.setRoles(adminRoles);
            userRepository.save(admin);

            // Create nutritionist user
            User nutritionist = new User();
            nutritionist.setUsername("nutriologo");
            nutritionist.setEmail("nutriologo@nutritrack.com");
            nutritionist.setPassword(passwordEncoder.encode("nutri123"));
            nutritionist.setFirstName("Maria");
            nutritionist.setLastName("Gonzalez");
            nutritionist.setPhone("5512345678");
            nutritionist.setAddress("Av. Reforma 123, CDMX");
            nutritionist.setDegree("Licenciatura en Nutricion");
            nutritionist.setUniversity("Universidad Nacional Autonoma de Mexico");
            nutritionist.setProfessionalLicense("1234567");
            Set<Role> nutriRoles = new HashSet<>();
            nutriRoles.add(nutriologoRole);
            nutritionist.setRoles(nutriRoles);
            userRepository.save(nutritionist);

            // Create patient user
            User patientUser = new User();
            patientUser.setUsername("paciente");
            patientUser.setEmail("paciente@nutritrack.com");
            patientUser.setPassword(passwordEncoder.encode("paciente123"));
            patientUser.setFirstName("Juan");
            patientUser.setLastName("Perez");
            Set<Role> pacienteRoles = new HashSet<>();
            pacienteRoles.add(pacienteRole);
            patientUser.setRoles(pacienteRoles);
            patientUser = userRepository.save(patientUser);

            // Create patient profile
            Patient patient = new Patient();
            patient.setUser(patientUser);
            patient.setFirstName("Juan");
            patient.setLastName("Perez");
            patient.setDateOfBirth(LocalDate.of(1990, 5, 15));
            patient.setGender("Masculino");
            patient.setHeight(new BigDecimal("175.00"));
            patient.setCurrentWeight(new BigDecimal("80.00"));
            patient.setActivityLevel("Moderado");
            patient.setEmail("paciente@nutritrack.com");
            patient.setPhone("5598765432");
            patient.setHealthGoal("MAINTAIN_WEIGHT");
            patient.setCreatedAt(LocalDateTime.now());
            patientRepository.save(patient);

            return ResponseEntity.ok().body("{\"message\": \"Database initialized successfully\", \"users\": 3, \"patients\": 1}");
        } catch (Exception e) {
            return ResponseEntity.status(500).body("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

    @GetMapping("/status")
    public ResponseEntity<?> getStatus() {
        long userCount = userRepository.count();
        long patientCount = patientRepository.count();
        boolean initialized = userCount > 0;
        
        return ResponseEntity.ok().body("{\"initialized\": " + initialized + ", \"users\": " + userCount + ", \"patients\": " + patientCount + "}");
    }

    @PostMapping("/load-data")
    public ResponseEntity<?> loadDataSql() {
        try {
            // Load data.sql from resources
            ClassPathResource resource = new ClassPathResource("data.sql");
            
            if (!resource.exists()) {
                return ResponseEntity.status(404).body("{\"error\": \"data.sql not found\"}");
            }
            
            // Read the entire SQL file
            String sql;
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(resource.getInputStream(), StandardCharsets.UTF_8))) {
                sql = reader.lines().collect(Collectors.joining("\n"));
            }
            
            // Remove comments
            sql = sql.replaceAll("--[^\n]*\n", "\n");
            
            // Split by semicolon but keep multi-line statements together
            String[] statements = sql.split(";");
            int executed = 0;
            int skipped = 0;
            
            for (String statement : statements) {
                statement = statement.trim();
                if (!statement.isEmpty()) {
                    try {
                        jdbcTemplate.execute(statement);
                        executed++;
                    } catch (Exception e) {
                        // Continue even if some statements fail (e.g., duplicates)
                        skipped++;
                    }
                }
            }
            
            // Get final counts
            long userCount = userRepository.count();
            long patientCount = patientRepository.count();
            
            return ResponseEntity.ok().body("{\"message\": \"Data loaded successfully\", \"executed\": " + executed + ", \"skipped\": " + skipped + ", \"users\": " + userCount + ", \"patients\": " + patientCount + "}");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
