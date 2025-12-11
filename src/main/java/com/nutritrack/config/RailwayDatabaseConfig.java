package com.nutritrack.config;

import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.ConfigurationProperties;
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
    @ConfigurationProperties("spring.datasource")
    public DataSourceProperties dataSourceProperties() {
        DataSourceProperties properties = new DataSourceProperties();
        
        // Get DATABASE_URL from environment
        String databaseUrl = System.getenv("DATABASE_URL");
        
        if (databaseUrl != null && !databaseUrl.isEmpty()) {
            // Convert postgresql:// to jdbc:postgresql://
            if (databaseUrl.startsWith("postgresql://")) {
                databaseUrl = "jdbc:" + databaseUrl;
            }
            
            System.out.println("=== RAILWAY DATABASE CONFIG ===");
            System.out.println("Original URL: " + System.getenv("DATABASE_URL"));
            System.out.println("Converted URL: " + databaseUrl);
            System.out.println("===============================");
            
            properties.setUrl(databaseUrl);
            properties.setDriverClassName("org.postgresql.Driver");
        }
        
        return properties;
    }

    @Bean
    @Primary
    public DataSource dataSource(DataSourceProperties properties) {
        return properties.initializeDataSourceBuilder().build();
    }
}
