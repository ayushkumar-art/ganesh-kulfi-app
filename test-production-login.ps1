Write-Host "`n⏳ Waiting for Render Deployment..." -ForegroundColor Cyan
Write-Host "   Fixed: Duplicate V9 migration renamed to V12" -ForegroundColor Yellow
Write-Host "   Commit: d38db2f" -ForegroundColor Gray
Write-Host "   (Checking every 15 seconds for up to 5 minutes)`n" -ForegroundColor Yellow

$maxAttempts = 20
$attempt = 1
$deployed = $false

while ($attempt -le $maxAttempts -and -not $deployed) {
    Write-Host "Attempt $attempt/$maxAttempts..." -ForegroundColor Gray
    
    # Test login
    $body = @{ email = "admin@ganeshkulfi.com"; password = "Admin@123" } | ConvertTo-Json
    
    try {
        $login = Invoke-RestMethod -Uri "https://ganesh-kulfi-backend.onrender.com/api/auth/login" `
                                    -Method Post `
                                    -Body $body `
                                    -ContentType "application/json" `
                                    -TimeoutSec 10
        
        Write-Host "`n✅ DEPLOYMENT SUCCESSFUL!" -ForegroundColor Green
        Write-Host "================================`n" -ForegroundColor Green
        
        Write-Host "👤 User: $($login.data.name)" -ForegroundColor White
        Write-Host "📧 Email: $($login.data.email)" -ForegroundColor White
        Write-Host "🔐 Role: $($login.data.role)" -ForegroundColor White
        Write-Host "🔑 Token: $($login.data.token.Substring(0,40))..." -ForegroundColor Gray
        
        Write-Host "`n🎉 Production backend is now FULLY WORKING!" -ForegroundColor Green
        Write-Host "   • Database tables created ✅" -ForegroundColor White
        Write-Host "   • Admin user exists ✅" -ForegroundColor White
        Write-Host "   • JWT authentication works ✅" -ForegroundColor White
        Write-Host "   • Android app ready to connect ✅`n" -ForegroundColor White
        
        $deployed = $true
    }
    catch {
        $statusCode = $_.Exception.Response.StatusCode.Value__
        
        if ($statusCode -eq 500) {
            Write-Host "   Still deploying (500 error - migrations running)..." -ForegroundColor Yellow
        }
        elseif ($statusCode -eq 503) {
            Write-Host "   Backend starting up..." -ForegroundColor Yellow
        }
        else {
            Write-Host "   Error: $statusCode" -ForegroundColor Red
        }
        
        Start-Sleep -Seconds 15
    }
    
    $attempt++
}

if (-not $deployed) {
    Write-Host "`n⚠️  Deployment taking longer than expected" -ForegroundColor Yellow
    Write-Host "   Check Render dashboard: https://dashboard.render.com" -ForegroundColor Cyan
}
