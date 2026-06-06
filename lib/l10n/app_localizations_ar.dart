// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Phone Cleaner– AI Junk Cleaner';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get commonOk => 'موافق';

  @override
  String get commonDone => 'تم';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonShare => 'مشاركة';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonTryAgain => 'حاول مرة أخرى';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonSettings => 'الإعدادات';

  @override
  String get navClean => 'تنظيف';

  @override
  String get navContacts => 'جهات الاتصال';

  @override
  String get navCompress => 'ضغط';

  @override
  String get navMore => 'المزيد';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsSectionUpgrade => 'ترقية';

  @override
  String get settingsRestorePurchases => 'استعادة المشتريات';

  @override
  String get settingsSectionPrivatePhoto => 'إعدادات الصور الخاصة';

  @override
  String get settingsPrivateVault => 'الخزنة الخاصة';

  @override
  String get settingsUsePasscode => 'استخدام رمز المرور';

  @override
  String get settingsRemoveAfterImport => 'إزالة بعد الاستيراد';

  @override
  String get settingsSectionCustom => 'إعدادات مخصصة';

  @override
  String get settingsPhotoWidget => 'أداة الصور';

  @override
  String get settingsFaceId => 'Face ID';

  @override
  String get settingsLanguages => 'اللغات';

  @override
  String get settingsSectionOthers => 'أخرى';

  @override
  String get settingsGetHelp => 'الحصول على مساعدة';

  @override
  String get settingsRate5Stars => 'قيّم بـ 5 نجوم';

  @override
  String get settingsShareWithFriends => 'مشاركة مع الأصدقاء';

  @override
  String get settingsAboutUs => 'من نحن';

  @override
  String get settingsTermsAndConditions => 'الشروط والأحكام';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsThemeMode => 'وضع السمة';

  @override
  String get settingsAppLock => 'قفل التطبيق';

  @override
  String get languagePickerTitle => 'اللغات';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageUrdu => 'الأردية';

  @override
  String get languageChinese => 'الصينية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageSpanish => 'الإسبانية';

  @override
  String get cleanerAppTitle => 'منظف';

  @override
  String get cleanerPro => 'احترافي';

  @override
  String get cleanerSortLargestFirst => 'الأكبر أولاً';

  @override
  String get cleanerSortSmallestFirst => 'الأصغر أولاً';

  @override
  String get cleanerSortNewestDateFirst => 'أحدث تاريخ';

  @override
  String get cleanerSortOldestDateFirst => 'أقدم تاريخ';

  @override
  String get cleanerAnalyzingLibrary => 'جاري تحليل مكتبتك';

  @override
  String get cleanerUnknownError => 'خطأ غير معروف';

  @override
  String get cleanerScanPreparing => 'جاري التحضير…';

  @override
  String get cleanerScanLoadingLibrary => 'جاري تحميل المكتبة…';

  @override
  String get cleanerScanFindingDuplicates => 'جاري البحث عن الملفات المكررة…';

  @override
  String get cleanerScanFindingSimilar => 'جاري البحث عن صور مشابهة…';

  @override
  String get cleanerScanDone => 'تم';

  @override
  String get cleanerScanSomethingWentWrong => 'حدث خطأ ما';

  @override
  String get cleanerCategorySimilarPhotos => 'صور مشابهة';

  @override
  String get cleanerCategoryDuplicatePhotos => 'صور مكررة';

  @override
  String get cleanerCategorySimilarVideos => 'فيديوهات مشابهة';

  @override
  String get cleanerCategoryVideos => 'فيديوهات';

  @override
  String get cleanerCategoryScreenshots => 'لقطات الشاشة';

  @override
  String get cleanerCategorySimilarLivePhotos => 'صور حية مشابهة';

  @override
  String get cleanerOptimizeYourStorage => 'حسّن مساحة التخزين';

  @override
  String get cleanerAiPhotoEditor => 'محرر الصور بالذكاء الاصطناعي';

  @override
  String get cleanerImprovePhotoQuality => 'تحسين جودة الصورة';

  @override
  String get cleanerPickPhotoToEnhance => 'اختر صورة للتحسين';

  @override
  String get cleanerPickOldPhotoToRestore => 'اختر صورة قديمة للاستعادة';

  @override
  String get cleanerPhotosAccessTitle => 'الوصول إلى الصور';

  @override
  String get cleanerPhotosAccessBlocked =>
      'الوصول للصور محظور. فعّله في الإعدادات.';

  @override
  String get cleanerPhotosAccessRequest => 'اسمح بالوصول لمكتبة الصور.';

  @override
  String get cleanerCouldNotOpenImage => 'تعذر فتح الصورة.';

  @override
  String get cleanerCrop => 'قص';

  @override
  String get cleanerPhotoSavedToGallery => 'تم حفظ الصورة في المعرض.';

  @override
  String cleanerCouldNotSaveToGallery(String error) {
    return 'تعذر الحفظ: $error';
  }

  @override
  String get cleanerAiPhotoEditorTitle => 'محرر الصور بالذكاء الاصطناعي';

  @override
  String get cleanerChooseFromLibrary => 'اختر من المكتبة';

  @override
  String get cleanerPhotoEnhance => 'تحسين الصورة';

  @override
  String get cleanerBoostQuality => 'تعزيز الجودة';

  @override
  String get cleanerFixOldPhoto => 'إصلاح صورة قديمة';

  @override
  String get cleanerRestoreOldMemories => 'استعادة الذكريات';

  @override
  String get cleanerNoPhotosFound => 'لم يتم العثور على صور';

  @override
  String get cleanerStorageUsed => 'مستخدم:';

  @override
  String get cleanerStorageUnavailable => '—';

  @override
  String get cleanerBest => 'الأفضل';

  @override
  String get cleanerDeleteSelected => 'حذف المحدد';

  @override
  String cleanerGroupNumber(int number) {
    return 'المجموعة $number';
  }

  @override
  String get cleanerDeletedTitle => 'تم الحذف';

  @override
  String cleanerDeletedMessage(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر · $size متاح',
      one: 'عنصر واحد · $size متاح',
    );
    return '$_temp0';
  }

  @override
  String get cleanerSomeItemsNotRemoved => 'لم تُزال بعض العناصر';

  @override
  String cleanerSomeItemsFailed(int count) {
    return '$count فشل';
  }

  @override
  String get cleanerNothingDeleted => 'لم يُحذف شيء';

  @override
  String get cleanerNothingDeletedHint => 'حاول مرة أخرى أو تحقق من الأذونات.';

  @override
  String cleanerSelectedSummary(int count, String size) {
    return '$count محدد · $size';
  }

  @override
  String get contactsTitle => 'جهات الاتصال';

  @override
  String get contactsAccessNeeded => 'مطلوب الوصول لجهات الاتصال';

  @override
  String get contactsAccessBody => 'اسمح بالوصول لعرض العدد والقوائم.';

  @override
  String get contactsOpenSettings => 'فتح الإعدادات';

  @override
  String get contactsBackup => 'نسخ احتياطي';

  @override
  String get contactsDuplicateContacts => 'جهات مكررة';

  @override
  String get contactsIncompleteContacts => 'جهات غير مكتملة';

  @override
  String get contactsNamesNumbersEmails => 'الأسماء. الأرقام. البريد.';

  @override
  String get contactsIncompleteDescription =>
      'يجب أن يحتوي كل جهة على اسم ورقم وبريد.';

  @override
  String get contactsNoName => 'بدون اسم';

  @override
  String contactsMissingPrefix(String fields) {
    return 'مفقود: $fields';
  }

  @override
  String get contactsMissingName => 'الاسم';

  @override
  String get contactsMissingNumber => 'الرقم';

  @override
  String get contactsMissingEmail => 'البريد';

  @override
  String get contactsSelect => 'تحديد';

  @override
  String get contactsSearchHint => 'ابحث بالاسم أو الرقم';

  @override
  String get contactsNoSearchResults => 'لا توجد نتائج.';

  @override
  String get contactsNoDuplicates => 'لا توجد مجموعات مكررة.';

  @override
  String get contactsSameNumber => 'نفس الرقم';

  @override
  String get contactsSameName => 'نفس الاسم';

  @override
  String get contactsSharedNumber => 'رقم مشترك';

  @override
  String get contactsExportTitle => 'تصدير جهات الاتصال';

  @override
  String get contactsExportBody => 'ينشئ ملف .vcf واحد.';

  @override
  String get contactsExportPreparing => 'جاري التحضير…';

  @override
  String get contactsExportAllShare => 'تصدير الكل ومشاركة';

  @override
  String get contactsExportSubsetHint => 'يمكنك أيضاً التحديد من القائمة.';

  @override
  String contactsShareCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مشاركة $count جهات',
      one: 'مشاركة جهة واحدة',
    );
    return '$_temp0';
  }

  @override
  String contactsGroupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count جهات',
      one: 'جهة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get compressTitle => 'ضغط';

  @override
  String get compressVideoSaveUpTo => 'اضغط الفيديو لتوفير حتى';

  @override
  String get compressSort => 'فرز';

  @override
  String get compressRefresh => 'تحديث';

  @override
  String get compressClear => 'مسح';

  @override
  String get compressNext => 'التالي';

  @override
  String get compressButton => 'ضغط';

  @override
  String get compressNoVideosFound => 'لا توجد فيديوهات';

  @override
  String get compressNoVideosBody => 'ستظهر الفيديوهات بعد منح الوصول.';

  @override
  String get compressReload => 'إعادة التحميل';

  @override
  String get compressMediaAccessBlocked => 'الوصول للوسائط محظور';

  @override
  String get compressAllowMediaAccess => 'السماح بالوصول';

  @override
  String get compressMediaBlockedBody => 'فعّل الوصول في الإعدادات.';

  @override
  String get compressMediaRequestBody => 'مطلوب الوصول للمعرض.';

  @override
  String get compressAllowAccess => 'السماح';

  @override
  String get compressRetry => 'إعادة';

  @override
  String get compressNoMediaSelected => 'لم يُحدد وسائط';

  @override
  String get compressNoMediaSelectedBody =>
      'ارجع واختر فيديواً واحداً على الأقل.';

  @override
  String get compressQuality => 'الجودة';

  @override
  String get compressCompressionResults => 'نتائج الضغط';

  @override
  String get compressQualityLow => 'منخفض';

  @override
  String get compressQualityMedium => 'متوسط';

  @override
  String get compressQualityHigh => 'عالي';

  @override
  String compressQualitySavings(int percent) {
    return 'ضغط $percent%';
  }

  @override
  String get compressSelectMediaTitle => 'اختر وسائط للضغط';

  @override
  String get compressSelectMediaBody => 'اختر ملفات ثم تابع.';

  @override
  String get compressManageAccess => 'إدارة الوصول';

  @override
  String get compressVisibleItems => 'العناصر الظاهرة';

  @override
  String get compressSelected => 'محدد';

  @override
  String get compressSelectedSize => 'الحجم المحدد';

  @override
  String get compressOriginal => 'الأصلي';

  @override
  String get compressCompressed => 'مضغوط';

  @override
  String compressEstimatedSavings(String size) {
    return 'التوفير المتوقع: $size';
  }

  @override
  String compressActualSavings(String size) {
    return 'المساحة الموفرة: $size';
  }

  @override
  String get compressSelectedVideo => 'الفيديو المحدد';

  @override
  String get compressSelectedImage => 'الصورة المحددة';

  @override
  String get compressCompressedFile => 'الملف المضغوط';

  @override
  String compressFromSize(String size) {
    return 'من $size';
  }

  @override
  String compressToSize(String size) {
    return 'إلى $size';
  }

  @override
  String compressSavedSize(String size) {
    return 'وفّر $size';
  }

  @override
  String get compressCompressionProgress => 'تقدم الضغط';

  @override
  String compressCurrentFile(String label) {
    return 'الملف الحالي: $label';
  }

  @override
  String compressCurrentFileProgress(int percent) {
    return 'التقدم: $percent%';
  }

  @override
  String compressProgressDone(int processed, int total, String remaining) {
    return '$processed من $total · $remaining متبقي';
  }

  @override
  String compressProgressButton(int percent, String remaining) {
    return '$percent% · $remaining';
  }

  @override
  String compressSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count محدد',
      one: '1 محدد',
    );
    return '$_temp0';
  }

  @override
  String compressItemsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر',
      one: 'عنصر واحد',
    );
    return '$_temp0';
  }

  @override
  String get compressUnableCheckPermission => 'تعذر التحقق من الإذن.';

  @override
  String get compressUnableRequestPermission => 'تعذر طلب الإذن.';

  @override
  String get compressUnableLoadGallery => 'تعذر تحميل المعرض.';

  @override
  String get compressUnableLoadMore => 'تعذر تحميل المزيد.';

  @override
  String get compressReadyToCompress => 'جاهز للضغط';

  @override
  String get compressPreparingCompression => 'جاري التحضير';

  @override
  String compressCompressingItem(String label) {
    return 'ضغط $label';
  }

  @override
  String get compressFinalizingCompression => 'جاري الإنهاء';

  @override
  String compressCompressedCount(int done, int total) {
    return '$done من $total';
  }

  @override
  String get compressCompressionComplete => 'اكتمل الضغط';

  @override
  String compressCompressedSummary(int success, int total) {
    return 'ضُغط $success من $total';
  }

  @override
  String get compressUnableCompressSelected => 'تعذر ضغط الوسائط.';

  @override
  String compressFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'فشل $count',
      one: 'فشل واحد',
    );
    return '$_temp0';
  }

  @override
  String compressSuccessMessage(String size, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر',
      one: 'عنصر',
    );
    return 'حُفظ في المعرض. $size، $_temp0';
  }

  @override
  String get compressOriginalUnavailable => 'الملف الأصلي غير متاح.';

  @override
  String compressCompressionFailed(String error) {
    return 'فشل الضغط: $error';
  }

  @override
  String get moreToolsTitle => 'أدوات إضافية';

  @override
  String get morePrivatePhotos => 'صور خاصة';

  @override
  String get morePrivatePhotosSubtitle => 'احمِ صورك السرية';

  @override
  String get moreChargingAnimation => 'رسوم الشحن';

  @override
  String get moreChargingAnimationSubtitle => 'خصّص شاشة الشحن';

  @override
  String get moreCleaningGuide => 'دليل التنظيف';

  @override
  String get moreCleaningGuideSubtitle => 'تعلّم التنظيف الآمن';

  @override
  String get guideTitle => 'دليل التنظيف';

  @override
  String get guideSectionApps => 'التطبيقات';

  @override
  String get guideSectionCache => 'ذاكرة التطبيق';

  @override
  String get guideOffloadUnusedApps => 'تفريغ التطبيقات';

  @override
  String get guideDeleteUnusedApps => 'حذف التطبيقات';

  @override
  String get guideFlowTitle => 'تفريغ التطبيقات';

  @override
  String get guideStepOpenSettings => 'افتح الإعدادات';

  @override
  String get guideStepClickGeneral => 'اضغط عام';

  @override
  String get guideStepTapIphoneStorage => 'مساحة iPhone';

  @override
  String get guideStepEnableOffload => 'فعّل التفريغ';

  @override
  String get guideFlowNext => 'التالي';

  @override
  String get guideFlowClose => 'إغلاق الدليل';

  @override
  String get guideClean => 'تنظيف';

  @override
  String get chargingAnimationTitle => 'رسوم الشحن';

  @override
  String get chargingViewAnimation => 'عرض الرسوم';

  @override
  String get chargingBrowseAnimations => 'تصفح الرسوم';

  @override
  String get chargingAllowLockScreenOnCharge => 'السماح بشاشة القفل';

  @override
  String get chargingLockScreenSetup => 'إعداد شاشة القفل';

  @override
  String get chargingChooseAnimation => 'اختر رسماً';

  @override
  String get chargingNoAnimationSelected => 'لم يُحدد رسم';

  @override
  String get chargingChooseAnimationAppBar => 'اختر رسماً';

  @override
  String get chargingApplyAnimation => 'تطبيق الرسم';

  @override
  String chargingBatteryPercent(int level) {
    return '$level%';
  }

  @override
  String get chargingHeadlineCharging => 'جاري الشحن';

  @override
  String get chargingHeadlineFullyCharged => 'مشحون بالكامل';

  @override
  String get chargingHeadlineDisconnected => 'غير متصل';

  @override
  String get chargingHeadlineBatteryStatus => 'حالة البطارية';

  @override
  String get chargingHeadlinePowerConnected => 'الطاقة متصلة';

  @override
  String get chargingSubtitleCharging => 'جهازك يشحن.';

  @override
  String get chargingSubtitleFullyCharged => 'يمكنك فصل الشاحن.';

  @override
  String get chargingSubtitleDisconnected => 'وصّل الشاحن لرؤية الرسوم.';

  @override
  String get chargingSubtitleUnknown => 'الحالة غير متاحة.';

  @override
  String get chargingSubtitleConnectedNotCharging => 'متصل ولا يشحن.';

  @override
  String get chargingAppliedTitle => 'تم التطبيق';

  @override
  String chargingAppliedMessage(String title) {
    return '$title أصبح رسم الشحن.';
  }

  @override
  String get chargingAnimationSemantics => 'رسم الشحن';

  @override
  String get chargingMissingLottieAsset => 'ملف Lottie مفقود';

  @override
  String get chargingStepApplyAnimation => 'طبّق من التصفح.';

  @override
  String get chargingStepOpenWhileCharging => 'افتح أثناء الشحن.';

  @override
  String get chargingStepIosNoLockScreen => 'غير مدعوم على iPhone.';

  @override
  String get chargingStepBrowsePreviewApply => 'تصفح → معاينة → تطبيق';

  @override
  String get chargingStepAllowLockScreen => 'اضغط السماح بشاشة القفل.';

  @override
  String get chargingStepLockAndPlugIn => 'أقفل ووصّل الشاحن.';

  @override
  String get chargingStepOemSettings => 'Samsung/Xiaomi/Oppo: اسمح بالخلفية.';

  @override
  String get chargingPlatformNoteIos =>
      'الرسوم على شاشة القفل غير مدعومة على iPhone.';

  @override
  String get chargingPlatformNoteAndroid => 'على Android وصّل الشاحن.';

  @override
  String get chargingAnimNeonBattery => 'بطارية نيون';

  @override
  String get chargingAnimCircularCharge => 'شحن دائري';

  @override
  String get chargingAnimCyberpunk => 'سايبربانك';

  @override
  String get chargingAnimGlowingEnergy => 'طاقة متوهجة';

  @override
  String get chargingAnimMinimalBattery => 'بطارية بسيطة';

  @override
  String get chargingAnimFuturisticPulse => 'نبض مستقبلية';

  @override
  String get chargingAnimLiquidWave => 'موجة سائلة';

  @override
  String get chargingAnimAuroraRing => 'حلقة الشفق';

  @override
  String get appLockLocked => 'التطبيق مقفل';

  @override
  String get appLockEnterPinOrBiometrics => 'أدخل PIN أو البصمة.';

  @override
  String get appLockSetupTitle => 'إعداد قفل التطبيق';

  @override
  String get appLockCreatePin => 'أنشئ PIN من 4 أرقام';

  @override
  String get appLockConfirmPin => 'أكد PIN';

  @override
  String get appLockCreatePinHint => 'ستستخدمه لفتح التطبيق.';

  @override
  String get appLockConfirmPinHint => 'أدخل نفس PIN.';

  @override
  String get appLockEnableBiometric => 'تفعيل Face ID / البصمة';

  @override
  String get appLockBiometricSubtitle => 'افتح دون كتابة PIN';

  @override
  String get appLockContinue => 'متابعة';

  @override
  String get appLockFinishSetup => 'إنهاء الإعداد';

  @override
  String get appLockTurnOffTitle => 'إيقاف القفل';

  @override
  String get appLockEnterPinToTurnOff => 'أدخل PIN للإيقاف';

  @override
  String get appLockVerifyPinToDisable => 'تحقق من PIN الحالي.';

  @override
  String get appLockTooManyAttempts => 'محاولات كثيرة.';

  @override
  String get appLockIncorrectPin => 'PIN غير صحيح.';

  @override
  String get appLockPinsDoNotMatch => 'PIN غير متطابق.';

  @override
  String get appLockSetupFailed => 'فشل الإعداد';

  @override
  String get appLockCouldNotDisable => 'تعذر الإيقاف';

  @override
  String get appLockSnackbarTitle => 'قفل التطبيق';

  @override
  String get appLockBiometricReason => 'فتح تطبيق التنظيف';

  @override
  String get photoWidgetTitle => 'أداة الصور';

  @override
  String get photoWidgetShowOnHomeScreen => 'عرض على الشاشة الرئيسية';

  @override
  String get photoWidgetActive => 'الأداة نشطة';

  @override
  String get photoWidgetTurnOnAfterImport => 'تشغيل بعد الاستيراد';

  @override
  String get photoWidgetImportFirst => 'استورد الصور أولاً';

  @override
  String get photoWidgetMyAlbums => 'ألبوماتي';

  @override
  String get photoWidgetWidgetStyle => 'نمط الأداة';

  @override
  String get photoWidgetCreateAlbum => 'إنشاء ألبوم';

  @override
  String get photoWidgetEnterAlbumName => 'أدخل اسم الألبوم:';

  @override
  String get photoWidgetWidgetSource => 'مصدر الأداة';

  @override
  String get photoWidgetAlbum => 'ألبوم';

  @override
  String get photoWidgetAlbumNotFound => 'الألبوم غير موجود';

  @override
  String get photoWidgetUseForHomeScreen => 'لأداة الشاشة الرئيسية';

  @override
  String get photoWidgetActiveAlbum => 'ألبوم الأداة النشط';

  @override
  String get photoWidgetAddNewPhotos => 'إضافة صور';

  @override
  String get photoWidgetImportPhotos => 'استيراد صور';

  @override
  String get photoWidgetImportPhotosTitle => 'استيراد الصور';

  @override
  String photoWidgetDoneCount(int count) {
    return 'تم ($count)';
  }

  @override
  String photoWidgetSelectUpTo(int max) {
    return 'اختر حتى $max صور.';
  }

  @override
  String get photoWidgetGrid => 'شبكة';

  @override
  String get photoWidgetSlideshow => 'عرض شرائح';

  @override
  String get photoWidgetPreview => 'معاينة';

  @override
  String get photoWidgetGridDescription => 'شبكة 2×2 على الشاشة.';

  @override
  String get photoWidgetSlideshowDescription =>
      'تدوير بالمؤقت (15 ثانية على الأقل).';

  @override
  String get photoWidgetRenameAlbum => 'إعادة تسمية';

  @override
  String get photoWidgetDeleteAlbumTitle => 'حذف الألبوم؟';

  @override
  String get photoWidgetDeleteAlbumBody => 'ستُزال من ذاكرة الأداة.';

  @override
  String get photoWidgetAddWidgetTitle => 'إضافة أداة الصور';

  @override
  String get photoWidgetHelpAndroid =>
      '1. استورد في ألبوم\n2. اضغط مطولاً → أدوات\n3. Cleaner App → Photo Widget\n4. اسحب\n\nأو ثبّت أدناه.';

  @override
  String get photoWidgetHelpIos =>
      '1. اضغط مطولاً\n2. +\n3. ابحث عن التطبيق\n4. Add Widget\n\nملاحظة: iOS يحدّث بالجدول.';

  @override
  String get photoWidgetPinWidget => 'تثبيت الأداة';

  @override
  String get photoWidgetPinWidgetButton => 'تثبيت على الشاشة';

  @override
  String get photoWidgetPinFollowPrompt => 'اتبع مطالبة النظام.';

  @override
  String get photoWidgetPinManualSteps => 'استخدم الخطوات اليدوية.';

  @override
  String get photoWidgetHelp => 'مساعدة';

  @override
  String photoWidgetDefaultAlbumName(int number) {
    return 'ألبوم $number';
  }

  @override
  String get photoWidgetPermissionRequired => 'مطلوب إذن';

  @override
  String get photoWidgetAllowPhotoAccess => 'اسمح بالوصول للصور.';

  @override
  String get photoWidgetLimitReached => 'بلغ الحد';

  @override
  String get photoWidgetAlbumFull => 'الألبوم ممتلئ (30 كحد أقصى).';

  @override
  String photoWidgetImportLimit(int max) {
    return 'استورد حتى $max في المرة.';
  }

  @override
  String get photoWidgetImportFailed => 'فشل الاستيراد';

  @override
  String get photoWidgetCouldNotSave => 'تعذر الحفظ.';

  @override
  String get photoWidgetPartialImport => 'استيراد جزئي';

  @override
  String photoWidgetPartialImportMessage(int imported, int total) {
    return 'استورد $imported من $total.';
  }

  @override
  String get photoWidgetAddToHomeTitle => 'إضافة للشاشة';

  @override
  String get photoWidgetAddToHomeBody => 'اضغط مطولاً → أدوات أو مساعدة.';

  @override
  String get photoWidgetUpdated => 'تم التحديث';

  @override
  String get photoWidgetUpdatedBody => 'حدّث الأداة على الشاشة.';

  @override
  String get photoWidgetPinSnackbarTitle => 'أداة';

  @override
  String get vaultPrivatePhotos => 'صور خاصة';

  @override
  String vaultMediaCount(int photos, int videos) {
    String _temp0 = intl.Intl.pluralLogic(
      photos,
      locale: localeName,
      other: '$photos صور',
      one: 'صورة واحدة',
    );
    String _temp1 = intl.Intl.pluralLogic(
      videos,
      locale: localeName,
      other: '$videos فيديوهات',
      one: 'فيديو واحد',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get vaultSelectAll => 'تحديد الكل';

  @override
  String get vaultDeleteSelected => 'حذف المحدد';

  @override
  String get vaultAddPhotos => 'إضافة صور';

  @override
  String get vaultCouldNotOpen => 'تعذر فتح الصور';

  @override
  String get vaultGoBack => 'رجوع';

  @override
  String get vaultEmptyState => 'اختر صوراً للاستيراد.\nستُقفل بأمان.';

  @override
  String get vaultTakePhotoOrVideo => 'التقاط صورة أو فيديو';

  @override
  String get vaultImportPhotosOrVideos => 'استيراد صور/فيديو';

  @override
  String get vaultAlbums => 'ألبومات';

  @override
  String get vaultNewAlbum => 'ألبوم جديد';

  @override
  String get vaultAlbumNameHint => 'اسم الألبوم';

  @override
  String get vaultCreate => 'إنشاء';

  @override
  String get vaultSettings => 'إعدادات الخزنة';

  @override
  String get vaultRemoveAfterImport => 'إزالة بعد الاستيراد';

  @override
  String get vaultRemoveAfterImportSubtitle => 'حذف الأصل بعد الاستيراد';

  @override
  String get vaultUseFaceIdFingerprint => 'Face ID / البصمة';

  @override
  String get vaultSecurity => 'الأمان';

  @override
  String get vaultLockNow => 'قفل الخزنة';

  @override
  String get vaultChangePin => 'تغيير PIN';

  @override
  String get vaultCreatePin => 'إنشاء PIN';

  @override
  String get vaultConfirmPin => 'تأكيد PIN';

  @override
  String get vaultCreatePinSubtitle => 'PIN من 4 أرقام';

  @override
  String get vaultConfirmPinSubtitle => 'أدخل نفس PIN';

  @override
  String get vaultEnableBiometric => 'تفعيل البصمة';

  @override
  String get vaultUnlockTitle => 'أدخل رمز المرور';

  @override
  String get vaultUnlockSubtitle => 'PIN من 4 أرقام';

  @override
  String vaultUnlockLocked(int seconds) {
    return 'حاول بعد $seconds ث';
  }

  @override
  String get vaultPinMustBeFourDigits => 'PIN من 4 أرقام';

  @override
  String get vaultEnterCurrentPin => 'PIN الحالي';

  @override
  String get vaultEnterNewPin => 'PIN جديد';

  @override
  String get vaultConfirmNewPin => 'تأكيد PIN';

  @override
  String get vaultPinsDoNotMatch => 'PIN غير متطابق.';

  @override
  String get vaultCurrentPinIncorrect => 'PIN الحالي خاطئ';

  @override
  String get vaultPinsDoNotMatchShort => 'غير متطابق';

  @override
  String get vaultPinChanged => 'تم تغيير PIN';

  @override
  String get vaultIncorrectPin => 'PIN خاطئ';

  @override
  String get vaultPermissionTitle => 'إذن';

  @override
  String get vaultPhotoLibraryRequired => 'مطلوب مكتبة الصور';

  @override
  String get vaultImportTitle => 'استيراد';

  @override
  String vaultImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عناصر',
      one: 'عنصر واحد',
    );
    return '$_temp0 مستورد';
  }

  @override
  String get vaultSnackbarTitle => 'الخزنة';

  @override
  String get vaultBiometricReason => 'فتح الخزنة الخاصة';

  @override
  String get permissionLimitedLibraryAccess => 'وصول محدود للمكتبة';

  @override
  String get permissionAllowPhotosVideos => 'السماح بالصور والفيديو';

  @override
  String get permissionLimitedBody => 'يمكنك الإدارة أو منح وصول كامل.';

  @override
  String get permissionFullBody => 'مطلوب للبحث عن المكررات.';

  @override
  String get permissionManageLibraryAccess => 'إدارة الوصول';

  @override
  String get permissionRefreshAccess => 'تحديث الوصول';

  @override
  String get permissionOpenSettings => 'فتح الإعدادات';
}
