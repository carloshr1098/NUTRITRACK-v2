package com.nutritrack.repository;

import com.nutritrack.entity.WeightRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WeightRecordRepository extends JpaRepository<WeightRecord, Long> {
    List<WeightRecord> findByPatientIdOrderByRecordDateAsc(Long patientId);
}
