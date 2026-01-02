# 🔨 Building the Kulfi Delight Android App

## Prerequisites

Before building, ensure you have:

- ✅ **Android Studio** - Hedgehog (2023.1.1) or later
- ✅ **JDK 17** - Java Development Kit
- ✅ **Firebase Configuration** - `google-services.json` properly configured
- ✅ **Internet Connection** - For downloading Gradle and dependencies

## Build Methods

### Method 1: Build with Android Studio (Recommended) ⭐

This is the **easiest and most reliable** method.

#### Steps:

1. **Open Project**
   ```
   Open Android Studio → File → Open
   Navigate to: e:\Ganesh Kulfi web\Ganesh Kulfi\android\KulfiDelightAndroid
   Click OK
   ```

2. **Wait for Gradle Sync**
   - Android Studio will automatically download Gradle
   - It will sync all dependencies (2-5 minutes first time)
   - Status bar will show progress

3. **Configure Firebase** (If not done)
   - Replace `app/google-services.json` with your Firebase config
   - Ensure package name is `com.ganeshkulfi.app`

4. **Build the App**
   
   **Option A: Debug Build (For Testing)**
   ```
   Build → Make Project (Ctrl+F9)
   OR
   Build → Build Bundle(s)/APK(s) → Build APK(s)
   ```
   
   **Option B: Release Build (For Distribution)**
   ```
   Build → Generate Signed Bundle/APK
   → Select APK → Next
   → Create new or use existing keystore
   → Fill in key information → Next → Finish
   ```

5. **Run on Device/Emulator**
   ```
   Click Run button (▶️) or press Shift+F10
   Select target device
   Wait for installation
   ```

#### Build Outputs:
- **Debug APK**: `app/build/outputs/apk/debug/app-debug.apk`
- **Release APK**: `app/build/outputs/apk/release/app-release.apk`

---

### Method 2: Build with Gradle Command Line

Use this if you want to build without opening Android Studio.

#### Prerequisites:
```powershell
# Verify Java is installed
java -version
# Should show: java version "17.x.x"

# If not installed, download from:
# https://adoptium.net/temurin/releases/
```

#### Build Commands:

```powershell
# Navigate to project
cd "e:\Ganesh Kulfi web\Ganesh Kulfi\android\KulfiDelightAndroid"

# Make gradlew executable (first time only)
# On Windows, this is automatic

# Build Debug APK
.\gradlew.bat assembleDebug

# Build Release APK (unsigned)
.\gradlew.bat assembleRelease

# Build and install on connected device
.\gradlew.bat installDebug

# Clean build
.\gradlew.bat clean

# Run tests
.\gradlew.bat test
```

#### Build Outputs:
- Debug: `app\build\outputs\apk\debug\app-debug.apk`
- Release: `app\build\outputs\apk\release\app-release.apk`

---

### Method 3: CI/CD Build (GitHub Actions)

For automated builds, you can use this GitHub Actions workflow.

Create `.github/workflows/android-build.yml`:

```yaml
name: Android Build

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
    
    - name: Grant execute permission for gradlew
      run: chmod +x android/KulfiDelightAndroid/gradlew
    
    - name: Build with Gradle
      run: |
        cd android/KulfiDelightAndroid
        ./gradlew assembleDebug
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: app-debug
        path: android/KulfiDelightAndroid/app/build/outputs/apk/debug/app-debug.apk
```

---

## Build Configurations

### Debug Build
- **Purpose**: Development and testing
- **Features**: 
  - Includes debugging symbols
  - Larger APK size (~20-25 MB)
  - Not optimized
  - Can be installed alongside release builds
- **Signing**: Uses debug keystore (auto-generated)

### Release Build
- **Purpose**: Production distribution
- **Features**:
  - Optimized and minified
  - ProGuard enabled
  - Smaller APK size (~15-18 MB)
  - Requires signing with release keystore
- **Signing**: Requires manual keystore creation

---

## Creating a Release Keystore

For release builds, you need to create a signing keystore:

```powershell
# Generate keystore
keytool -genkey -v -keystore kulfi-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias kulfi

# You'll be prompted for:
# - Keystore password
# - Key password
# - Organization details
```

### Configure Signing in build.gradle.kts

Add to `app/build.gradle.kts`:

```kotlin
android {
    signingConfigs {
        create("release") {
            storeFile = file("../kulfi-release-key.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD") ?: "your-password"
            keyAlias = "kulfi"
            keyPassword = System.getenv("KEY_PASSWORD") ?: "your-password"
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // ... existing config
        }
    }
}
```

**⚠️ Security Note**: Never commit keystore files or passwords to Git!

---

## Build Variants

The app has multiple build variants:

```kotlin
debug {
    applicationIdSuffix = ".debug"
    debuggable = true
}

release {
    minifyEnabled = true
    shrinkResources = true
    proguardFiles(...)
}
```

### Available Variants:
- `debug` - Development build
- `release` - Production build

### Build Specific Variant:
```powershell
.\gradlew.bat assembleDebug
.\gradlew.bat assembleRelease
```

---

## Troubleshooting

### Problem: Gradle Sync Failed

**Solution 1**: Check Java version
```powershell
java -version
# Must be 17 or higher
```

**Solution 2**: Clear Gradle cache
```powershell
cd "e:\Ganesh Kulfi web\Ganesh Kulfi\android\KulfiDelightAndroid"
.\gradlew.bat clean
Remove-Item -Recurse -Force .gradle
```

**Solution 3**: In Android Studio
```
File → Invalidate Caches → Invalidate and Restart
```

### Problem: Build Failed - Missing google-services.json

**Error**: `File google-services.json is missing`

**Solution**:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Add Android app: `com.ganeshkulfi.app`
3. Download `google-services.json`
4. Place in `app/` folder

### Problem: Out of Memory

**Error**: `OutOfMemoryError: Java heap space`

**Solution**: Edit `gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxMetaspaceSize=512m
```

### Problem: Compilation Failed

**Error**: Various compilation errors

**Solution**:
```powershell
# Clean and rebuild
.\gradlew.bat clean build --refresh-dependencies
```

### Problem: Firebase Not Working

**Error**: Authentication or Firestore errors

**Solution**:
1. Verify `google-services.json` is correct
2. Check package name matches: `com.ganeshkulfi.app`
3. Enable services in Firebase Console:
   - Authentication → Email/Password
   - Firestore Database
4. Add SHA-1 fingerprint (for Google Sign-in if needed):
```powershell
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

---

## Build Optimization

### Reduce Build Time

1. **Enable Gradle Daemon** (in `gradle.properties`):
```properties
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
```

2. **Use Build Cache**:
```properties
android.enableBuildCache=true
```

3. **Increase Heap Size**:
```properties
org.gradle.jvmargs=-Xmx4096m
```

### Reduce APK Size

1. **Enable Shrinking** (already configured):
```kotlin
minifyEnabled = true
shrinkResources = true
```

2. **Use APK Splits** (for different architectures):
```kotlin
splits {
    abi {
        enable = true
        reset()
        include("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
        universalApk = false
    }
}
```

3. **Use Android App Bundle (.aab)**:
```powershell
.\gradlew.bat bundleRelease
```

---

## Build Outputs Explained

### Debug APK
```
app/build/outputs/apk/debug/app-debug.apk
```
- Size: ~20-25 MB
- Debuggable: Yes
- Optimized: No
- Install alongside release: Yes

### Release APK
```
app/build/outputs/apk/release/app-release.apk
```
- Size: ~15-18 MB
- Debuggable: No
- Optimized: Yes (ProGuard)
- Install alongside debug: No

### Android App Bundle (AAB)
```
app/build/outputs/bundle/release/app-release.aab
```
- For Google Play Store
- Smaller download size (dynamic delivery)
- Automatically optimized per device

---

## Next Steps After Building

### 1. Install APK on Device

**Method A**: ADB (Android Debug Bridge)
```powershell
# Connect device via USB
adb devices

# Install APK
adb install app/build/outputs/apk/debug/app-debug.apk

# Uninstall
adb uninstall com.ganeshkulfi.app
```

**Method B**: Transfer and Install
1. Copy APK to phone
2. Enable "Install from unknown sources"
3. Tap APK file to install

### 2. Test the App

- Create test account
- Browse flavors
- Test authentication
- Check multi-language support
- Verify Firebase integration

### 3. Prepare for Release

- [ ] Test thoroughly on multiple devices
- [ ] Create release keystore
- [ ] Build signed release APK/AAB
- [ ] Test release build
- [ ] Create Play Store listing
- [ ] Add screenshots and description
- [ ] Submit for review

---

## Continuous Integration

For automated builds on every commit:

### Using GitHub Actions
See Method 3 above for workflow configuration.

### Using GitLab CI
Create `.gitlab-ci.yml`:

```yaml
build:
  image: circleci/android:api-34
  stage: build
  script:
    - cd android/KulfiDelightAndroid
    - chmod +x gradlew
    - ./gradlew assembleDebug
  artifacts:
    paths:
      - android/KulfiDelightAndroid/app/build/outputs/apk/debug/
```

---

## Build Time Estimates

| Build Type | First Build | Subsequent Builds |
|------------|-------------|-------------------|
| Clean Build | 3-5 minutes | 2-3 minutes |
| Incremental | - | 30-60 seconds |
| With Cache | 2-3 minutes | 20-40 seconds |

*Times vary based on machine specs and internet speed*

---

## Quick Reference

```powershell
# Navigate to project
cd "e:\Ganesh Kulfi web\Ganesh Kulfi\android\KulfiDelightAndroid"

# Build debug APK
.\gradlew.bat assembleDebug

# Build release APK
.\gradlew.bat assembleRelease

# Install on device
.\gradlew.bat installDebug

# Clean
.\gradlew.bat clean

# Build and test
.\gradlew.bat build

# Check dependencies
.\gradlew.bat dependencies
```

---

## Support

If you encounter issues:

1. Check this guide first
2. Review error messages in Logcat (Android Studio)
3. Check [Stack Overflow](https://stackoverflow.com/questions/tagged/android)
4. Consult [Android Developer Documentation](https://developer.android.com/)

---

**Happy Building! 🚀**

*Last Updated: November 4, 2025*
