package com.nutritrack.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/api/test")
public class TestController {

    @GetMapping("/public")
    public ResponseEntity<?> publicEndpoint() {
        return ResponseEntity.ok("Public endpoint working!");
    }

    @PostMapping("/login-test")
    public ResponseEntity<?> testLogin(@RequestBody String body) {
        return ResponseEntity.ok("Received: " + body);
    }
}