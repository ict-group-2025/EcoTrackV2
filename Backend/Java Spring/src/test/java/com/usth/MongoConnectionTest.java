package com.usth;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class MongoConnectionTest {

    @Test
    public void testMongoConnection() {
        String uri = "mongodb+srv://admin:22ba13206@cluster0.aah4xok.mongodb.net/?appName=Cluster0";
        
        try (MongoClient mongoClient = MongoClients.create(uri)) {
            MongoDatabase database = mongoClient.getDatabase("test");
            
            // Test connection by getting database name
            String dbName = database.getName();
            System.out.println("Connected to database: " + dbName);
            
            // List collections to verify connection
            for (String collectionName : database.listCollectionNames()) {
                System.out.println("Found collection: " + collectionName);
            }
            
            System.out.println("MongoDB connection test successful!");
            
        } catch (Exception e) {
            System.err.println("MongoDB connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
