# Photo Widget Extension (iOS)

Add the Widget Extension target in Xcode:

1. Open `ios/Runner.xcworkspace`.
2. File → New → Target → Widget Extension.
3. Name: `PhotoWidgetExtension`, include Live Activity: **off**.
4. Replace generated Swift files with the sources in this folder.
5. Set **App Groups** capability on Runner and PhotoWidgetExtension: `group.com.example.cleaner_app`.
6. Assign `Runner.entitlements` and `PhotoWidgetExtension.entitlements` to each target.
7. Set extension bundle ID: `com.example.cleanerApp.PhotoWidgetExtension` (or your app ID suffix).

After setup, `PhotoWidgetChannel` copies manifest/images into the App Group when Flutter calls `saveWidgetConfig`.
