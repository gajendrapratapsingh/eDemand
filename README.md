# e_demand


//to run the application
```shell
flutter run
```

//To update iOS pods
```shell
cd ios
pod init
pod update
pod install
cd ..
```

//To clean the pub cache
```shell
flutter clean
flutter pub cache clean
flutter pub get
```

//To repair the pub cache
```shell
flutter clean
flutter pub cache repair
flutter pub get
```

//to generate android application
```shell
flutter build apk --split-per-abi
open  build/app/outputs/flutter-apk/
```

// to solve most common iOS errors
```shell
flutter clean
rm -Rf ios/Pods
rm -Rf ios/.symlinks
rm -Rf ios/Flutter/Flutter.framework
rm -Rf Flutter/Flutter.podspec
rm ios/podfile.lock
cd ios 
pod deintegrate
sudo rm -rf ~/Library/Developer/Xcode/DerivedData
flutter pub cache repair
flutter pub get 
Pod update 
pod install 
```

//to run application in release mode
```shell
flutter run --release
```
