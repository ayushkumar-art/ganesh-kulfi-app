# 🔍 DEBUG GUIDE - Orders Not Showing

## 📱 NEW APK WITH DEBUG LOGGING

**APK Details:**
- **File:** `app/build/outputs/apk/debug/app-debug.apk`
- **Size:** 44.0 MB
- **Built:** 2025-12-31 09:37:41
- **Changes:** Added comprehensive debug logging

## 🎯 What Was Added

### 1. Enhanced ViewModel Logging
The `AdminViewModel.fetchOrders()` now prints:
```
════════════════════════════════════════════
🔄 FETCHING ORDERS - START
   Token: eyJhbGciOiJIUzI1NiI...
   Token length: 291
📡 Response code: 200
📡 Response isSuccessful: true
📡 Response body success: true
📡 Response body message: Orders retrieved successfully
📊 Admin response: AdminOrdersResponse(...)
📊 Orders count: 1
   🔍 Processing order: ORD-20251230-0001
✅ Setting orders in state: 1 orders
✅ Orders state updated successfully
✅ Current _orders.value.size: 1
   📦 ORD-20251230-0001: PENDING, ₹236, Items: 1
🔄 FETCHING ORDERS - END
════════════════════════════════════════════
```

### 2. Enhanced Screen Logging
The `AdminOrdersScreen` now prints:
```
════════════════════════════════════════════
📱 AdminOrdersScreen State:
   backendOrders.size: 1
   isLoading: false
   errorMessage: null
   [0] Order: ORD-20251230-0001, Status: PENDING, Amount: 236.0
════════════════════════════════════════════
🔄 Converting 1 backend orders to UI models
✅ Converted to 1 UI orders
```

## 🧪 Testing Steps

### Step 1: Install New APK
```powershell
# The APK is at:
e:\kaka\app\build\outputs\apk\debug\app-debug.apk

# Install on your device via:
# - USB debugging (adb install)
# - Transfer to device and install manually
```

### Step 2: Open App with Logcat
If testing on emulator or connected device:
```powershell
# View logs in real-time
adb logcat | Select-String "AdminOrdersScreen|AdminViewModel|fetchOrders"
```

### Step 3: Login as Admin
- **Email:** `admin@ganeshkulfi.com`
- **Password:** `Admin@123`

### Step 4: Navigate to Orders Management
- Click on "Orders Management" button
- **Watch the logs!**

## 🔍 What to Look For

### Scenario A: Token Issue
If you see:
```
🔑 Using auth token: dummy-token-for-test...
```
**Problem:** Token not saved in SharedPreferences
**Solution:** The app needs to properly save token after login

### Scenario B: API Call Fails
If you see:
```
❌ Failed to fetch orders: ...
Response code: 401
```
**Problem:** Authentication failed
**Solution:** Token is invalid or expired

### Scenario C: Backend Returns Empty
If you see:
```
📊 Orders count: 0
```
**Problem:** Backend has no orders
**Solution:** Create a test order first

### Scenario D: Everything Works But UI Shows Empty
If you see logs showing orders but UI is empty:
```
✅ Current _orders.value.size: 1
📱 AdminOrdersScreen State:
   backendOrders.size: 0  ← This should be 1!
```
**Problem:** StateFlow not collecting properly
**Solution:** Check Hilt injection

## 🏥 Quick Health Check

Run this to verify backend:
```powershell
$login = Invoke-RestMethod -Uri "http://10.242.116.68:8080/api/auth/login" -Method POST -ContentType "application/json" -Body '{"email":"admin@ganeshkulfi.com","password":"Admin@123"}'
$token = $login.data.token
$orders = Invoke-RestMethod -Uri "http://10.242.116.68:8080/api/admin/orders" -Headers @{Authorization="Bearer $token"}
Write-Host "Orders in backend: $($orders.data.orders.Count)"
```

Expected output:
```
Orders in backend: 1
```

## 🔧 Common Issues & Solutions

### Issue 1: "dummy-token-for-testing" appears in logs
**Cause:** Token not saved after login  
**Fix:** Check if login screen is calling `authRepository.saveToken()`

### Issue 2: HTTP 401 Unauthorized
**Cause:** Token expired or invalid  
**Fix:** Logout and login again

### Issue 3: No logs appear at all
**Cause:** App not actually calling fetchOrders  
**Fix:** Check LaunchedEffect in AdminOrdersScreen

### Issue 4: Logs show data but UI empty
**Cause:** ViewModel instance mismatch  
**Fix:** Ensure ViewModel is injected with @HiltViewModel

## 📊 Expected Full Log Sequence

When everything works, you should see:
```
1. 📱 AdminOrdersScreen: Fetching orders...
2. 🔑 Using auth token: eyJhbGciOiJIUzI1NiI...
3. ════════════════════════════════════════════
4. 🔄 FETCHING ORDERS - START
5.    Token: eyJhbGciOiJIUzI1NiI...
6.    Token length: 291
7. 📡 Response code: 200
8. 📡 Response isSuccessful: true
9. 📡 Response body success: true
10. 📊 Orders count: 1
11.    🔍 Processing order: ORD-20251230-0001
12. ✅ Setting orders in state: 1 orders
13. ✅ Current _orders.value.size: 1
14.    📦 ORD-20251230-0001: PENDING, ₹236, Items: 1
15. 🔄 FETCHING ORDERS - END
16. ════════════════════════════════════════════
17. 📱 AdminOrdersScreen State:
18.    backendOrders.size: 1
19.    isLoading: false
20.    [0] Order: ORD-20251230-0001, Status: PENDING, Amount: 236.0
21. 🔄 Converting 1 backend orders to UI models
22. ✅ Converted to 1 UI orders
```

## 🎯 Next Steps

1. **Install new APK** (44 MB, built just now)
2. **Open app and navigate** to Orders Management
3. **Check logcat or device logs** for the debug output
4. **Report back** what you see in the logs

The logs will tell us exactly where the issue is!
