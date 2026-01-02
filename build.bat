@echo off
REM ============================================================
REM Kulfi Delight Android App - Build Script
REM ============================================================

echo.
echo ========================================
echo   KULFI DELIGHT - ANDROID BUILD
echo ========================================
echo.

REM Check if running from correct directory
if not exist "app\build.gradle.kts" (
    echo ERROR: Please run this script from the KulfiDelightAndroid directory
    echo Current directory: %CD%
    pause
    exit /b 1
)

REM Check Java installation
echo [1/5] Checking Java installation...
java -version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Java is not installed or not in PATH
    echo Please install JDK 17 or higher from: https://adoptium.net/
    pause
    exit /b 1
)
echo ✓ Java is installed
echo.

REM Check Firebase configuration
echo [2/5] Checking Firebase configuration...
if not exist "app\google-services.json" (
    echo WARNING: google-services.json not found
    echo Please configure Firebase before building
    echo See: BUILD_GUIDE.md for instructions
    pause
)
echo ✓ Firebase configuration found
echo.

REM Display build options
echo [3/5] Select build type:
echo.
echo   1. Debug Build (For Testing)
echo   2. Release Build (For Distribution)
echo   3. Build and Install on Device
echo   4. Clean Project
echo   5. Exit
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto debug
if "%choice%"=="2" goto release
if "%choice%"=="3" goto install
if "%choice%"=="4" goto clean
if "%choice%"=="5" goto end
echo Invalid choice
pause
exit /b 1

:debug
echo.
echo [4/5] Building Debug APK...
echo This may take 3-5 minutes on first build...
echo.
call gradlew.bat assembleDebug
if errorlevel 1 (
    echo.
    echo BUILD FAILED!
    echo Check error messages above
    pause
    exit /b 1
)
echo.
echo [5/5] BUILD SUCCESSFUL!
echo.
echo APK Location: app\build\outputs\apk\debug\app-debug.apk
echo.
echo You can now:
echo - Install on device: adb install app\build\outputs\apk\debug\app-debug.apk
echo - Share the APK file for testing
echo.
goto end

:release
echo.
echo [4/5] Building Release APK...
echo NOTE: Release builds require a signing keystore
echo This may take 3-5 minutes on first build...
echo.
call gradlew.bat assembleRelease
if errorlevel 1 (
    echo.
    echo BUILD FAILED!
    echo.
    echo Common issues:
    echo - Missing signing keystore
    echo - Check BUILD_GUIDE.md for keystore creation
    echo.
    pause
    exit /b 1
)
echo.
echo [5/5] BUILD SUCCESSFUL!
echo.
echo APK Location: app\build\outputs\apk\release\app-release.apk
echo.
goto end

:install
echo.
echo [4/5] Building and Installing on Device...
echo Make sure your device is connected via USB
echo USB debugging must be enabled
echo.
call gradlew.bat installDebug
if errorlevel 1 (
    echo.
    echo INSTALL FAILED!
    echo.
    echo Common issues:
    echo - Device not connected
    echo - USB debugging not enabled
    echo - Device not authorized
    echo.
    echo Try: adb devices
    echo.
    pause
    exit /b 1
)
echo.
echo [5/5] INSTALL SUCCESSFUL!
echo.
echo The app should now be installed on your device
echo Look for "Kulfi Delight" icon
echo.
goto end

:clean
echo.
echo [4/5] Cleaning project...
call gradlew.bat clean
if errorlevel 1 (
    echo CLEAN FAILED!
    pause
    exit /b 1
)
echo.
echo [5/5] CLEAN SUCCESSFUL!
echo All build artifacts have been removed
echo.
goto end

:end
echo.
echo ========================================
echo Thank you for using Kulfi Delight Build Script!
echo For more options, see BUILD_GUIDE.md
echo ========================================
echo.
pause
