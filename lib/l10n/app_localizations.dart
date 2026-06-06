import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('ur'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone Cleaner– AI Junk Cleaner'**
  String get appTitle;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonTryAgain;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// No description provided for @navClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get navClean;

  /// No description provided for @navContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get navContacts;

  /// No description provided for @navCompress.
  ///
  /// In en, this message translates to:
  /// **'Compress'**
  String get navCompress;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionUpgrade.
  ///
  /// In en, this message translates to:
  /// **'UPGRADE'**
  String get settingsSectionUpgrade;

  /// No description provided for @settingsRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get settingsRestorePurchases;

  /// No description provided for @settingsSectionPrivatePhoto.
  ///
  /// In en, this message translates to:
  /// **'PRIVATE PHOTO SETTINGS'**
  String get settingsSectionPrivatePhoto;

  /// No description provided for @settingsPrivateVault.
  ///
  /// In en, this message translates to:
  /// **'Private Vault'**
  String get settingsPrivateVault;

  /// No description provided for @settingsUsePasscode.
  ///
  /// In en, this message translates to:
  /// **'Use Passcode'**
  String get settingsUsePasscode;

  /// No description provided for @settingsRemoveAfterImport.
  ///
  /// In en, this message translates to:
  /// **'Remove After Import'**
  String get settingsRemoveAfterImport;

  /// No description provided for @settingsSectionCustom.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM SETTINGS'**
  String get settingsSectionCustom;

  /// No description provided for @settingsPhotoWidget.
  ///
  /// In en, this message translates to:
  /// **'Photo Widget'**
  String get settingsPhotoWidget;

  /// No description provided for @settingsFaceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get settingsFaceId;

  /// No description provided for @settingsLanguages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get settingsLanguages;

  /// No description provided for @settingsSectionOthers.
  ///
  /// In en, this message translates to:
  /// **'OTHERS'**
  String get settingsSectionOthers;

  /// No description provided for @settingsGetHelp.
  ///
  /// In en, this message translates to:
  /// **'Get Help'**
  String get settingsGetHelp;

  /// No description provided for @settingsRate5Stars.
  ///
  /// In en, this message translates to:
  /// **'Rate 5 Stars'**
  String get settingsRate5Stars;

  /// No description provided for @settingsShareWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Share With Friends'**
  String get settingsShareWithFriends;

  /// No description provided for @settingsAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get settingsAboutUs;

  /// No description provided for @settingsTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get settingsTermsAndConditions;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get settingsThemeMode;

  /// No description provided for @settingsAppLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get settingsAppLock;

  /// No description provided for @languagePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languagePickerTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageChinese;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @cleanerAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleaner'**
  String get cleanerAppTitle;

  /// No description provided for @cleanerPro.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get cleanerPro;

  /// No description provided for @cleanerSortLargestFirst.
  ///
  /// In en, this message translates to:
  /// **'Largest first'**
  String get cleanerSortLargestFirst;

  /// No description provided for @cleanerSortSmallestFirst.
  ///
  /// In en, this message translates to:
  /// **'Smallest first'**
  String get cleanerSortSmallestFirst;

  /// No description provided for @cleanerSortNewestDateFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest date first'**
  String get cleanerSortNewestDateFirst;

  /// No description provided for @cleanerSortOldestDateFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest date first'**
  String get cleanerSortOldestDateFirst;

  /// No description provided for @cleanerAnalyzingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your library'**
  String get cleanerAnalyzingLibrary;

  /// No description provided for @cleanerUnknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get cleanerUnknownError;

  /// No description provided for @cleanerScanPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing…'**
  String get cleanerScanPreparing;

  /// No description provided for @cleanerScanLoadingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Loading library…'**
  String get cleanerScanLoadingLibrary;

  /// No description provided for @cleanerScanFindingDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Finding duplicate files…'**
  String get cleanerScanFindingDuplicates;

  /// No description provided for @cleanerScanFindingSimilar.
  ///
  /// In en, this message translates to:
  /// **'Finding similar photos…'**
  String get cleanerScanFindingSimilar;

  /// No description provided for @cleanerScanDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get cleanerScanDone;

  /// No description provided for @cleanerScanSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get cleanerScanSomethingWentWrong;

  /// No description provided for @cleanerCategorySimilarPhotos.
  ///
  /// In en, this message translates to:
  /// **'Similar Photos'**
  String get cleanerCategorySimilarPhotos;

  /// No description provided for @cleanerCategoryDuplicatePhotos.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Photos'**
  String get cleanerCategoryDuplicatePhotos;

  /// No description provided for @cleanerCategorySimilarVideos.
  ///
  /// In en, this message translates to:
  /// **'Similar Videos'**
  String get cleanerCategorySimilarVideos;

  /// No description provided for @cleanerCategoryVideos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get cleanerCategoryVideos;

  /// No description provided for @cleanerCategoryScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Screenshots'**
  String get cleanerCategoryScreenshots;

  /// No description provided for @cleanerCategorySimilarLivePhotos.
  ///
  /// In en, this message translates to:
  /// **'Similar Live Photos'**
  String get cleanerCategorySimilarLivePhotos;

  /// No description provided for @cleanerOptimizeYourStorage.
  ///
  /// In en, this message translates to:
  /// **'Optimize Your Storage'**
  String get cleanerOptimizeYourStorage;

  /// No description provided for @cleanerAiPhotoEditor.
  ///
  /// In en, this message translates to:
  /// **'AI Photo Editor'**
  String get cleanerAiPhotoEditor;

  /// No description provided for @cleanerImprovePhotoQuality.
  ///
  /// In en, this message translates to:
  /// **'Improve photo quality'**
  String get cleanerImprovePhotoQuality;

  /// No description provided for @cleanerPickPhotoToEnhance.
  ///
  /// In en, this message translates to:
  /// **'Pick a photo to enhance'**
  String get cleanerPickPhotoToEnhance;

  /// No description provided for @cleanerPickOldPhotoToRestore.
  ///
  /// In en, this message translates to:
  /// **'Pick an old photo to restore'**
  String get cleanerPickOldPhotoToRestore;

  /// No description provided for @cleanerPhotosAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos access'**
  String get cleanerPhotosAccessTitle;

  /// No description provided for @cleanerPhotosAccessBlocked.
  ///
  /// In en, this message translates to:
  /// **'Photo access is blocked. Enable it in Settings to pick images.'**
  String get cleanerPhotosAccessBlocked;

  /// No description provided for @cleanerPhotosAccessRequest.
  ///
  /// In en, this message translates to:
  /// **'Allow photo library access to choose an image.'**
  String get cleanerPhotosAccessRequest;

  /// No description provided for @cleanerCouldNotOpenImage.
  ///
  /// In en, this message translates to:
  /// **'Could not open that image.'**
  String get cleanerCouldNotOpenImage;

  /// No description provided for @cleanerCrop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get cleanerCrop;

  /// No description provided for @cleanerPhotoSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo saved to your gallery.'**
  String get cleanerPhotoSavedToGallery;

  /// No description provided for @cleanerCouldNotSaveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Could not save to gallery: {error}'**
  String cleanerCouldNotSaveToGallery(String error);

  /// No description provided for @cleanerAiPhotoEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Photo Editor'**
  String get cleanerAiPhotoEditorTitle;

  /// No description provided for @cleanerChooseFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get cleanerChooseFromLibrary;

  /// No description provided for @cleanerPhotoEnhance.
  ///
  /// In en, this message translates to:
  /// **'Photo Enhance'**
  String get cleanerPhotoEnhance;

  /// No description provided for @cleanerBoostQuality.
  ///
  /// In en, this message translates to:
  /// **'Boost quality'**
  String get cleanerBoostQuality;

  /// No description provided for @cleanerFixOldPhoto.
  ///
  /// In en, this message translates to:
  /// **'Fix Old Photo'**
  String get cleanerFixOldPhoto;

  /// No description provided for @cleanerRestoreOldMemories.
  ///
  /// In en, this message translates to:
  /// **'Restore old memories'**
  String get cleanerRestoreOldMemories;

  /// No description provided for @cleanerNoPhotosFound.
  ///
  /// In en, this message translates to:
  /// **'No photos found'**
  String get cleanerNoPhotosFound;

  /// No description provided for @cleanerStorageUsed.
  ///
  /// In en, this message translates to:
  /// **'Used:'**
  String get cleanerStorageUsed;

  /// No description provided for @cleanerStorageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get cleanerStorageUnavailable;

  /// No description provided for @cleanerBest.
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get cleanerBest;

  /// No description provided for @cleanerDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get cleanerDeleteSelected;

  /// No description provided for @cleanerGroupNumber.
  ///
  /// In en, this message translates to:
  /// **'Group {number}'**
  String cleanerGroupNumber(int number);

  /// No description provided for @cleanerDeletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get cleanerDeletedTitle;

  /// No description provided for @cleanerDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 item · {size} freed} other{{count} items · {size} freed}}'**
  String cleanerDeletedMessage(int count, String size);

  /// No description provided for @cleanerSomeItemsNotRemoved.
  ///
  /// In en, this message translates to:
  /// **'Some items were not removed'**
  String get cleanerSomeItemsNotRemoved;

  /// No description provided for @cleanerSomeItemsFailed.
  ///
  /// In en, this message translates to:
  /// **'{count} failed'**
  String cleanerSomeItemsFailed(int count);

  /// No description provided for @cleanerNothingDeleted.
  ///
  /// In en, this message translates to:
  /// **'Nothing deleted'**
  String get cleanerNothingDeleted;

  /// No description provided for @cleanerNothingDeletedHint.
  ///
  /// In en, this message translates to:
  /// **'Try again or check photo permissions.'**
  String get cleanerNothingDeletedHint;

  /// No description provided for @cleanerSelectedSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} selected · {size}'**
  String cleanerSelectedSummary(int count, String size);

  /// No description provided for @contactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contactsTitle;

  /// No description provided for @contactsAccessNeeded.
  ///
  /// In en, this message translates to:
  /// **'Contacts access needed'**
  String get contactsAccessNeeded;

  /// No description provided for @contactsAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Allow access to your contacts to see counts, lists, backups, and to open the system editor.'**
  String get contactsAccessBody;

  /// No description provided for @contactsOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get contactsOpenSettings;

  /// No description provided for @contactsBackup.
  ///
  /// In en, this message translates to:
  /// **'Contacts Backup'**
  String get contactsBackup;

  /// No description provided for @contactsDuplicateContacts.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Contacts'**
  String get contactsDuplicateContacts;

  /// No description provided for @contactsIncompleteContacts.
  ///
  /// In en, this message translates to:
  /// **'Incomplete Contacts'**
  String get contactsIncompleteContacts;

  /// No description provided for @contactsNamesNumbersEmails.
  ///
  /// In en, this message translates to:
  /// **'Names. Numbers. Emails.'**
  String get contactsNamesNumbersEmails;

  /// No description provided for @contactsIncompleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Every contact has a name, at least one number, and at least one email.'**
  String get contactsIncompleteDescription;

  /// No description provided for @contactsNoName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get contactsNoName;

  /// No description provided for @contactsMissingPrefix.
  ///
  /// In en, this message translates to:
  /// **'Missing: {fields}'**
  String contactsMissingPrefix(String fields);

  /// No description provided for @contactsMissingName.
  ///
  /// In en, this message translates to:
  /// **'name'**
  String get contactsMissingName;

  /// No description provided for @contactsMissingNumber.
  ///
  /// In en, this message translates to:
  /// **'number'**
  String get contactsMissingNumber;

  /// No description provided for @contactsMissingEmail.
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get contactsMissingEmail;

  /// No description provided for @contactsSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get contactsSelect;

  /// No description provided for @contactsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search via name, number or email'**
  String get contactsSearchHint;

  /// No description provided for @contactsNoSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No contacts match your search.'**
  String get contactsNoSearchResults;

  /// No description provided for @contactsNoDuplicates.
  ///
  /// In en, this message translates to:
  /// **'No duplicate groups found by phone or name.'**
  String get contactsNoDuplicates;

  /// No description provided for @contactsSameNumber.
  ///
  /// In en, this message translates to:
  /// **'Same number'**
  String get contactsSameNumber;

  /// No description provided for @contactsSameName.
  ///
  /// In en, this message translates to:
  /// **'Same name'**
  String get contactsSameName;

  /// No description provided for @contactsSharedNumber.
  ///
  /// In en, this message translates to:
  /// **'Shared number'**
  String get contactsSharedNumber;

  /// No description provided for @contactsExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export your contacts'**
  String get contactsExportTitle;

  /// No description provided for @contactsExportBody.
  ///
  /// In en, this message translates to:
  /// **'Creates a single .vcf file with your contacts so you can save it to Files, AirDrop it, or open it in another app.'**
  String get contactsExportBody;

  /// No description provided for @contactsExportPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing…'**
  String get contactsExportPreparing;

  /// No description provided for @contactsExportAllShare.
  ///
  /// In en, this message translates to:
  /// **'Export all & share'**
  String get contactsExportAllShare;

  /// No description provided for @contactsExportSubsetHint.
  ///
  /// In en, this message translates to:
  /// **'You can also pick contacts from the main list, tap Select, then share a subset.'**
  String get contactsExportSubsetHint;

  /// No description provided for @contactsShareCount.
  ///
  /// In en, this message translates to:
  /// **'Share {count, plural, one{1 contact} other{{count} contacts}}'**
  String contactsShareCount(int count);

  /// No description provided for @contactsGroupCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 contact} other{{count} contacts}}'**
  String contactsGroupCount(int count);

  /// No description provided for @compressTitle.
  ///
  /// In en, this message translates to:
  /// **'Compress'**
  String get compressTitle;

  /// No description provided for @compressVideoSaveUpTo.
  ///
  /// In en, this message translates to:
  /// **'Compress video to save up to'**
  String get compressVideoSaveUpTo;

  /// No description provided for @compressSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get compressSort;

  /// No description provided for @compressRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get compressRefresh;

  /// No description provided for @compressClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get compressClear;

  /// No description provided for @compressNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get compressNext;

  /// No description provided for @compressButton.
  ///
  /// In en, this message translates to:
  /// **'COMPRESS'**
  String get compressButton;

  /// No description provided for @compressNoVideosFound.
  ///
  /// In en, this message translates to:
  /// **'No videos found'**
  String get compressNoVideosFound;

  /// No description provided for @compressNoVideosBody.
  ///
  /// In en, this message translates to:
  /// **'Videos will appear here after gallery access is granted.'**
  String get compressNoVideosBody;

  /// No description provided for @compressReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get compressReload;

  /// No description provided for @compressMediaAccessBlocked.
  ///
  /// In en, this message translates to:
  /// **'Media access blocked'**
  String get compressMediaAccessBlocked;

  /// No description provided for @compressAllowMediaAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow media access'**
  String get compressAllowMediaAccess;

  /// No description provided for @compressMediaBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Open system settings and enable gallery access to compress videos.'**
  String get compressMediaBlockedBody;

  /// No description provided for @compressMediaRequestBody.
  ///
  /// In en, this message translates to:
  /// **'Cleaner needs access to your gallery before it can show videos for compression.'**
  String get compressMediaRequestBody;

  /// No description provided for @compressAllowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow access'**
  String get compressAllowAccess;

  /// No description provided for @compressRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get compressRetry;

  /// No description provided for @compressNoMediaSelected.
  ///
  /// In en, this message translates to:
  /// **'No media selected'**
  String get compressNoMediaSelected;

  /// No description provided for @compressNoMediaSelectedBody.
  ///
  /// In en, this message translates to:
  /// **'Go back and select at least one video.'**
  String get compressNoMediaSelectedBody;

  /// No description provided for @compressQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get compressQuality;

  /// No description provided for @compressCompressionResults.
  ///
  /// In en, this message translates to:
  /// **'Compression results'**
  String get compressCompressionResults;

  /// No description provided for @compressQualityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get compressQualityLow;

  /// No description provided for @compressQualityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get compressQualityMedium;

  /// No description provided for @compressQualityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get compressQualityHigh;

  /// No description provided for @compressQualitySavings.
  ///
  /// In en, this message translates to:
  /// **'Compress {percent}%'**
  String compressQualitySavings(int percent);

  /// No description provided for @compressSelectMediaTitle.
  ///
  /// In en, this message translates to:
  /// **'Select media to compress'**
  String get compressSelectMediaTitle;

  /// No description provided for @compressSelectMediaBody.
  ///
  /// In en, this message translates to:
  /// **'Pick one or more images/videos, then continue to quality selection and compression.'**
  String get compressSelectMediaBody;

  /// No description provided for @compressManageAccess.
  ///
  /// In en, this message translates to:
  /// **'Manage access'**
  String get compressManageAccess;

  /// No description provided for @compressVisibleItems.
  ///
  /// In en, this message translates to:
  /// **'Visible items'**
  String get compressVisibleItems;

  /// No description provided for @compressSelected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get compressSelected;

  /// No description provided for @compressSelectedSize.
  ///
  /// In en, this message translates to:
  /// **'Selected size'**
  String get compressSelectedSize;

  /// No description provided for @compressOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get compressOriginal;

  /// No description provided for @compressCompressed.
  ///
  /// In en, this message translates to:
  /// **'Compressed'**
  String get compressCompressed;

  /// No description provided for @compressEstimatedSavings.
  ///
  /// In en, this message translates to:
  /// **'Estimated savings: {size}'**
  String compressEstimatedSavings(String size);

  /// No description provided for @compressActualSavings.
  ///
  /// In en, this message translates to:
  /// **'Space saved: {size}'**
  String compressActualSavings(String size);

  /// No description provided for @compressSelectedVideo.
  ///
  /// In en, this message translates to:
  /// **'Selected video'**
  String get compressSelectedVideo;

  /// No description provided for @compressSelectedImage.
  ///
  /// In en, this message translates to:
  /// **'Selected image'**
  String get compressSelectedImage;

  /// No description provided for @compressCompressedFile.
  ///
  /// In en, this message translates to:
  /// **'Compressed file'**
  String get compressCompressedFile;

  /// No description provided for @compressFromSize.
  ///
  /// In en, this message translates to:
  /// **'From {size}'**
  String compressFromSize(String size);

  /// No description provided for @compressToSize.
  ///
  /// In en, this message translates to:
  /// **'To {size}'**
  String compressToSize(String size);

  /// No description provided for @compressSavedSize.
  ///
  /// In en, this message translates to:
  /// **'Saved {size}'**
  String compressSavedSize(String size);

  /// No description provided for @compressCompressionProgress.
  ///
  /// In en, this message translates to:
  /// **'Compression progress'**
  String get compressCompressionProgress;

  /// No description provided for @compressCurrentFile.
  ///
  /// In en, this message translates to:
  /// **'Current file: {label}'**
  String compressCurrentFile(String label);

  /// No description provided for @compressCurrentFileProgress.
  ///
  /// In en, this message translates to:
  /// **'Current file progress: {percent}%'**
  String compressCurrentFileProgress(int percent);

  /// No description provided for @compressProgressDone.
  ///
  /// In en, this message translates to:
  /// **'{processed} of {total} done · {remaining} remaining'**
  String compressProgressDone(int processed, int total, String remaining);

  /// No description provided for @compressProgressButton.
  ///
  /// In en, this message translates to:
  /// **'{percent}% · {remaining} left'**
  String compressProgressButton(int percent, String remaining);

  /// No description provided for @compressSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 selected} other{{count} selected}}'**
  String compressSelectedCount(int count);

  /// No description provided for @compressItemsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 item selected} other{{count} items selected}}'**
  String compressItemsSelected(int count);

  /// No description provided for @compressUnableCheckPermission.
  ///
  /// In en, this message translates to:
  /// **'Unable to check media permission state.'**
  String get compressUnableCheckPermission;

  /// No description provided for @compressUnableRequestPermission.
  ///
  /// In en, this message translates to:
  /// **'Unable to request media permission.'**
  String get compressUnableRequestPermission;

  /// No description provided for @compressUnableLoadGallery.
  ///
  /// In en, this message translates to:
  /// **'Unable to load gallery media.'**
  String get compressUnableLoadGallery;

  /// No description provided for @compressUnableLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Unable to load more media.'**
  String get compressUnableLoadMore;

  /// No description provided for @compressReadyToCompress.
  ///
  /// In en, this message translates to:
  /// **'Ready to compress'**
  String get compressReadyToCompress;

  /// No description provided for @compressPreparingCompression.
  ///
  /// In en, this message translates to:
  /// **'Preparing compression'**
  String get compressPreparingCompression;

  /// No description provided for @compressCompressingItem.
  ///
  /// In en, this message translates to:
  /// **'Compressing {label}'**
  String compressCompressingItem(String label);

  /// No description provided for @compressFinalizingCompression.
  ///
  /// In en, this message translates to:
  /// **'Finalizing compression'**
  String get compressFinalizingCompression;

  /// No description provided for @compressCompressedCount.
  ///
  /// In en, this message translates to:
  /// **'Compressed {done} of {total}'**
  String compressCompressedCount(int done, int total);

  /// No description provided for @compressCompressionComplete.
  ///
  /// In en, this message translates to:
  /// **'Compression complete'**
  String get compressCompressionComplete;

  /// No description provided for @compressCompressedSummary.
  ///
  /// In en, this message translates to:
  /// **'Compressed {success} of {total} items'**
  String compressCompressedSummary(int success, int total);

  /// No description provided for @compressUnableCompressSelected.
  ///
  /// In en, this message translates to:
  /// **'Unable to compress the selected media.'**
  String get compressUnableCompressSelected;

  /// No description provided for @compressFailedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 item could not be compressed.} other{{count} items could not be compressed.}}'**
  String compressFailedCount(int count);

  /// No description provided for @compressSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Saved new *_compressed* copies to gallery. Total saved: {size} across {count, plural, one{1 item} other{{count} items}}.'**
  String compressSuccessMessage(String size, int count);

  /// No description provided for @compressOriginalUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Original file is no longer available.'**
  String get compressOriginalUnavailable;

  /// No description provided for @compressCompressionFailed.
  ///
  /// In en, this message translates to:
  /// **'Compression failed: {error}'**
  String compressCompressionFailed(String error);

  /// No description provided for @moreToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'More Tools'**
  String get moreToolsTitle;

  /// No description provided for @morePrivatePhotos.
  ///
  /// In en, this message translates to:
  /// **'Private Photos'**
  String get morePrivatePhotos;

  /// No description provided for @morePrivatePhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your secret photos'**
  String get morePrivatePhotosSubtitle;

  /// No description provided for @moreChargingAnimation.
  ///
  /// In en, this message translates to:
  /// **'Charging Animation'**
  String get moreChargingAnimation;

  /// No description provided for @moreChargingAnimationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize charging screen'**
  String get moreChargingAnimationSubtitle;

  /// No description provided for @moreCleaningGuide.
  ///
  /// In en, this message translates to:
  /// **'Cleaning Guide'**
  String get moreCleaningGuide;

  /// No description provided for @moreCleaningGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn how to clean safely'**
  String get moreCleaningGuideSubtitle;

  /// No description provided for @guideTitle.
  ///
  /// In en, this message translates to:
  /// **'Cleanup Guide'**
  String get guideTitle;

  /// No description provided for @guideSectionApps.
  ///
  /// In en, this message translates to:
  /// **'Apps'**
  String get guideSectionApps;

  /// No description provided for @guideSectionCache.
  ///
  /// In en, this message translates to:
  /// **'App\'s Cache'**
  String get guideSectionCache;

  /// No description provided for @guideOffloadUnusedApps.
  ///
  /// In en, this message translates to:
  /// **'Offload Unused Apps'**
  String get guideOffloadUnusedApps;

  /// No description provided for @guideDeleteUnusedApps.
  ///
  /// In en, this message translates to:
  /// **'Delete Unused Apps'**
  String get guideDeleteUnusedApps;

  /// No description provided for @guideFlowTitle.
  ///
  /// In en, this message translates to:
  /// **'Offload Unused Apps'**
  String get guideFlowTitle;

  /// No description provided for @guideStepOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get guideStepOpenSettings;

  /// No description provided for @guideStepClickGeneral.
  ///
  /// In en, this message translates to:
  /// **'Click General'**
  String get guideStepClickGeneral;

  /// No description provided for @guideStepTapIphoneStorage.
  ///
  /// In en, this message translates to:
  /// **'Tap iPhone Storage'**
  String get guideStepTapIphoneStorage;

  /// No description provided for @guideStepEnableOffload.
  ///
  /// In en, this message translates to:
  /// **'Enable Offload Unused Apps'**
  String get guideStepEnableOffload;

  /// No description provided for @guideFlowNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get guideFlowNext;

  /// No description provided for @guideFlowClose.
  ///
  /// In en, this message translates to:
  /// **'Close Guide'**
  String get guideFlowClose;

  /// No description provided for @guideClean.
  ///
  /// In en, this message translates to:
  /// **'Clean'**
  String get guideClean;

  /// No description provided for @chargingAnimationTitle.
  ///
  /// In en, this message translates to:
  /// **'Charging Animation'**
  String get chargingAnimationTitle;

  /// No description provided for @chargingViewAnimation.
  ///
  /// In en, this message translates to:
  /// **'View animation'**
  String get chargingViewAnimation;

  /// No description provided for @chargingBrowseAnimations.
  ///
  /// In en, this message translates to:
  /// **'Browse animations'**
  String get chargingBrowseAnimations;

  /// No description provided for @chargingAllowLockScreenOnCharge.
  ///
  /// In en, this message translates to:
  /// **'Allow lock screen on charge'**
  String get chargingAllowLockScreenOnCharge;

  /// No description provided for @chargingLockScreenSetup.
  ///
  /// In en, this message translates to:
  /// **'Lock screen setup'**
  String get chargingLockScreenSetup;

  /// No description provided for @chargingChooseAnimation.
  ///
  /// In en, this message translates to:
  /// **'Choose an animation'**
  String get chargingChooseAnimation;

  /// No description provided for @chargingNoAnimationSelected.
  ///
  /// In en, this message translates to:
  /// **'No animation selected'**
  String get chargingNoAnimationSelected;

  /// No description provided for @chargingChooseAnimationAppBar.
  ///
  /// In en, this message translates to:
  /// **'Choose animation'**
  String get chargingChooseAnimationAppBar;

  /// No description provided for @chargingApplyAnimation.
  ///
  /// In en, this message translates to:
  /// **'Apply animation'**
  String get chargingApplyAnimation;

  /// No description provided for @chargingBatteryPercent.
  ///
  /// In en, this message translates to:
  /// **'{level}%'**
  String chargingBatteryPercent(int level);

  /// No description provided for @chargingHeadlineCharging.
  ///
  /// In en, this message translates to:
  /// **'Charging'**
  String get chargingHeadlineCharging;

  /// No description provided for @chargingHeadlineFullyCharged.
  ///
  /// In en, this message translates to:
  /// **'Fully charged'**
  String get chargingHeadlineFullyCharged;

  /// No description provided for @chargingHeadlineDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get chargingHeadlineDisconnected;

  /// No description provided for @chargingHeadlineBatteryStatus.
  ///
  /// In en, this message translates to:
  /// **'Battery status'**
  String get chargingHeadlineBatteryStatus;

  /// No description provided for @chargingHeadlinePowerConnected.
  ///
  /// In en, this message translates to:
  /// **'Power connected'**
  String get chargingHeadlinePowerConnected;

  /// No description provided for @chargingSubtitleCharging.
  ///
  /// In en, this message translates to:
  /// **'Your device is drawing power.'**
  String get chargingSubtitleCharging;

  /// No description provided for @chargingSubtitleFullyCharged.
  ///
  /// In en, this message translates to:
  /// **'You can unplug whenever you are ready.'**
  String get chargingSubtitleFullyCharged;

  /// No description provided for @chargingSubtitleDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Plug in to see your charging animation.'**
  String get chargingSubtitleDisconnected;

  /// No description provided for @chargingSubtitleUnknown.
  ///
  /// In en, this message translates to:
  /// **'Battery state unavailable on this device.'**
  String get chargingSubtitleUnknown;

  /// No description provided for @chargingSubtitleConnectedNotCharging.
  ///
  /// In en, this message translates to:
  /// **'Power connected; battery is not actively charging.'**
  String get chargingSubtitleConnectedNotCharging;

  /// No description provided for @chargingAppliedTitle.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get chargingAppliedTitle;

  /// No description provided for @chargingAppliedMessage.
  ///
  /// In en, this message translates to:
  /// **'{title} is now your charging animation.'**
  String chargingAppliedMessage(String title);

  /// No description provided for @chargingAnimationSemantics.
  ///
  /// In en, this message translates to:
  /// **'Charging animation'**
  String get chargingAnimationSemantics;

  /// No description provided for @chargingMissingLottieAsset.
  ///
  /// In en, this message translates to:
  /// **'Missing Lottie asset path'**
  String get chargingMissingLottieAsset;

  /// No description provided for @chargingStepApplyAnimation.
  ///
  /// In en, this message translates to:
  /// **'Apply an animation from Browse animations.'**
  String get chargingStepApplyAnimation;

  /// No description provided for @chargingStepOpenWhileCharging.
  ///
  /// In en, this message translates to:
  /// **'Open the app while the phone is charging.'**
  String get chargingStepOpenWhileCharging;

  /// No description provided for @chargingStepIosNoLockScreen.
  ///
  /// In en, this message translates to:
  /// **'Lock-screen auto show is not supported on iPhone.'**
  String get chargingStepIosNoLockScreen;

  /// No description provided for @chargingStepBrowsePreviewApply.
  ///
  /// In en, this message translates to:
  /// **'Browse animations → Preview → Apply animation.'**
  String get chargingStepBrowsePreviewApply;

  /// No description provided for @chargingStepAllowLockScreen.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Allow lock screen on charge\" below (battery optimization).'**
  String get chargingStepAllowLockScreen;

  /// No description provided for @chargingStepLockAndPlugIn.
  ///
  /// In en, this message translates to:
  /// **'Lock the phone, plug in the charger — animation should appear.'**
  String get chargingStepLockAndPlugIn;

  /// No description provided for @chargingStepOemSettings.
  ///
  /// In en, this message translates to:
  /// **'Samsung / Xiaomi / Oppo: Settings → Apps → Cleaner App → allow background & display on lock screen.'**
  String get chargingStepOemSettings;

  /// No description provided for @chargingPlatformNoteIos.
  ///
  /// In en, this message translates to:
  /// **'Lock-screen animation is not supported on iPhone. Open the app while charging to view your animation.'**
  String get chargingPlatformNoteIos;

  /// No description provided for @chargingPlatformNoteAndroid.
  ///
  /// In en, this message translates to:
  /// **'On Android, plug in your charger to see the animation. Enable lock-screen display in settings if needed.'**
  String get chargingPlatformNoteAndroid;

  /// No description provided for @chargingAnimNeonBattery.
  ///
  /// In en, this message translates to:
  /// **'Neon Battery'**
  String get chargingAnimNeonBattery;

  /// No description provided for @chargingAnimCircularCharge.
  ///
  /// In en, this message translates to:
  /// **'Circular Charge'**
  String get chargingAnimCircularCharge;

  /// No description provided for @chargingAnimCyberpunk.
  ///
  /// In en, this message translates to:
  /// **'Cyberpunk'**
  String get chargingAnimCyberpunk;

  /// No description provided for @chargingAnimGlowingEnergy.
  ///
  /// In en, this message translates to:
  /// **'Glowing Energy'**
  String get chargingAnimGlowingEnergy;

  /// No description provided for @chargingAnimMinimalBattery.
  ///
  /// In en, this message translates to:
  /// **'Minimal Battery'**
  String get chargingAnimMinimalBattery;

  /// No description provided for @chargingAnimFuturisticPulse.
  ///
  /// In en, this message translates to:
  /// **'Futuristic Pulse'**
  String get chargingAnimFuturisticPulse;

  /// No description provided for @chargingAnimLiquidWave.
  ///
  /// In en, this message translates to:
  /// **'Liquid Wave'**
  String get chargingAnimLiquidWave;

  /// No description provided for @chargingAnimAuroraRing.
  ///
  /// In en, this message translates to:
  /// **'Aurora Ring'**
  String get chargingAnimAuroraRing;

  /// No description provided for @appLockLocked.
  ///
  /// In en, this message translates to:
  /// **'App locked'**
  String get appLockLocked;

  /// No description provided for @appLockEnterPinOrBiometrics.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN or use biometrics.'**
  String get appLockEnterPinOrBiometrics;

  /// No description provided for @appLockSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up App Lock'**
  String get appLockSetupTitle;

  /// No description provided for @appLockCreatePin.
  ///
  /// In en, this message translates to:
  /// **'Create a 4-digit PIN'**
  String get appLockCreatePin;

  /// No description provided for @appLockConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm your PIN'**
  String get appLockConfirmPin;

  /// No description provided for @appLockCreatePinHint.
  ///
  /// In en, this message translates to:
  /// **'You will use this PIN to unlock the app.'**
  String get appLockCreatePinHint;

  /// No description provided for @appLockConfirmPinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the same PIN again.'**
  String get appLockConfirmPinHint;

  /// No description provided for @appLockEnableBiometric.
  ///
  /// In en, this message translates to:
  /// **'Enable Face ID / fingerprint'**
  String get appLockEnableBiometric;

  /// No description provided for @appLockBiometricSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock the app without typing your PIN.'**
  String get appLockBiometricSubtitle;

  /// No description provided for @appLockContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get appLockContinue;

  /// No description provided for @appLockFinishSetup.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get appLockFinishSetup;

  /// No description provided for @appLockTurnOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn off App Lock'**
  String get appLockTurnOffTitle;

  /// No description provided for @appLockEnterPinToTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN to turn off App Lock'**
  String get appLockEnterPinToTurnOff;

  /// No description provided for @appLockVerifyPinToDisable.
  ///
  /// In en, this message translates to:
  /// **'Verify your current PIN to disable app lock.'**
  String get appLockVerifyPinToDisable;

  /// No description provided for @appLockTooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again or use biometrics.'**
  String get appLockTooManyAttempts;

  /// No description provided for @appLockIncorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN. Try again.'**
  String get appLockIncorrectPin;

  /// No description provided for @appLockPinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Start again.'**
  String get appLockPinsDoNotMatch;

  /// No description provided for @appLockSetupFailed.
  ///
  /// In en, this message translates to:
  /// **'Setup failed'**
  String get appLockSetupFailed;

  /// No description provided for @appLockCouldNotDisable.
  ///
  /// In en, this message translates to:
  /// **'Could not disable'**
  String get appLockCouldNotDisable;

  /// No description provided for @appLockSnackbarTitle.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get appLockSnackbarTitle;

  /// No description provided for @appLockBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock Cleaner App'**
  String get appLockBiometricReason;

  /// No description provided for @photoWidgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Photo Widget'**
  String get photoWidgetTitle;

  /// No description provided for @photoWidgetShowOnHomeScreen.
  ///
  /// In en, this message translates to:
  /// **'Show on home screen'**
  String get photoWidgetShowOnHomeScreen;

  /// No description provided for @photoWidgetActive.
  ///
  /// In en, this message translates to:
  /// **'Widget is active'**
  String get photoWidgetActive;

  /// No description provided for @photoWidgetTurnOnAfterImport.
  ///
  /// In en, this message translates to:
  /// **'Turn on after importing photos'**
  String get photoWidgetTurnOnAfterImport;

  /// No description provided for @photoWidgetImportFirst.
  ///
  /// In en, this message translates to:
  /// **'Import photos into an album first'**
  String get photoWidgetImportFirst;

  /// No description provided for @photoWidgetMyAlbums.
  ///
  /// In en, this message translates to:
  /// **'My albums'**
  String get photoWidgetMyAlbums;

  /// No description provided for @photoWidgetWidgetStyle.
  ///
  /// In en, this message translates to:
  /// **'Widget style'**
  String get photoWidgetWidgetStyle;

  /// No description provided for @photoWidgetCreateAlbum.
  ///
  /// In en, this message translates to:
  /// **'Create an Album'**
  String get photoWidgetCreateAlbum;

  /// No description provided for @photoWidgetEnterAlbumName.
  ///
  /// In en, this message translates to:
  /// **'Enter the name of album:'**
  String get photoWidgetEnterAlbumName;

  /// No description provided for @photoWidgetWidgetSource.
  ///
  /// In en, this message translates to:
  /// **'Widget source'**
  String get photoWidgetWidgetSource;

  /// No description provided for @photoWidgetAlbum.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get photoWidgetAlbum;

  /// No description provided for @photoWidgetAlbumNotFound.
  ///
  /// In en, this message translates to:
  /// **'Album not found'**
  String get photoWidgetAlbumNotFound;

  /// No description provided for @photoWidgetUseForHomeScreen.
  ///
  /// In en, this message translates to:
  /// **'Use for home screen widget'**
  String get photoWidgetUseForHomeScreen;

  /// No description provided for @photoWidgetActiveAlbum.
  ///
  /// In en, this message translates to:
  /// **'Active widget album'**
  String get photoWidgetActiveAlbum;

  /// No description provided for @photoWidgetAddNewPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add New Photos'**
  String get photoWidgetAddNewPhotos;

  /// No description provided for @photoWidgetImportPhotos.
  ///
  /// In en, this message translates to:
  /// **'Import Photos'**
  String get photoWidgetImportPhotos;

  /// No description provided for @photoWidgetImportPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Import photos'**
  String get photoWidgetImportPhotosTitle;

  /// No description provided for @photoWidgetDoneCount.
  ///
  /// In en, this message translates to:
  /// **'Done ({count})'**
  String photoWidgetDoneCount(int count);

  /// No description provided for @photoWidgetSelectUpTo.
  ///
  /// In en, this message translates to:
  /// **'Select up to {max} photos.'**
  String photoWidgetSelectUpTo(int max);

  /// No description provided for @photoWidgetGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get photoWidgetGrid;

  /// No description provided for @photoWidgetSlideshow.
  ///
  /// In en, this message translates to:
  /// **'Slideshow'**
  String get photoWidgetSlideshow;

  /// No description provided for @photoWidgetPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get photoWidgetPreview;

  /// No description provided for @photoWidgetGridDescription.
  ///
  /// In en, this message translates to:
  /// **'Shows a 2×2 grid of your photos on the home screen widget.'**
  String get photoWidgetGridDescription;

  /// No description provided for @photoWidgetSlideshowDescription.
  ///
  /// In en, this message translates to:
  /// **'Rotates through photos on a timer (minimum 15 seconds).'**
  String get photoWidgetSlideshowDescription;

  /// No description provided for @photoWidgetRenameAlbum.
  ///
  /// In en, this message translates to:
  /// **'Rename album'**
  String get photoWidgetRenameAlbum;

  /// No description provided for @photoWidgetDeleteAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete album?'**
  String get photoWidgetDeleteAlbumTitle;

  /// No description provided for @photoWidgetDeleteAlbumBody.
  ///
  /// In en, this message translates to:
  /// **'Photos in this album will be removed from the widget cache.'**
  String get photoWidgetDeleteAlbumBody;

  /// No description provided for @photoWidgetAddWidgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Photo Widget'**
  String get photoWidgetAddWidgetTitle;

  /// No description provided for @photoWidgetHelpAndroid.
  ///
  /// In en, this message translates to:
  /// **'1. Import photos in an album (widget turns on automatically)\n2. Long-press your home screen → Widgets\n3. Find Cleaner App → Photo Widget\n4. Drag it to your home screen\n\nOr tap below to pin the widget (Android 8+).'**
  String get photoWidgetHelpAndroid;

  /// No description provided for @photoWidgetHelpIos.
  ///
  /// In en, this message translates to:
  /// **'1. Long-press your home screen\n2. Tap the + button\n3. Search for Cleaner App\n4. Choose Photo Widget size and tap Add Widget\n\nNote: iOS widgets refresh on a timeline and may not update instantly.'**
  String get photoWidgetHelpIos;

  /// No description provided for @photoWidgetPinWidget.
  ///
  /// In en, this message translates to:
  /// **'Pin widget'**
  String get photoWidgetPinWidget;

  /// No description provided for @photoWidgetPinWidgetButton.
  ///
  /// In en, this message translates to:
  /// **'Pin widget to home screen'**
  String get photoWidgetPinWidgetButton;

  /// No description provided for @photoWidgetPinFollowPrompt.
  ///
  /// In en, this message translates to:
  /// **'Follow the system prompt to add the widget.'**
  String get photoWidgetPinFollowPrompt;

  /// No description provided for @photoWidgetPinManualSteps.
  ///
  /// In en, this message translates to:
  /// **'Use the manual steps above if pin is unavailable.'**
  String get photoWidgetPinManualSteps;

  /// No description provided for @photoWidgetHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get photoWidgetHelp;

  /// No description provided for @photoWidgetDefaultAlbumName.
  ///
  /// In en, this message translates to:
  /// **'Album {number}'**
  String photoWidgetDefaultAlbumName(int number);

  /// No description provided for @photoWidgetPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get photoWidgetPermissionRequired;

  /// No description provided for @photoWidgetAllowPhotoAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow photo access to import images.'**
  String get photoWidgetAllowPhotoAccess;

  /// No description provided for @photoWidgetLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit reached'**
  String get photoWidgetLimitReached;

  /// No description provided for @photoWidgetAlbumFull.
  ///
  /// In en, this message translates to:
  /// **'This album is full (30 photos max).'**
  String get photoWidgetAlbumFull;

  /// No description provided for @photoWidgetImportLimit.
  ///
  /// In en, this message translates to:
  /// **'You can import up to {max} photos at a time.'**
  String photoWidgetImportLimit(int max);

  /// No description provided for @photoWidgetImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get photoWidgetImportFailed;

  /// No description provided for @photoWidgetCouldNotSave.
  ///
  /// In en, this message translates to:
  /// **'Could not save selected photos.'**
  String get photoWidgetCouldNotSave;

  /// No description provided for @photoWidgetPartialImport.
  ///
  /// In en, this message translates to:
  /// **'Partial import'**
  String get photoWidgetPartialImport;

  /// No description provided for @photoWidgetPartialImportMessage.
  ///
  /// In en, this message translates to:
  /// **'Imported {imported} of {total} photos (limits apply).'**
  String photoWidgetPartialImportMessage(int imported, int total);

  /// No description provided for @photoWidgetAddToHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add widget to home screen'**
  String get photoWidgetAddToHomeTitle;

  /// No description provided for @photoWidgetAddToHomeBody.
  ///
  /// In en, this message translates to:
  /// **'Long-press home screen → Widgets → Photo Widget, or tap help (?) to pin.'**
  String get photoWidgetAddToHomeBody;

  /// No description provided for @photoWidgetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Widget updated'**
  String get photoWidgetUpdated;

  /// No description provided for @photoWidgetUpdatedBody.
  ///
  /// In en, this message translates to:
  /// **'Add or refresh the Photo Widget on your home screen to see photos.'**
  String get photoWidgetUpdatedBody;

  /// No description provided for @photoWidgetPinSnackbarTitle.
  ///
  /// In en, this message translates to:
  /// **'Widget'**
  String get photoWidgetPinSnackbarTitle;

  /// No description provided for @vaultPrivatePhotos.
  ///
  /// In en, this message translates to:
  /// **'Private Photos'**
  String get vaultPrivatePhotos;

  /// No description provided for @vaultMediaCount.
  ///
  /// In en, this message translates to:
  /// **'{photos, plural, one{1 Photo} other{{photos} Photos}}, {videos, plural, one{1 Video} other{{videos} Videos}}'**
  String vaultMediaCount(int photos, int videos);

  /// No description provided for @vaultSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get vaultSelectAll;

  /// No description provided for @vaultDeleteSelected.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get vaultDeleteSelected;

  /// No description provided for @vaultAddPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get vaultAddPhotos;

  /// No description provided for @vaultCouldNotOpen.
  ///
  /// In en, this message translates to:
  /// **'Could not open Private Photos'**
  String get vaultCouldNotOpen;

  /// No description provided for @vaultGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get vaultGoBack;

  /// No description provided for @vaultEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Select Photos to begin importing.\nThey will be securely locked.'**
  String get vaultEmptyState;

  /// No description provided for @vaultTakePhotoOrVideo.
  ///
  /// In en, this message translates to:
  /// **'Take photo or video'**
  String get vaultTakePhotoOrVideo;

  /// No description provided for @vaultImportPhotosOrVideos.
  ///
  /// In en, this message translates to:
  /// **'Import photos or videos'**
  String get vaultImportPhotosOrVideos;

  /// No description provided for @vaultAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get vaultAlbums;

  /// No description provided for @vaultNewAlbum.
  ///
  /// In en, this message translates to:
  /// **'New Album'**
  String get vaultNewAlbum;

  /// No description provided for @vaultAlbumNameHint.
  ///
  /// In en, this message translates to:
  /// **'Album name'**
  String get vaultAlbumNameHint;

  /// No description provided for @vaultCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get vaultCreate;

  /// No description provided for @vaultSettings.
  ///
  /// In en, this message translates to:
  /// **'Vault Settings'**
  String get vaultSettings;

  /// No description provided for @vaultRemoveAfterImport.
  ///
  /// In en, this message translates to:
  /// **'Remove After Import'**
  String get vaultRemoveAfterImport;

  /// No description provided for @vaultRemoveAfterImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete originals from gallery after successful import'**
  String get vaultRemoveAfterImportSubtitle;

  /// No description provided for @vaultUseFaceIdFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Use Face ID / Fingerprint'**
  String get vaultUseFaceIdFingerprint;

  /// No description provided for @vaultSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get vaultSecurity;

  /// No description provided for @vaultLockNow.
  ///
  /// In en, this message translates to:
  /// **'Lock Vault Now'**
  String get vaultLockNow;

  /// No description provided for @vaultChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get vaultChangePin;

  /// No description provided for @vaultCreatePin.
  ///
  /// In en, this message translates to:
  /// **'Create Vault PIN'**
  String get vaultCreatePin;

  /// No description provided for @vaultConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm Vault PIN'**
  String get vaultConfirmPin;

  /// No description provided for @vaultCreatePinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4-digit PIN to protect your private photos'**
  String get vaultCreatePinSubtitle;

  /// No description provided for @vaultConfirmPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the same PIN again'**
  String get vaultConfirmPinSubtitle;

  /// No description provided for @vaultEnableBiometric.
  ///
  /// In en, this message translates to:
  /// **'Enable Face ID / fingerprint'**
  String get vaultEnableBiometric;

  /// No description provided for @vaultUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Passcode to unlock'**
  String get vaultUnlockTitle;

  /// No description provided for @vaultUnlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit vault PIN'**
  String get vaultUnlockSubtitle;

  /// No description provided for @vaultUnlockLocked.
  ///
  /// In en, this message translates to:
  /// **'Try again in {seconds}s'**
  String vaultUnlockLocked(int seconds);

  /// No description provided for @vaultPinMustBeFourDigits.
  ///
  /// In en, this message translates to:
  /// **'Vault PIN must be 4 digits'**
  String get vaultPinMustBeFourDigits;

  /// No description provided for @vaultEnterCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Enter current PIN'**
  String get vaultEnterCurrentPin;

  /// No description provided for @vaultEnterNewPin.
  ///
  /// In en, this message translates to:
  /// **'Enter new PIN'**
  String get vaultEnterNewPin;

  /// No description provided for @vaultConfirmNewPin.
  ///
  /// In en, this message translates to:
  /// **'Confirm new PIN'**
  String get vaultConfirmNewPin;

  /// No description provided for @vaultPinsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match. Try again.'**
  String get vaultPinsDoNotMatch;

  /// No description provided for @vaultCurrentPinIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Current PIN is incorrect'**
  String get vaultCurrentPinIncorrect;

  /// No description provided for @vaultPinsDoNotMatchShort.
  ///
  /// In en, this message translates to:
  /// **'PINs do not match'**
  String get vaultPinsDoNotMatchShort;

  /// No description provided for @vaultPinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN changed successfully'**
  String get vaultPinChanged;

  /// No description provided for @vaultIncorrectPin.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get vaultIncorrectPin;

  /// No description provided for @vaultPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get vaultPermissionTitle;

  /// No description provided for @vaultPhotoLibraryRequired.
  ///
  /// In en, this message translates to:
  /// **'Photo library access is required'**
  String get vaultPhotoLibraryRequired;

  /// No description provided for @vaultImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get vaultImportTitle;

  /// No description provided for @vaultImportedCount.
  ///
  /// In en, this message translates to:
  /// **'Imported {count, plural, one{1 item} other{{count} items}}'**
  String vaultImportedCount(int count);

  /// No description provided for @vaultSnackbarTitle.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get vaultSnackbarTitle;

  /// No description provided for @vaultBiometricReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock your private vault'**
  String get vaultBiometricReason;

  /// No description provided for @permissionLimitedLibraryAccess.
  ///
  /// In en, this message translates to:
  /// **'Limited library access'**
  String get permissionLimitedLibraryAccess;

  /// No description provided for @permissionAllowPhotosVideos.
  ///
  /// In en, this message translates to:
  /// **'Allow photos & videos'**
  String get permissionAllowPhotosVideos;

  /// No description provided for @permissionLimitedBody.
  ///
  /// In en, this message translates to:
  /// **'You can manage which items Cleaner can see, or grant full access in Settings.'**
  String get permissionLimitedBody;

  /// No description provided for @permissionFullBody.
  ///
  /// In en, this message translates to:
  /// **'Cleaner needs access to scan for duplicates, similar shots, videos, and screenshots.'**
  String get permissionFullBody;

  /// No description provided for @permissionManageLibraryAccess.
  ///
  /// In en, this message translates to:
  /// **'Manage library access'**
  String get permissionManageLibraryAccess;

  /// No description provided for @permissionRefreshAccess.
  ///
  /// In en, this message translates to:
  /// **'Refresh access'**
  String get permissionRefreshAccess;

  /// No description provided for @permissionOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get permissionOpenSettings;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'ur', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ur':
      return AppLocalizationsUr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
