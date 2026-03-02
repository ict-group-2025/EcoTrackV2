package com.usth.repository;

import com.usth.entity.AdminLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AdminLogRepository extends JpaRepository<AdminLog, Long> {

    List<AdminLog> findByAdminIdOrderByCreatedAtDesc(Long adminId);

    List<AdminLog> findByTargetUserIdOrderByCreatedAtDesc(Long targetUserId);

    List<AdminLog> findByActionTypeOrderByCreatedAtDesc(String actionType);

    Page<AdminLog> findAllByOrderByCreatedAtDesc(Pageable pageable);

    List<AdminLog> findTop50ByOrderByCreatedAtDesc();

    long countByActionType(String actionType);
}
