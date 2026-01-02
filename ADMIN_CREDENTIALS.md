# Admin Login Credentials

## Admin Access

Use the following credentials to access the Admin Dashboard:

### Admin Credentials
- **Email:** `admin@ganeshkulfi.com`
- **Password:** `admin123`

## Features Available for Admin

Once logged in as admin, you will have access to:

### 1. **Admin Dashboard** 
   - View key metrics (Today's Sales, Total Revenue, Total Stock)
   - Track low stock items
   - Monitor active retailers
   - View pending orders

### 2. **Inventory Management**
   - View all 13 kulfi flavors with stock levels
   - Track available stock, total stock, and stock given to retailers
   - Get low stock alerts
   - View sales metrics (today, this week, this month)
   - Add stock and update quantities

### 3. **Retailer Management**
   - View all retailers
   - Track outstanding payments
   - Monitor credit limits
   - Add new retailers
   - Edit retailer information
   - View retailer contact details

### 4. **Stock Transaction Tracking**
   - Record stock given to retailers
   - Track stock returns
   - Monitor payment status (Pending, Paid, Partial, Overdue)
   - View transaction history

### 5. **Payment Processing** (Ready for Razorpay integration)
   - Multiple payment methods: Cash, UPI, Card, Net Banking, Cheque
   - Payment gateway support: Razorpay, Paytm, PhonePe, GPay, Stripe, Cashfree
   - Track payment status and refunds

## How to Access Admin Dashboard

### Option 1: Direct Login
1. Open the app
2. Click "Sign In" on the splash screen
3. Enter admin credentials:
   - Email: `admin@ganeshkulfi.com`
   - Password: `admin123`
4. You'll be automatically redirected to the Admin Dashboard

### Option 2: From Profile (if already logged in as admin)
1. Navigate to the Profile screen
2. You'll see a highlighted "Admin Dashboard" card
3. Click on it to access the Admin Dashboard
4. The card shows "Manage inventory & retailers"

## Sample Data

The app comes pre-loaded with sample data:

### Sample Retailers
1. **Kumar Sweet Shop**
   - Contact: 9876543210
   - Outstanding: ₹5,000
   - Credit Limit: ₹50,000

2. **Sharma Ice Cream Corner**
   - Contact: 9876543211
   - Outstanding: ₹2,000
   - Credit Limit: ₹30,000

### Inventory
- 13 kulfi flavors with varying stock levels
- Cost prices: ₹8-15 per unit
- Selling prices: ₹20-40 per unit
- Profit margins: 60-150%

## Security Notes

⚠️ **Important:** These are demo credentials for testing purposes.

In production, you should:
1. Use secure password hashing (bcrypt, Argon2)
2. Implement proper authentication (Firebase Auth, OAuth)
3. Store credentials securely (encrypted database)
4. Add multi-factor authentication for admin access
5. Implement role-based access control (RBAC)
6. Use HTTPS for all API calls
7. Implement session management and token expiration

## Future Enhancements

- [ ] Connect admin screens to ViewModels for real-time data
- [ ] Implement "Give Stock to Retailer" dialog
- [ ] Add payment recording functionality
- [ ] Integrate Razorpay payment gateway
- [ ] Build reports and analytics screens
- [ ] Add Room database for data persistence
- [ ] Implement user management (add/remove admin users)
- [ ] Add activity logs for admin actions

## Support

For any issues or questions:
- Check the BUSINESS_MANAGEMENT_GUIDE.md for detailed feature documentation
- Review the code in `app/data/repository/AuthRepository.kt` for authentication logic
- Check `app/presentation/ui/admin/` for admin screen implementations

---

**Last Updated:** November 7, 2025
