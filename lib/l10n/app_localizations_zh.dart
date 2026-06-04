// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Phone Cleaner– AI Junk Cleaner';

  @override
  String get commonBack => '返回';

  @override
  String get commonCancel => '取消';

  @override
  String get commonConfirm => '确认';

  @override
  String get commonOk => '确定';

  @override
  String get commonDone => '完成';

  @override
  String get commonDelete => '删除';

  @override
  String get commonShare => '分享';

  @override
  String get commonSave => '保存';

  @override
  String get commonTryAgain => '重试';

  @override
  String get commonContinue => '继续';

  @override
  String get commonSettings => '设置';

  @override
  String get navClean => '清理';

  @override
  String get navContacts => '联系人';

  @override
  String get navCompress => '压缩';

  @override
  String get navMore => '更多';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionUpgrade => '升级';

  @override
  String get settingsRestorePurchases => '恢复购买';

  @override
  String get settingsSectionPrivatePhoto => '私密照片设置';

  @override
  String get settingsPrivateVault => '私密保险库';

  @override
  String get settingsUsePasscode => '使用密码';

  @override
  String get settingsRemoveAfterImport => '导入后删除';

  @override
  String get settingsSectionCustom => '自定义设置';

  @override
  String get settingsPhotoWidget => '照片小组件';

  @override
  String get settingsFaceId => '面容 ID';

  @override
  String get settingsLanguages => '语言';

  @override
  String get settingsSectionOthers => '其他';

  @override
  String get settingsGetHelp => '获取帮助';

  @override
  String get settingsRate5Stars => '五星好评';

  @override
  String get settingsShareWithFriends => '分享给朋友';

  @override
  String get settingsAboutUs => '关于我们';

  @override
  String get settingsTermsAndConditions => '条款与条件';

  @override
  String get settingsPrivacyPolicy => '隐私政策';

  @override
  String get settingsThemeMode => '主题模式';

  @override
  String get settingsAppLock => '应用锁';

  @override
  String get languagePickerTitle => '语言';

  @override
  String get languageEnglish => '英语';

  @override
  String get languageUrdu => '乌尔都语';

  @override
  String get languageChinese => '中文';

  @override
  String get languageArabic => '阿拉伯语';

  @override
  String get languageSpanish => '西班牙语';

  @override
  String get cleanerAppTitle => '清理器';

  @override
  String get cleanerPro => '专业版';

  @override
  String get cleanerSortLargestFirst => '最大优先';

  @override
  String get cleanerSortSmallestFirst => '最小优先';

  @override
  String get cleanerSortNewestDateFirst => '最新日期';

  @override
  String get cleanerSortOldestDateFirst => '最早日期';

  @override
  String get cleanerAnalyzingLibrary => '正在分析您的图库';

  @override
  String get cleanerUnknownError => '未知错误';

  @override
  String get cleanerScanPreparing => '准备中…';

  @override
  String get cleanerScanLoadingLibrary => '正在加载图库…';

  @override
  String get cleanerScanFindingDuplicates => '正在查找重复文件…';

  @override
  String get cleanerScanFindingSimilar => '正在查找相似照片…';

  @override
  String get cleanerScanDone => '完成';

  @override
  String get cleanerScanSomethingWentWrong => '出了点问题';

  @override
  String get cleanerCategorySimilarPhotos => '相似照片';

  @override
  String get cleanerCategoryDuplicatePhotos => '重复照片';

  @override
  String get cleanerCategorySimilarVideos => '相似视频';

  @override
  String get cleanerCategoryVideos => '视频';

  @override
  String get cleanerCategoryScreenshots => '截图';

  @override
  String get cleanerCategorySimilarLivePhotos => '相似实况照片';

  @override
  String get cleanerOptimizeYourStorage => '优化您的存储';

  @override
  String get cleanerAiPhotoEditor => 'AI 照片编辑';

  @override
  String get cleanerImprovePhotoQuality => '提升照片质量';

  @override
  String get cleanerPickPhotoToEnhance => '选择要增强的照片';

  @override
  String get cleanerPickOldPhotoToRestore => '选择要修复的旧照片';

  @override
  String get cleanerPhotosAccessTitle => '照片访问';

  @override
  String get cleanerPhotosAccessBlocked => '照片访问被阻止。请在设置中启用。';

  @override
  String get cleanerPhotosAccessRequest => '请允许访问照片库以选择图片。';

  @override
  String get cleanerCouldNotOpenImage => '无法打开该图片。';

  @override
  String get cleanerCrop => '裁剪';

  @override
  String get cleanerPhotoSavedToGallery => '照片已保存到图库。';

  @override
  String cleanerCouldNotSaveToGallery(String error) {
    return '无法保存到图库：$error';
  }

  @override
  String get cleanerAiPhotoEditorTitle => 'AI 照片编辑';

  @override
  String get cleanerChooseFromLibrary => '从图库选择';

  @override
  String get cleanerPhotoEnhance => '照片增强';

  @override
  String get cleanerBoostQuality => '提升质量';

  @override
  String get cleanerFixOldPhoto => '修复旧照片';

  @override
  String get cleanerRestoreOldMemories => '恢复旧日回忆';

  @override
  String get cleanerNoPhotosFound => '未找到照片';

  @override
  String get cleanerStorageUsed => '已用:';

  @override
  String get cleanerStorageUnavailable => '—';

  @override
  String get cleanerBest => '最佳';

  @override
  String get cleanerDeleteSelected => '删除所选';

  @override
  String cleanerGroupNumber(int number) {
    return '组 $number';
  }

  @override
  String get cleanerDeletedTitle => '已删除';

  @override
  String cleanerDeletedMessage(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项 · 释放 $size',
      one: '1 项 · 释放 $size',
    );
    return '$_temp0';
  }

  @override
  String get cleanerSomeItemsNotRemoved => '部分项目未删除';

  @override
  String cleanerSomeItemsFailed(int count) {
    return '$count 失败';
  }

  @override
  String get cleanerNothingDeleted => '未删除任何内容';

  @override
  String get cleanerNothingDeletedHint => '请重试或检查照片权限。';

  @override
  String cleanerSelectedSummary(int count, String size) {
    return '已选 $count · $size';
  }

  @override
  String get contactsTitle => '联系人';

  @override
  String get contactsAccessNeeded => '需要联系人访问权限';

  @override
  String get contactsAccessBody => '允许访问以查看数量、列表和备份。';

  @override
  String get contactsOpenSettings => '打开设置';

  @override
  String get contactsBackup => '联系人备份';

  @override
  String get contactsDuplicateContacts => '重复联系人';

  @override
  String get contactsIncompleteContacts => '不完整联系人';

  @override
  String get contactsNamesNumbersEmails => '姓名。号码。邮箱。';

  @override
  String get contactsIncompleteDescription => '每个联系人需有姓名、号码和邮箱。';

  @override
  String get contactsNoName => '无姓名';

  @override
  String contactsMissingPrefix(String fields) {
    return '缺少：$fields';
  }

  @override
  String get contactsMissingName => '姓名';

  @override
  String get contactsMissingNumber => '号码';

  @override
  String get contactsMissingEmail => '邮箱';

  @override
  String get contactsSelect => '选择';

  @override
  String get contactsSearchHint => '按姓名、号码或邮箱搜索';

  @override
  String get contactsNoSearchResults => '没有匹配的联系人。';

  @override
  String get contactsNoDuplicates => '未找到重复组。';

  @override
  String get contactsSameNumber => '相同号码';

  @override
  String get contactsSameName => '相同姓名';

  @override
  String get contactsSharedNumber => '共享号码';

  @override
  String get contactsExportTitle => '导出联系人';

  @override
  String get contactsExportBody => '创建单个 .vcf 文件。';

  @override
  String get contactsExportPreparing => '准备中…';

  @override
  String get contactsExportAllShare => '全部导出并分享';

  @override
  String get contactsExportSubsetHint => '也可从列表选择后分享。';

  @override
  String contactsShareCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '分享 $count 个联系人',
      one: '分享 1 个联系人',
    );
    return '$_temp0';
  }

  @override
  String contactsGroupCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个联系人',
      one: '1 个联系人',
    );
    return '$_temp0';
  }

  @override
  String get compressTitle => '压缩';

  @override
  String get compressVideoSaveUpTo => '压缩视频最多可节省';

  @override
  String get compressSort => '排序';

  @override
  String get compressRefresh => '刷新';

  @override
  String get compressClear => '清除';

  @override
  String get compressNext => '下一步';

  @override
  String get compressButton => '压缩';

  @override
  String get compressNoVideosFound => '未找到视频';

  @override
  String get compressNoVideosBody => '授权后视频将显示在此处。';

  @override
  String get compressReload => '重新加载';

  @override
  String get compressMediaAccessBlocked => '媒体访问被阻止';

  @override
  String get compressAllowMediaAccess => '允许媒体访问';

  @override
  String get compressMediaBlockedBody => '请在设置中启用图库访问。';

  @override
  String get compressMediaRequestBody => '压缩前需要图库访问权限。';

  @override
  String get compressAllowAccess => '允许访问';

  @override
  String get compressRetry => '重试';

  @override
  String get compressNoMediaSelected => '未选择媒体';

  @override
  String get compressNoMediaSelectedBody => '返回并至少选择一个视频。';

  @override
  String get compressQuality => '质量';

  @override
  String get compressCompressionResults => '压缩结果';

  @override
  String get compressQualityLow => '低';

  @override
  String get compressQualityMedium => '中';

  @override
  String get compressQualityHigh => '高';

  @override
  String compressQualitySavings(int percent) {
    return '压缩 $percent%';
  }

  @override
  String get compressSelectMediaTitle => '选择要压缩的媒体';

  @override
  String get compressSelectMediaBody => '选择一个或多个文件。';

  @override
  String get compressManageAccess => '管理访问';

  @override
  String get compressVisibleItems => '可见项目';

  @override
  String get compressSelected => '已选';

  @override
  String get compressSelectedSize => '已选大小';

  @override
  String get compressOriginal => '原始';

  @override
  String get compressCompressed => '已压缩';

  @override
  String compressEstimatedSavings(String size) {
    return '预计节省：$size';
  }

  @override
  String compressActualSavings(String size) {
    return '节省空间：$size';
  }

  @override
  String get compressSelectedVideo => '所选视频';

  @override
  String get compressSelectedImage => '所选图片';

  @override
  String get compressCompressedFile => '压缩文件';

  @override
  String compressFromSize(String size) {
    return '从 $size';
  }

  @override
  String compressToSize(String size) {
    return '到 $size';
  }

  @override
  String compressSavedSize(String size) {
    return '节省 $size';
  }

  @override
  String get compressCompressionProgress => '压缩进度';

  @override
  String compressCurrentFile(String label) {
    return '当前文件：$label';
  }

  @override
  String compressCurrentFileProgress(int percent) {
    return '进度：$percent%';
  }

  @override
  String compressProgressDone(int processed, int total, String remaining) {
    return '$processed/$total 完成 · 剩余 $remaining';
  }

  @override
  String compressProgressButton(int percent, String remaining) {
    return '$percent% · 剩余 $remaining';
  }

  @override
  String compressSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已选 $count 项',
      one: '已选 1 项',
    );
    return '$_temp0';
  }

  @override
  String compressItemsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项',
      one: '1 项',
    );
    return '$_temp0';
  }

  @override
  String get compressUnableCheckPermission => '无法检查权限。';

  @override
  String get compressUnableRequestPermission => '无法请求权限。';

  @override
  String get compressUnableLoadGallery => '无法加载图库。';

  @override
  String get compressUnableLoadMore => '无法加载更多。';

  @override
  String get compressReadyToCompress => '准备压缩';

  @override
  String get compressPreparingCompression => '准备压缩';

  @override
  String compressCompressingItem(String label) {
    return '正在压缩 $label';
  }

  @override
  String get compressFinalizingCompression => '完成压缩';

  @override
  String compressCompressedCount(int done, int total) {
    return '$done/$total';
  }

  @override
  String get compressCompressionComplete => '压缩完成';

  @override
  String compressCompressedSummary(int success, int total) {
    return '已压缩 $success/$total';
  }

  @override
  String get compressUnableCompressSelected => '无法压缩所选媒体。';

  @override
  String compressFailedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项失败',
      one: '1 项失败',
    );
    return '$_temp0';
  }

  @override
  String compressSuccessMessage(String size, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项',
      one: '1 项',
    );
    return '已保存。共节省 $size，$_temp0';
  }

  @override
  String get compressOriginalUnavailable => '原文件不可用。';

  @override
  String compressCompressionFailed(String error) {
    return '压缩失败：$error';
  }

  @override
  String get moreToolsTitle => '更多工具';

  @override
  String get morePrivatePhotos => '私密照片';

  @override
  String get morePrivatePhotosSubtitle => '保护您的私密照片';

  @override
  String get moreChargingAnimation => '充电动画';

  @override
  String get moreChargingAnimationSubtitle => '自定义充电界面';

  @override
  String get moreCleaningGuide => '清理指南';

  @override
  String get moreCleaningGuideSubtitle => '学习安全清理';

  @override
  String get guideTitle => '清理指南';

  @override
  String get guideSectionApps => '应用';

  @override
  String get guideSectionCache => '应用缓存';

  @override
  String get guideOffloadUnusedApps => '卸载未用应用';

  @override
  String get guideDeleteUnusedApps => '删除未用应用';

  @override
  String get guideFlowTitle => '卸载未用应用';

  @override
  String get guideStepOpenSettings => '打开设置';

  @override
  String get guideStepClickGeneral => '点击通用';

  @override
  String get guideStepTapIphoneStorage => '轻点 iPhone 储存空间';

  @override
  String get guideStepEnableOffload => '启用卸载未用应用';

  @override
  String get guideFlowNext => '下一步';

  @override
  String get guideFlowClose => '关闭指南';

  @override
  String get guideClean => '清理';

  @override
  String get chargingAnimationTitle => '充电动画';

  @override
  String get chargingViewAnimation => '查看动画';

  @override
  String get chargingBrowseAnimations => '浏览动画';

  @override
  String get chargingAllowLockScreenOnCharge => '充电时允许锁屏';

  @override
  String get chargingLockScreenSetup => '锁屏设置';

  @override
  String get chargingChooseAnimation => '选择动画';

  @override
  String get chargingNoAnimationSelected => '未选择动画';

  @override
  String get chargingChooseAnimationAppBar => '选择动画';

  @override
  String get chargingApplyAnimation => '应用动画';

  @override
  String chargingBatteryPercent(int level) {
    return '$level%';
  }

  @override
  String get chargingHeadlineCharging => '正在充电';

  @override
  String get chargingHeadlineFullyCharged => '已充满';

  @override
  String get chargingHeadlineDisconnected => '未连接';

  @override
  String get chargingHeadlineBatteryStatus => '电池状态';

  @override
  String get chargingHeadlinePowerConnected => '已接通电源';

  @override
  String get chargingSubtitleCharging => '设备正在充电。';

  @override
  String get chargingSubtitleFullyCharged => '可随时拔掉电源。';

  @override
  String get chargingSubtitleDisconnected => '插入电源以查看动画。';

  @override
  String get chargingSubtitleUnknown => '此设备无法获取电池状态。';

  @override
  String get chargingSubtitleConnectedNotCharging => '已接通但未在充电。';

  @override
  String get chargingAppliedTitle => '已应用';

  @override
  String chargingAppliedMessage(String title) {
    return '$title 现为充电动画。';
  }

  @override
  String get chargingAnimationSemantics => '充电动画';

  @override
  String get chargingMissingLottieAsset => '缺少 Lottie 资源';

  @override
  String get chargingStepApplyAnimation => '从浏览应用动画。';

  @override
  String get chargingStepOpenWhileCharging => '充电时打开应用。';

  @override
  String get chargingStepIosNoLockScreen => 'iPhone 不支持锁屏自动显示。';

  @override
  String get chargingStepBrowsePreviewApply => '浏览 → 预览 → 应用';

  @override
  String get chargingStepAllowLockScreen => '点击下方“充电时允许锁屏”。';

  @override
  String get chargingStepLockAndPlugIn => '锁定手机并插入充电器。';

  @override
  String get chargingStepOemSettings => '三星/小米/OPPO：允许后台和锁屏显示。';

  @override
  String get chargingPlatformNoteIos => 'iPhone 不支持锁屏动画。充电时打开应用查看。';

  @override
  String get chargingPlatformNoteAndroid => 'Android 上插入充电器即可。可在设置中启用锁屏显示。';

  @override
  String get chargingAnimNeonBattery => '霓虹电池';

  @override
  String get chargingAnimCircularCharge => '环形充电';

  @override
  String get chargingAnimCyberpunk => '赛博朋克';

  @override
  String get chargingAnimGlowingEnergy => '发光能量';

  @override
  String get chargingAnimMinimalBattery => '极简电池';

  @override
  String get chargingAnimFuturisticPulse => '未来脉冲';

  @override
  String get chargingAnimLiquidWave => '液体波浪';

  @override
  String get chargingAnimAuroraRing => '极光环';

  @override
  String get appLockLocked => '应用已锁定';

  @override
  String get appLockEnterPinOrBiometrics => '输入 PIN 或使用生物识别。';

  @override
  String get appLockSetupTitle => '设置应用锁';

  @override
  String get appLockCreatePin => '创建 4 位 PIN';

  @override
  String get appLockConfirmPin => '确认 PIN';

  @override
  String get appLockCreatePinHint => '用于解锁应用。';

  @override
  String get appLockConfirmPinHint => '再次输入相同 PIN。';

  @override
  String get appLockEnableBiometric => '启用面容/指纹';

  @override
  String get appLockBiometricSubtitle => '无需输入 PIN 即可解锁';

  @override
  String get appLockContinue => '继续';

  @override
  String get appLockFinishSetup => '完成设置';

  @override
  String get appLockTurnOffTitle => '关闭应用锁';

  @override
  String get appLockEnterPinToTurnOff => '输入 PIN 以关闭';

  @override
  String get appLockVerifyPinToDisable => '验证当前 PIN。';

  @override
  String get appLockTooManyAttempts => '尝试次数过多。';

  @override
  String get appLockIncorrectPin => 'PIN 不正确。';

  @override
  String get appLockPinsDoNotMatch => 'PIN 不匹配。';

  @override
  String get appLockSetupFailed => '设置失败';

  @override
  String get appLockCouldNotDisable => '无法关闭';

  @override
  String get appLockSnackbarTitle => '应用锁';

  @override
  String get appLockBiometricReason => '解锁清理应用';

  @override
  String get photoWidgetTitle => '照片小组件';

  @override
  String get photoWidgetShowOnHomeScreen => '在主屏幕显示';

  @override
  String get photoWidgetActive => '小组件已启用';

  @override
  String get photoWidgetTurnOnAfterImport => '导入后开启';

  @override
  String get photoWidgetImportFirst => '请先导入照片';

  @override
  String get photoWidgetMyAlbums => '我的相册';

  @override
  String get photoWidgetWidgetStyle => '小组件样式';

  @override
  String get photoWidgetCreateAlbum => '创建相册';

  @override
  String get photoWidgetEnterAlbumName => '输入相册名称：';

  @override
  String get photoWidgetWidgetSource => '小组件来源';

  @override
  String get photoWidgetAlbum => '相册';

  @override
  String get photoWidgetAlbumNotFound => '未找到相册';

  @override
  String get photoWidgetUseForHomeScreen => '用于主屏幕小组件';

  @override
  String get photoWidgetActiveAlbum => '当前小组件相册';

  @override
  String get photoWidgetAddNewPhotos => '添加新照片';

  @override
  String get photoWidgetImportPhotos => '导入照片';

  @override
  String get photoWidgetImportPhotosTitle => '导入照片';

  @override
  String photoWidgetDoneCount(int count) {
    return '完成 ($count)';
  }

  @override
  String photoWidgetSelectUpTo(int max) {
    return '最多选择 $max 张。';
  }

  @override
  String get photoWidgetGrid => '网格';

  @override
  String get photoWidgetSlideshow => '幻灯片';

  @override
  String get photoWidgetPreview => '预览';

  @override
  String get photoWidgetGridDescription => '主屏幕显示 2×2 网格。';

  @override
  String get photoWidgetSlideshowDescription => '定时轮播（至少 15 秒）。';

  @override
  String get photoWidgetRenameAlbum => '重命名相册';

  @override
  String get photoWidgetDeleteAlbumTitle => '删除相册？';

  @override
  String get photoWidgetDeleteAlbumBody => '将从小组件缓存中移除。';

  @override
  String get photoWidgetAddWidgetTitle => '添加照片小组件';

  @override
  String get photoWidgetHelpAndroid => '1. 在相册中导入照片\n2. 长按主屏幕 → 小组件\n3. 找到清理应用 → 照片小组件\n4. 拖到主屏幕\n\n或点击下方固定。';

  @override
  String get photoWidgetHelpIos => '1. 长按主屏幕\n2. 点 +\n3. 搜索清理应用\n4. 选择大小并添加\n\n注：iOS 按时间线刷新。';

  @override
  String get photoWidgetPinWidget => '固定小组件';

  @override
  String get photoWidgetPinWidgetButton => '固定到主屏幕';

  @override
  String get photoWidgetPinFollowPrompt => '按系统提示操作。';

  @override
  String get photoWidgetPinManualSteps => '若无法固定请按上方步骤。';

  @override
  String get photoWidgetHelp => '帮助';

  @override
  String photoWidgetDefaultAlbumName(int number) {
    return '相册 $number';
  }

  @override
  String get photoWidgetPermissionRequired => '需要权限';

  @override
  String get photoWidgetAllowPhotoAccess => '允许照片访问以导入。';

  @override
  String get photoWidgetLimitReached => '已达上限';

  @override
  String get photoWidgetAlbumFull => '相册已满（最多 30 张）。';

  @override
  String photoWidgetImportLimit(int max) {
    return '一次最多导入 $max 张。';
  }

  @override
  String get photoWidgetImportFailed => '导入失败';

  @override
  String get photoWidgetCouldNotSave => '无法保存所选照片。';

  @override
  String get photoWidgetPartialImport => '部分导入';

  @override
  String photoWidgetPartialImportMessage(int imported, int total) {
    return '已导入 $imported/$total 张。';
  }

  @override
  String get photoWidgetAddToHomeTitle => '添加到主屏幕';

  @override
  String get photoWidgetAddToHomeBody => '长按主屏幕 → 小组件，或点帮助。';

  @override
  String get photoWidgetUpdated => '小组件已更新';

  @override
  String get photoWidgetUpdatedBody => '请刷新主屏幕小组件。';

  @override
  String get photoWidgetPinSnackbarTitle => '小组件';

  @override
  String get vaultPrivatePhotos => '私密照片';

  @override
  String vaultMediaCount(int photos, int videos) {
    String _temp0 = intl.Intl.pluralLogic(
      photos,
      locale: localeName,
      other: '$photos 张照片',
      one: '1 张照片',
    );
    String _temp1 = intl.Intl.pluralLogic(
      videos,
      locale: localeName,
      other: '$videos 个视频',
      one: '1 个视频',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String get vaultSelectAll => '全选';

  @override
  String get vaultDeleteSelected => '删除所选';

  @override
  String get vaultAddPhotos => '添加照片';

  @override
  String get vaultCouldNotOpen => '无法打开私密照片';

  @override
  String get vaultGoBack => '返回';

  @override
  String get vaultEmptyState => '选择照片开始导入。\n将安全锁定。';

  @override
  String get vaultTakePhotoOrVideo => '拍摄照片或视频';

  @override
  String get vaultImportPhotosOrVideos => '导入照片或视频';

  @override
  String get vaultAlbums => '相册';

  @override
  String get vaultNewAlbum => '新建相册';

  @override
  String get vaultAlbumNameHint => '相册名称';

  @override
  String get vaultCreate => '创建';

  @override
  String get vaultSettings => '保险库设置';

  @override
  String get vaultRemoveAfterImport => '导入后删除';

  @override
  String get vaultRemoveAfterImportSubtitle => '导入成功后从图库删除原文件';

  @override
  String get vaultUseFaceIdFingerprint => '使用面容/指纹';

  @override
  String get vaultSecurity => '安全';

  @override
  String get vaultLockNow => '立即锁定保险库';

  @override
  String get vaultChangePin => '更改 PIN';

  @override
  String get vaultCreatePin => '创建保险库 PIN';

  @override
  String get vaultConfirmPin => '确认保险库 PIN';

  @override
  String get vaultCreatePinSubtitle => '4 位 PIN 保护私密照片';

  @override
  String get vaultConfirmPinSubtitle => '再次输入相同 PIN';

  @override
  String get vaultEnableBiometric => '启用面容/指纹';

  @override
  String get vaultUnlockTitle => '输入密码解锁';

  @override
  String get vaultUnlockSubtitle => '输入 4 位保险库 PIN';

  @override
  String vaultUnlockLocked(int seconds) {
    return '$seconds 秒后重试';
  }

  @override
  String get vaultPinMustBeFourDigits => '保险库 PIN 须为 4 位';

  @override
  String get vaultEnterCurrentPin => '输入当前 PIN';

  @override
  String get vaultEnterNewPin => '输入新 PIN';

  @override
  String get vaultConfirmNewPin => '确认新 PIN';

  @override
  String get vaultPinsDoNotMatch => 'PIN 不匹配。';

  @override
  String get vaultCurrentPinIncorrect => '当前 PIN 错误';

  @override
  String get vaultPinsDoNotMatchShort => 'PIN 不匹配';

  @override
  String get vaultPinChanged => 'PIN 已更改';

  @override
  String get vaultIncorrectPin => 'PIN 错误';

  @override
  String get vaultPermissionTitle => '权限';

  @override
  String get vaultPhotoLibraryRequired => '需要照片库访问';

  @override
  String get vaultImportTitle => '导入';

  @override
  String vaultImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已导入 $count 项',
      one: '已导入 1 项',
    );
    return '$_temp0';
  }

  @override
  String get vaultSnackbarTitle => '保险库';

  @override
  String get vaultBiometricReason => '解锁私密保险库';

  @override
  String get permissionLimitedLibraryAccess => '有限图库访问';

  @override
  String get permissionAllowPhotosVideos => '允许照片和视频';

  @override
  String get permissionLimitedBody => '可管理可见项或在设置中授予完全访问。';

  @override
  String get permissionFullBody => '需要访问以扫描重复项和视频。';

  @override
  String get permissionManageLibraryAccess => '管理图库访问';

  @override
  String get permissionRefreshAccess => '刷新访问';

  @override
  String get permissionOpenSettings => '打开设置';
}
