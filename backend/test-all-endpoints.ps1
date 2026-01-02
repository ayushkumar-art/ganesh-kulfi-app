# Comprehensive Backend Functionality Test
# Tests all major endpoints of Ganesh Kulfi Backend

Write-Host "🍦 Ganesh Kulfi Backend - Functionality Test" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Gray
Write-Host ""

$baseUrl = "http://localhost:8080"
$results = @()

# Test 1: Health Check
Write-Host "1️⃣ Testing Health Endpoint..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "$baseUrl/api/health" -Method Get
    Write-Host "   ✅ Status: $($health.status)" -ForegroundColor Green
    Write-Host "   ✅ Database: $($health.database)" -ForegroundColor Green
    $results += "✅ Health Check: PASSED"
} catch {
    Write-Host "   ❌ Health check failed: $($_.Exception.Message)" -ForegroundColor Red
    $results += "❌ Health Check: FAILED"
}
Write-Host ""

# Test 2: User Registration (Admin)
Write-Host "2️⃣ Testing User Registration (Admin)..." -ForegroundColor Yellow
try {
    $adminBody = @{
        email = "testadmin$(Get-Random)@ganeshkulfi.com"
        password = "Admin@123"
        name = "Test Admin User"
        phone = "9876543210"
        role = "ADMIN"
    } | ConvertTo-Json
    
    $adminResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/register" -Method Post -Body $adminBody -ContentType "application/json"
    if ($adminResponse.success -and $adminResponse.data.token) {
        Write-Host "   ✅ Admin registered: $($adminResponse.data.user.name)" -ForegroundColor Green
        $adminToken = $adminResponse.data.token
        $results += "✅ Admin Registration: PASSED"
    } else {
        Write-Host "   ❌ Unexpected response format" -ForegroundColor Red
        $results += "❌ Admin Registration: FAILED"
    }
} catch {
    if ($_.Exception.Message -like "*already exists*") {
        Write-Host "   ℹ️ Admin already exists, logging in..." -ForegroundColor Cyan
        $loginBody = @{
            email = "admin@ganeshkulfi.com"
            password = "Admin1234"
        } | ConvertTo-Json
        $adminResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/login" -Method Post -Body $loginBody -ContentType "application/json"
        if ($adminResponse.success) {
            $adminToken = $adminResponse.data.token
            Write-Host "   ✅ Admin logged in successfully" -ForegroundColor Green
            $results += "✅ Admin Login: PASSED"
        }
    } else {
        Write-Host "   ❌ Admin registration failed: $($_.Exception.Message)" -ForegroundColor Red
        $results += "❌ Admin Registration: FAILED"
    }
}
Write-Host ""

# Test 3: User Registration (Retailer)
Write-Host "3️⃣ Testing User Registration (Retailer)..." -ForegroundColor Yellow
try {
    $retailerBody = @{
        email = "retailer$(Get-Random)@test.com"
        password = "Retailer@123"
        name = "Test Retailer"
        phone = "9876543211"
        role = "RETAILER"
        shopName = "Test Kulfi Shop"
        gstNumber = "GST123456"
    } | ConvertTo-Json
    
    $retailerResponse = Invoke-RestMethod -Uri "$baseUrl/api/auth/register" -Method Post -Body $retailerBody -ContentType "application/json"
    if ($retailerResponse.success -and $retailerResponse.data.token) {
        Write-Host "   ✅ Retailer registered: $($retailerResponse.data.user.name)" -ForegroundColor Green
        $retailerToken = $retailerResponse.data.token
        $results += "✅ Retailer Registration: PASSED"
    } else {
        Write-Host "   ❌ Unexpected response format" -ForegroundColor Red
        $results += "❌ Retailer Registration: FAILED"
    }
} catch {
    Write-Host "   ❌ Retailer registration failed: $($_.Exception.Message)" -ForegroundColor Red
    $results += "❌ Retailer Registration: FAILED"
}
Write-Host ""

# Test 4: Get Products (No Auth Required)
Write-Host "4️⃣ Testing Product Listing..." -ForegroundColor Yellow
try {
    $productsResponse = Invoke-RestMethod -Uri "$baseUrl/api/products" -Method Get
    $products = $productsResponse.data.products
    Write-Host "   ✅ Found $($products.Count) products" -ForegroundColor Green
    if ($products.Count -gt 0) {
        Write-Host "   📦 Sample: $($products[0].name) - ₹$($products[0].basePrice)" -ForegroundColor Cyan
    }
    $results += "✅ Product Listing: PASSED ($($products.Count) products)"
} catch {
    Write-Host "   ❌ Product listing failed: $($_.Exception.Message)" -ForegroundColor Red
    $results += "❌ Product Listing: FAILED"
}
Write-Host ""

# Test 5: Create Order (Retailer)
Write-Host "5️⃣ Testing Order Creation (Retailer)..." -ForegroundColor Yellow
if ($retailerToken -and $products.Count -gt 0) {
    try {
        $product = $products[0]
        $orderBody = @{
            items = @(
                @{
                    productId = $product.id
                    productName = $product.name
                    quantity = 10
                    unitPrice = $product.basePrice
                    discountPercent = 0.0
                }
            )
            retailerNotes = "Test order"
        } | ConvertTo-Json -Depth 10
        
        $headers = @{ Authorization = "Bearer $retailerToken" }
        $orderResponse = Invoke-RestMethod -Uri "$baseUrl/api/orders" -Method Post -Body $orderBody -ContentType "application/json" -Headers $headers
        if ($orderResponse.success) {
            Write-Host "   ✅ Order created: #$($orderResponse.data.id)" -ForegroundColor Green
            Write-Host "   💰 Total: ₹$($orderResponse.data.totalAmount)" -ForegroundColor Cyan
            $orderId = $orderResponse.data.id
            $results += "✅ Order Creation: PASSED"
        } else {
            Write-Host "   ❌ Unexpected response" -ForegroundColor Red
            $results += "❌ Order Creation: FAILED"
        }
    } catch {
        Write-Host "   ❌ Order creation failed: $($_.Exception.Message)" -ForegroundColor Red
        $results += "❌ Order Creation: FAILED"
    }
} else {
    Write-Host "   ⚠️ Skipped (no retailer token or products)" -ForegroundColor Yellow
    $results += "⚠️ Order Creation: SKIPPED"
}
Write-Host ""

# Test 6: Get Order History (Retailer)
Write-Host "6️⃣ Testing Order History (Retailer)..." -ForegroundColor Yellow
if ($retailerToken) {
    try {
        $headers = @{ Authorization = "Bearer $retailerToken" }
        $orders = Invoke-RestMethod -Uri "$baseUrl/api/retailer/orders/history" -Method Get -Headers $headers
        Write-Host "   ✅ Found $($orders.Count) orders in history" -ForegroundColor Green
        $results += "✅ Order History: PASSED"
    } catch {
        Write-Host "   ❌ Order history failed: $($_.Exception.Message)" -ForegroundColor Red
        $results += "❌ Order History: FAILED"
    }
} else {
    Write-Host "   ⚠️ Skipped (no retailer token)" -ForegroundColor Yellow
    $results += "⚠️ Order History: SKIPPED"
}
Write-Host ""

# Test 7: Get Factory Orders (Admin)
Write-Host "7️⃣ Testing Factory Orders (Admin)..." -ForegroundColor Yellow
if ($adminToken) {
    try {
        $headers = @{ Authorization = "Bearer $adminToken" }
        $factoryOrders = Invoke-RestMethod -Uri "$baseUrl/api/factory/orders" -Method Get -Headers $headers
        Write-Host "   ✅ Found $($factoryOrders.Count) factory orders" -ForegroundColor Green
        $results += "✅ Factory Orders: PASSED"
    } catch {
        Write-Host "   ❌ Factory orders failed: $($_.Exception.Message)" -ForegroundColor Red
        $results += "❌ Factory Orders: FAILED"
    }
} else {
    Write-Host "   ⚠️ Skipped (no admin token)" -ForegroundColor Yellow
    $results += "⚠️ Factory Orders: SKIPPED"
}
Write-Host ""

# Test 8: Confirm Order (Admin/Factory)
Write-Host "8️⃣ Testing Order Confirmation (Factory)..." -ForegroundColor Yellow
if ($adminToken -and $orderId) {
    try {
        $headers = @{ Authorization = "Bearer $adminToken" }
        $confirmed = Invoke-RestMethod -Uri "$baseUrl/api/orders/$orderId/confirm" -Method Post -Headers $headers
        Write-Host "   ✅ Order confirmed: Status = $($confirmed.data.status)" -ForegroundColor Green
        $results += "✅ Order Confirmation: PASSED"
    } catch {
        Write-Host "   ❌ Order confirmation failed: $($_.Exception.Message)" -ForegroundColor Red
        $results += "❌ Order Confirmation: FAILED"
    }
} else {
    Write-Host "   ⚠️ Skipped (no admin token or order)" -ForegroundColor Yellow
    $results += "⚠️ Order Confirmation: SKIPPED"
}
Write-Host ""

# Test 9: Admin Analytics
Write-Host "9️⃣ Testing Admin Analytics..." -ForegroundColor Yellow
if ($adminToken) {
    try {
        $headers = @{ Authorization = "Bearer $adminToken" }
        $analytics = Invoke-RestMethod -Uri "$baseUrl/api/admin/analytics/dashboard" -Method Get -Headers $headers
        Write-Host "   ✅ Analytics retrieved" -ForegroundColor Green
        Write-Host "   📊 Total Orders: $($analytics.totalOrders)" -ForegroundColor Cyan
        Write-Host "   💰 Total Revenue: ₹$($analytics.totalRevenue)" -ForegroundColor Cyan
        $results += "✅ Admin Analytics: PASSED"
    } catch {
        Write-Host "   ❌ Analytics failed: $($_.Exception.Message)" -ForegroundColor Red
        $results += "❌ Admin Analytics: FAILED"
    }
} else {
    Write-Host "   ⚠️ Skipped (no admin token)" -ForegroundColor Yellow
    $results += "⚠️ Admin Analytics: SKIPPED"
}
Write-Host ""

# Test 10: Order Timeline
Write-Host "🔟 Testing Order Timeline..." -ForegroundColor Yellow
if ($retailerToken -and $orderId) {
    try {
        $headers = @{ Authorization = "Bearer $retailerToken" }
        $timeline = Invoke-RestMethod -Uri "$baseUrl/api/orders/$orderId/timeline" -Method Get -Headers $headers
        Write-Host "   ✅ Timeline retrieved: $($timeline.Count) events" -ForegroundColor Green
        $results += "✅ Order Timeline: PASSED"
    } catch {
        Write-Host "   ❌ Timeline failed: $($_.Exception.Message)" -ForegroundColor Red
        $results += "❌ Order Timeline: FAILED"
    }
} else {
    Write-Host "   ⚠️ Skipped (no token or order)" -ForegroundColor Yellow
    $results += "⚠️ Order Timeline: SKIPPED"
}
Write-Host ""

# Summary
Write-Host "=" * 60 -ForegroundColor Gray
Write-Host "📋 TEST SUMMARY" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Gray
$results | ForEach-Object { Write-Host $_ }
Write-Host "=" * 60 -ForegroundColor Gray
Write-Host ""

$passedCount = ($results | Where-Object { $_ -like "*PASSED*" }).Count
$totalCount = $results.Count
Write-Host "✅ Passed: $passedCount / $totalCount tests" -ForegroundColor Green
Write-Host ""
