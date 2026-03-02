package com.usth.service;

import com.usth.entity.Comment;
import com.usth.entity.Location;
import com.usth.entity.User;
import com.usth.dto.ChatMessage;
import com.usth.repository.CommentRepository;
import com.usth.repository.LocationRepository;
import com.usth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

@Slf4j
@Service
@RequiredArgsConstructor
@SuppressWarnings({ "nullness", "NullAway" })
public class ChatService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final LocationRepository locationRepository;

    @SuppressWarnings("nullness")
    @Transactional
    public ChatMessage saveComment(String locationIdStr, ChatMessage chatMessage) {
        if (chatMessage == null || chatMessage.getSender() == null || chatMessage.getContent() == null) {
            throw new IllegalArgumentException("ChatMessage không hợp lệ");
        }

        try {
            String username = chatMessage.getSender().trim();
            if (username.isEmpty()) {
                throw new IllegalArgumentException("Username không được để trống");
            }

            User user = userRepository.findByUsername(username)
                    .orElseGet(() -> {
                        User newUser = User.builder()
                                .username(username)
                                .fullName(username)
                                .password("$2a$10$dummyHashedPasswordForChatUser000000000000")
                                .build();
                        return Objects.requireNonNull(userRepository.save(newUser), "Saved user cannot be null");
                    });

            Location location = resolveLocation(locationIdStr);

            String content = chatMessage.getContent().trim();
            if (content.isEmpty()) {
                throw new IllegalArgumentException("Nội dung comment không được để trống");
            }

            if (content.length() > 1000) {
                content = content.substring(0, 1000);
                log.warn("Comment quá dài, đã cắt bớt từ user: {}", username);
            }

            Comment comment = Comment.builder()
                    .content(content)
                    .user(user)
                    .location(location)
                    .build();

            Comment savedComment = commentRepository.save(comment);
            Objects.requireNonNull(savedComment, "Saved comment cannot be null");
            log.debug("Đã lưu comment từ user {} cho location {}", username, locationIdStr);

            chatMessage.setUserId(user.getId());
            chatMessage.setUserLocation(user.getUserLocation());
            chatMessage.setAvatarId(user.getAvatarId());
            return chatMessage;
        } catch (IllegalArgumentException e) {
            log.error("Lỗi validation khi lưu comment: {}", e.getMessage());
            throw e;
        } catch (Exception e) {
            log.error("Lỗi khi lưu comment: {}", e.getMessage(), e);
            throw new RuntimeException("Không thể lưu comment: " + e.getMessage());
        }
    }

    private Location resolveLocation(String locationIdStr) {
        try {
            Long locId = Long.parseLong(locationIdStr);
            return locationRepository.findById(locId)
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy Location ID: " + locId));
        } catch (NumberFormatException e) {
            return locationRepository.findByCityNameIgnoreCase(locationIdStr)
                    .orElseGet(() -> {
                        Location newLoc = Location.builder()
                                .cityName(locationIdStr)
                                .latitude(0.0)
                                .longitude(0.0)
                                .build();
                        log.info("Tạo Location mới cho chat: {}", locationIdStr);
                        return locationRepository.save(newLoc);
                    });
        }
    }

    public Map<String, Object> getChatHistory(String locationIdStr, int page, int size) {
        Location location = resolveLocation(locationIdStr);
        Pageable pageable = PageRequest.of(page, size);
        Page<Comment> commentPage = commentRepository.findByLocationIdWithUser(location.getId(), pageable);

        List<ChatMessage> history = commentPage.getContent().stream().map(comment -> {
            ChatMessage msg = new ChatMessage();
            msg.setCommentId(comment.getId());
            if (comment.getUser() != null) {
                msg.setSender(comment.getUser().getUsername());
                msg.setUserId(comment.getUser().getId());
                msg.setUserLocation(comment.getUser().getUserLocation());
                msg.setAvatarId(comment.getUser().getAvatarId());
            } else {
                msg.setSender("Unknown");
                msg.setAvatarId(1);
            }
            msg.setContent(comment.getContent());
            msg.setType("CHAT");
            return msg;
        }).collect(Collectors.toList());

        Map<String, Object> response = new HashMap<>();
        response.put("content", history);
        response.put("totalElements", commentPage.getTotalElements());
        response.put("totalPages", commentPage.getTotalPages());
        response.put("currentPage", commentPage.getNumber());
        response.put("pageSize", commentPage.getSize());

        return response;
    }

    public List<Map<String, Object>> getAllLocationsWithStats() {
        List<Location> locations = locationRepository.findAll();
        return locations.stream().map(loc -> {
            Map<String, Object> item = new HashMap<>();
            item.put("id", loc.getId());
            item.put("cityName", loc.getCityName());
            item.put("countryCode", loc.getCountryCode());
            long messageCount = commentRepository.findByLocationIdOrderByCreatedAtDesc(loc.getId()).size();
            item.put("messageCount", messageCount);
            return item;
        }).collect(Collectors.toList());
    }

    @Transactional
    public ResponseEntity<?> recallComment(Long commentId, String sender) {
        return commentRepository.findById(commentId).map(comment -> {
            if (comment.getUser() == null || !comment.getUser().getUsername().equals(sender)) {
                return ResponseEntity.badRequest().body("Bạn chỉ có thể thu hồi tin nhắn của chính mình!");
            }
            commentRepository.deleteById(commentId);
            log.info("User {} đã thu hồi tin nhắn ID {}", sender, commentId);
            return ResponseEntity.ok("Đã thu hồi tin nhắn");
        }).orElse(ResponseEntity.notFound().build());
    }
}