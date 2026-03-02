package com.usth.controller;

import com.usth.model.TestDocument;
import com.usth.repository.TestDocumentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/mongo-test")
public class MongoTestController {

    @Autowired
    private TestDocumentRepository testDocumentRepository;

    @GetMapping("/test-connection")
    public ResponseEntity<String> testConnection() {
        try {
            long count = testDocumentRepository.count();
            return ResponseEntity.ok("MongoDB connection successful! Total documents: " + count);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("MongoDB connection failed: " + e.getMessage());
        }
    }

    @GetMapping("/all")
    public ResponseEntity<List<TestDocument>> getAllDocuments() {
        try {
            List<TestDocument> documents = testDocumentRepository.findAll();
            return ResponseEntity.ok(documents);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    @PostMapping("/add")
    public ResponseEntity<TestDocument> addTestDocument(@RequestBody TestDocument document) {
        try {
            document.setTimestamp(System.currentTimeMillis());
            TestDocument saved = testDocumentRepository.save(document);
            return ResponseEntity.ok(saved);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<TestDocument> getDocumentById(@PathVariable String id) {
        try {
            Optional<TestDocument> document = testDocumentRepository.findById(id);
            return document.map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.status(500).body(null);
        }
    }
}
