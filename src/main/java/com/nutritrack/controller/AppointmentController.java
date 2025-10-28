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
    @PreAuthorize("hasRole('NUTRITIONIST') or hasRole('ADMIN')")
    public ResponseEntity<?> getMyAppointments(Authentication authentication) {
        try {
            String username = authentication.getName();
            User nutritionist = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            List<Appointment> appointments = appointmentRepository.findByNutritionistId(nutritionist.getId());
            return ResponseEntity.ok(appointments);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener citas: " + e.getMessage());
        }
    }

    // Obtener citas del día actual
    @GetMapping("/today")
    @PreAuthorize("hasRole('NUTRITIONIST') or hasRole('ADMIN')")
    public ResponseEntity<?> getTodayAppointments(Authentication authentication) {
        try {
            String username = authentication.getName();
            User nutritionist = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            LocalDateTime startOfDay = LocalDateTime.now().withHour(0).withMinute(0).withSecond(0);
            LocalDateTime endOfDay = LocalDateTime.now().withHour(23).withMinute(59).withSecond(59);

            List<Appointment> appointments = appointmentRepository
                .findByNutritionistIdAndAppointmentDateBetween(nutritionist.getId(), startOfDay, endOfDay);
            
            return ResponseEntity.ok(appointments);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener citas del día: " + e.getMessage());
        }
    }

    // Crear nueva cita
    @PostMapping
    @PreAuthorize("hasRole('NUTRITIONIST') or hasRole('ADMIN')")
    public ResponseEntity<?> createAppointment(@RequestBody Map<String, Object> request, Authentication authentication) {
        try {
            String username = authentication.getName();
            User nutritionist = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            // Obtener datos de la solicitud
            Long patientId = Long.valueOf(request.get("patientId").toString());
            String appointmentDateStr = request.get("appointmentDate").toString();
            String appointmentType = request.get("appointmentType").toString();
            Integer duration = request.containsKey("duration") ? 
                Integer.valueOf(request.get("duration").toString()) : 60;

            // Buscar el paciente
            Patient patient = patientRepository.findById(patientId)
                .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));

            // Parsear fecha
            LocalDateTime appointmentDate = LocalDateTime.parse(appointmentDateStr);

            // Verificar disponibilidad (no debe haber otra cita en el mismo horario)
            LocalDateTime endTime = appointmentDate.plusMinutes(duration);
            List<Appointment> conflictingAppts = appointmentRepository
                .findByNutritionistIdAndAppointmentDateBetween(
                    nutritionist.getId(), 
                    appointmentDate.minusMinutes(duration), 
                    endTime
                );

            if (!conflictingAppts.isEmpty()) {
                return ResponseEntity.badRequest()
                    .body("Ya existe una cita programada en ese horario");
            }

            // Crear nueva cita
            Appointment appointment = new Appointment();
            appointment.setPatient(patient);
            appointment.setNutritionist(nutritionist);
            appointment.setAppointmentDate(appointmentDate);
            appointment.setDurationMinutes(duration);
            appointment.setAppointmentType(appointmentType);
            appointment.setStatus("SCHEDULED");

            // Guardar
            Appointment savedAppointment = appointmentRepository.save(appointment);
            
            return ResponseEntity.ok(Map.of(
                "message", "Cita creada exitosamente",
                "appointment", savedAppointment
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                .body("Error al crear cita: " + e.getMessage());
        }
    }

    // Obtener todos los pacientes para el selector
    @GetMapping("/patients")
    @PreAuthorize("hasRole('NUTRITIONIST') or hasRole('ADMIN')")
    public ResponseEntity<?> getPatients() {
        try {
            List<Patient> patients = patientRepository.findAll();
            return ResponseEntity.ok(patients);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener pacientes: " + e.getMessage());
        }
    }

    // Actualizar cita
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('NUTRITIONIST') or hasRole('ADMIN')")
    public ResponseEntity<?> updateAppointment(@PathVariable Long id, 
                                              @RequestBody Map<String, Object> request,
                                              Authentication authentication) {
        try {
            String username = authentication.getName();
            User nutritionist = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            Appointment appointment = appointmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cita no encontrada"));

            // Verificar que la cita pertenece al nutriólogo autenticado
            if (!appointment.getNutritionist().getId().equals(nutritionist.getId())) {
                return ResponseEntity.status(403).body("No tiene permisos para modificar esta cita");
            }

            // Actualizar campos si están presentes
            if (request.containsKey("appointmentDate")) {
                appointment.setAppointmentDate(LocalDateTime.parse(request.get("appointmentDate").toString()));
            }
            if (request.containsKey("status")) {
                appointment.setStatus(request.get("status").toString());
            }
            if (request.containsKey("appointmentType")) {
                appointment.setAppointmentType(request.get("appointmentType").toString());
            }
            if (request.containsKey("notes")) {
                appointment.setNotes(request.get("notes").toString());
            }

            Appointment savedAppointment = appointmentRepository.save(appointment);
            return ResponseEntity.ok(Map.of(
                "message", "Cita actualizada exitosamente",
                "appointment", savedAppointment
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al actualizar cita: " + e.getMessage());
        }
    }

    // Cancelar cita
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('NUTRITIONIST') or hasRole('ADMIN')")
    public ResponseEntity<?> cancelAppointment(@PathVariable Long id, Authentication authentication) {
        try {
            String username = authentication.getName();
            User nutritionist = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Nutriólogo no encontrado"));

            Appointment appointment = appointmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Cita no encontrada"));

            // Verificar permisos
            if (!appointment.getNutritionist().getId().equals(nutritionist.getId())) {
                return ResponseEntity.status(403).body("No tiene permisos para cancelar esta cita");
            }

            appointment.setStatus("CANCELLED");
            appointmentRepository.save(appointment);

            return ResponseEntity.ok(Map.of("message", "Cita cancelada exitosamente"));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al cancelar cita: " + e.getMessage());
        }
    }
}