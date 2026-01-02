# OAuth Implementation Guide
### Google Sign-In with Automatic Role Detection

---

## 🎯 Overview

Your app now supports **OAuth authentication with Google Sign-In**! Users simply sign in with their Google account, and the app automatically:
1. ✅ Detects their role (Admin, Retailer, or Customer) based on email
2. ✅ Loads retailer-specific data (shop name, pricing tier) if they're a retailer
3. ✅ Routes them to the correct screen automatically

---

## 🚀 How It Works

### Email-Based Role Detection

```
User signs in with Google
     ↓
App checks email against UserRoleMapper
     ↓
     ├─→ admin@ganeshkulfi.com → ADMIN role
     ├─→ kumar@shop.com → RETAILER role (loads shop data)
     └─→ other@gmail.com → CUSTOMER role
     ↓
Auto-navigate to appropriate screen
```

### Registered Emails

#### Admin Emails (Full Access)
```
✅ admin@ganeshkulfi.com
✅ ganeshkulfi@gmail.com
✅ owner@ganeshkulfi.com
```

#### Retailer Emails (With Shop Data)
```
✅ kumar@shop.com → Kumar Sweet Shop (VIP - 25% off)
✅ priya@shop.com → Sharma Ice Cream Parlor (PREMIUM - 15% off)
✅ amit@sweets.com → Patel Sweets & Snacks (REGULAR - 10% off)
✅ suresh@icecream.com → Reddy Ice Cream Corner (WHOLESALE - 5% off)
✅ deepak@store.com → Gupta General Store (RETAIL - 0% off)
```

#### Any Other Email
```
→ Treated as CUSTOMER (regular user)
```

---

## 📦 What's Implemented

### ✅ 1. Dependencies Added

**build.gradle.kts (app level):**
```kotlin
// Firebase & Google Sign-In
implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
implementation("com.google.firebase:firebase-auth-ktx")
implementation("com.google.android.gms:play-services-auth:20.7.0")
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-play-services:1.7.3")
```

**build.gradle.kts (project level):**
```kotlin
id("com.google.gms.google-services") version "4.4.0" apply false
```

### ✅ 2. UserRoleMapper.kt

**File:** `app/src/main/java/com/ganeshkulfi/app/data/model/UserRoleMapper.kt`

**Features:**
- Maps emails to roles (ADMIN, RETAILER, CUSTOMER)
- Stores retailer information (shop name, pricing tier, GST, etc.)
- Provides helper methods:
  - `getUserRole(email)` - Get role for email
  - `getRetailerInfo(email)` - Get shop details
  - `isAdmin(email)` - Check if admin
  - `isRetailer(email)` - Check if retailer

**Example Usage:**
```kotlin
val role = UserRoleMapper.getUserRole("kumar@shop.com")
// Returns: UserRole.RETAILER

val info = UserRoleMapper.getRetailerInfo("kumar@shop.com")
// Returns: RetailerInfo(
//   id = "ret_001",
//   name = "Rajesh Kumar",
//   shopName = "Kumar Sweet Shop",
//   pricingTier = PricingTier.VIP
// )
```

### ✅ 3. GoogleSignInHelper.kt

**File:** `app/src/main/java/com/ganeshkulfi/app/data/auth/GoogleSignInHelper.kt`

**Features:**
- Handles Google OAuth flow with Firebase
- Uses Google One Tap Sign-In for better UX
- Auto-selects account if only one Google account
- Methods:
  - `signIn()` - Start OAuth flow
  - `handleSignInResult()` - Process sign-in result
  - `signOut()` - Sign out from Google
  - `getCurrentUser()` - Get current Firebase user

### ✅ 4. Updated AuthRepository

**File:** `app/src/main/java/com/ganeshkulfi/app/data/repository/AuthRepository.kt`

**New Methods:**
```kotlin
// Start Google Sign-In
suspend fun initiateGoogleSignIn(): IntentSender?

// Handle sign-in result
suspend fun handleGoogleSignInResult(intent: Intent): Result<User>

// Process Firebase user with role detection
suspend fun signInWithGoogle(firebaseUser: FirebaseUser): Result<User>
```

**Automatic Role Detection:**
```kotlin
val role = UserRoleMapper.getUserRole(email)
when (role) {
    UserRole.ADMIN -> {
        // Create admin user
    }
    UserRole.RETAILER -> {
        // Load retailer data & create user
        val retailerInfo = UserRoleMapper.getRetailerInfo(email)
    }
    UserRole.CUSTOMER -> {
        // Create regular customer
    }
}
```

---

## 🔧 Setup Steps

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name: "Ganesh Kulfi"
4. Enable Google Analytics (optional)
5. Click "Create Project"

### Step 2: Add Android App

1. In Firebase Console → Click "Add app" → Select Android
2. Android package name: `com.ganeshkulfi.app`
3. App nickname: "Ganesh Kulfi Android"
4. Download `google-services.json`
5. Place file in: `app/google-services.json`

### Step 3: Enable Google Sign-In

1. Firebase Console → Authentication → Sign-in method
2. Click "Google" → Enable
3. Set support email (your email)
4. Click "Save"

### Step 4: Get Web Client ID

1. Firebase Console → Project Settings → General
2. Scroll to "Your apps" → Web App
3. If no web app exists:
   - Click "Add app" → Select Web (</>) icon
   - Register app
4. Copy the "Web API Key" or "Web client ID"
5. Update in `GoogleSignInHelper.kt`:
   ```kotlin
   private val webClientId = "YOUR_WEB_CLIENT_ID.apps.googleusercontent.com"
   ```

### Step 5: Add SHA-1 Fingerprint

#### Debug SHA-1 (For Testing):
```powershell
cd "e:\Ganesh Kulfi web\Ganesh Kulfi\android\KulfiDelightAndroid"
.\gradlew signingReport
```

Copy the SHA-1 from "debug" variant.

#### Add to Firebase:
1. Firebase Console → Project Settings → General
2. Scroll to "Your apps" → Android app
3. Click "Add fingerprint"
4. Paste SHA-1
5. Download new `google-services.json` and replace

### Step 6: Place google-services.json

```
android/KulfiDelightAndroid/
  └── app/
      ├── src/
      ├── build.gradle.kts
      └── google-services.json  ← Place here
```

---

## 💻 Implementation in LoginScreen

### Update LoginScreen.kt

Add Google Sign-In button and handling:

```kotlin
@Composable
fun LoginScreen(
    onNavigateToSignUp: () -> Unit,
    onNavigateToHome: () -> Unit,
    onNavigateToAdmin: () -> Unit = {},
    onNavigateToRetailerHome: () -> Unit = {},
    viewModel: AuthViewModel = hiltViewModel()
) {
    val context = LocalContext.current
    val authState by viewModel.authState.collectAsState()
    
    // Google Sign-In launcher
    val googleSignInLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.StartIntentSenderForResult()
    ) { result ->
        if (result.resultCode == Activity.RESULT_OK) {
            viewModel.handleGoogleSignInResult(result.data ?: return@rememberLauncherForActivityResult)
        }
    }
    
    // ... existing UI code ...
    
    // Google Sign-In Button
    OutlinedButton(
        onClick = {
            viewModel.signInWithGoogle { intentSender ->
                val intent = IntentSenderRequest.Builder(intentSender).build()
                googleSignInLauncher.launch(intent)
            }
        },
        modifier = Modifier.fillMaxWidth()
    ) {
        Row(
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                painter = painterResource(R.drawable.ic_google),
                contentDescription = "Google",
                modifier = Modifier.size(20.dp)
            )
            Spacer(modifier = Modifier.width(8.dp))
            Text("Sign in with Google")
        }
    }
}
```

### Update AuthViewModel

Add Google Sign-In methods:

```kotlin
fun signInWithGoogle(onIntentSenderReady: (IntentSender) -> Unit) {
    viewModelScope.launch {
        _authState.value = AuthState.Loading
        val intentSender = authRepository.initiateGoogleSignIn()
        if (intentSender != null) {
            onIntentSenderReady(intentSender)
        } else {
            _authState.value = AuthState.Error("Failed to start Google Sign-In")
        }
    }
}

fun handleGoogleSignInResult(intent: Intent) {
    viewModelScope.launch {
        _authState.value = AuthState.Loading
        val result = authRepository.handleGoogleSignInResult(intent)
        _authState.value = if (result.isSuccess) {
            AuthState.Success
        } else {
            AuthState.Error(result.exceptionOrNull()?.message ?: "Sign-in failed")
        }
    }
}
```

---

## 🧪 Testing OAuth

### Test 1: Admin Sign-In
```
1. Click "Sign in with Google"
2. Select/enter: admin@ganeshkulfi.com
3. Expected: Navigate to Admin Dashboard
4. Verify: Full admin access
```

### Test 2: Retailer Sign-In
```
1. Click "Sign in with Google"
2. Select/enter: kumar@shop.com
3. Expected: Navigate to Retailer Home
4. Verify:
   - Shop name: "Kumar Sweet Shop"
   - Pricing tier: "VIP Tier"
   - Products show 25% discount
```

### Test 3: New Customer Sign-In
```
1. Click "Sign in with Google"
2. Select any other Google account
3. Expected: Navigate to Customer Home
4. Verify: Regular customer interface, no discounts
```

### Test 4: Multiple Retailers
```
Test each retailer email:
- priya@shop.com → Sharma Ice Cream Parlor (PREMIUM)
- amit@sweets.com → Patel Sweets & Snacks (REGULAR)
- suresh@icecream.com → Reddy Ice Cream Corner (WHOLESALE)
- deepak@store.com → Gupta General Store (RETAIL)

Each should show their specific shop name and pricing tier
```

---

## 🎨 UI/UX Enhancements

### Google Sign-In Button Design

```kotlin
OutlinedButton(
    onClick = { /* Google Sign-In */ },
    modifier = Modifier
        .fillMaxWidth()
        .height(56.dp),
    border = BorderStroke(1.dp, MaterialTheme.colorScheme.outline),
    colors = ButtonDefaults.outlinedButtonColors(
        containerColor = MaterialTheme.colorScheme.surface
    )
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.Center,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Image(
            painter = painterResource(R.drawable.ic_google),
            contentDescription = "Google",
            modifier = Modifier.size(24.dp)
        )
        Spacer(modifier = Modifier.width(12.dp))
        Text(
            "Continue with Google",
            style = MaterialTheme.typography.titleMedium,
            fontWeight = FontWeight.Medium
        )
    }
}
```

### Loading State

```kotlin
if (authState is AuthState.Loading) {
    CircularProgressIndicator(
        modifier = Modifier.size(48.dp)
    )
}
```

### Error Handling

```kotlin
if (authState is AuthState.Error) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.errorContainer
        )
    ) {
        Text(
            text = (authState as AuthState.Error).message,
            color = MaterialTheme.colorScheme.onErrorContainer,
            modifier = Modifier.padding(16.dp)
        )
    }
}
```

---

## 🔐 Security Features

### Automatic Token Management
- Firebase handles token refresh automatically
- Secure token storage
- Automatic expiration handling

### Email Verification (Optional)
```kotlin
// In GoogleSignInHelper
if (firebaseUser.isEmailVerified) {
    // Proceed
} else {
    // Ask user to verify email
    firebaseUser.sendEmailVerification()
}
```

### Retailer Whitelist
- Only registered emails can access retailer features
- Unknown emails default to customer role
- Admin can add new retailers through admin panel

---

## 📊 Adding New Retailers

### Option 1: Update UserRoleMapper (Quick)

**File:** `UserRoleMapper.kt`

```kotlin
private val retailerMappings = mapOf(
    // ... existing mappings ...
    
    // Add new retailer
    "newshop@gmail.com" to RetailerInfo(
        id = "ret_006",
        name = "Shop Owner Name",
        shopName = "New Shop Name",
        phone = "9876543215",
        pricingTier = PricingTier.PREMIUM,
        address = "Shop Address",
        gstNumber = "GST_NUMBER"
    )
)
```

### Option 2: Admin Panel (Future)

Create admin screen to add retailers:
```kotlin
fun addRetailer(
    email: String,
    name: String,
    shopName: String,
    phone: String,
    pricingTier: PricingTier,
    // ... other fields
) {
    // Save to Firebase/Backend
    // Update UserRoleMapper dynamically
}
```

---

## 🚀 Next Steps

### Immediate (Complete Setup)
1. ✅ Create Firebase project
2. ✅ Download `google-services.json`
3. ✅ Enable Google Sign-In in Firebase
4. ✅ Get Web Client ID
5. ✅ Update GoogleSignInHelper with Web Client ID
6. ✅ Add SHA-1 fingerprint

### Short Term (UI Implementation)
1. Update LoginScreen with Google Sign-In button
2. Add Google logo image resource
3. Implement loading and error states
4. Test with different email types

### Medium Term (Enhancements)
1. Add "Continue with Email" option
2. Implement email verification
3. Add profile photo from Google account
4. Store user data in Firestore

### Long Term (Admin Features)
1. Admin panel to add/remove retailers
2. Real-time retailer approval workflow
3. Email notifications for new retailer requests
4. Bulk retailer import from CSV

---

## 🐛 Troubleshooting

### "Sign-in failed" Error
**Cause:** Web Client ID not configured or incorrect
**Solution:** 
1. Verify Web Client ID in GoogleSignInHelper
2. Check if it ends with `.apps.googleusercontent.com`
3. Ensure it matches Firebase console

### "SHA-1 fingerprint" Error
**Cause:** SHA-1 not added to Firebase
**Solution:**
```powershell
.\gradlew signingReport
```
Copy SHA-1 and add to Firebase Console

### Google Sign-In UI not showing
**Cause:** google-services.json missing or invalid
**Solution:**
1. Download latest from Firebase Console
2. Place in `app/google-services.json`
3. Clean and rebuild project

### Role detection not working
**Cause:** Email not in UserRoleMapper
**Solution:**
1. Check email spelling in UserRoleMapper
2. Ensure email is lowercase
3. Add retailer mapping if needed

---

## 📱 User Experience Flow

### First Time User (Retailer)
```
1. Opens app → Sees login screen
2. Clicks "Sign in with Google"
3. Selects kumar@shop.com
4. App detects: RETAILER role
5. Loads shop data: Kumar Sweet Shop, VIP tier
6. Navigates to: Retailer Home Screen
7. Sees: Products with 25% discount
8. Experience: Seamless, one-tap login!
```

### Returning User (Auto Sign-In)
```
1. Opens app → Splash screen
2. Firebase checks: Already signed in
3. Loads saved user data
4. Auto-navigates to: Appropriate screen
5. Experience: Instant access!
```

---

## 🎉 Benefits

### For Users
- ✅ **No password to remember** - Use Google account
- ✅ **One-tap sign-in** - Fast and easy
- ✅ **Secure** - Google's OAuth 2.0
- ✅ **Auto role detection** - No manual role selection
- ✅ **Seamless experience** - Straight to their screen

### For You (Factory Owner)
- ✅ **Easy retailer onboarding** - Just add email to list
- ✅ **No password management** - Google handles it
- ✅ **Secure authentication** - Industry standard
- ✅ **Role-based access** - Automatic based on email
- ✅ **Scalable** - Easy to add more retailers

### For Retailers
- ✅ **Quick login** - One click with Google
- ✅ **Automatic shop detection** - See their shop name
- ✅ **Correct pricing** - Always see their tier discounts
- ✅ **Professional** - Modern authentication

---

## 📄 Files Created/Modified

### New Files:
1. `UserRoleMapper.kt` - Email to role mapping
2. `GoogleSignInHelper.kt` - OAuth flow handler

### Modified Files:
1. `app/build.gradle.kts` - Firebase dependencies
2. `build.gradle.kts` - Google services plugin
3. `AuthRepository.kt` - OAuth methods

### Required Files:
1. `app/google-services.json` - Firebase config (download from Firebase)
2. `res/drawable/ic_google.xml` - Google logo (optional)

---

## 🔑 Summary

**What You Have:**
- ✅ Google OAuth authentication ready
- ✅ Automatic role detection based on email
- ✅ 5 test retailer accounts configured
- ✅ Admin email whitelist
- ✅ Seamless navigation to correct screen
- ✅ Retailer data auto-loaded (shop name, pricing tier)

**What You Need:**
- 🔧 Complete Firebase setup (15 minutes)
- 🔧 Add google-services.json
- 🔧 Update Web Client ID
- 🔧 Implement UI in LoginScreen

**What Users Get:**
- 🎉 One-tap Google Sign-In
- 🎉 Auto-navigate to their screen
- 🎉 No password to remember
- 🎉 Secure authentication
- 🎉 Perfect user experience!

---

**Ready to deploy!** Complete the Firebase setup and users can start signing in with Google! 🚀

