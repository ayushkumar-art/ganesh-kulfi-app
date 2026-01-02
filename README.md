# Kulfi Delight Android App

A native Android application for **Shri Ganesh Kulfi**, built with Kotlin and Jetpack Compose. This app provides a modern, user-friendly interface for browsing kulfi flavors, placing orders, and managing the business.

## 🎯 Features

- **User Authentication**: Firebase Authentication with email/password
- **Flavor Showcase**: Browse 14+ kulfi varieties with images and descriptions
- **Multi-language Support**: English, Hindi, and Marathi
- **Shopping Cart**: Add items and place orders
- **Order Management**: Track order status and history
- **Admin Dashboard**: Manage menu, inventory, and orders
- **Offline Support**: Room database for caching
- **Material Design 3**: Modern UI with custom saffron/cream theme

## 🏗️ Architecture

This app follows **Clean Architecture** principles with **MVVM** pattern:

```
app/
├── data/
│   ├── model/          # Data classes (Flavor, Order, User)
│   └── repository/     # Data sources (Firebase, Room)
├── domain/
│   └── usecase/        # Business logic
├── presentation/
│   ├── ui/             # Compose screens
│   ├── viewmodel/      # ViewModels
│   ├── navigation/     # Navigation setup
│   └── theme/          # Material Design theme
└── di/                 # Dependency Injection (Hilt)
```

## 🛠️ Tech Stack

- **Language**: Kotlin 1.9.20
- **UI**: Jetpack Compose (Material 3)
- **Architecture**: MVVM + Clean Architecture
- **Dependency Injection**: Hilt
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Image Loading**: Coil
- **Navigation**: Jetpack Navigation Compose
- **Database**: Room (offline caching)
- **Async**: Kotlin Coroutines & Flow
- **Build**: Gradle Kotlin DSL

## 📋 Prerequisites

- **Android Studio**: Hedgehog (2023.1.1) or later
- **JDK**: 17 or later
- **Minimum SDK**: 24 (Android 7.0)
- **Target SDK**: 34 (Android 14)

## 🚀 Setup Instructions

### 1. Clone the Repository

The Android project is located in the `android/KulfiDelightAndroid` folder of your main web app repository.

### 2. Configure Firebase

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your existing project: **kulfi-delight-3d**
3. Add an Android app:
   - Package name: `com.ganeshkulfi.app`
   - Register app
4. Download `google-services.json`
5. Replace the existing `app/google-services.json` with your downloaded file
6. **Important**: Update the `mobilesdk_app_id` in the file

### 3. Open in Android Studio

1. Open Android Studio
2. Click **File → Open**
3. Navigate to `android/KulfiDelightAndroid`
4. Click **OK**
5. Wait for Gradle sync to complete

### 4. Build the Project

```bash
# In Android Studio terminal
./gradlew build

# Or use Android Studio's Build menu
Build → Make Project
```

### 5. Run the App

1. Connect an Android device or start an emulator
2. Click the **Run** button (▶️) in Android Studio
3. Select your device
4. Wait for installation and launch

## 🔑 Firebase Setup Details

### Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Enable **Email/Password** provider
4. Save

### Create Firestore Database

1. Go to **Firestore Database**
2. Click **Create Database**
3. Choose **Start in test mode** (for development)
4. Select your region
5. Create collections:
   - `users`
   - `flavors`
   - `orders`

### Add Initial Flavors Data

You can add flavors manually in Firestore Console or run the app - it will use default flavors from `Flavor.kt`.

## 📱 App Structure

### Screens

- **Splash Screen**: Initial loading screen
- **Login/Signup**: User authentication
- **Home Screen**: 
  - Hero section
  - Flavor showcase grid
  - Brand story
  - Contact information
- **Cart**: Shopping cart (Coming soon)
- **Orders**: Order history (Coming soon)
- **Profile**: User profile (Coming soon)
- **Admin Dashboard**: Admin features (Coming soon)

### Data Models

#### Flavor
```kotlin
data class Flavor(
    val id: String,
    val key: String,
    val nameEn: String,
    val nameHi: String,
    val nameMr: String,
    val descriptionEn: String,
    val descriptionHi: String,
    val descriptionMr: String,
    val image: String,
    val tags: List<String>,
    val price: Int,
    val stock: Int,
    val isAvailable: Boolean
)
```

#### Order
```kotlin
data class Order(
    val id: String,
    val userId: String,
    val items: List<OrderItem>,
    val totalAmount: Double,
    val status: OrderStatus,
    val customerName: String,
    val customerPhone: String,
    val customerAddress: String,
    val createdAt: Timestamp
)
```

## 🎨 Theming

The app uses a custom Material Design 3 theme matching the web app:

- **Primary**: Saffron (#FFB347) - warmth and vibrancy
- **Background**: Cream (#F5F5DC) - soft and inviting
- **Accent**: Deep Brown (#8B4513) - depth and richness

## 🌍 Localization

Add translations to:
- `res/values/strings.xml` (English)
- `res/values-hi/strings.xml` (Hindi)
- `res/values-mr/strings.xml` (Marathi)

The system automatically selects based on device language.

## 🔧 Configuration

### Gradle Dependencies

All dependencies are managed in `app/build.gradle.kts`. Key libraries:

- Jetpack Compose BOM: 2023.10.01
- Firebase BOM: 32.7.0
- Hilt: 2.48
- Coil: 2.5.0
- Room: 2.6.1

### ProGuard Rules

Release builds use ProGuard rules in `proguard-rules.pro` to keep Firebase and data classes.

## 📦 Building Release APK

1. Generate a signing key:
```bash
keytool -genkey -v -keystore kulfi-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias kulfi
```

2. Add to `app/build.gradle.kts`:
```kotlin
android {
    signingConfigs {
        create("release") {
            storeFile = file("kulfi-release-key.jks")
            storePassword = "your-password"
            keyAlias = "kulfi"
            keyPassword = "your-password"
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

3. Build:
```bash
./gradlew assembleRelease
```

APK will be in `app/build/outputs/apk/release/`

## 🚧 Next Steps

### TODO List

- [ ] Add image assets to drawable folders
- [ ] Implement shopping cart functionality
- [ ] Create order placement flow
- [ ] Build admin dashboard screens
- [ ] Add push notifications
- [ ] Implement offline mode with Room
- [ ] Add unit tests
- [ ] Add UI tests
- [ ] Implement Google Maps for location
- [ ] Add payment gateway integration

### Adding Images

Place kulfi images in appropriate drawable folders:

```
res/
├── drawable/           # Default images
├── drawable-hdpi/      # High density
├── drawable-xhdpi/     # Extra high density
├── drawable-xxhdpi/    # Extra extra high
└── drawable-xxxhdpi/   # Extra extra extra high
```

Or use Firebase Storage and load with Coil:

```kotlin
AsyncImage(
    model = "https://firebasestorage.googleapis.com/...",
    contentDescription = "Kulfi"
)
```

## 🐛 Troubleshooting

### Gradle Sync Failed
- Ensure you have JDK 17 installed
- Check internet connection
- Try: File → Invalidate Caches → Invalidate and Restart

### Firebase Authentication Not Working
- Verify `google-services.json` is correct
- Check SHA-1 fingerprint in Firebase Console
- Enable Email/Password in Firebase Authentication

### App Crashes on Launch
- Check Logcat for error messages
- Verify Firebase configuration
- Ensure all permissions are granted

## 📄 License

This project is proprietary software for **Shri Ganesh Kulfi**.

## 👥 Credits

- **Founder**: Ganesh Raut
- **Location**: Kopargaon, Maharashtra
- **Developer**: Aditya Tilekar

## 📞 Support

For issues or questions, please contact the development team.

---

**Made with ❤️ for authentic kulfi lovers**
