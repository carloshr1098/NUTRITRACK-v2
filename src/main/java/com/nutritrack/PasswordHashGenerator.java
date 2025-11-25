package com.nutritrack;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordHashGenerator {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        String admin123 = encoder.encode("admin123");
        String nutri123 = encoder.encode("nutri123");
        String paciente123 = encoder.encode("paciente123");
        
        System.out.println("admin123: " + admin123);
        System.out.println("nutri123: " + nutri123);
        System.out.println("paciente123: " + paciente123);
    }
}
