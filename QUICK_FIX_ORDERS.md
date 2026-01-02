# 🚨 QUICK FIX GUIDE - Orders Not Showing

## ⚡ IMMEDIATE ACTIONS

### 1. Uninstall Old App
```
Settings → Apps → Ganesh Kulfi → Uninstall
```

### 2. Install NEW APK
```
Location: e:\kaka\app\build\outputs\apk\debug\app-debug.apk
Size: 44 MB
Built: 2025-12-31 09:37:41
```

### 3. Test Login
```
Email: admin@ganeshkulfi.com
Password: Admin@123
```

### 4. Check Orders Management
Navigate to Orders Management and observe

## 📊 Expected Behavior

### If Working:
- Loading spinner appears briefly
- Order ORD-20251230-0001 appears
- Shows: ₹236, PENDING, 1 item

### If Not Working - Check Logs:
```powershell
# If device connected via USB:
adb logcat | Select-String "AdminOrdersScreen|fetchOrders"
```

## 🔍 Debug Output You Should See

```
📱 AdminOrdersScreen: Fetching orders...
🔑 Using auth token: eyJhbGci...
════════════════════════════════════════════
🔄 FETCHING ORDERS - START
📡 Response code: 200
📊 Orders count: 1
✅ Setting orders in state: 1 orders
🔄 FETCHING ORDERS - END
════════════════════════════════════════════
📱 AdminOrdersScreen State:
   backendOrders.size: 1
```

## ⚠️ Common Issues

### Issue: "dummy-token-for-testing" in logs
**Fix:** Login screen not saving token properly
**Check:** AuthRepository.saveToken() is called

### Issue: HTTP 401
**Fix:** Token invalid
**Action:** Logout and login again

### Issue: backendOrders.size: 0 (but API works)
**Fix:** ViewModel not injected correctly
**Check:** @HiltViewModel annotation present

## 🧪 Backend Verification (Run This First)

```powershell
# Test if backend has orders:
$login = Invoke-RestMethod -Uri "http://10.242.116.68:8080/api/auth/login" -Method POST -ContentType "application/json" -Body '{"email":"admin@ganeshkulfi.com","password":"Admin@123"}'

$token = $login.data.token

$orders = Invoke-RestMethod -Uri "http://10.242.116.68:8080/api/admin/orders" -Headers @{Authorization="Bearer $token"}

Write-Host "Orders: $($orders.data.orders.Count)"
# Should show: Orders: 1
```

## 📱 Installation Methods

### Method 1: ADB (If device connected)
```powershell
adb install -r e:\kaka\app\build\outputs\apk\debug\app-debug.apk
```

### Method 2: Manual Transfer
1. Copy APK to device
2. Open file manager on device
3. Click APK to install
4. Allow installation from unknown sources if prompted

## ✅ Success Indicators

- [ ] New APK installed (44 MB)
- [ ] Can login as admin
- [ ] Orders Management screen loads
- [ ] Loading spinner shows briefly
- [ ] Order ORD-20251230-0001 visible
- [ ] Shows: Retailer, 1 items, ₹236, PENDING status

## 🆘 If Still Not Working

**Report back with:**
1. Logcat output (debug logs)
2. Screenshots of Orders Management screen
3. Whether you see loading spinner
4. Any error messages

The debug logs will pinpoint the exact issue!
