package com.usth.service;

import com.usth.entity.AdminLog;
import com.usth.entity.User;
import com.usth.repository.AdminLogRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AdminLogService {

    @Autowired
    private AdminLogRepository adminLogRepository;

    public void logWarn(User admin, User targetUser) {
        AdminLog log = new AdminLog(admin.getId(), admin.getUsername(), "WARN");
        log.setTargetUserId(targetUser.getId());
        log.setTargetUsername(targetUser.getUsername());
        log.setDetails(
                "Cảnh báo user " + targetUser.getUsername() + " (warnings: " + targetUser.getWarningCount() + ")");
        adminLogRepository.save(log);
    }

    public void logBan(User admin, User targetUser) {
        AdminLog log = new AdminLog(admin.getId(), admin.getUsername(), "BAN");
        log.setTargetUserId(targetUser.getId());
        log.setTargetUsername(targetUser.getUsername());
        log.setDetails("Ban vĩnh viễn user " + targetUser.getUsername());
        adminLogRepository.save(log);
    }

    public void logUnban(User admin, User targetUser) {
        AdminLog log = new AdminLog(admin.getId(), admin.getUsername(), "UNBAN");
        log.setTargetUserId(targetUser.getId());
        log.setTargetUsername(targetUser.getUsername());
        log.setDetails("Gỡ ban user " + targetUser.getUsername());
        adminLogRepository.save(log);
    }

    public void logDeleteComment(User admin, Long messageId) {
        AdminLog log = new AdminLog(admin.getId(), admin.getUsername(), "DELETE_COMMENT");
        log.setTargetMessageId(messageId);
        log.setDetails("Xóa tin nhắn ID: " + messageId);
        adminLogRepository.save(log);
    }

    public List<AdminLog> getRecentLogs() {
        return adminLogRepository.findTop50ByOrderByCreatedAtDesc();
    }

    public Page<AdminLog> getLogs(int page, int size) {
        return adminLogRepository.findAllByOrderByCreatedAtDesc(PageRequest.of(page, size));
    }

    public Map<String, Long> getStats() {
        Map<String, Long> stats = new HashMap<>();
        stats.put("warn", adminLogRepository.countByActionType("WARN"));
        stats.put("ban", adminLogRepository.countByActionType("BAN"));
        stats.put("unban", adminLogRepository.countByActionType("UNBAN"));
        stats.put("delete", adminLogRepository.countByActionType("DELETE_COMMENT"));
        stats.put("total", adminLogRepository.count());
        return stats;
    }
}
