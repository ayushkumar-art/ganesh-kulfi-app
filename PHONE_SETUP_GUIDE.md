# 📱 App Installation & Login Guide

## ✅ Setup Complete!

### Your Configuration:
- **Computer IP:** `10.242.116.68`
- **Backend URL:** `http://10.242.116.68:8080`
- **APK Location:** `E:\kaka\app\build\outputs\apk\debug\app-debug.apk`
- **APK Size:** 43.6 MB
- **Built:** December 30, 2025

---

## 📲 Install on Your Phone

### Step 1: Transfer APK to Phone
Choose one of these methods:

**Option A: USB Cable**
```powershell
# Connect phone via USB and copy:
Copy-Item "E:\kaka\app\build\outputs\apk\debug\app-debug.apk" -Destination "YOUR_PHONE_PATH"
```

**Option B: Cloud Storage**
- Upload `app-debug.apk` to Google Drive, Dropbox, or email
- Download on your phone

**Option C: Direct WiFi Transfer**
- Use apps like "Send Anywhere" or "ShareIt"

### Step 2: Install APK
1. On your phone, locate the `app-debug.apk` file
2. Tap to install
3. If prompted, enable "Install from Unknown Sources"
4. Complete installation

---

## 🔐 Login Credentials

### Admin Account:
- **Email:** `admin@ganeshkulfi.com`
- **Password:** `Admin1234`
- **Access:** Full admin dashboard, all features

### Retailer Account:
- **Email:** `retailer@test.com`
- **Password:** `Retailer1234`
- **Access:** Retailer dashboard, orders, inventory

---

## 🌐 Network Requirements

### Important: Phone & Computer Must Be On Same WiFi!

**Your Computer's IP:** `10.242.116.68`

**Backend Status Check:**
```powershell
# Verify backend is running:
Invoke-RestMethod -Uri "http://localhost:8080/api/health"
```

**If Backend Not Running:**
```powershell
cd e:\kaka\backend
$env:DATABASE_URL="jdbc:postgresql://localhost:5432/ganeshkulfi_db"
$env:DATABASE_USER="ganeshkulfi_user"
$env:DATABASE_PASSWORD="Ganesh@123"
$env:JWT_SECRET="ganeshkulfi_secret_key_2024_very_secure"
$env:JWT_ISSUER="ganeshkulfi"
$env:JWT_AUDIENCE="ganeshkulfi-app"
java -jar build/libs/ganeshkulfi-backend-all.jar
```

**Firewall Rule (Already Created):**
```powershell
# Port 8080 is open for backend access
Get-NetFirewallRule -DisplayName "Ganesh Kulfi Backend"
```

---

## 📱 Using the App

1. **Open App** on your phone
2. **Login** with credentials above
3. **Test Features:**
   - Admin: View dashboard, manage products, view orders
   - Retailer: Place orders, check inventory, view pricing

---

## 🔧 Troubleshooting

### "Cannot connect to server"
- ✅ Verify phone and computer on same WiFi
- ✅ Check backend is running (health check above)
- ✅ Confirm firewall rule exists
- ✅ Try: `http://10.242.116.68:8080/api/health` in phone browser

### "Invalid credentials"
- Use exact credentials above (case-sensitive)
- If still fails, backend might not be running

### Change IP Address Later
1. Edit: `app\src\main\java\com\ganeshkulfi\app\data\remote\ApiConfig.kt`
2. Update `BASE_URL` with new IP
3. Rebuild: `.\gradlew.bat assembleDebug`

---

## 🎉 You're Ready!

- ✅ Backend running at `http://10.242.116.68:8080`
- ✅ APK built with correct IP configuration
- ✅ Test credentials ready
- ✅ Firewall configured

**Next:** Transfer APK to phone, install, and login! 🚀
