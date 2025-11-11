package com.nutritrack.controller;

import com.nutritrack.entity.Appointment;
import com.nutritrack.entity.Patient;
import com.nutritrack.entity.User;
import com.nutritrack.repository.AppointmentRepository;
import com.nutritrack.repository.PatientRepository;
import com.nutritrack.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/appointments")
@CrossOrigin(origins = {"http://localhost:3000", "http://localhost:3001"})
public class AppointmentController {

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private UserRepository userRepository;

    // Obtener todas las citas del nutriólogo autenticado
    @GetMapping
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> obtenerMisCitas(Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            List<Appointment> citas = appointmentRepository.findByNutritionist(nutriologo);
            return ResponseEntity.ok(citas);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener citas: " + e.getMessage());
        }
    }

    // Obtener citas del día actual
    @GetMapping("/today")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> obtenerCitasHoy(Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            LocalDateTime inicioDia = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
            LocalDateTime finDia = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);

            List<Appointment> citasHoy = appointmentRepository
                .findByNutritionistAndAppointmentDateBetween(nutriologo, inicioDia, finDia);
            
            return ResponseEntity.ok(citasHoy);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener citas del día: " + e.getMessage());
        }
    }

    // Crear nueva cita
    @PostMapping
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> crearCita(@RequestBody Map<String, Object> solicitud, Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            // Obtener datos de la solicitud
            Long idPaciente = Long.valueOf(solicitud.get("patientId").toString());
            String fechaCitaStr = solicitud.get("appointmentDate").toString();
            String tipoCita = solicitud.get("appointmentType").toString();
            Integer duracion = solicitud.containsKey("duration") ? 
                Integer.valueOf(solicitud.get("duration").toString()) : 60;

            // Buscar el paciente
            Patient paciente = patientRepository.findById(idPaciente)
                .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));

            // Parsear fecha
            LocalDateTime fechaCita = LocalDateTime.parse(fechaCitaStr);

            // Verificar disponibilidad (no debe haber otra cita en el mismo horario)
            LocalDateTime horaFin = fechaCita.plusMinutes(duracion);
            List<Appointment> citasConflicto = appointmentRepository
                .findByNutritionistAndAppointmentDateBetween(
                    nutriologo, 
                    fechaCita.minusMinutes(duracion), 
                    horaFin
                );

            if (!citasConflicto.isEmpty()) {
                return ResponseEntity.badRequest()
                    .body("Ya existe una cita programada en ese horario");
            }

            // Crear nueva cita
            Appointment cita = new Appointment();
            cita.setPatient(paciente);
            cita.setNutritionist(nutriologo);
            cita.setAppointmentDate(fechaCita);
            cita.setDurationMinutes(duracion);
            cita.setAppointmentType(tipoCita);
            cita.setStatus("SCHEDULED");

            // Guardar
            Appointment citaGuardada = appointmentRepository.save(cita);
            
            return ResponseEntity.ok(Map.of(
                "message", "Cita creada exitosamente",
                "appointment", citaGuardada
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body("Error al crear cita: " + e.getMessage());
        }
    }

    // Obtener todos los pacientes para el selector
    @GetMapping("/patients")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> obtenerPacientes() {
        try {
            List<Patient> pacientes = patientRepository.findAll();
            return ResponseEntity.ok(pacientes);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener pacientes: " + e.getMessage());
        }
    }

    // Actualizar cita
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> actualizarCita(@PathVariable Long id, 
                                              @RequestBody Map<String, Object> solicitud,
                                              Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            Appointment cita = appointmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cita no encontrada"));

            // Verificar que la cita pertenece al nutriólogo autenticado
            if (!cita.getNutritionist().getId().equals(nutriologo.getId())) {
                return ResponseEntity.status(403).body("No tiene permisos para modificar esta cita");
            }

            // Actualizar paciente si se proporciona
            if (solicitud.containsKey("patientId")) {
                Long idPaciente = Long.valueOf(solicitud.get("patientId").toString());
                Patient paciente = patientRepository.findById(idPaciente)
                    .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));
                cita.setPatient(paciente);
            }

            // Actualizar campos si están presentes
            if (solicitud.containsKey("appointmentDate")) {
                String fechaStr = solicitud.get("appointmentDate").toString();
                // Manejar formato ISO 8601 con zona horaria
                if (fechaStr.contains("Z") || fechaStr.contains("+")) {
                    cita.setAppointmentDate(java.time.ZonedDateTime.parse(fechaStr).toLocalDateTime());
                } else {
                    cita.setAppointmentDate(LocalDateTime.parse(fechaStr));
                }
            }
            if (solicitud.containsKey("status")) {
                cita.setStatus(solicitud.get("status").toString());
            }
            if (solicitud.containsKey("appointmentType")) {
                cita.setAppointmentType(solicitud.get("appointmentType").toString());
            }
            if (solicitud.containsKey("durationMinutes")) {
                cita.setDurationMinutes(Integer.valueOf(solicitud.get("durationMinutes").toString()));
            }
            if (solicitud.containsKey("notes")) {
                cita.setNotes(solicitud.get("notes").toString());
            }

            Appointment citaGuardada = appointmentRepository.save(cita);
            return ResponseEntity.ok(Map.of(
                "message", "Cita actualizada exitosamente",
                "appointment", citaGuardada
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al actualizar cita: " + e.getMessage());
        }
    }

    // Eliminar cita permanentemente
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ROLE_NUTRIOLOGO') or hasRole('ROLE_ADMIN')")
    public ResponseEntity<?> eliminarCita(@PathVariable Long id, Authentication authentication) {
        try {
            String nombreUsuario = authentication.getName();
            User nutriologo = userRepository.findByUsername(nombreUsuario)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            Appointment cita = appointmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cita no encontrada"));

            // Verificar permisos
            if (!cita.getNutritionist().getId().equals(nutriologo.getId())) {
                return ResponseEntity.status(403).body("No tiene permisos para eliminar esta cita");
            }

            // Eliminar permanentemente
            appointmentRepository.delete(cita);

            return ResponseEntity.ok(Map.of("message", "Cita eliminada exitosamente"));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al eliminar cita: " + e.getMessage());
        }
    }
}
