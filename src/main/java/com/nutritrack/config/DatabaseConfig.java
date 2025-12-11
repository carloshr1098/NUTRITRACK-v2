package com.nutritrack.config;

import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

import javax.sql.DataSource;

/**
 * Database configuration for Railway deployment
 * Converts Railway's DATABASE_URL format to Spring Boot format
 */
@Configuration
@Profile("prod")
public class DatabaseConfig {

    @Bean
    public DataSource dataSource() {
        String databaseUrl = System.getenv("DATABASE_URL");
        
        if (databaseUrl == null || databaseUrl.isEmpty()) {
            throw new IllegalStateException("DATABASE_URL environment variable is not set");
        }
        
        // Railway provides: postgresql://user:password@host:port/database
        // Spring Boot needs: jdbc:postgresql://host:port/database
        // And separate username/password
        
        String jdbcUrl;
        String username = null;
        String password = null;
        
        if (databaseUrl.startsWith("postgresql://")) {
            // Parse the URL to extract components
            String urlWithoutPrefix = databaseUrl.substring("postgresql://".length());
            
            // Extract username and password
            int atIndex = urlWithoutPrefix.indexOf('@');
            if (atIndex > 0) {
                String credentials = urlWithoutPrefix.substring(0, atIndex);
                String hostAndDb = urlWithoutPrefix.substring(atIndex + 1);
                
                int colonIndex = credentials.indexOf(':');
                if (colonIndex > 0) {
                    username = credentials.substring(0, colonIndex);
                    password = credentials.substring(colonIndex + 1);
                }
                
                jdbcUrl = "jdbc:postgresql://" + hostAndDb;
            } else {
                jdbcUrl = "jdbc:" + databaseUrl;
            }
        } else if (databaseUrl.startsWith("jdbc:postgresql://")) {
            jdbcUrl = databaseUrl;
        } else {
            throw new IllegalStateException("Invalid DATABASE_URL format: " + databaseUrl);
        }
        
        System.out.println("=== DATABASE CONNECTION INFO ===");
        System.out.println("JDBC URL: " + jdbcUrl);
        System.out.println("Username: " + username);
        System.out.println("Password: " + (password != null ? "***" : "null"));
        System.out.println("================================");
        
        return DataSourceBuilder
                .create()
                .url(jdbcUrl)
                .username(username)
                .password(password)
                .driverClassName("org.postgresql.Driver")
                .build();
    }
}
