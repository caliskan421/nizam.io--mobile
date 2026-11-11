plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "io.nizamio.mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Ürün sahibi kabulü: prod io.nizamio.mobile, dev .dev ekiyle ayrılır.
        // Mağaza imzalaması henüz tamamlanmadı; README "Uygulama kimliği" bölümü.
        applicationId = "io.nizamio.mobile"
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

// Yalnız flavor'a ait istemci yapılandırması okunur; kök/build-type fallback yoktur.
// Google Services mevcut dosyada applicationId ile eşleşen client arar ve yoksa durur.
val prodFirebaseConfig = layout.projectDirectory.file("src/prod/google-services.json")
val prodFirebaseCleanup = listOf("Debug", "Profile", "Release").associate { buildType ->
    val processingTaskName = "processProd${buildType}GoogleServices"
    processingTaskName to tasks.register<Delete>("${processingTaskName}Cleanup") {
        onlyIf { !prodFirebaseConfig.asFile.exists() }
        // Düz dosya sağlayıcısı kullanılır: çıktı sağlayıcısının örtük üretici
        // bağımlılığı cleanup → processing → cleanup döngüsü oluşturmamalı.
        delete(provider {
            tasks.named<com.google.gms.googleservices.GoogleServicesTask>(processingTaskName)
                .get().outputDirectory.get().asFile
        })
    }
}
tasks.withType<com.google.gms.googleservices.GoogleServicesTask>().configureEach {
    val flavor = when {
        name.startsWith("processDev") -> "dev"
        name.startsWith("processProd") -> "prod"
        else -> error("Bilinmeyen Firebase varyantı: $name")
    }
    val config = layout.projectDirectory.file("src/$flavor/google-services.json")
    googleServicesJsonFiles.set(listOf(config.asFile))
    if (flavor == "prod" && !config.asFile.exists()) {
        // Dev/prod çıktıları ayrıdır; yalnız bu Google Services varyantının eski
        // kaynaklarını temizle. Dev görevleri aynı assemble çağrısında çalışabilir.
        dependsOn(prodFirebaseCleanup.getValue(name))
        enabled = false
    }
}
