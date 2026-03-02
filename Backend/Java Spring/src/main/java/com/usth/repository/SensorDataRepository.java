package com.usth.repository;

import com.usth.model.SensorData;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface SensorDataRepository extends MongoRepository<SensorData, String> {
    
    List<SensorData> findByLocation(String location);
    
    List<SensorData> findByLocationOrderByTimestampDesc(String location);
    
    List<SensorData> findByLocationAndTimestampAfter(String location, LocalDateTime timestamp);
    
    @Query("{ 'location': ?0, 'timestamp': { $gte: ?1, $lte: ?2 } }")
    List<SensorData> findByLocationAndTimestampBetween(String location, LocalDateTime start, LocalDateTime end);
    
    @Query("{}")
    List<SensorData> findAllDocuments();
}
