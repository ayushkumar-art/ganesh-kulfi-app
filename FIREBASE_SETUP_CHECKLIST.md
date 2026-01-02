# Firebase Setup Checklist
### Quick Setup Guide for OAuth Authentication

---

## ✅ Setup Steps

### 1. Create Firebase Project (5 minutes)
- [ ] Go to https://console.firebase.google.com/
- [ ] Click "Add project"
- [ ] Name: `Ganesh Kulfi`
- [ ] Click "Continue" → "Continue" → "Create project"
- [ ] Wait for project creation
- [ ] Click "Continue"

### 2. Add Android App (5 minutes)
- [ ] Click Android icon (or "Add app" → Android)
- [ ] Android package name: `com.ganeshkulfi.app`
- [ ] App nickname: `Ganesh Kulfi`
- [ ] Click "Register app"
- [ ] Click "Download google-services.json"
- [ ] Save file to: `android/KulfiDelightAndroid/app/google-services.json`
- [ ] Click "Next" → "Next" → "Continue to console"

### 3. Enable Google Sign-In (2 minutes)
- [ ] Firebase Console → Build → Authentication
- [ ] Click "Get started"
- [ ] Click "Sign-in method" tab
- [ ] Find "Google" → Click to expand
- [ ] Toggle "Enable"
- [ ] Enter support email: `your-email@gmail.com`
- [ ] Click "Save"

### 4. Get Web Client ID (3 minutes)
- [ ] Firebase Console → Project Settings (gear icon)
- [ ] Scroll to "Your apps"
- [ ] Find Web app section
- [ ] If no web app exists:
  - [ ] Click "Add app" → Select Web `</>`
  - [ ] App nickname: `Ganesh Kulfi Web`
  - [ ] Click "Register app"
- [ ] Copy the **Web client ID** (looks like: `xxx.apps.googleusercontent.com`)
- [ ] Open `GoogleSignInHelper.kt`
- [ ] Replace: `private val webClientId = "YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com"`
- [ ] Paste your Web Client ID

### 5. Get SHA-1 Fingerprint (5 minutes)

#### Windows PowerShell:
```powershell
cd "e:\Ganesh Kulfi web\Ganesh Kulfi\android\KulfiDelightAndroid"
.\gradlew signingReport
```

#### Look for output like:
```
Variant: debug
SHA-1: A1:B2:C3:D4:E5:F6:...
```

- [ ] Copy the SHA-1 fingerprint
- [ ] Firebase Console → Project Settings → Your apps → Android app
- [ ] Scroll to "SHA certificate fingerprints"
- [ ] Click "Add fingerprint"
- [ ] Paste SHA-1
- [ ] Click "Save"

### 6. Update google-services.json (2 minutes)
- [ ] Firebase Console → Project Settings
- [ ] Scroll to "Your apps" → Android app
- [ ] Click "google-services.json" to download latest
- [ ] Replace the existing file in `app/google-services.json`

### 7. Verify Setup (2 minutes)
- [ ] Check file exists: `app/google-services.json`
- [ ] Check Web Client ID updated in `GoogleSignInHelper.kt`
- [ ] Check SHA-1 added to Firebase Console
- [ ] All dependencies in build.gradle.kts

---

## 🔄 Build & Test

### Clean Build
```powershell
cd "e:\Ganesh Kulfi web\Ganesh Kulfi\android\KulfiDelightAndroid"
.\gradlew clean build
```

### Test Sign-In
1. Install APK on device/emulator
2. Open app → Login screen
3. Click "Sign in with Google" (after implementing UI)
4. Select test account
5. Verify role detection works

---

## 📧 Test Accounts

### Admin (Your Email)
- Use your actual Gmail: `youremail@gmail.com`
- Add to `adminEmails` in `UserRoleMapper.kt`

### Retailer Test Accounts
Create these Gmail accounts or use existing ones:
- `kumar.sweetshop@gmail.com` → Maps to Kumar Sweet Shop (VIP)
- `sharma.icecream@gmail.com` → Maps to Sharma Ice Cream (PREMIUM)
- `patel.sweets@gmail.com` → Maps to Patel Sweets (REGULAR)

Or just test with any retailer email already in UserRoleMapper.

### Customer
- Any other Gmail account

---

## 🐛 Common Issues

### Issue: "Sign-in failed"
**Fix:** 
1. Check Web Client ID is correct
2. Verify google-services.json is in app folder
3. Rebuild project

### Issue: "SHA fingerprint mismatch"
**Fix:**
1. Run `.\gradlew signingReport` again
2. Copy exact SHA-1 shown
3. Add to Firebase Console
4. Wait 5 minutes for changes to propagate

### Issue: Google Sign-In UI not showing
**Fix:**
1. Verify google-services.json exists
2. Check internet connection
3. Rebuild and reinstall app

---

## ✅ Verification Checklist

Before testing:
- [ ] `google-services.json` in correct location
- [ ] Web Client ID updated in code
- [ ] SHA-1 added to Firebase
- [ ] Build successful
- [ ] APK installed on device

After testing:
- [ ] Admin email works → Shows admin dashboard
- [ ] Retailer email works → Shows retailer home with shop name
- [ ] New email works → Shows customer home

---

## 🎯 Quick Test

1. **Login as Admin:**
   - Email: admin@ganeshkulfi.com (add to adminEmails first)
   - Expected: Admin Dashboard

2. **Login as Retailer:**
   - Email: kumar@shop.com (if in UserRoleMapper)
   - Expected: "Welcome Back, Rajesh Kumar" + "Kumar Sweet Shop - VIP Tier"

3. **Login as Customer:**
   - Email: any other Google account
   - Expected: Regular customer home

---

**Total Time: ~25 minutes** ⏱️

After completing this checklist, your OAuth authentication will be fully functional! 🎉
