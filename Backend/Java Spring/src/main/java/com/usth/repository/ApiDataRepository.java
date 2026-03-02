package com.usth.repository;

import com.usth.entity.ApiData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface ApiDataRepository extends JpaRepository<ApiData, Long> {
    Optional<ApiData> findTopByLocationIdOrderByRecordedAtDesc(Long locationId);
    
    @Query("SELECT DISTINCT a FROM ApiData a " +
           "INNER JOIN FETCH a.location l " +
           "WHERE a.id IN (SELECT MAX(a2.id) FROM ApiData a2 GROUP BY a2.location.id)")
    List<ApiData> findLatestApiDataForAllLocations();
    
    @Query("SELECT a FROM ApiData a WHERE a.location.id = :locationId ORDER BY a.recordedAt DESC")
    List<ApiData> findByLocationIdOrderByRecordedAtDesc(@Param("locationId") Long locationId);
}