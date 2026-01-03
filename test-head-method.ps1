Write-Host "`n🧪 Testing HEAD Method Support" -ForegroundColor Cyan
Write-Host "================================`n" -ForegroundColor Cyan

# Test GET
Write-Host "1️⃣ Testing GET method:" -ForegroundColor Yellow
try {
    $getResp = Invoke-RestMethod "https://ganesh-kulfi-backend.onrender.com/api/health" -Method Get
    Write-Host "   ✅ GET works! Status: $($getResp.status)" -ForegroundColor Green
} catch {
    Write-Host "   ❌ GET failed: $($_.Exception.Response.StatusCode.Value__)" -ForegroundColor Red
}

Write-Host ""

# Test HEAD
Write-Host "2️⃣ Testing HEAD method:" -ForegroundColor Yellow
try {
    $headResp = Invoke-WebRequest "https://ganesh-kulfi-backend.onrender.com/api/health" -Method Head
    Write-Host "   ✅ HEAD works! Status: $($headResp.StatusCode)" -ForegroundColor Green
    Write-Host ""
    Write-Host "🎉 SUCCESS! UptimeRobot FREE plan will work!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📌 Setup UptimeRobot:" -ForegroundColor Cyan
    Write-Host "   • URL: https://ganesh-kulfi-backend.onrender.com/api/health" -ForegroundColor White
    Write-Host "   • Method: HEAD (default on free plan)" -ForegroundColor White
    Write-Host "   • Interval: 5 minutes" -ForegroundColor White
} catch {
    Write-Host "   ❌ HEAD failed: $($_.Exception.Response.StatusCode.Value__)" -ForegroundColor Red
    Write-Host "   ⚠️  Make sure deployment finished on Render" -ForegroundColor Yellow
}
