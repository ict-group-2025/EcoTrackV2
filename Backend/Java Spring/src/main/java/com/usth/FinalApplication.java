package com.usth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling // <-- QUAN TRỌNG: Thêm dòng này để auto cập nhật thời tiết
@EnableJpaRepositories(basePackages = "com.usth.repository") // <-- Thêm để scan repositories
public class FinalApplication {

	public static void main(String[] args) {
		SpringApplication.run(FinalApplication.class, args);
	}

}
