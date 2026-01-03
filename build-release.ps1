# Build Release APK Script
# This builds a minified, optimized release APK

Write-Host "`n╔═══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                               ║" -ForegroundColor Cyan
Write-Host "║     🍦 GANESH KULFI - RELEASE BUILD 🍦       ║" -ForegroundColor Cyan
Write-Host "║                                               ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n📦 Building Release APK with:" -ForegroundColor Yellow
Write-Host "   ✅ Code Minification (R8)" -ForegroundColor White
Write-Host "   ✅ Resource Shrinking" -ForegroundColor White
Write-Host "   ✅ Code Obfuscation" -ForegroundColor White
Write-Host "   ✅ Optimizations" -ForegroundColor White
Write-Host ""

$startTime = Get-Date

# Build release APK
Write-Host "🔨 Building..." -ForegroundColor Cyan
.\gradlew.bat assembleRelease

if ($LASTEXITCODE -eq 0) {
    $endTime = Get-Date
    $duration = ($endTime - $startTime).TotalSeconds
    
    Write-Host "`n✅ BUILD SUCCESSFUL in $([math]::Round($duration, 1))s" -ForegroundColor Green
    Write-Host ""
    
    # Get APK info
    $apkPath = "app\build\outputs\apk\release\app-release-unsigned.apk"
    if (Test-Path $apkPath) {
        $apkInfo = Get-Item $apkPath
        $sizeMB = [math]::Round($apkInfo.Length / 1MB, 2)
        
        Write-Host "📱 Release APK Details:" -ForegroundColor Cyan
        Write-Host "   📁 Location: $apkPath" -ForegroundColor White
        Write-Host "   📏 Size: $sizeMB MB" -ForegroundColor White
        Write-Host "   🕐 Built: $($apkInfo.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor White
        Write-Host ""
        
        # Compare with debug size
        $debugPath = "app\build\outputs\apk\debug\app-debug.apk"
        if (Test-Path $debugPath) {
            $debugSize = [math]::Round((Get-Item $debugPath).Length / 1MB, 2)
            $savings = [math]::Round($debugSize - $sizeMB, 2)
            $savingsPercent = [math]::Round(($savings / $debugSize) * 100, 1)
            
            Write-Host "📊 Size Comparison:" -ForegroundColor Cyan
            Write-Host "   Debug APK:   $debugSize MB" -ForegroundColor Yellow
            Write-Host "   Release APK: $sizeMB MB" -ForegroundColor Green
            Write-Host "   Savings:     $savings MB ($savingsPercent%)" -ForegroundColor Green
            Write-Host ""
        }
        
        Write-Host "⚠️  NOTE: This is an UNSIGNED APK" -ForegroundColor Yellow
        Write-Host "   For production, you need to:" -ForegroundColor Yellow
        Write-Host "   1. Generate a keystore" -ForegroundColor White
        Write-Host "   2. Sign the APK" -ForegroundColor White
        Write-Host "   3. Use 'assembleRelease' with signing config" -ForegroundColor White
        Write-Host ""
        
        Write-Host "🚀 You can install this for testing:" -ForegroundColor Cyan
        Write-Host "   adb install $apkPath" -ForegroundColor White
        Write-Host ""
    } else {
        Write-Host "⚠️  APK not found at expected location" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n❌ BUILD FAILED" -ForegroundColor Red
    Write-Host "Check the error messages above" -ForegroundColor Yellow
}

Write-Host "╚═══════════════════════════════════════════════╝`n" -ForegroundColor Cyan
