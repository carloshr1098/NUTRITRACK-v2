package com.nutritrack.repository;

import com.nutritrack.entity.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    // Buscar citas por ID de paciente
    List<Appointment> findByPatientId(Long pacienteId);
    
    // Buscar citas por nutríólogo
    List<Appointment> findByNutritionist(com.nutritrack.entity.User nutritionist);
    
    // Encontrar citas de un nutriólogo entre fechas específicas
    List<Appointment> findByNutritionistAndAppointmentDateBetween(
        com.nutritrack.entity.User nutritionist, LocalDateTime inicio, LocalDateTime fin);
    
    // Encontrar citas entre fechas específicas
    List<Appointment> findByAppointmentDateBetween(LocalDateTime inicio, LocalDateTime fin);
    
    // Encontrar citas próximas desde ahora
    @Query("SELECT a FROM Appointment a WHERE a.appointmentDate > :ahora ORDER BY a.appointmentDate ASC")
    List<Appointment> findUpcomingAppointments(LocalDateTime ahora);
}