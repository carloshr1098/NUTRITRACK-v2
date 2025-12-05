package com.nutritrack.controller;

import com.nutritrack.entity.NutritionalAssessment;
import com.nutritrack.service.NutritionalAssessmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/nutritional-assessments")
@CrossOrigin(origins = "*", maxAge = 3600)
public class NutritionalAssessmentController {
    
    @Autowired
    private NutritionalAssessmentService assessmentService;
    
    // Crear nueva evaluación
    @PostMapping
    @PreAuthorize("hasRole('NUTRIOLOGO')")
    public ResponseEntity<?> createAssessment(
            @RequestBody NutritionalAssessment assessment,
            @RequestParam Long patientId,
            @RequestParam Long nutritionistId) {
        try {
            NutritionalAssessment created = assessmentService.createAssessment(assessment, patientId, nutritionistId);
            return ResponseEntity.status(HttpStatus.CREATED).body(created);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body("Error al crear la evaluación: " + e.getMessage());
        }
    }
    
    // Actualizar evaluación existente
    @PutMapping("/{id}")
    @PreAuthorize("hasRole('NUTRIOLOGO')")
    public ResponseEntity<?> updateAssessment(
            @PathVariable Long id,
            @RequestBody NutritionalAssessment assessment) {
        try {
            NutritionalAssessment updated = assessmentService.updateAssessment(id, assessment);
            return ResponseEntity.ok(updated);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body("Error al actualizar la evaluación: " + e.getMessage());
        }
    }
    
    // Obtener todas las evaluaciones de un paciente
    @GetMapping("/patient/{patientId}")
    @PreAuthorize("hasRole('NUTRIOLOGO') or hasRole('PACIENTE')")
    public ResponseEntity<List<NutritionalAssessment>> getAssessmentsByPatient(@PathVariable Long patientId) {
        List<NutritionalAssessment> assessments = assessmentService.getAssessmentsByPatient(patientId);
        return ResponseEntity.ok(assessments);
    }
    
    // Obtener la evaluación más reciente de un paciente
    @GetMapping("/patient/{patientId}/latest")
    @PreAuthorize("hasRole('NUTRIOLOGO') or hasRole('PACIENTE')")
    public ResponseEntity<?> getLatestAssessment(@PathVariable Long patientId) {
        return assessmentService.getLatestAssessmentByPatient(patientId)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    // Obtener una evaluación específica por ID
    @GetMapping("/{id}")
    @PreAuthorize("hasRole('NUTRIOLOGO') or hasRole('PACIENTE')")
    public ResponseEntity<?> getAssessmentById(@PathVariable Long id) {
        return assessmentService.getAssessmentById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
    
    // Obtener todas las evaluaciones realizadas por un nutricionista
    @GetMapping("/nutritionist/{nutritionistId}")
    @PreAuthorize("hasRole('NUTRIOLOGO')")
    public ResponseEntity<List<NutritionalAssessment>> getAssessmentsByNutritionist(@PathVariable Long nutritionistId) {
        List<NutritionalAssessment> assessments = assessmentService.getAssessmentsByNutritionist(nutritionistId);
        return ResponseEntity.ok(assessments);
    }
    
    // Eliminar una evaluación
    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('NUTRIOLOGO')")
    public ResponseEntity<?> deleteAssessment(@PathVariable Long id) {
        try {
            assessmentService.deleteAssessment(id);
            return ResponseEntity.ok("Evaluación eliminada correctamente");
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body("Error al eliminar la evaluación: " + e.getMessage());
        }
    }
}
