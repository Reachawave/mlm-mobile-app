plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
        import java.io.FileInputStream

// Load keystore props (must be at project root)
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (!keystorePropertiesFile.exists()) {
    throw GradleException("key.properties not found at project root: ${keystorePropertiesFile.absolutePath}")
}
keystoreProperties.load(FileInputStream(keystorePropertiesFile))

fun prop(name: String): String =
    (keystoreProperties[name] as String?)?.takeIf { it.isNotBlank() }
        ?: throw GradleException("Missing '$name' in key.properties")

val storePath = prop("storeFile")
val storeFileObj = file(storePath)
if (!storeFileObj.exists()) {
    throw GradleException("Keystore file not found at '$storePath' (resolved: ${storeFileObj.absolutePath})")
}

android {
    namespace = "com.reachawave.new_project"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }

    defaultConfig {
        applicationId = "com.reachawave.new_project"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = prop("keyAlias")
            keyPassword = prop("keyPassword")
            storeFile = storeFileObj
            storePassword = prop("storePassword")
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release") // must be release
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        getByName("debug") { isDebuggable = true }
    }
}

flutter { source = "../.." }
