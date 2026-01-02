# Admin Features - Implementation Guide

## Backend APIs (Already Available)

### 1. Retailer Management

#### Update Retailer
```
PUT /api/users/{userId}
Authorization: Bearer {admin_token}

Body:
{
  "name": "string",
  "phone": "string", 
  "role": "RETAILER",
  "retailerId": "string",
  "shopName": "string",
  "tier": "BASIC|SILVER|GOLD|PLATINUM"
}
```

#### Delete Retailer
```
DELETE /api/users/{userId}
Authorization: Bearer {admin_token}
```

### 2. Order Management

#### Confirm Order
```
POST /api/orders/{orderId}/confirm
Authorization: Bearer {admin_token}
```

#### Mark as Packed
```
POST /api/orders/{orderId}/pack
Authorization: Bearer {admin_token}
```

#### Mark as Out for Delivery
```
POST /api/orders/{orderId}/out-for-delivery
Authorization: Bearer {admin_token}
```

#### Mark as Delivered
```
POST /api/orders/{orderId}/deliver
Authorization: Bearer {admin_token}
```

#### Cancel Order (Admin)
```
PATCH /api/admin/orders/{orderId}/cancel
Authorization: Bearer {admin_token}

Body:
{
  "reason": "string"
}
```

## Android App Updates Needed

### Files to Update:

1. **AdminDashboardScreen.kt / AdminOrdersScreen.kt** - Add order status buttons
2. **RetailerManagementScreen.kt** (create if doesn't exist) - Add edit/delete options
3. **ApiService.kt** - Add new endpoint functions
4. **Repositories** - Add business logic

### Implementation Priority:

1. ✅ Backend APIs exist
2. ⏳ Add to Android app UI
3. ⏳ Test with real data
