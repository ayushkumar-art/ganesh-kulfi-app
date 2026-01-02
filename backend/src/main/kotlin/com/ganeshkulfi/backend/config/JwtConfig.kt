package com.ganeshkulfi.backend.config

/**
 * JWT Configuration
 * Hardcoded for development (move to application.conf for production)
 */
object JwtConfig {
    // JWT Settings
    const val SECRET = "kulfi_secret_2025"  // ⚠️ Change in production!
    const val ISSUER = "http://localhost:8080"
    const val AUDIENCE = "kulfi-users"
    const val REALM = "Ganesh Kulfi API"
    const val EXPIRATION_TIME = 604800000L  // 7 days in milliseconds
    
    // Token Claims
    const val CLAIM_USER_ID = "userId"
    const val CLAIM_EMAIL = "email"
    const val CLAIM_ROLE = "role"
}
