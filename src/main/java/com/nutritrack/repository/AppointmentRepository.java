package com.nutritrack.repository;

import com.nutritrack.entity.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByPatientId(Long patientId);
    List<Appointment> findByNutritionistId(Long nutritionistId);
    
    // Encontrar citas de un nutriólogo entre fechas específicas
    List<Appointment> findByNutritionistIdAndAppointmentDateBetween(
        Long nutritionistId, LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT a FROM Appointment a WHERE a.appointmentDate BETWEEN :start AND :end")
    List<Appointment> findAppointmentsBetween(LocalDateTime start, LocalDateTime end);
    
    @Query("SELECT a FROM Appointment a WHERE a.appointmentDate > :now ORDER BY a.appointmentDate ASC")
    List<Appointment> findUpcomingAppointments(LocalDateTime now);
}