pluginManagement {
    val flutterSdkPath =
        run {
            val localPropertiesFile = file("local.properties")
            if (!localPropertiesFile.exists()) {
                throw GradleException("File 'local.properties' not found. Please create it in the 'android' directory.")
            }
            val properties = java.util.Properties()
            localPropertiesFile.inputStream().use { input ->
                properties.load(input)
            }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "'flutter.sdk' not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
