package com.ganeshkulfi.backend.services

import com.ganeshkulfi.backend.data.dto.*
import com.ganeshkulfi.backend.data.models.RetailerTier
import com.ganeshkulfi.backend.data.models.User
import com.ganeshkulfi.backend.data.models.UserRole
import com.ganeshkulfi.backend.data.repository.UserRepository

/**
 * User Service
 * Business logic for user management and authentication
 */
class UserService(
    private val userRepository: UserRepository,
    private val passwordService: PasswordService,
    private val jwtService: JWTService
) {
    
    /**
     * Register a new user
     */
    fun register(request: RegisterRequest): Result<AuthResponse> {
        // Validate password strength
        val passwordValidation = passwordService.validatePasswordStrength(request.password)
        if (!passwordValidation.isValid) {
            return Result.failure(IllegalArgumentException(passwordValidation.message))
        }
        
        // Check if email already exists
        if (userRepository.emailExists(request.email)) {
            return Result.failure(IllegalArgumentException("Email already registered"))
        }
        
        // Hash password
        val passwordHash = passwordService.hashPassword(request.password)
        
        // Convert role string to enum
        val userRole = try {
            UserRole.valueOf(request.role.uppercase())
        } catch (e: IllegalArgumentException) {
            UserRole.CUSTOMER  // Default to CUSTOMER if invalid role
        }
        
        // Create user
        val user = userRepository.create(
            email = request.email,
            passwordHash = passwordHash,
            name = request.name,
            phone = request.phone,
            role = userRole
        ) ?: return Result.failure(IllegalStateException("Failed to create user"))
        
        // Generate JWT token
        val token = jwtService.generateToken(user.id, user.email, user.role)
        
        return Result.success(
            AuthResponse(
                token = token,
                user = UserResponse.fromUser(user)
            )
        )
    }
    
    /**
     * Login user
     * PASSWORD VERIFICATION DISABLED - Login with email only
     * Users can update their password after logging in
     */
    fun login(request: LoginRequest): Result<AuthResponse> {
        // Find user by email
        val user = userRepository.findByEmail(request.email)
            ?: return Result.failure(IllegalArgumentException("User not found with email: ${request.email}"))
        
        // PASSWORD VERIFICATION DISABLED FOR TESTING
        // Uncomment below to re-enable password verification:
        // if (!passwordService.verifyPassword(request.password, user.passwordHash)) {
        //     return Result.failure(IllegalArgumentException("Invalid email or password"))
        // }
        
        // Generate JWT token
        val token = jwtService.generateToken(user.id, user.email, user.role)
        
        return Result.success(
            AuthResponse(
                token = token,
                user = UserResponse.fromUser(user)
            )
        )
    }
    
    /**
     * Get current user by ID
     */
    fun getCurrentUser(userId: String): Result<UserResponse> {
        val user = userRepository.findById(userId)
            ?: return Result.failure(IllegalArgumentException("User not found"))
        
        return Result.success(UserResponse.fromUser(user))
    }
    
    /**
     * Create a new user (admin only)
     */
    fun createUser(request: CreateUserRequest): Result<UserResponse> {
        // Validate password strength
        val passwordValidation = passwordService.validatePasswordStrength(request.password)
        if (!passwordValidation.isValid) {
            return Result.failure(IllegalArgumentException(passwordValidation.message))
        }
        
        // Check if email already exists
        if (userRepository.emailExists(request.email)) {
            return Result.failure(IllegalArgumentException("Email already registered"))
        }
        
        // Check if retailer ID already exists (if provided)
        if (request.retailerId != null && userRepository.retailerIdExists(request.retailerId)) {
            return Result.failure(IllegalArgumentException("Retailer ID already exists"))
        }
        
        // Hash password
        val passwordHash = passwordService.hashPassword(request.password)
        
        // Convert role string to enum
        val userRole = try {
            UserRole.valueOf(request.role.uppercase())
        } catch (e: IllegalArgumentException) {
            return Result.failure(IllegalArgumentException("Invalid role: ${request.role}"))
        }
        
        // Convert tier string to RetailerTier if provided (Day 9)
        val retailerTier = request.tier?.let {
            RetailerTier.fromString(it) ?: return Result.failure(
                IllegalArgumentException("Invalid tier: $it. Must be BASIC, SILVER, GOLD, or PLATINUM")
            )
        }?.name ?: "BASIC"
        
        // Auto-generate retailerId for RETAILER role if not provided
        val finalRetailerId = if (userRole == UserRole.RETAILER && request.retailerId.isNullOrBlank()) {
            val generated = "ret_${System.currentTimeMillis()}"
            println("🔧 Auto-generated retailerId: $generated for ${request.email}")
            generated
        } else {
            println("🔧 Using provided retailerId: ${request.retailerId} for ${request.email}")
            request.retailerId
        }
        
        // Create user
        val user = userRepository.create(
            email = request.email,
            passwordHash = passwordHash,
            name = request.name,
            phone = request.phone,
            role = userRole,
            retailerId = finalRetailerId,
            shopName = request.shopName,
            tier = retailerTier
        ) ?: return Result.failure(IllegalStateException("Failed to create user"))
        
        return Result.success(UserResponse.fromUser(user))
    }
    
    /**
     * Update user
     */
    fun updateUser(userId: String, request: UpdateUserRequest): Result<UserResponse> {
        // Check if user exists
        val existingUser = userRepository.findById(userId)
            ?: return Result.failure(IllegalArgumentException("User not found"))
        
        // Build updates map
        val updates = mutableMapOf<String, Any?>()
        
        request.name?.let { updates["name"] = it }
        request.phone?.let { updates["phone"] = it }
        
        // Convert role string to enum if provided
        request.role?.let { roleStr ->
            val userRole = try {
                UserRole.valueOf(roleStr.uppercase())
            } catch (e: IllegalArgumentException) {
                return Result.failure(IllegalArgumentException("Invalid role: $roleStr"))
            }
            updates["role"] = userRole
        }
        
        request.retailerId?.let { 
            // Check if retailer ID already exists
            if (it != existingUser.retailerId && userRepository.retailerIdExists(it)) {
                return Result.failure(IllegalArgumentException("Retailer ID already exists"))
            }
            updates["retailerId"] = it
        }
        request.shopName?.let { updates["shopName"] = it }
        
        // Convert tier string to RetailerTier if provided (Day 9)
        request.tier?.let { tierStr ->
            val retailerTier = RetailerTier.fromString(tierStr)
                ?: return Result.failure(IllegalArgumentException("Invalid tier: $tierStr. Must be BASIC, SILVER, GOLD, or PLATINUM"))
            updates["tier"] = retailerTier.name
        }
        
        // Update user
        val updatedUser = userRepository.update(userId, updates)
            ?: return Result.failure(IllegalStateException("Failed to update user"))
        
        return Result.success(UserResponse.fromUser(updatedUser))
    }
    
    /**
     * Delete user
     */
    fun deleteUser(userId: String): Result<Unit> {
        val deleted = userRepository.delete(userId)
        return if (deleted) {
            Result.success(Unit)
        } else {
            Result.failure(IllegalArgumentException("User not found"))
        }
    }
    
    /**
     * Get all users
     */
    fun getAllUsers(): Result<List<UserResponse>> {
        val users = userRepository.findAll()
        return Result.success(users.map { UserResponse.fromUser(it) })
    }
    
    /**
     * Get users by role
     */
    fun getUsersByRole(role: UserRole): Result<List<UserResponse>> {
        val users = userRepository.findByRole(role)
        return Result.success(users.map { UserResponse.fromUser(it) })
    }
    
}
