# flutter_nuvei_sdk

**** Important: Note that the current package is only for testing ****

Native SDK documentation 👉 https://docs.nuvei.com/documentation/accept-payment/mobile-sdk/

# Install package plugin
Go to [project]/pubspec.yaml
```
flutter_nuvei_sdk:
    git:
      url: https://github.com/TrinhCDanh/flutter_nuvei_sdk.git
      ref: master
```

# iOS Configuration
Go to https://docs.nuvei.com/documentation/accept-payment/mobile-sdk/ios-native-sdk/
### Edit Podfile
Go to [project]/ios/Podfile
```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES' // Add this line     
    end
  end
end
```

# Android Configuration
Go to https://docs.nuvei.com/documentation/accept-payment/mobile-sdk/android-native-sdk/
### Step 1: Configure Android
Go to [project]/android/app/build.gradle
```
android {
    compileSdkVersion 34 // Change version number
    
    ...
    ...

    packagingOptions {
        exclude 'META-INF/DEPENDENCIES'
        exclude 'META-INF/LICENSE.md'
        exclude 'META-INF/NOTICE.md'
    }
}
```
Go to [project]/android/build.gradle
```
allprojects {
    repositories {
        google()
        mavenCentral()
        // ---> Add code below
        maven {
            url "https://raw.githubusercontent.com/Nuvei/nuvei-maven-android/master"
        }
    }
}
```
### Step 2: Edit Your Manifest
Go to [project]/android/app/src/main/AndroidManifest.xml
```
<application
    ...
    android:theme="@style/Theme.AppCompat"
>
```
# Example code

[example](https://github.com/TrinhCDanh/flutter_nuvei_sdk/tree/master/example)