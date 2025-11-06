package com.nutritrack.controller;

import com.nutritrack.entity.Patient;
import com.nutritrack.repository.PatientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

@RestController
@RequestMapping("/api/pacientes")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001"})
public class PacienteController {

    @Autowired
    private PatientRepository patientRepository;

    // Obtener todos los pacientes (solo nutriólogos y admins)
    @GetMapping
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> obtenerTodosPacientes() {
        try {
            List<Patient> pacientes = patientRepository.findAll();
            return ResponseEntity.ok(pacientes);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener pacientes: " + e.getMessage());
        }
    }

    // Obtener paciente por ID
    @GetMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> obtenerPacientePorId(@PathVariable Long id) {
        try {
            Patient paciente = patientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));
            return ResponseEntity.ok(paciente);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener paciente: " + e.getMessage());
        }
    }

    // Crear nuevo paciente
    @PostMapping
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> crearPaciente(@RequestBody Map<String, Object> solicitud) {
        try {
            Patient paciente = new Patient();
            
            // Datos básicos (aceptar tanto español como inglés)
            if (solicitud.containsKey("primerNombre") && solicitud.get("primerNombre") != null) {
                paciente.setFirstName(solicitud.get("primerNombre").toString());
            } else if (solicitud.containsKey("firstName") && solicitud.get("firstName") != null) {
                paciente.setFirstName(solicitud.get("firstName").toString());
            }
            
            if (solicitud.containsKey("primerApellido") && solicitud.get("primerApellido") != null) {
                paciente.setLastName(solicitud.get("primerApellido").toString());
            } else if (solicitud.containsKey("lastName") && solicitud.get("lastName") != null) {
                paciente.setLastName(solicitud.get("lastName").toString());
            }
            
            if (solicitud.containsKey("genero") && solicitud.get("genero") != null) {
                String genero = solicitud.get("genero").toString();
                if (!genero.isEmpty()) {
                    paciente.setGender(genero);
                }
            } else if (solicitud.containsKey("gender") && solicitud.get("gender") != null) {
                String gender = solicitud.get("gender").toString();
                if (!gender.isEmpty()) {
                    paciente.setGender(gender);
                }
            }
            
            // Fecha de nacimiento
            if (solicitud.containsKey("fechaNacimiento") && solicitud.get("fechaNacimiento") != null) {
                String fecha = solicitud.get("fechaNacimiento").toString();
                if (!fecha.isEmpty()) {
                    paciente.setDateOfBirth(LocalDate.parse(fecha));
                }
            } else if (solicitud.containsKey("dateOfBirth") && solicitud.get("dateOfBirth") != null) {
                String dateOfBirth = solicitud.get("dateOfBirth").toString();
                if (!dateOfBirth.isEmpty()) {
                    paciente.setDateOfBirth(LocalDate.parse(dateOfBirth));
                }
            }
            
            // Datos físicos
            if (solicitud.containsKey("altura") && solicitud.get("altura") != null) {
                paciente.setHeight(new BigDecimal(solicitud.get("altura").toString()));
            } else if (solicitud.containsKey("height") && solicitud.get("height") != null) {
                paciente.setHeight(new BigDecimal(solicitud.get("height").toString()));
            }
            
            if (solicitud.containsKey("pesoActual") && solicitud.get("pesoActual") != null) {
                paciente.setCurrentWeight(new BigDecimal(solicitud.get("pesoActual").toString()));
            } else if (solicitud.containsKey("currentWeight") && solicitud.get("currentWeight") != null) {
                paciente.setCurrentWeight(new BigDecimal(solicitud.get("currentWeight").toString()));
            }
            
            // Nivel de actividad
            if (solicitud.containsKey("nivelActividad") && solicitud.get("nivelActividad") != null) {
                String nivel = solicitud.get("nivelActividad").toString();
                if (!nivel.isEmpty()) {
                    paciente.setActivityLevel(nivel);
                }
            } else if (solicitud.containsKey("activityLevel") && solicitud.get("activityLevel") != null) {
                String activityLevel = solicitud.get("activityLevel").toString();
                if (!activityLevel.isEmpty()) {
                    paciente.setActivityLevel(activityLevel);
                }
            }
            
            // Información médica
            if (solicitud.containsKey("alergias") && solicitud.get("alergias") != null) {
                String alergias = solicitud.get("alergias").toString();
                if (!alergias.isEmpty()) {
                    paciente.setAllergies(alergias);
                }
            } else if (solicitud.containsKey("allergies") && solicitud.get("allergies") != null) {
                String allergies = solicitud.get("allergies").toString();
                if (!allergies.isEmpty()) {
                    paciente.setAllergies(allergies);
                }
            }
            
            if (solicitud.containsKey("condicionesMedicas") && solicitud.get("condicionesMedicas") != null) {
                String condiciones = solicitud.get("condicionesMedicas").toString();
                if (!condiciones.isEmpty()) {
                    paciente.setMedicalConditions(condiciones);
                }
            } else if (solicitud.containsKey("medicalConditions") && solicitud.get("medicalConditions") != null) {
                String medicalConditions = solicitud.get("medicalConditions").toString();
                if (!medicalConditions.isEmpty()) {
                    paciente.setMedicalConditions(medicalConditions);
                }
            }
            
            if (solicitud.containsKey("dietaryRestrictions") && solicitud.get("dietaryRestrictions") != null) {
                String dietary = solicitud.get("dietaryRestrictions").toString();
                if (!dietary.isEmpty()) {
                    paciente.setDietaryRestrictions(dietary);
                }
            }
            
            // Contacto
            if (solicitud.containsKey("email") && solicitud.get("email") != null) {
                String email = solicitud.get("email").toString();
                if (!email.isEmpty()) {
                    paciente.setEmail(email);
                }
            }
            
            if (solicitud.containsKey("telefono") && solicitud.get("telefono") != null) {
                String telefono = solicitud.get("telefono").toString();
                if (!telefono.isEmpty()) {
                    paciente.setPhone(telefono);
                }
            } else if (solicitud.containsKey("phone") && solicitud.get("phone") != null) {
                String phone = solicitud.get("phone").toString();
                if (!phone.isEmpty()) {
                    paciente.setPhone(phone);
                }
            }
            
            // Información de emergencia
            if (solicitud.containsKey("emergencyContactName") && solicitud.get("emergencyContactName") != null) {
                String emergencyName = solicitud.get("emergencyContactName").toString();
                if (!emergencyName.isEmpty()) {
                    paciente.setEmergencyContactName(emergencyName);
                }
            }
            if (solicitud.containsKey("emergencyContactPhone") && solicitud.get("emergencyContactPhone") != null) {
                String emergencyPhone = solicitud.get("emergencyContactPhone").toString();
                if (!emergencyPhone.isEmpty()) {
                    paciente.setEmergencyContactPhone(emergencyPhone);
                }
            }
            

            
            // Timestamps
            paciente.setCreatedAt(LocalDateTime.now());
            paciente.setUpdatedAt(LocalDateTime.now());
            
            Patient pacienteGuardado = patientRepository.save(paciente);
            
            return ResponseEntity.ok(Map.of(
                "message", "Paciente creado exitosamente",
                "paciente", pacienteGuardado
            ));
            
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al crear paciente: " + e.getMessage());
        }
    }

    // Actualizar paciente
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> actualizarPaciente(@PathVariable Long id, @RequestBody Map<String, Object> solicitud) {
        try {
            Patient paciente = patientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));

            // Actualizar campos si están presentes
            if (solicitud.containsKey("firstName")) {
                paciente.setFirstName(solicitud.get("firstName").toString());
            }
            if (solicitud.containsKey("lastName")) {
                paciente.setLastName(solicitud.get("lastName").toString());
            }
            if (solicitud.containsKey("gender")) {
                paciente.setGender(solicitud.get("gender").toString());
            }
            if (solicitud.containsKey("dateOfBirth")) {
                paciente.setDateOfBirth(LocalDate.parse(solicitud.get("dateOfBirth").toString()));
            }
            if (solicitud.containsKey("height")) {
                paciente.setHeight(new BigDecimal(solicitud.get("height").toString()));
            }
            if (solicitud.containsKey("currentWeight")) {
                paciente.setCurrentWeight(new BigDecimal(solicitud.get("currentWeight").toString()));
            }
            if (solicitud.containsKey("activityLevel")) {
                paciente.setActivityLevel(solicitud.get("activityLevel").toString());
            }
            if (solicitud.containsKey("allergies")) {
                paciente.setAllergies(solicitud.get("allergies").toString());
            }
            if (solicitud.containsKey("medicalConditions")) {
                paciente.setMedicalConditions(solicitud.get("medicalConditions").toString());
            }
            if (solicitud.containsKey("dietaryRestrictions")) {
                paciente.setDietaryRestrictions(solicitud.get("dietaryRestrictions").toString());
            }
            if (solicitud.containsKey("email")) {
                paciente.setEmail(solicitud.get("email").toString());
            }
            if (solicitud.containsKey("phone")) {
                paciente.setPhone(solicitud.get("phone").toString());
            }
            if (solicitud.containsKey("emergencyContactName")) {
                paciente.setEmergencyContactName(solicitud.get("emergencyContactName").toString());
            }
            if (solicitud.containsKey("emergencyContactPhone")) {
                paciente.setEmergencyContactPhone(solicitud.get("emergencyContactPhone").toString());
            }

            paciente.setUpdatedAt(LocalDateTime.now());
            Patient pacienteActualizado = patientRepository.save(paciente);

            return ResponseEntity.ok(Map.of(
                "message", "Paciente actualizado exitosamente",
                "paciente", pacienteActualizado
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al actualizar paciente: " + e.getMessage());
        }
    }

    // Eliminar paciente
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> eliminarPaciente(@PathVariable Long id) {
        try {
            Patient paciente = patientRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));

            patientRepository.delete(paciente);

            return ResponseEntity.ok(Map.of("message", "Paciente eliminado exitosamente"));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al eliminar paciente: " + e.getMessage());
        }
    }
}
