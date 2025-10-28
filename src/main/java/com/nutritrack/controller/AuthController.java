package com.nutritrack.controller;

import com.nutritrack.entity.ERole;
import com.nutritrack.entity.Role;
import com.nutritrack.entity.User;
import com.nutritrack.payload.request.LoginRequest;
import com.nutritrack.payload.request.SignupRequest;
import com.nutritrack.payload.response.JwtResponse;
import com.nutritrack.payload.response.MessageResponse;
import com.nutritrack.repository.RoleRepository;
import com.nutritrack.repository.UserRepository;
import com.nutritrack.repository.PatientRepository;
import com.nutritrack.entity.Patient;
import com.nutritrack.security.jwt.JwtUtils;
import com.nutritrack.security.jwt.UserPrincipal;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    UserRepository userRepository;

    @Autowired
    RoleRepository roleRepository;

    @Autowired
    PatientRepository patientRepository;

    @Autowired
    PasswordEncoder encoder;

    @Autowired
    JwtUtils jwtUtils;

    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        
        System.out.println("Login attempt - Username: " + loginRequest.getUsername());
        System.out.println("Login attempt - Password provided: " + (loginRequest.getPassword() != null ? "YES" : "NO"));

        Authentication authentication = authenticationManager
                .authenticate(new UsernamePasswordAuthenticationToken(
                        loginRequest.getUsername(),
                        loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserPrincipal userDetails = (UserPrincipal) authentication.getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());

        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                userDetails.getFirstName(),
                userDetails.getLastName(),
                roles));
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@Valid @RequestBody SignupRequest signUpRequest) {
        if (userRepository.existsByUsername(signUpRequest.getUsername())) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: Username is already taken!"));
        }

        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: Email is already in use!"));
        }

        // Create new user's account
        User user = new User(signUpRequest.getUsername(),
                signUpRequest.getEmail(),
                encoder.encode(signUpRequest.getPassword()));

        user.setFirstName(signUpRequest.getFirstName());
        user.setLastName(signUpRequest.getLastName());

        Set<String> strRoles = signUpRequest.getRole();
        Set<Role> roles = new HashSet<>();

        if (strRoles == null) {
            Role patientRole = roleRepository.findByName(ERole.ROLE_PATIENT)
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
            roles.add(patientRole);
        } else {
            strRoles.forEach(role -> {
                switch (role) {
                    case "admin":
                    case "ROLE_ADMIN":
                        Role adminRole = roleRepository.findByName(ERole.ROLE_ADMIN)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(adminRole);
                        break;
                    case "nutritionist":
                    case "ROLE_NUTRITIONIST":
                        Role nutritionistRole = roleRepository.findByName(ERole.ROLE_NUTRITIONIST)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(nutritionistRole);
                        break;
                    default:
                        Role patientRole = roleRepository.findByName(ERole.ROLE_PATIENT)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(patientRole);
                }
            });
        }

        user.setRoles(roles);
        userRepository.save(user);

        return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
    }

    @GetMapping("/test")
    public ResponseEntity<?> testEndpoint() {
        return ResponseEntity.ok(new MessageResponse("Auth endpoint is working!"));
    }

    @GetMapping("/debug-users")
    public ResponseEntity<?> debugUsers() {
        StringBuilder sb = new StringBuilder();
        sb.append("Total users: ").append(userRepository.count()).append("\n");
        sb.append("Total roles: ").append(roleRepository.count()).append("\n");
        
        userRepository.findAll().forEach(user -> {
            sb.append("User: ").append(user.getUsername())
              .append(", Email: ").append(user.getEmail())
              .append(", Roles: ").append(user.getRoles().size())
              .append("\n");
        });
        
        return ResponseEntity.ok(new MessageResponse(sb.toString()));
    }

    @PostMapping("/init-data")
    public ResponseEntity<?> initializeData() {
        // Check if roles exist, if not create them
        if (roleRepository.count() == 0) {
            roleRepository.save(new Role(ERole.ROLE_ADMIN));
            roleRepository.save(new Role(ERole.ROLE_NUTRITIONIST));
            roleRepository.save(new Role(ERole.ROLE_PATIENT));
        }

        // Check if users exist, if not create sample users
        if (userRepository.count() == 0) {
            // Create Admin user
            User admin = new User("admin", "admin@nutritrack.com", encoder.encode("123456"));
            admin.setFirstName("Administrador");
            admin.setLastName("Sistema");
            Set<Role> adminRoles = new HashSet<>();
            adminRoles.add(roleRepository.findByName(ERole.ROLE_ADMIN).orElseThrow());
            admin.setRoles(adminRoles);
            userRepository.save(admin);

            // Create Nutritionist user
            User nutritionist = new User("nutriologo", "nutriologo@nutritrack.com", encoder.encode("123456"));
            nutritionist.setFirstName("Dr. María");
            nutritionist.setLastName("González");
            Set<Role> nutritionistRoles = new HashSet<>();
            nutritionistRoles.add(roleRepository.findByName(ERole.ROLE_NUTRITIONIST).orElseThrow());
            nutritionist.setRoles(nutritionistRoles);
            userRepository.save(nutritionist);

            // Create Patient user
            User patient = new User("paciente", "paciente@nutritrack.com", encoder.encode("123456"));
            patient.setFirstName("Juan");
            patient.setLastName("Pérez");
            Set<Role> patientRoles = new HashSet<>();
            patientRoles.add(roleRepository.findByName(ERole.ROLE_PATIENT).orElseThrow());
            patient.setRoles(patientRoles);
            userRepository.save(patient);

            // Create sample patients for appointments
            this.createSamplePatients();

            return ResponseEntity.ok(new MessageResponse("Sample data initialized successfully! " +
                "Users created: admin/123456, nutriologo/123456, paciente/123456"));
        } else {
            return ResponseEntity.ok(new MessageResponse("Data already exists. No initialization needed."));
        }
    }

    private void createSamplePatients() {
        // Crear algunos pacientes de ejemplo si no existen
        String[] nombres = {"Ana", "Carlos", "María", "José", "Carmen"};
        String[] apellidos = {"López", "Rodríguez", "García", "Martínez", "Sánchez"};
        
        for (int i = 0; i < nombres.length; i++) {
            Patient patient = new Patient();
            patient.setFirstName(nombres[i]);
            patient.setLastName(apellidos[i]);
            patient.setDateOfBirth(java.time.LocalDate.now().minusYears(25 + i * 5));
            patient.setGender(i % 2 == 0 ? "F" : "M");
            patient.setEmergencyContactName("Contacto " + nombres[i]);
            patient.setEmergencyContactPhone("555-000" + (i + 1));
            patientRepository.save(patient);
        }
    }
}