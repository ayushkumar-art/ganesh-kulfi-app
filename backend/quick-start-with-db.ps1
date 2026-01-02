# Quick Start with Database Credentials
# Uses ganeshkulfi_user/kulfi@123

Write-Host "🚀 Starting Ganesh Kulfi Backend" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$dbHost = "localhost"
$dbPort = "5432"
$dbName = "ganeshkulfi_db"
$dbUser = "ganeshkulfi_user"
$dbPassword = "kulfi@123"

Write-Host "📝 Configuration:" -ForegroundColor Yellow
Write-Host "   Database: $dbName" -ForegroundColor Gray
Write-Host "   User: $dbUser" -ForegroundColor Gray
Write-Host ""

# Generate JWT secret
$jwtSecret = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | % {[char]$_})

# Create .env
$envContent = @"
DB_URL=jdbc:postgresql://${dbHost}:${dbPort}/${dbName}
DB_USER=$dbUser
DB_PASSWORD=$dbPassword
DB_POOL_SIZE=10
JWT_SECRET=$jwtSecret
JWT_ISSUER=ganeshkulfi
JWT_AUDIENCE=ganeshkulfi-app
APP_PORT=8080
UPLOADS_DIR=./uploads
"@

$envContent | Out-File -FilePath ".env" -Encoding UTF8 -NoNewline
Write-Host "✅ Configuration file created" -ForegroundColor Green

# Create uploads directory
if (-not (Test-Path "uploads")) {
    New-Item -ItemType Directory -Path "uploads" | Out-Null
}

# Set environment variables
$env:DB_URL = "jdbc:postgresql://${dbHost}:${dbPort}/${dbName}"
$env:DB_USER = $dbUser
$env:DB_PASSWORD = $dbPassword
$env:DB_POOL_SIZE = "10"
$env:JWT_SECRET = $jwtSecret
$env:JWT_ISSUER = "ganeshkulfi"
$env:JWT_AUDIENCE = "ganeshkulfi-app"
$env:APP_PORT = "8080"
$env:UPLOADS_DIR = "./uploads"

Write-Host ""
Write-Host "🚀 Starting backend server..." -ForegroundColor Cyan
Write-Host "   Web UI: http://localhost:8080" -ForegroundColor Yellow
Write-Host "   Health: http://localhost:8080/health" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press Ctrl+C to stop" -ForegroundColor Gray
Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Start the backend
java -Xms256m -Xmx512m -XX:+UseG1GC -jar build\libs\ganeshkulfi-backend-all.jar
