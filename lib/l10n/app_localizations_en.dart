// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cleaner App';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonOk => 'OK';

  @override
  String get commonDone => 'Done';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonShare => 'Share';

  @override
  String get commonSave => 'Save';

  @override
  String get commonTryAgain => 'Try again';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSettings => 'Settings';

  @override
  String get navClean => 'Clean';

  @override
  String get navContacts => 'Contacts';

  @override
  String get navCompress => 'Compress';

  @override
  String get navMore => 'More';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionUpgrade => 'UPGRADE';

  @override
  String get settingsRestorePurchases => 'Restore Purchases';

  @override
  String get settingsSectionPrivatePhoto => 'PRIVATE PHOTO SETTINGS';

  @override
  String get settingsPrivateVault => 'Private Vault';

  @override
  String get settingsUsePasscode => 'Use Passcode';

  @override
  String get settingsRemoveAfterImport => 'Remove After Import';

  @override
  String get settingsSectionCustom => 'CUSTOM SETTINGS';

  @override
  String get settingsPhotoWidget => 'Photo Widget';

  @override
  String get settingsFaceId => 'Face ID';

  @override
  String get settingsLanguages => 'Languages';

  @override
  String get settingsSectionOthers => 'OTHERS';

  @override
  String get settingsGetHelp => 'Get Help';

  @override
  String get settingsRate5Stars => 'Rate 5 Stars';

  @override
  String get settingsShareWithFriends => 'Share With Friends';

  @override
  String get settingsAboutUs => 'About Us';

  @override
  String get settingsTermsAndConditions => 'Terms and Conditions';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsThemeMode => 'Theme Mode';

  @override
  String get settingsAppLock => 'App Lock';

  @override
  String get languagePickerTitle => 'Languages';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUrdu => 'Urdu';

  @override
  String get languageChinese => 'Chinese';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get cleanerAppTitle => 'Cleaner';

  @override
  String get cleanerPro => 'PRO';

  @override
  String get cleanerSortLargestFirst => 'Largest first';

  @override
  String get cleanerSortSmallestFirst => 'Smallest first';

  @override
  String get cleanerSortNewestDateFirst => 'Newest date first';

  @override
  String get cleanerSortOldestDateFirst => 'Oldest date first';

  @override
  String get cleanerAnalyzingLibrary => 'Analyzing your library';

  @override
  String get cleanerUnknownError => 'Unknown error';

  @override
  String get cleanerScanPreparing => 'Preparing…';

  @override
  String get cleanerScanLoadingLibrary => 'Loading library…';

  @override
  String get cleanerScanFindingDuplicates => 'Finding duplicate files…';

  @override
  String get cleanerScanFindingSimilar => 'Finding similar photos…';

  @override
  String get cleanerScanDone => 'Done';

  @override
  String get cleanerScanSomethingWentWrong => 'Something went wrong';

  @override
  String get cleanerCategorySimilarPhotos => 'Similar Photos';

  @override
  String get cleanerCategoryDuplicatePhotos => 'Duplicate Photos';

  @override
  String get cleanerCategorySimilarVideos => 'Similar Videos';

  @override
  String get cleanerCategoryVideos => 'Videos';

  @override
  String get cleanerCategoryScreenshots => 'Screenshots';

  @override
  String get cleanerCategorySimilarLivePhotos => 'Similar Live Photos';

  @override
  String get cleanerOptimizeYourStorage => 'Optimize Your Storage';

  @override
  String get cleanerAiPhotoEditor => 'AI Photo Editor';

  @override
  String get cleanerImprovePhotoQuality => 'Improve photo quality';

  @override
  String get cleanerPickPhotoToEnhance => 'Pick a photo to enhance';

  @override
  String get cleanerPickOldPhotoToRestore => 'Pick an old photo to restore';

  @override
  String get cleanerPhotosAccessTitle => 'Photos access';

  @override
  String get cleanerPhotosAccessBlocked => 'Photo access is blocked. Enable it in Settings to pick images.';

  @override
  String get cleanerPhotosAccessRequest => 'Allow photo library access to choose an image.';

  @override
  String get cleanerCouldNotOpenImage => 'Could not open that image.';

  @override
  String get cleanerCrop => 'Crop';

  @override
  String get cleanerPhotoSavedToGallery => 'Photo saved to your gallery.';

  @override
  String cleanerCouldNotSaveToGallery(String error) {
    return 'Could not save to gallery: $error';
  }

  @override
  String get cleanerAiPhotoEditorTitle => 'AI Photo Editor';

  @override
  String get cleanerChooseFromLibrary => 'Choose from library';

  @override
  String get cleanerPhotoEnhance => 'Photo Enhance';

  @override
  String get cleanerBoostQuality => 'Boost quality';

  @override
  String get cleanerFixOldPhoto => 'Fix Old Photo';

  @override
  String get cleanerRestoreOldMemories => 'Restore old memories';

  @override
  String get cleanerNoPhotosFound => 'No photos found';

  @override
  String get cleanerStorageUsed => 'Used:';

  @override
  String get cleanerStorageUnavailable => '—';

  @override
  String get cleanerBest => 'Best';

  @override
  String get cleanerDeleteSelected => 'Delete selected';

  @override
  String cleanerGroupNumber(int number) {
    return 'Group $number';
  }

  @override
  String get cleanerDeletedTitle => 'Deleted';

  @override
  String cleanerDeletedMessage(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items · $size freed',
      one: '1 item · $size freed',
    );
    return '$_temp0';
  }

  @override
  String get cleanerSomeItemsNotRemoved => 'Some items were not removed';

  @override
  String cleanerSomeItemsFailed(int count) {
    return '$count failed';
  }

  @override
  String get cleanerNothingDeleted => 'Nothing deleted';

  @override
  String get cleanerNothingDeletedHint => 'Try again or check photo permissions.';

  @override
  String cleanerSelectedSummary(int count, String size) {
    return '$count selected · $size';
  }

  @override
  String get contactsTitle => 'Contacts';

  @override
  String get contactsAccessNeeded => 'Contacts access needed';

  @override
  String get contactsAccessBody => 'Allow access to your contacts to see counts, lists, backups, and to open the system editor.';

  @override
  String get contactsOpenSettings => 'Open settings';

  @override
  String get contactsBackup => 'Contacts Backup';

  @override
  String get contactsDuplicateContacts => 'Duplicate Contacts';

  @override
  String get contactsIncompleteContacts => 'Incomplete Contacts';

  @override
  String get contactsNamesNumbersEmails => 'Names. Numbers. Emails.';

  @override
  String get contactsIncompleteDescription => 'Every contact has a name, at least one number, and at least one email.';

  @override
  String get contactsNoName => 'No name';

  @override
  String contactsMissingPrefix(String fields) {
    return 'Missing: $fields';
  }

  @override
  String get contactsMissingName => 'name';

  @override
  String get contactsMissingNumber => 'number';

  @override
  String get contactsMissingEmail => 'email';

  @override
  String get contactsSelect => 'Select';

  @override
  String get contactsSearchHint => 'Search via name, number or email';

  @override
  String get contactsNoSearchResults => 'No contacts match your search.';

  @override
  String get contactsNoDuplicates => 'No duplicate groups found by phone or name.';

  @override
  String get contactsSameNumber => 'Same number';

  @override
  String get contactsSameName => 'Same name';

  @override
  String get contactsSharedNumber => 'Shared number';

  @override
  String get contactsExportTitle => 'Export your contacts';

  @override
  String get contactsExportBody => 'Creates a single .vcf file with your contacts so you can save it to Files, AirDrop it, or open it in another app.';

  @override
  String get contactsExportPreparing => 'Preparing…';

  @override
  String get contactsExportAllShare => 'Export all & share';

  @override
  String get contactsExportSubsetHint => 'You can also pick contacts from the main list, tap Select, then share a subset.';

  @override
  String contactsShareCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contacts',
      one: '1 contact',
    );
    return 'Share $_temp0';
  }

  @override
  String contactsGroupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contacts',
      one: '1 contact',
    );
    return '$_temp0';
  }

  @override
  String get compressTitle => 'Compress';

  @override
  String get compressVideoSaveUpTo => 'Compress video to save up to';

  @override
  String get compressSort => 'Sort';

  @override
  String get compressRefresh => 'Refresh';

  @override
  String get compressClear => 'Clear';

  @override
  String get compressNext => 'Next';

  @override
  String get compressButton => 'COMPRESS';

  @override
  String get compressNoVideosFound => 'No videos found';

  @override
  String get compressNoVideosBody => 'Videos will appear here after gallery access is granted.';

  @override
  String get compressReload => 'Reload';

  @override
  String get compressMediaAccessBlocked => 'Media access blocked';

  @override
  String get compressAllowMediaAccess => 'Allow media access';

  @override
  String get compressMediaBlockedBody => 'Open system settings and enable gallery access to compress videos.';

  @override
  String get compressMediaRequestBody => 'Cleaner needs access to your gallery before it can show videos for compression.';

  @override
  String get compressAllowAccess => 'Allow access';

  @override
  String get compressRetry => 'Retry';

  @override
  String get compressNoMediaSelected => 'No media selected';

  @override
  String get compressNoMediaSelectedBody => 'Go back and select at least one video.';

  @override
  String get compressQuality => 'Quality';

  @override
  String get compressCompressionResults => 'Compression results';

  @override
  String get compressQualityLow => 'Low';

  @override
  String get compressQualityMedium => 'Medium';

  @override
  String get compressQualityHigh => 'High';

  @override
  String compressQualitySavings(int percent) {
    return 'Compress $percent%';
  }

  @override
  String get compressSelectMediaTitle => 'Select media to compress';

  @override
  String get compressSelectMediaBody => 'Pick one or more images/videos, then continue to quality selection and compression.';

  @override
  String get compressManageAccess => 'Manage access';

  @override
  String get compressVisibleItems => 'Visible items';

  @override
  String get compressSelected => 'Selected';

  @override
  String get compressSelectedSize => 'Selected size';

  @override
  String get compressOriginal => 'Original';

  @override
  String get compressCompressed => 'Compressed';

  @override
  String compressEstimatedSavings(String size) {
    return 'Estimated savings: $size';
  }

  @override
  String get compressSelectedVideo => 'Selected video';

  @override
  String get compressSelectedImage => 'Selected image';

  @override
  String get compressCompressedFile => 'Compressed file';

  @override
  String compressFromSize(String size) {
    return 'From $size';
  }

  @override
  String compressToSize(String size) {
    return 'To $size';
  }

  @override
  String compressSavedSize(String size) {
    return 'Saved $size';
  }

  @override
  String get compressCompressionProgress => 'Compression progress';

  @override
  String compressCurrentFile(String label) {
    return 'Current file: $label';
  }

  @override
  String compressCurrentFileProgress(int percent) {
    return 'Current file progress: $percent%';
  }

  @override
  String compressProgressDone(int processed, int total, String remaining) {
    return '$processed of $total done · $remaining remaining';
  }

  @override
  String compressProgressButton(int percent, String remaining) {
    return '$percent% · $remaining left';
  }

  @override
  String compressSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
    );
    return '$_temp0';
  }

  @override
  String compressItemsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items selected',
      one: '1 item selected',
    );
    return '$_temp0';
  }

  @override
  String get compressUnableCheckPermission => 'Unable to check media permission state.';

  @override
  String get compressUnableRequestPermission => 'Unable to request media permission.';

  @override
  String get compressUnableLoadGallery => 'Unable to load gallery media.';

  @override
  String get compressUnableLoadMore => 'Unable to load more media.';

  @override
  String get compressReadyToCompress => 'Ready to compress';

  @override
  String get compressPreparingCompression => 'Preparing compression';

  @override
  String compressCompressingItem(String label) {
    return 'Compressing $label';
  }

  @override
  String get compressFinalizingCompression => 'Finalizing compression';

  @override
  String compressCompressedCount(int done, int total) {
    return 'Compressed $done of $total';
  }

  @override
  String get compressCompressionComplete => 'Compression complete';

  @override
  String compressCompressedSummary(int success, int total) {
    return 'Compressed $success of $total items';
  }

  @override
  String get compressUnableCompressSelected => 'Unable to compress the selected media.';

  @override
  String compressFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items could not be compressed.',
      one: '1 item could not be compressed.',
    );
    return '$_temp0';
  }

  @override
  String compressSuccessMessage(String size, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Saved compressed copies to gallery. Total saved: $size across $_temp0.';
  }

  @override
  String get compressOriginalUnavailable => 'Original file is no longer available.';

  @override
  String compressCompressionFailed(String error) {
    return 'Compression failed: $error';
  }

  @override
  String get moreToolsTitle => 'More Tools';

  @override
  String get morePrivatePhotos => 'Private Photos';

  @override
  String get morePrivatePhotosSubtitle => 'Protect your secret photos';

  @override
  String get moreChargingAnimation => 'Charging Animation';

  @override
  String get moreChargingAnimationSubtitle => 'Customize charging screen';

  @override
  String get moreCleaningGuide => 'Cleaning Guide';

  @override
  String get moreCleaningGuideSubtitle => 'Learn how to clean safely';

  @override
  String get guideTitle => 'Cleanup Guide';

  @override
  String get guideSectionApps => 'Apps';

  @override
  String get guideSectionCache => 'App\'s Cache';

  @override
  String get guideOffloadUnusedApps => 'Offload Unused Apps';

  @override
  String get guideDeleteUnusedApps => 'Delete Unused Apps';

  @override
  String get guideFlowTitle => 'Offload Unused Apps';

  @override
  String get guideStepOpenSettings => 'Open Settings';

  @override
  String get guideStepClickGeneral => 'Click General';

  @override
  String get guideStepTapIphoneStorage => 'Tap iPhone Storage';

  @override
  String get guideStepEnableOffload => 'Enable Offload Unused Apps';

  @override
  String get guideFlowNext => 'Next';

  @override
  String get guideFlowClose => 'Close Guide';

  @override
  String get guideClean => 'Clean';

  @override
  String get chargingAnimationTitle => 'Charging Animation';

  @override
  String get chargingViewAnimation => 'View animation';

  @override
  String get chargingBrowseAnimations => 'Browse animations';

  @override
  String get chargingAllowLockScreenOnCharge => 'Allow lock screen on charge';

  @override
  String get chargingLockScreenSetup => 'Lock screen setup';

  @override
  String get chargingChooseAnimation => 'Choose an animation';

  @override
  String get chargingNoAnimationSelected => 'No animation selected';

  @override
  String get chargingChooseAnimationAppBar => 'Choose animation';

  @override
  String get chargingApplyAnimation => 'Apply animation';

  @override
  String chargingBatteryPercent(int level) {
    return '$level%';
  }

  @override
  String get chargingHeadlineCharging => 'Charging';

  @override
  String get chargingHeadlineFullyCharged => 'Fully charged';

  @override
  String get chargingHeadlineDisconnected => 'Disconnected';

  @override
  String get chargingHeadlineBatteryStatus => 'Battery status';

  @override
  String get chargingHeadlinePowerConnected => 'Power connected';

  @override
  String get chargingSubtitleCharging => 'Your device is drawing power.';

  @override
  String get chargingSubtitleFullyCharged => 'You can unplug whenever you are ready.';

  @override
  String get chargingSubtitleDisconnected => 'Plug in to see your charging animation.';

  @override
  String get chargingSubtitleUnknown => 'Battery state unavailable on this device.';

  @override
  String get chargingSubtitleConnectedNotCharging => 'Power connected; battery is not actively charging.';

  @override
  String get chargingAppliedTitle => 'Applied';

  @override
  String chargingAppliedMessage(String title) {
    return '$title is now your charging animation.';
  }

  @override
  String get chargingAnimationSemantics => 'Charging animation';

  @override
  String get chargingMissingLottieAsset => 'Missing Lottie asset path';

  @override
  String get chargingStepApplyAnimation => 'Apply an animation from Browse animations.';

  @override
  String get chargingStepOpenWhileCharging => 'Open the app while the phone is charging.';

  @override
  String get chargingStepIosNoLockScreen => 'Lock-screen auto show is not supported on iPhone.';

  @override
  String get chargingStepBrowsePreviewApply => 'Browse animations → Preview → Apply animation.';

  @override
  String get chargingStepAllowLockScreen => 'Tap \"Allow lock screen on charge\" below (battery optimization).';

  @override
  String get chargingStepLockAndPlugIn => 'Lock the phone, plug in the charger — animation should appear.';

  @override
  String get chargingStepOemSettings => 'Samsung / Xiaomi / Oppo: Settings → Apps → Cleaner App → allow background & display on lock screen.';

  @override
  String get chargingPlatformNoteIos => 'Lock-screen animation is not supported on iPhone. Open the app while charging to view your animation.';

  @override
  String get chargingPlatformNoteAndroid => 'On Android, plug in your charger to see the animation. Enable lock-screen display in settings if needed.';

  @override
  String get chargingAnimNeonBattery => 'Neon Battery';

  @override
  String get chargingAnimCircularCharge => 'Circular Charge';

  @override
  String get chargingAnimCyberpunk => 'Cyberpunk';

  @override
  String get chargingAnimGlowingEnergy => 'Glowing Energy';

  @override
  String get chargingAnimMinimalBattery => 'Minimal Battery';

  @override
  String get chargingAnimFuturisticPulse => 'Futuristic Pulse';

  @override
  String get chargingAnimLiquidWave => 'Liquid Wave';

  @override
  String get chargingAnimAuroraRing => 'Aurora Ring';

  @override
  String get appLockLocked => 'App locked';

  @override
  String get appLockEnterPinOrBiometrics => 'Enter your PIN or use biometrics.';

  @override
  String get appLockSetupTitle => 'Set up App Lock';

  @override
  String get appLockCreatePin => 'Create a 4-digit PIN';

  @override
  String get appLockConfirmPin => 'Confirm your PIN';

  @override
  String get appLockCreatePinHint => 'You will use this PIN to unlock the app.';

  @override
  String get appLockConfirmPinHint => 'Enter the same PIN again.';

  @override
  String get appLockEnableBiometric => 'Enable Face ID / fingerprint';

  @override
  String get appLockBiometricSubtitle => 'Unlock the app without typing your PIN.';

  @override
  String get appLockContinue => 'Continue';

  @override
  String get appLockFinishSetup => 'Finish setup';

  @override
  String get appLockTurnOffTitle => 'Turn off App Lock';

  @override
  String get appLockEnterPinToTurnOff => 'Enter PIN to turn off App Lock';

  @override
  String get appLockVerifyPinToDisable => 'Verify your current PIN to disable app lock.';

  @override
  String get appLockTooManyAttempts => 'Too many attempts. Try again or use biometrics.';

  @override
  String get appLockIncorrectPin => 'Incorrect PIN. Try again.';

  @override
  String get appLockPinsDoNotMatch => 'PINs do not match. Start again.';

  @override
  String get appLockSetupFailed => 'Setup failed';

  @override
  String get appLockCouldNotDisable => 'Could not disable';

  @override
  String get appLockSnackbarTitle => 'App Lock';

  @override
  String get appLockBiometricReason => 'Unlock Cleaner App';

  @override
  String get photoWidgetTitle => 'Photo Widget';

  @override
  String get photoWidgetShowOnHomeScreen => 'Show on home screen';

  @override
  String get photoWidgetActive => 'Widget is active';

  @override
  String get photoWidgetTurnOnAfterImport => 'Turn on after importing photos';

  @override
  String get photoWidgetImportFirst => 'Import photos into an album first';

  @override
  String get photoWidgetMyAlbums => 'My albums';

  @override
  String get photoWidgetWidgetStyle => 'Widget style';

  @override
  String get photoWidgetCreateAlbum => 'Create an Album';

  @override
  String get photoWidgetEnterAlbumName => 'Enter the name of album:';

  @override
  String get photoWidgetWidgetSource => 'Widget source';

  @override
  String get photoWidgetAlbum => 'Album';

  @override
  String get photoWidgetAlbumNotFound => 'Album not found';

  @override
  String get photoWidgetUseForHomeScreen => 'Use for home screen widget';

  @override
  String get photoWidgetActiveAlbum => 'Active widget album';

  @override
  String get photoWidgetAddNewPhotos => 'Add New Photos';

  @override
  String get photoWidgetImportPhotos => 'Import Photos';

  @override
  String get photoWidgetImportPhotosTitle => 'Import photos';

  @override
  String photoWidgetDoneCount(int count) {
    return 'Done ($count)';
  }

  @override
  String photoWidgetSelectUpTo(int max) {
    return 'Select up to $max photos.';
  }

  @override
  String get photoWidgetGrid => 'Grid';

  @override
  String get photoWidgetSlideshow => 'Slideshow';

  @override
  String get photoWidgetPreview => 'Preview';

  @override
  String get photoWidgetGridDescription => 'Shows a 2×2 grid of your photos on the home screen widget.';

  @override
  String get photoWidgetSlideshowDescription => 'Rotates through photos on a timer (minimum 15 seconds).';

  @override
  String get photoWidgetRenameAlbum => 'Rename album';

  @override
  String get photoWidgetDeleteAlbumTitle => 'Delete album?';

  @override
  String get photoWidgetDeleteAlbumBody => 'Photos in this album will be removed from the widget cache.';

  @override
  String get photoWidgetAddWidgetTitle => 'Add Photo Widget';

  @override
  String get photoWidgetHelpAndroid => '1. Import photos in an album (widget turns on automatically)\n2. Long-press your home screen → Widgets\n3. Find Cleaner App → Photo Widget\n4. Drag it to your home screen\n\nOr tap below to pin the widget (Android 8+).';

  @override
  String get photoWidgetHelpIos => '1. Long-press your home screen\n2. Tap the + button\n3. Search for Cleaner App\n4. Choose Photo Widget size and tap Add Widget\n\nNote: iOS widgets refresh on a timeline and may not update instantly.';

  @override
  String get photoWidgetPinWidget => 'Pin widget';

  @override
  String get photoWidgetPinWidgetButton => 'Pin widget to home screen';

  @override
  String get photoWidgetPinFollowPrompt => 'Follow the system prompt to add the widget.';

  @override
  String get photoWidgetPinManualSteps => 'Use the manual steps above if pin is unavailable.';

  @override
  String get photoWidgetHelp => 'Help';

  @override
  String photoWidgetDefaultAlbumName(int number) {
    return 'Album $number';
  }

  @override
  String get photoWidgetPermissionRequired => 'Permission required';

  @override
  String get photoWidgetAllowPhotoAccess => 'Allow photo access to import images.';

  @override
  String get photoWidgetLimitReached => 'Limit reached';

  @override
  String get photoWidgetAlbumFull => 'This album is full (30 photos max).';

  @override
  String photoWidgetImportLimit(int max) {
    return 'You can import up to $max photos at a time.';
  }

  @override
  String get photoWidgetImportFailed => 'Import failed';

  @override
  String get photoWidgetCouldNotSave => 'Could not save selected photos.';

  @override
  String get photoWidgetPartialImport => 'Partial import';

  @override
  String photoWidgetPartialImportMessage(int imported, int total) {
    return 'Imported $imported of $total photos (limits apply).';
  }

  @override
  String get photoWidgetAddToHomeTitle => 'Add widget to home screen';

  @override
  String get photoWidgetAddToHomeBody => 'Long-press home screen → Widgets → Photo Widget, or tap help (?) to pin.';

  @override
  String get photoWidgetUpdated => 'Widget updated';

  @override
  String get photoWidgetUpdatedBody => 'Add or refresh the Photo Widget on your home screen to see photos.';

  @override
  String get photoWidgetPinSnackbarTitle => 'Widget';

  @override
  String get vaultPrivatePhotos => 'Private Photos';

  @override
  String vaultMediaCount(int photos, int videos) {
    String _temp0 = intl.Intl.pluralLogic(
      photos,
      locale: localeName,
      other: '$photos Photos',
      one: '1 Photo',
    );
    String _temp1 = intl.Intl.pluralLogic(
      videos,
      locale: localeName,
      other: '$videos Videos',
      one: '1 Video',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get vaultSelectAll => 'Select All';

  @override
  String get vaultDeleteSelected => 'Delete Selected';

  @override
  String get vaultAddPhotos => 'Add Photos';

  @override
  String get vaultCouldNotOpen => 'Could not open Private Photos';

  @override
  String get vaultGoBack => 'Go back';

  @override
  String get vaultEmptyState => 'Select Photos to begin importing.\nThey will be securely locked.';

  @override
  String get vaultTakePhotoOrVideo => 'Take photo or video';

  @override
  String get vaultImportPhotosOrVideos => 'Import photos or videos';

  @override
  String get vaultAlbums => 'Albums';

  @override
  String get vaultNewAlbum => 'New Album';

  @override
  String get vaultAlbumNameHint => 'Album name';

  @override
  String get vaultCreate => 'Create';

  @override
  String get vaultSettings => 'Vault Settings';

  @override
  String get vaultRemoveAfterImport => 'Remove After Import';

  @override
  String get vaultRemoveAfterImportSubtitle => 'Delete originals from gallery after successful import';

  @override
  String get vaultUseFaceIdFingerprint => 'Use Face ID / Fingerprint';

  @override
  String get vaultSecurity => 'Security';

  @override
  String get vaultLockNow => 'Lock Vault Now';

  @override
  String get vaultChangePin => 'Change PIN';

  @override
  String get vaultCreatePin => 'Create Vault PIN';

  @override
  String get vaultConfirmPin => 'Confirm Vault PIN';

  @override
  String get vaultCreatePinSubtitle => 'Choose a 4-digit PIN to protect your private photos';

  @override
  String get vaultConfirmPinSubtitle => 'Enter the same PIN again';

  @override
  String get vaultEnableBiometric => 'Enable Face ID / fingerprint';

  @override
  String get vaultUnlockTitle => 'Enter Passcode to unlock';

  @override
  String get vaultUnlockSubtitle => 'Enter your 4-digit vault PIN';

  @override
  String vaultUnlockLocked(int seconds) {
    return 'Try again in ${seconds}s';
  }

  @override
  String get vaultPinMustBeFourDigits => 'Vault PIN must be 4 digits';

  @override
  String get vaultEnterCurrentPin => 'Enter current PIN';

  @override
  String get vaultEnterNewPin => 'Enter new PIN';

  @override
  String get vaultConfirmNewPin => 'Confirm new PIN';

  @override
  String get vaultPinsDoNotMatch => 'PINs do not match. Try again.';

  @override
  String get vaultCurrentPinIncorrect => 'Current PIN is incorrect';

  @override
  String get vaultPinsDoNotMatchShort => 'PINs do not match';

  @override
  String get vaultPinChanged => 'PIN changed successfully';

  @override
  String get vaultIncorrectPin => 'Incorrect PIN';

  @override
  String get vaultPermissionTitle => 'Permission';

  @override
  String get vaultPhotoLibraryRequired => 'Photo library access is required';

  @override
  String get vaultImportTitle => 'Import';

  @override
  String vaultImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Imported $_temp0';
  }

  @override
  String get vaultSnackbarTitle => 'Vault';

  @override
  String get vaultBiometricReason => 'Unlock your private vault';

  @override
  String get permissionLimitedLibraryAccess => 'Limited library access';

  @override
  String get permissionAllowPhotosVideos => 'Allow photos & videos';

  @override
  String get permissionLimitedBody => 'You can manage which items Cleaner can see, or grant full access in Settings.';

  @override
  String get permissionFullBody => 'Cleaner needs access to scan for duplicates, similar shots, videos, and screenshots.';

  @override
  String get permissionManageLibraryAccess => 'Manage library access';

  @override
  String get permissionRefreshAccess => 'Refresh access';

  @override
  String get permissionOpenSettings => 'Open settings';
}
