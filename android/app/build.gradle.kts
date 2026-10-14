plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "io.nizamio.placeholder.nizamio"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // YER TUTUCU uygulama kimliği (varsayılan: emülatör, imzasız). Gerçek kimlik ve
        // imzalama bu altyapı çalışmasının dışındadır; README "Uygulama kimliği" bölümü.
        applicationId = "io.nizamio.placeholder.nizamio"
        // Asgari platform: Android 8.0 (API 26) — K-11 / D-0030.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Flavor'lar (K-11; uygulama adı src/<flavor>/res/values/strings.xml): dev — localhost/emülatör için http serbest; prod — yalnız https.
    // Dart tarafındaki asıl kapı lib/core/server/ (prod'da http reddedilir); buradaki ağ
    // güvenlik yapılandırması platform katmanında ikinci savunmadır (src/<flavor>/res/xml).
    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
        }
        create("prod") {
            dimension = "env"
        }
    }

    buildTypes {
        release {
            // İmzalama bu altyapı çalışmasının dışındadır: yayın derlemesi yalnız `--obfuscate`
            // denetimi içindir ve debug anahtarıyla imzalanır; dağıtılmaz.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
