package com.usth.repository;

import com.usth.entity.Comment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByLocationIdOrderByCreatedAtDesc(Long locationId);

    @Query("SELECT c FROM Comment c JOIN FETCH c.user WHERE c.location.id = :locationId ORDER BY c.createdAt DESC")
    Page<Comment> findByLocationIdWithUser(@Param("locationId") Long locationId, Pageable pageable);

    @Query("SELECT c.location.id, COUNT(c) as cnt FROM Comment c GROUP BY c.location.id ORDER BY cnt DESC")
    List<Object[]> findTopLocations(Pageable pageable);
}