package com.ganeshkulfi.backend.plugins

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import io.ktor.server.application.*
import org.flywaydb.core.Flyway
import org.jetbrains.exposed.sql.Database
import javax.sql.DataSource

/**
 * Database Configuration
 * Sets up database connection with HikariCP connection pool
 * and runs Flyway migrations
 * 
 * Database: PostgreSQL 14+
 */
object DatabaseConfig {
    
    fun init(environment: ApplicationEnvironment) {
        val config = environment.config
        
        // Read database config from application.conf
        val host = config.property("database.host").getString()
        val port = config.property("database.port").getString()
        val dbName = config.property("database.name").getString()
        val user = config.property("database.user").getString()
        val password = config.property("database.password").getString()
        val maxPoolSize = config.property("database.maxPoolSize").getString().toInt()
        
        // PostgreSQL connection string
        val jdbcUrl = "jdbc:postgresql://$host:$port/$dbName"
        val driverClass = "org.postgresql.Driver"
        
        // Configure HikariCP connection pool
        val dataSource = createDataSource(jdbcUrl, user, password, maxPoolSize, driverClass)
        
        // Run Flyway migrations - DISABLED (migrations already applied)
        // runMigrations(dataSource)
        
        // Connect Exposed ORM
        Database.connect(dataSource)
        
        environment.log.info("✅ PostgreSQL database connected: $jdbcUrl")
    }
    
    private fun createDataSource(
        jdbcUrl: String,
        user: String,
        password: String,
        maxPoolSize: Int,
        driverClass: String
    ): HikariDataSource {
        val config = HikariConfig().apply {
            this.jdbcUrl = jdbcUrl
            this.username = user
            this.password = password
            this.maximumPoolSize = maxPoolSize
            this.driverClassName = driverClass
            
            // Connection pool settings
            this.connectionTimeout = 30000 // 30 seconds
            this.idleTimeout = 600000 // 10 minutes
            this.maxLifetime = 1800000 // 30 minutes
            
            // Performance tuning
            this.isAutoCommit = false
            this.transactionIsolation = "TRANSACTION_REPEATABLE_READ"
            
            // Pool naming
            this.poolName = "GaneshKulfiHikariPool"
        }
        
        return HikariDataSource(config)
    }
    
    private fun runMigrations(dataSource: DataSource) {
        val flyway = Flyway.configure()
            .dataSource(dataSource)
            .locations("classpath:db/migration")
            .baselineOnMigrate(true)
            .validateOnMigrate(false)  // Allow modified migrations (V2 was updated to match Android app)
            .load()
        
        val migrationInfo = flyway.info()
        val pending = migrationInfo.pending().size
        
        if (pending > 0) {
            flyway.migrate()
        } else {
        }
    }
}
