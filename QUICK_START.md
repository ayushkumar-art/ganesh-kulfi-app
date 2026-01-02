# 🚀 Quick Start Guide - Kulfi Delight Android App

## ⚡ 5-Minute Setup

### Prerequisites Check
- [ ] Android Studio installed (Hedgehog or later)
- [ ] JDK 17 installed
- [ ] Firebase project access (kulfi-delight-3d)

### Step-by-Step Setup

#### 1. Open Project (30 seconds)
```powershell
# Navigate to the Android project
cd "e:\Ganesh Kulfi web\Ganesh Kulfi\android\KulfiDelightAndroid"

# Open in Android Studio
# Double-click on the folder or use File > Open in Android Studio
```

#### 2. Configure Firebase (2 minutes)

**Option A: Use Existing Config** (Quickest)
The project already has a template `google-services.json`. You just need to update it with your Android app ID:

1. Open Firebase Console: https://console.firebase.google.com/
2. Go to Project Settings → Your Apps
3. Click "Add App" → Android
4. Enter package name: `com.ganeshkulfi.app`
5. Download the new `google-services.json`
6. Replace: `app/google-services.json` with your downloaded file

**Option B: Manual Update**
Edit `app/google-services.json` and update the `mobilesdk_app_id`:
```json
"mobilesdk_app_id": "1:507505123370:android:YOUR_APP_ID_HERE"
```

#### 3. Sync Gradle (1 minute)
Android Studio will automatically start Gradle sync. If not:
- Click: **File → Sync Project with Gradle Files**
- Wait for completion (may take 1-2 minutes)

#### 4. Run the App (1 minute)
1. Click the **Run** button (▶️) or press `Shift + F10`
2. Select a device:
   - **Physical Device**: Enable USB debugging and connect
   - **Emulator**: Create one via Device Manager if needed
3. Wait for build and installation

### ✅ Verification

If everything works, you should see:
1. Splash screen with "Kulfi Delight"
2. Login screen
3. Ability to create account
4. Home screen with kulfi flavors

## 🔧 Common Issues

### Issue: Gradle Sync Failed
**Solution**:
```powershell
# Clear Gradle cache
./gradlew clean

# Or in Android Studio:
# File → Invalidate Caches → Invalidate and Restart
```

### Issue: Firebase Authentication Error
**Solution**:
1. Go to Firebase Console
2. Authentication → Sign-in method
3. Enable "Email/Password"
4. Save

### Issue: App Crashes on Startup
**Solution**:
- Check Logcat in Android Studio (View → Tool Windows → Logcat)
- Common cause: Missing `google-services.json` or wrong package name

## 📱 Test Accounts

Create a test account or use:
- Email: `test@ganeshkulfi.com`
- Password: `Test@123`
(You'll need to create this in Firebase Authentication)

## 🎨 Customization Quick Tips

### Change App Name
Edit: `app/src/main/res/values/strings.xml`
```xml
<string name="app_name">Your New Name</string>
```

### Change Theme Colors
Edit: `app/src/main/java/com/ganeshkulfi/app/presentation/theme/Color.kt`
```kotlin
val Saffron = Color(0xFFYOURCOLOR)
```

### Add More Flavors
Edit: `app/src/main/java/com/ganeshkulfi/app/data/model/Flavor.kt`
Add to `getDefaultFlavors()` function

## 📚 Next Steps

1. **Add Images**: Copy kulfi images to `res/drawable/`
2. **Test Features**: Try login, signup, browse flavors
3. **Customize**: Update colors, strings, images
4. **Build Release**: Follow README.md instructions

## 🆘 Need Help?

Check these files:
- **Full Documentation**: `README.md`
- **Conversion Guide**: `../CONVERSION_GUIDE.md`
- **Troubleshooting**: README.md → Troubleshooting section

## 🎉 You're Ready!

Your Android app is now set up and running. Start customizing and building features!

---

**Quick Links**:
- [Firebase Console](https://console.firebase.google.com/project/kulfi-delight-3d)
- [Android Studio](https://developer.android.com/studio)
- [Kotlin Docs](https://kotlinlang.org/docs/home.html)
- [Jetpack Compose](https://developer.android.com/jetpack/compose)
