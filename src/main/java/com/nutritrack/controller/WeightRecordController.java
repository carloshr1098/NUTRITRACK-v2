package com.nutritrack.controller;

import com.nutritrack.entity.Patient;
import com.nutritrack.entity.WeightRecord;
import com.nutritrack.repository.PatientRepository;
import com.nutritrack.repository.WeightRecordRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/weight-records")
@CrossOrigin(origins = "*", maxAge = 3600)
public class WeightRecordController {
    
    @Autowired
    private WeightRecordRepository weightRecordRepository;
    
    @Autowired
    private PatientRepository patientRepository;
    
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<?> getWeightRecordsByPatient(@PathVariable Long patientId) {
        try {
            List<WeightRecord> records = weightRecordRepository.findByPatientIdOrderByRecordDateAsc(patientId);
            return ResponseEntity.ok(records);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al obtener registros de peso: " + e.getMessage());
        }
    }
    
    @PostMapping
    public ResponseEntity<?> createWeightRecord(@RequestBody Map<String, Object> payload) {
        try {
            Long patientId = Long.valueOf(payload.get("patientId").toString());
            Double weight = Double.valueOf(payload.get("weight").toString());
            String dateStr = payload.get("recordDate").toString();
            LocalDate recordDate = LocalDate.parse(dateStr);
            
            Patient patient = patientRepository.findById(patientId)
                    .orElseThrow(() -> new RuntimeException("Paciente no encontrado"));
            
            WeightRecord record = new WeightRecord(patient, weight, recordDate);
            if (payload.containsKey("notes")) {
                record.setNotes(payload.get("notes").toString());
            }
            
            WeightRecord savedRecord = weightRecordRepository.save(record);
            
            // Actualizar el peso actual del paciente si es el registro más reciente
            patient.setCurrentWeight(BigDecimal.valueOf(weight));
            patientRepository.save(patient);
            
            Map<String, Object> response = new HashMap<>();
            response.put("id", savedRecord.getId());
            response.put("weight", savedRecord.getWeight());
            response.put("recordDate", savedRecord.getRecordDate());
            response.put("notes", savedRecord.getNotes());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al crear registro de peso: " + e.getMessage());
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteWeightRecord(@PathVariable Long id) {
        try {
            weightRecordRepository.deleteById(id);
            return ResponseEntity.ok().body("Registro eliminado exitosamente");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error al eliminar registro: " + e.getMessage());
        }
    }
}
