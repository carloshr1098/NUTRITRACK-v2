package com.nutritrack.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;

import javax.sql.DataSource;

/**
 * Railway Database Configuration
 * Converts Railway's DATABASE_URL format (postgresql://) to JDBC format (jdbc:postgresql://)
 */
@Configuration
@Profile("prod")
public class RailwayDatabaseConfig {

    @Bean
    @Primary
    public DataSource dataSource() {
        // Get DATABASE_URL from environment
        String databaseUrl = System.getenv("DATABASE_URL");
        
        if (databaseUrl == null || databaseUrl.isEmpty()) {
            throw new IllegalStateException("DATABASE_URL environment variable is not set");
        }
        
        // Convert postgresql:// to jdbc:postgresql://
        if (databaseUrl.startsWith("postgresql://")) {
            databaseUrl = "jdbc:" + databaseUrl;
        }
        
        System.out.println("=== RAILWAY DATABASE CONFIG ===");
        System.out.println("Original URL: " + System.getenv("DATABASE_URL"));
        System.out.println("Converted URL: " + databaseUrl);
        System.out.println("===============================");
        
        return DataSourceBuilder
                .create()
                .url(databaseUrl)
                .driverClassName("org.postgresql.Driver")
                .build();
    }
}
