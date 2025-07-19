plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase plugin
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.myapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.myapp"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("com.google.firebase:firebase-analytics:21.0.0") // Firebase Analytics
    implementation("com.google.firebase:firebase-auth:21.0.1") // Firebase Authentication
    implementation("com.google.firebase:firebase-firestore:24.0.0") // Firebase Firestore
    implementation("com.google.firebase:firebase-messaging:23.0.0") // Firebase Messaging (Optional)
    implementation ("com.google.android.gms:play-services-tflite-gpu:16.1.0")
    // Add other Firebase dependencies as needed
}

flutter {
    source = "../.." // Your Flutter SDK source path
}

buildscript {
    dependencies {
        // Correct syntax for Kotlin DSL:
        classpath("com.google.gms:google-services:4.4.3")  // Firebase plugin classpath
    }
}

// Apply the google-services plugin at the bottom of the file
apply(plugin = "com.google.gms.google-services")
