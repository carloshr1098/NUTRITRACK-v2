package com.nutritrack.controller;

import com.nutritrack.entity.DietPlan;
import com.nutritrack.entity.Patient;
import com.nutritrack.entity.User;
import com.nutritrack.repository.DietPlanRepository;
import com.nutritrack.repository.PatientRepository;
import com.nutritrack.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/diet-plans")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001"})
public class DietPlanController {

    @Autowired
    private DietPlanRepository dietPlanRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserRepository userRepository;

    // Obtener todos los planes del nutriólogo autenticado
    @GetMapping
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> obtenerMisPlanes(Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            List<DietPlan> planes = dietPlanRepository.findByNutritionist(nutriologo);
            return ResponseEntity.ok(planes);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener planes: " + e.getMessage());
        }
    }

    // Obtener planes por estado
    @GetMapping("/status/{status}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> obtenerPlanesPorEstado(@PathVariable String status, Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            List<DietPlan> planes = dietPlanRepository.findByNutritionist(nutriologo);
            // Filtrar por estado
            planes = planes.stream()
                .filter(p -> p.getStatus().equals(status))
                .toList();

            return ResponseEntity.ok(planes);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener planes: " + e.getMessage());
        }
    }

    // Obtener plan por ID
    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN') or hasRole('ROLE_PACIENTE')")
    public ResponseEntity<?> obtenerPlanPorId(@PathVariable Long id) {
        try {
            DietPlan plan = dietPlanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Plan no encontrado"));
            return ResponseEntity.ok(plan);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener plan: " + e.getMessage());
        }
    }

    // Crear nuevo plan dietético
    @PostMapping
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> crearPlan(@RequestBody Map<String, Object> solicitud, 
                                       Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            // Obtener el paciente
            Long idPaciente = Long.valueOf(solicitud.get("patientId").toString());
            Patient paciente = patientRepository.findById(idPaciente)
                .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));

            // Crear el plan
            DietPlan plan = new DietPlan();
            plan.setPatient(paciente);
            plan.setNutritionist(nutriologo);
            plan.setPlanName(solicitud.get("planName").toString());
            
            if (solicitud.containsKey("description")) {
                plan.setDescription(solicitud.get("description").toString());
            }
            
            if (solicitud.containsKey("startDate")) {
                plan.setStartDate(LocalDate.parse(solicitud.get("startDate").toString()));
            }
            
            if (solicitud.containsKey("endDate")) {
                plan.setEndDate(LocalDate.parse(solicitud.get("endDate").toString()));
            }
            
            if (solicitud.containsKey("dailyCalories")) {
                plan.setDailyCalories(Integer.valueOf(solicitud.get("dailyCalories").toString()));
            }
            
            if (solicitud.containsKey("goals")) {
                plan.setGoals(solicitud.get("goals").toString());
            }
            
            plan.setStatus("ACTIVE");

            DietPlan planGuardado = dietPlanRepository.save(plan);

            return ResponseEntity.ok(Map.of(
                "message", "Plan creado exitosamente",
                "dietPlan", planGuardado
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al crear plan: " + e.getMessage());
        }
    }

    // Actualizar plan dietético
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> actualizarPlan(@PathVariable Long id, 
                                           @RequestBody Map<String, Object> solicitud,
                                           Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            DietPlan plan = dietPlanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Plan no encontrado"));

            // Verificar que el plan pertenece al nutriólogo autenticado
            if (!plan.getNutritionist().getId().equals(nutriologo.getId())) {
                return ResponseEntity.status(403).body("No tiene permisos para actualizar este plan");
            }

            // Actualizar campos
            if (solicitud.containsKey("planName")) {
                plan.setPlanName(solicitud.get("planName").toString());
            }
            if (solicitud.containsKey("description")) {
                plan.setDescription(solicitud.get("description").toString());
            }
            if (solicitud.containsKey("startDate")) {
                plan.setStartDate(LocalDate.parse(solicitud.get("startDate").toString()));
            }
            if (solicitud.containsKey("endDate")) {
                plan.setEndDate(LocalDate.parse(solicitud.get("endDate").toString()));
            }
            if (solicitud.containsKey("dailyCalories")) {
                plan.setDailyCalories(Integer.valueOf(solicitud.get("dailyCalories").toString()));
            }
            if (solicitud.containsKey("goals")) {
                plan.setGoals(solicitud.get("goals").toString());
            }
            if (solicitud.containsKey("status")) {
                plan.setStatus(solicitud.get("status").toString());
            }

            DietPlan planActualizado = dietPlanRepository.save(plan);

            return ResponseEntity.ok(Map.of(
                "message", "Plan actualizado exitosamente",
                "dietPlan", planActualizado
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al actualizar plan: " + e.getMessage());
        }
    }

    // Eliminar plan dietético
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> eliminarPlan(@PathVariable Long id, Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            DietPlan plan = dietPlanRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Plan no encontrado"));

            // Verificar que el plan pertenece al nutriólogo autenticado
            if (!plan.getNutritionist().getId().equals(nutriologo.getId())) {
                return ResponseEntity.status(403).body("No tiene permisos para eliminar este plan");
            }

            dietPlanRepository.delete(plan);

            return ResponseEntity.ok(Map.of("message", "Plan eliminado exitosamente"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al eliminar plan: " + e.getMessage());
        }
    }

    // Obtener planes de un paciente específico
    @GetMapping("/patient/{patientId}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN') or hasRole('ROLE_PACIENTE')")
    public ResponseEntity<?> obtenerPlanesPorPaciente(@PathVariable Long patientId) {
        try {
            Patient paciente = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));

            List<DietPlan> planes = dietPlanRepository.findByPatient(paciente);
            return ResponseEntity.ok(planes);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener planes: " + e.getMessage());
        }
    }
}
