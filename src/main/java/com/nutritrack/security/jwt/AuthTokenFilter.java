package com.nutritrack.security.jwt;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

public class AuthTokenFilter extends OncePerRequestFilter {
    @Autowired
    private JwtUtils jwtUtils;

    @Autowired
    private UserDetailsService userDetailsService;

    private static final Logger logger = LoggerFactory.getLogger(AuthTokenFilter.class);

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, 
                                  FilterChain filterChain) throws ServletException, IOException {
        // Skip JWT validation for public auth endpoints only
        String path = request.getRequestURI();
        String method = request.getMethod();
        
        logger.debug("Processing request: {} {}", method, path);
        
        // Only skip JWT for public auth endpoints (signin, signup, test, etc.)
        // Profile endpoint requires authentication
        boolean isPublicAuthEndpoint = path.equals("/api/auth/signin") 
                || path.equals("/api/auth/signup")
                || path.equals("/api/auth/test")
                || path.equals("/api/auth/debug-users")
                || path.equals("/api/auth/init-data");
        
        if (isPublicAuthEndpoint || path.startsWith("/h2-console")) {
            filterChain.doFilter(request, response);
            return;
        }
            
        try {
            String jwt = parseJwt(request);
            logger.debug("Path: {}, Method: {}, JWT: {}", path, method, jwt != null ? "Present" : "Absent");
            
            if (jwt != null && jwtUtils.validateJwtToken(jwt)) {
                String username = jwtUtils.getUserNameFromJwtToken(jwt);
                logger.debug("JWT valid, username: {}", username);

                UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                UsernamePasswordAuthenticationToken authentication = 
                        new UsernamePasswordAuthenticationToken(userDetails, null,
                                                              userDetails.getAuthorities());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                SecurityContextHolder.getContext().setAuthentication(authentication);
                logger.debug("Authentication set for user: {} with authorities: {}", username, userDetails.getAuthorities());
            } else {
                logger.warn("JWT validation failed or JWT is null for {} {}", method, path);
            }
        } catch (Exception e) {
            logger.error("Cannot set user authentication for {} {}: {}", method, path, e.getMessage());
        }

        filterChain.doFilter(request, response);
    }

    private String parseJwt(HttpServletRequest request) {
        String headerAuth = request.getHeader("Authorization");

        if (StringUtils.hasText(headerAuth) && headerAuth.startsWith("Bearer ")) {
            return headerAuth.substring(7);
        }

        return null;
    }
}