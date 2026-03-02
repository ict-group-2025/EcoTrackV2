package com.usth.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import lombok.Data;

@Data
@Document(collection = "test_collection")
public class TestDocument {
    @Id
    private String id;
    private String name;
    private String description;
    private Long timestamp;
}
