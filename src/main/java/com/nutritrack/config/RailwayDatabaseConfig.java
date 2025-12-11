package com.nutritrack.config;

import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;

import javax.sql.DataSource;
import java.net.URI;
import java.net.URISyntaxException;

/**
 * Railway Database Configuration
 * Converts Railway's DATABASE_URL format to Spring Boot DataSource configuration
 */
@Configuration
@Profile("prod")
public class RailwayDatabaseConfig {

    @Bean
    @Primary
    public DataSource dataSource() {
        String databaseUrl = System.getenv("DATABASE_URL");
        
        if (databaseUrl == null || databaseUrl.isEmpty()) {
            throw new IllegalStateException("DATABASE_URL environment variable is not set");
        }
        
        try {
            // Parse Railway URL: postgresql://username:password@host:port/database
            URI dbUri = new URI(databaseUrl);
            
            String username = null;
            String password = null;
            
            // Extract username and password
            String userInfo = dbUri.getUserInfo();
            if (userInfo != null) {
                String[] credentials = userInfo.split(":");
                username = credentials[0];
                password = credentials.length > 1 ? credentials[1] : null;
            }
            
            // Build JDBC URL without credentials
            String jdbcUrl = "jdbc:postgresql://" + dbUri.getHost() + ":" + dbUri.getPort() + dbUri.getPath();
            
            System.out.println("=== RAILWAY DATABASE CONFIG ===");
            System.out.println("JDBC URL: " + jdbcUrl);
            System.out.println("Username: " + username);
            System.out.println("Password: " + (password != null ? "***" : "null"));
            System.out.println("===============================");
            
            return DataSourceBuilder
                    .create()
                    .url(jdbcUrl)
                    .username(username)
                    .password(password)
                    .driverClassName("org.postgresql.Driver")
                    .build();
                    
        } catch (URISyntaxException e) {
            throw new IllegalStateException("Invalid DATABASE_URL format", e);
        }
    }
}
