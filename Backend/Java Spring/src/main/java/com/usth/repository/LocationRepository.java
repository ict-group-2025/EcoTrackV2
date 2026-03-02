package com.usth.repository;

import com.usth.entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface LocationRepository extends JpaRepository<Location, Long> {
    Optional<Location> findByCityName(String cityName);

    Optional<Location> findByCityNameIgnoreCase(String cityName);
}