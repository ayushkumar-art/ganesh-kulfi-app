# Retailer Pricing System - Quick Start Guide

## 🎯 What Problem Does This Solve?

**Problem:** You need to give different prices to different retailers based on their relationship, volume, and special agreements.

**Solution:** Automatic pricing tiers + custom pricing + bulk discounts

---

## 📊 Pricing Methods

### 1. **Pricing Tiers** (Automatic)

| Tier | Discount | Who Gets It |
|------|----------|-------------|
| VIP | 25% OFF | Best long-term customers |
| PREMIUM | 15% OFF | High-volume buyers |
| REGULAR | 10% OFF | Standard retailers |
| WHOLESALE | 5% OFF | Bulk distributors |
| RETAIL | 0% OFF | New/small retailers |

**How it works:**
- Assign tier to retailer → They get discount on ALL flavors automatically
- Example: VIP retailer buying ₹20 kulfi pays ₹15

---

### 2. **Custom Pricing** (Manual)

Set specific price for specific retailer + flavor combination.

**When to use:**
- Special agreements
- Promotional pricing
- Seasonal deals
- Overstocked flavors

**Example:**
- Kumar Sweet Shop normally gets VIP pricing (25% OFF)
- Set custom price for Chocolate Kulfi: ₹25 (instead of tier discount)
- Only applies to Chocolate, other flavors use VIP tier

---

### 3. **Bulk Discounts** (Automatic)

Based on order quantity:

| Quantity | Discount |
|----------|----------|
| 100+ | 5% OFF |
| 200+ | 10% OFF |
| 500+ | 15% OFF |
| 1000+ | 20% OFF |

**System automatically uses BEST discount** (bulk vs tier)

---

## 🔄 How Pricing is Calculated

```
Priority (Highest to Lowest):
1. Custom Price (if set)
2. Best of: Bulk Discount OR Tier Discount
3. Base Price
```

**Example:**
- Retailer: PREMIUM tier (15% OFF)
- Ordering: 600 units (qualifies for 15% bulk discount)
- Custom Price: Not set
- **Result:** Uses tier discount (same as bulk, but tier applied first)

---

## 🛠️ How to Use

### Assign Pricing Tier to Retailer

1. **Admin Dashboard** → **Pricing Management**
2. Find retailer in list
3. Click **"Change Tier"** dropdown
4. Select tier (VIP, Premium, etc.)
5. ✅ Done! Applies to all future transactions

---

### Set Custom Price for Retailer

1. **Pricing Management**
2. Click on retailer card
3. Dialog shows all flavors with current prices
4. Find flavor you want custom pricing for
5. Click to set custom price
6. Enter price and optional minimum quantity
7. ✅ Done!

---

### View Pricing for Retailer

1. **Pricing Management**
2. Click any retailer
3. See complete price breakdown:
   - Base price (your standard)
   - Retailer price (what they pay)
   - Discount percentage
   - Whether custom pricing is active

---

## 💼 Common Scenarios

### Scenario 1: New Retailer

**Setup:**
```
1. Add retailer
2. Set tier: RETAIL (0% discount)
3. After 1 month of good orders → REGULAR (10%)
4. After 3 months → PREMIUM (15%)
5. Top customer → VIP (25%)
```

---

### Scenario 2: Special Festival Deal

**Setup:**
```
1. Retailer normally gets PREMIUM (15% OFF)
2. For Diwali: Set custom price for Mango Kulfi
3. Custom: ₹13 (vs normal ₹17)
4. Minimum quantity: 200 units
5. After festival: Remove custom pricing
```

---

### Scenario 3: Clear Overstocked Flavor

**Setup:**
```
1. Chocolate Kulfi overstocked
2. Set custom pricing for ALL retailers on Chocolate
3. VIP: ₹22 (vs normal ₹26.25)
4. Premium: ₹27 (vs normal ₹29.75)
5. Others remain at tier pricing
```

---

## 📱 What Admin Sees

### Pricing Management Screen

```
Pricing Tiers:
⭐ VIP Tier         25% OFF
⭐ PREMIUM Tier     15% OFF
⭐ REGULAR Tier     10% OFF

Retailers (2):

┌─────────────────────────────────┐
│ Kumar Sweet Shop          [Edit]│
│ Rajesh Kumar                    │
│ ⭐ VIP Tier - 25% discount      │
│            [Change Tier ▼]      │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ Sharma Ice Cream         [Edit] │
│ Priya Sharma                    │
│ ⭐ PREMIUM - 15% discount       │
│            [Change Tier ▼]      │
└─────────────────────────────────┘
```

---

### Retailer Detail Dialog

```
Custom Pricing for Kumar Sweet Shop
Current Tier: VIP (25% OFF)
─────────────────────────────
Flavor Prices:

Mango Kulfi
Base: ₹20  →  Retailer: ₹15.00
25% OFF

Chocolate Kulfi              [Remove]
Base: ₹35  →  Retailer: ₹25.00
28.6% OFF
✓ Custom Pricing Active
```

---

## 🎯 Key Features

✅ **Automatic Pricing** - Set tier once, applies to all flavors
✅ **Custom Override** - Special prices for specific combinations
✅ **Smart Selection** - System uses best available discount
✅ **Transparent** - Admin sees exact pricing breakdown
✅ **Transaction Integration** - Pricing automatic when giving stock
✅ **Flexible** - Easy to upgrade/downgrade tiers
✅ **Bulk Incentives** - Automatic discounts for large orders

---

## 📋 Quick Commands

### Update Retailer Tier
```kotlin
viewModel.updateRetailerPricingTier(
    retailerId = "ret_001",
    newTier = PricingTier.VIP
)
```

### Set Custom Price
```kotlin
viewModel.setCustomPrice(
    retailerId = "ret_001",
    flavorId = "chocolate",
    customPrice = 25.0,
    discount = 0.0,
    minimumQuantity = 100
)
```

### Give Stock (Automatic Pricing)
```kotlin
viewModel.giveStockToRetailer(
    retailerId = "ret_001",
    flavorId = "mango",
    quantity = 100
    // Price calculated automatically!
)
```

---

## 💡 Pro Tips

1. **Start Low, Promote Up** - Begin with RETAIL tier, upgrade based on performance
2. **Review Monthly** - Check if retailers should be upgraded/downgraded
3. **Use Custom Sparingly** - Too many custom prices = confusing
4. **Communicate Changes** - Tell retailers when you upgrade their tier
5. **Track Results** - Monitor which tiers drive most volume
6. **Seasonal Pricing** - Use custom pricing for temporary promotions

---

## ⚠️ Important Notes

- Custom price **overrides** tier discount
- System **automatically** uses best discount
- Tier applies to **ALL** flavors
- Past transactions **don't change** when tier changes
- Minimum quantities are **enforced**

---

## 🎓 Real Example

**Kumar Sweet Shop:**
- Status: Long-term customer, pays on time
- Tier: **VIP** (25% OFF)
- Monthly orders: ₹80,000

**Regular Order (100 Mango Kulfi):**
- Base: ₹20/unit = ₹2,000 total
- VIP Price: ₹15/unit = ₹1,500 total
- **Savings: ₹500**

**Special Order (500 Chocolate for festival):**
- Base: ₹35/unit = ₹17,500
- VIP would be: ₹26.25/unit = ₹13,125
- **Custom deal: ₹22/unit = ₹11,000**
- **Extra savings: ₹2,125** (vs VIP pricing)

---

## 🚀 Getting Started

**Step 1:** Review your current retailers
**Step 2:** Assign appropriate tiers based on volume/relationship
**Step 3:** Set custom pricing for any special agreements
**Step 4:** Test with a transaction
**Step 5:** Monitor and adjust

---

## 📞 Need Help?

See full documentation: **RETAILER_PRICING_GUIDE.md**

---

**Quick Start Guide v1.0**  
**Last Updated:** November 7, 2025  
**Status:** ✅ Ready to Use
