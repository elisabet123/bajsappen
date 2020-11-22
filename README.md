# bajsappen

To get the icon, one might need to run

```
flutter pub pub run flutter_launcher_icons:main
```

## release procedure
1. run scripts/increase_version.sh (change version number in android/app/build.gradle and pubspec.yaml, commit, create appbundle)
1. commit & push
1. run `flutter build appbundle`
1. create release in github web UI: https://github.com/elisabet123/bajsappen/releases
1. create release in google play https://play.google.com/apps/publish/
1. upload the bundle created in step 2 (<app dir>/build/app/outputs/bundle/release/app.aab)
