package com.usth.repository;

import com.usth.entity.News;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NewsRepository extends JpaRepository<News, Long> {

        Optional<News> findByGuid(String guid);

        boolean existsByGuid(String guid);

        List<News> findByCategoryOrderByPublishedAtDesc(String category);

        Page<News> findByCategoryOrderByPublishedAtDesc(String category, Pageable pageable);

        List<News> findTop20ByOrderByPublishedAtDesc();

        @Query("SELECT n FROM News n WHERE " +
                        "LOWER(n.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "LOWER(n.summary) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
                        "ORDER BY n.publishedAt DESC")
        List<News> searchByKeyword(@Param("keyword") String keyword);

        @Query("SELECT n FROM News n WHERE " +
                        "LOWER(n.title) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                        "LOWER(n.summary) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
                        "ORDER BY n.publishedAt DESC")
        Page<News> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);

        long countByCategory(String category);

        @Query("SELECT n FROM News n WHERE n.publishedAt >= :since ORDER BY n.publishedAt DESC")
        List<News> findRecentNews(@Param("since") java.time.LocalDateTime since);
}
