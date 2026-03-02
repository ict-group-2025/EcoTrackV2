package com.usth.controller;

import com.usth.entity.AdminLog;
import com.usth.entity.User;
import com.usth.repository.CommentRepository;
import com.usth.repository.UserRepository;
import com.usth.service.AdminLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@CrossOrigin(origins = "*", maxAge = 3600)
public class AdminController {

    private final UserRepository userRepository;
    private final CommentRepository commentRepository;
    private final AdminLogService adminLogService;

    private User getCurrentAdmin() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UserDetails) {
            UserDetails userDetails = (UserDetails) auth.getPrincipal();
            return userRepository.findByUsername(userDetails.getUsername()).orElse(null);
        }
        return null;
    }

    @DeleteMapping("/comments/{id}")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseEntity<?> deleteComment(@PathVariable Long id) {
        if (!commentRepository.existsById(id)) {
            return ResponseEntity.notFound().build();
        }

        User admin = getCurrentAdmin();
        commentRepository.deleteById(id);

        if (admin != null) {
            adminLogService.logDeleteComment(admin, id);
        }

        return ResponseEntity.ok("Đã xóa bình luận thành công.");
    }

    @PostMapping("/users/{userId}/warn")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseEntity<?> warnUser(@PathVariable Long userId) {
        User admin = getCurrentAdmin();

        return userRepository.findById(userId).map(user -> {

            if ("ADMIN".equals(user.getRole())) {
                return ResponseEntity.badRequest().body("Không thể cảnh báo Admin!");
            }

            user.setWarningCount(user.getWarningCount() + 1);
            String message = "Đã cảnh báo user. Số lần cảnh báo: " + user.getWarningCount();

            if (user.getWarningCount() >= 3) {
                user.setWarningCount(0);
                user.setBanCount(user.getBanCount() + 1);

                if (user.getBanCount() == 1) {
                    user.setBanExpiration(LocalDateTime.now().plusDays(7));
                    message = "User bị cấm 1 tuần (Lần đầu).";
                } else if (user.getBanCount() == 2) {
                    user.setBanExpiration(LocalDateTime.now().plusMonths(1));
                    message = "User bị cấm 1 tháng (Lần 2).";
                } else {
                    user.setBanned(true);
                    user.setBanExpiration(null);
                    message = "User bị cấm vĩnh viễn (Lần 3).";
                }
            }

            userRepository.save(user);

            if (admin != null) {
                adminLogService.logWarn(admin, user);
            }

            return ResponseEntity.ok(message);
        }).orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/users/{userId}/ban")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseEntity<?> banUser(@PathVariable Long userId) {
        User admin = getCurrentAdmin();

        return userRepository.findById(userId).map(user -> {
            if ("ADMIN".equals(user.getRole())) {
                return ResponseEntity.badRequest().body("Không thể ban Admin!");
            }
            user.setBanned(true);
            user.setBanExpiration(null);
            userRepository.save(user);

            if (admin != null) {
                adminLogService.logBan(admin, user);
            }

            return ResponseEntity.ok("Đã ban vĩnh viễn user " + user.getUsername());
        }).orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/users/{userId}/unban")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseEntity<?> unbanUser(@PathVariable Long userId) {
        User admin = getCurrentAdmin();

        return userRepository.findById(userId).map(user -> {
            user.setBanned(false);
            user.setBanExpiration(null);
            user.setWarningCount(0);
            userRepository.save(user);

            if (admin != null) {
                adminLogService.logUnban(admin, user);
            }

            return ResponseEntity.ok("Đã gỡ ban cho user " + user.getUsername());
        }).orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/logs")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseEntity<?> getAdminLogs() {
        List<AdminLog> logs = adminLogService.getRecentLogs();
        return ResponseEntity.ok(logs);
    }

    @GetMapping("/logs/stats")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseEntity<?> getLogStats() {
        Map<String, Long> stats = adminLogService.getStats();
        return ResponseEntity.ok(stats);
    }

    @GetMapping("/users")
    @PreAuthorize("hasAuthority('ADMIN')")
    public ResponseEntity<?> getAllUsers() {
        List<User> users = userRepository.findAll();
        var result = users.stream().map(u -> Map.of(
                "id", u.getId(),
                "username", u.getUsername(),
                "fullName", u.getFullName() != null ? u.getFullName() : "",
                "email", u.getEmail() != null ? u.getEmail() : "",
                "role", u.getRole(),
                "warningCount", u.getWarningCount(),
                "banCount", u.getBanCount(),
                "isBanned", u.isBanned(),
                "banExpiration", u.getBanExpiration() != null ? u.getBanExpiration().toString() : ""))
                .collect(java.util.stream.Collectors.toList());
        return ResponseEntity.ok(result);
    }
}
