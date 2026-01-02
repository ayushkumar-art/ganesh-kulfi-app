# Retailer Navigation Fix

## Problem
After adding a new retailer through the admin panel, the app was navigating to the customer/retailer screen instead of keeping the admin in the admin dashboard.

## Root Cause
When `addRetailerWithCredentials()` was called in `AdminViewModel`, it used `authRepository.signUpRetailer()` which:
1. Created the retailer credentials
2. **Set `_currentUser.value = user`** (changed the logged-in user from admin to the new retailer)

This caused the UI to react as if the admin had logged out and the new retailer logged in, triggering navigation to the wrong screen.

## Solution

### 1. Created New Method: `registerRetailerCredentials()`
Added a new method in `AuthRepository` that registers retailer credentials **without changing the current user session**.

**Key Differences:**
- `signUpRetailer()`: Creates credentials AND logs in as that user
- `registerRetailerCredentials()`: Creates credentials WITHOUT logging in

### 2. Updated Credential Storage Pattern
Retailer credentials are now stored with a unique key pattern:
```kotlin
val credentialKey = "retailer_cred_$email"
sharedPreferences.edit() {
    putString("${credentialKey}_email", email)
    putString("${credentialKey}_password", password)
    putString("${credentialKey}_name", name)
    // ... other fields
}
```

### 3. Updated Sign-In Logic
Enhanced `signIn()` to check for retailer credentials registered via admin:
```kotlin
// Check for retailer credentials registered via admin
val credentialKey = "retailer_cred_$email"
val storedRetailerEmail = sharedPreferences.getString("${credentialKey}_email", null)
val storedRetailerPassword = sharedPreferences.getString("${credentialKey}_password", null)

if (storedRetailerEmail == email && storedRetailerPassword == password) {
    // Load retailer data and create session
    // ...
}
```

### 4. Updated AdminViewModel
Changed `addRetailerWithCredentials()` to use the new method:
```kotlin
// OLD:
authRepository.signUpRetailer(...)  // This changed current user!

// NEW:
authRepository.registerRetailerCredentials(...)  // Keeps admin logged in
```

## How It Works Now

### When Admin Creates a Retailer:
1. Admin clicks "Add Retailer" in `RetailerManagementScreen`
2. `AdminViewModel.addRetailerWithCredentials()` is called
3. Retailer is created in `RetailerRepository`
4. Credentials are registered via `registerRetailerCredentials()`
5. **Admin stays logged in** (currentUser remains admin)
6. Admin sees the credentials dialog
7. Admin stays in the admin dashboard

### When Retailer Signs In:
1. Retailer enters email/password on login screen
2. `signIn()` checks retailer credentials
3. Finds credentials stored with key pattern `retailer_cred_$email`
4. Creates a session for the retailer
5. Sets `_currentUser.value = retailerUser`
6. Navigation triggers to retailer home screen

## Files Modified

### 1. `AuthRepository.kt`
- Added `registerRetailerCredentials()` method
- Updated `signIn()` to check retailer credentials with new key pattern
- Added documentation to clarify `signUpRetailer()` vs `registerRetailerCredentials()`

### 2. `AdminViewModel.kt`
- Changed `addRetailerWithCredentials()` to use `registerRetailerCredentials()`
- Added comment explaining the fix

## Testing Checklist

- [x] No compilation errors
- [ ] Admin can create retailer without being logged out
- [ ] Created retailer can sign in with generated credentials
- [ ] Retailer is navigated to retailer home screen on sign-in
- [ ] Admin stays in admin dashboard after creating retailer
- [ ] Credentials dialog shows correct email/password

## Future Improvements

1. **Add Result States**: Return success/failure states to UI instead of just printing errors
2. **Encrypted Storage**: Move to `EncryptedSharedPreferences` for credential storage
3. **Migrate to Database**: Store retailer credentials in Room database instead of SharedPreferences
4. **Add Validation**: Validate email format and password strength before registration

## Related Issues
- Fixed: "Failed to load user" bug (previous fix)
- Fixed: "Customer screen showed up after adding retailer" (this fix)
