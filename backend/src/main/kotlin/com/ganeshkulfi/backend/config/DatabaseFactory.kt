package com.ganeshkulfi.backend.config

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import org.jetbrains.exposed.sql.Database
import org.slf4j.LoggerFactory

/**
 * Day 14: Database Factory with HikariCP Connection Pool
 * Production-ready database configuration
 */
object DatabaseFactory {
    
    private val logger = LoggerFactory.getLogger(DatabaseFactory::class.java)
    
    fun init() {
        val dbUrl = System.getenv("DB_URL") 
            ?: "jdbc:postgresql://localhost:5432/ganeshkulfi_db"
        val dbUser = System.getenv("DB_USER") 
            ?: "ganeshkulfi_user"
        val dbPassword = System.getenv("DB_PASSWORD") 
            ?: "Ganesh@123"
        val poolSize = System.getenv("DB_POOL_SIZE")?.toIntOrNull() 
            ?: 10
        
        logger.info("🔧 Initializing database connection pool...")
        logger.info("📍 Database URL: $dbUrl")
        logger.info("👤 Database User: $dbUser")
        logger.info("🏊 Pool Size: $poolSize")
        
        val config = HikariConfig().apply {
            jdbcUrl = dbUrl
            username = dbUser
            password = dbPassword
            maximumPoolSize = poolSize
            driverClassName = "org.postgresql.Driver"
            isAutoCommit = false
            transactionIsolation = "TRANSACTION_REPEATABLE_READ"
            
            // Connection pool settings
            connectionTimeout = 30000 // 30 seconds
            idleTimeout = 600000 // 10 minutes
            maxLifetime = 1800000 // 30 minutes
            
            // Performance optimizations
            addDataSourceProperty("cachePrepStmts", "true")
            addDataSourceProperty("prepStmtCacheSize", "250")
            addDataSourceProperty("prepStmtCacheSqlLimit", "2048")
        }
        
        try {
            val dataSource = HikariDataSource(config)
            Database.connect(dataSource)
            logger.info("✅ Database connection pool initialized successfully")
        } catch (e: Exception) {
            logger.error("❌ Failed to initialize database connection pool", e)
            throw e
        }
    }
}
