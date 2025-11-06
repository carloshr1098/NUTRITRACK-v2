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
    public ResponseEntity<?> autenticarUsuario(@Valid @RequestBody LoginRequest solicitudLogin) {
        
        System.out.println("Intento de login - Usuario: " + solicitudLogin.getUsername());
        System.out.println("Intento de login - Contraseña proporcionada: " + (solicitudLogin.getPassword() != null ? "SI" : "NO"));

        Authentication autenticacion = authenticationManager
                .authenticate(new UsernamePasswordAuthenticationToken(
                        solicitudLogin.getUsername(),
                        solicitudLogin.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(autenticacion);
        String jwt = jwtUtils.generateJwtToken(autenticacion);

        UserPrincipal detallesUsuario = (UserPrincipal) autenticacion.getPrincipal();
        List<String> roles = detallesUsuario.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());

        return ResponseEntity.ok(new JwtResponse(jwt,
                detallesUsuario.getId(),
                detallesUsuario.getUsername(),
                detallesUsuario.getEmail(),
                detallesUsuario.getFirstName(),
                detallesUsuario.getLastName(),
                roles));
    }

    @PostMapping("/signup")
    public ResponseEntity<?> registrarUsuario(@Valid @RequestBody SignupRequest solicitudRegistro) {
        if (userRepository.existsByUsername(solicitudRegistro.getUsername())) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: El nombre de usuario ya está en uso!"));
        }

        if (userRepository.existsByEmail(solicitudRegistro.getEmail())) {
            return ResponseEntity.badRequest()
                    .body(new MessageResponse("Error: El email ya está en uso!"));
        }

        // Crear nueva cuenta de usuario
        User usuario = new User(solicitudRegistro.getUsername(),
                solicitudRegistro.getEmail(),
                encoder.encode(solicitudRegistro.getPassword()));

        usuario.setFirstName(solicitudRegistro.getFirstName());
        usuario.setLastName(solicitudRegistro.getLastName());

        Set<String> rolesStr = solicitudRegistro.getRole();
        Set<Role> roles = new HashSet<>();

        if (rolesStr == null) {
            Role rolPaciente = roleRepository.findByName(ERole.ROLE_PACIENTE)
                    .orElseThrow(() -> new RuntimeException("Error: Rol no encontrado."));
            roles.add(rolPaciente);
        } else {
            rolesStr.forEach(role -> {
                switch (role) {
                    case "admin":
                    case "ROLE_ADMIN":
                        Role rolAdmin = roleRepository.findByName(ERole.ROLE_ADMIN)
                                .orElseThrow(() -> new RuntimeException("Error: Rol no encontrado."));
                        roles.add(rolAdmin);
                        break;
                    case "nutriologo":
                    case "ROLE_NUTRIOLOGO":
                        Role rolNutriologo = roleRepository.findByName(ERole.ROLE_NUTRIOLOGO)
                                .orElseThrow(() -> new RuntimeException("Error: Rol no encontrado."));
                        roles.add(rolNutriologo);
                        break;
                    default:
                        Role rolPaciente = roleRepository.findByName(ERole.ROLE_PACIENTE)
                                .orElseThrow(() -> new RuntimeException("Error: Rol no encontrado."));
                        roles.add(rolPaciente);
                }
            });
        }

        usuario.setRoles(roles);
        userRepository.save(usuario);

        return ResponseEntity.ok(new MessageResponse("Usuario registrado exitosamente!"));
    }

    @GetMapping("/test")
    public ResponseEntity<?> endpointPrueba() {
        return ResponseEntity.ok(new MessageResponse("El endpoint de autenticación está funcionando!"));
    }

    @GetMapping("/debug-users")
    public ResponseEntity<?> depurarUsuarios() {
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
    public ResponseEntity<?> inicializarDatos() {
        // Verificar si los roles existen, si no, crearlos
        if (roleRepository.count() == 0) {
            roleRepository.save(new Role(ERole.ROLE_ADMIN));
            roleRepository.save(new Role(ERole.ROLE_NUTRIOLOGO));
            roleRepository.save(new Role(ERole.ROLE_PACIENTE));
        }

        // Verificar si los usuarios existen, si no, crear usuarios de ejemplo
        if (userRepository.count() == 0) {
            // Crear usuario Administrador
            User admin = new User("admin", "admin@nutritrack.com", encoder.encode("123456"));
            admin.setFirstName("Administrador");
            admin.setLastName("Sistema");
            Set<Role> rolesAdmin = new HashSet<>();
            rolesAdmin.add(roleRepository.findByName(ERole.ROLE_ADMIN).orElseThrow());
            admin.setRoles(rolesAdmin);
            userRepository.save(admin);

            // Crear usuario Nutriólogo
            User nutriologo = new User("nutriologo", "nutriologo@nutritrack.com", encoder.encode("123456"));
            nutriologo.setFirstName("Dr. María");
            nutriologo.setLastName("González");
            Set<Role> rolesNutriologo = new HashSet<>();
            rolesNutriologo.add(roleRepository.findByName(ERole.ROLE_NUTRIOLOGO).orElseThrow());
            nutriologo.setRoles(rolesNutriologo);
            userRepository.save(nutriologo);

            // Crear usuario Paciente
            User paciente = new User("paciente", "paciente@nutritrack.com", encoder.encode("123456"));
            paciente.setFirstName("Juan");
            paciente.setLastName("Pérez");
            Set<Role> rolesPaciente = new HashSet<>();
            rolesPaciente.add(roleRepository.findByName(ERole.ROLE_PACIENTE).orElseThrow());
            paciente.setRoles(rolesPaciente);
            userRepository.save(paciente);

            // Crear pacientes de ejemplo para las citas
            this.crearPacientesDeEjemplo();

            return ResponseEntity.ok(new MessageResponse("Datos de ejemplo inicializados correctamente! " +
                "Usuarios creados: admin/123456, nutriologo/123456, paciente/123456"));
        } else {
            // Crear pacientes de ejemplo incluso si los usuarios ya existen
            this.crearPacientesDeEjemplo();
            return ResponseEntity.ok(new MessageResponse("Los datos ya existen. Pacientes de ejemplo creados."));
        }
    }

    private void crearPacientesDeEjemplo() {
        // Solo crear si no hay pacientes
        if (patientRepository.count() == 0) {
            // Paciente 1
            Patient patient1 = new Patient();
            patient1.setFirstName("Ana");
            patient1.setLastName("García");
            patient1.setGender("F");
            patient1.setDateOfBirth(java.time.LocalDate.of(1985, 3, 15));
            patient1.setHeight(new java.math.BigDecimal("165"));
            patient1.setCurrentWeight(new java.math.BigDecimal("68.5"));
            patient1.setActivityLevel("Moderadamente activo");
            patient1.setAllergies("Ninguna conocida");
            patient1.setMedicalConditions("");
            patientRepository.save(patient1);
            
            // Paciente 2
            Patient patient2 = new Patient();
            patient2.setFirstName("Carlos");
            patient2.setLastName("Rodríguez");
            patient2.setGender("M");
            patient2.setDateOfBirth(java.time.LocalDate.of(1990, 7, 22));
            patient2.setHeight(new java.math.BigDecimal("178"));
            patient2.setCurrentWeight(new java.math.BigDecimal("85.2"));
            patient2.setActivityLevel("Activo");
            patient2.setAllergies("Frutos secos");
            patient2.setMedicalConditions("Diabetes tipo 2");
            patientRepository.save(patient2);
            
            // Paciente 3
            Patient patient3 = new Patient();
            patient3.setFirstName("María");
            patient3.setLastName("López");
            patient3.setGender("F");
            patient3.setDateOfBirth(java.time.LocalDate.of(1992, 11, 8));
            patient3.setHeight(new java.math.BigDecimal("162"));
            patient3.setCurrentWeight(new java.math.BigDecimal("72.1"));
            patient3.setActivityLevel("Sedentario");
            patient3.setAllergies("Lactosa");
            patient3.setMedicalConditions("Hipotiroidismo");
            patientRepository.save(patient3);
        }
    }
}