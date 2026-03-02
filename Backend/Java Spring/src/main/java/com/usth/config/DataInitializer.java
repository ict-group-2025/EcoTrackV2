package com.usth.config;

import com.usth.entity.User;
import com.usth.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        if (!userRepository.existsByUsername("admin")) {
            User admin = User.builder()
                    .username("admin")
                    .fullName("Administrator")
                    .password(passwordEncoder.encode("123456"))
                    .email("admin@ecotrack.com")
                    .role("ADMIN")
                    .build();
            userRepository.save(admin);
            System.out.println(">>> Đã tạo tài khoản ADMIN mặc định: admin / 123456");
        } else {
            User admin = userRepository.findByUsername("admin").get();
            admin.setPassword(passwordEncoder.encode("123456"));
            admin.setRole("ADMIN");
            userRepository.save(admin);
            System.out.println(">>> Đã cập nhật mật khẩu ADMIN: admin / 123456");
        }
    }
}
