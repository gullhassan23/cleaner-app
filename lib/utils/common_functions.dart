import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openTermsAndConditions(BuildContext context) async {
  final isAndroid = Theme.of(context).platform == TargetPlatform.android;
  final termsUrl = _envUrl([
    if (isAndroid) 'ANDROID_TERMS_AND_CONDITIONS_URL',
    'TERMS_OF_USE_URL',
  ], '');
  await _openExternalUrl(context, termsUrl);
}

Future<void> _openExternalUrl(BuildContext context, String url) async {
  final uri = Uri.tryParse(url.trim());
  if (uri == null || !uri.hasScheme) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid URL in app configuration')),
      );
    }
    return;
  }

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched && context.mounted) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Could not open link')));
  }
}

String _envUrl(List<String> keys, String fallback) {
  if (!dotenv.isInitialized) {
    return fallback;
  }
  for (final key in keys) {
    final value = dotenv.env[key]?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
  }
  return fallback;
}

Future<void> openPrivacyPolicy(BuildContext context) async {
  final isAndroid = Theme.of(context).platform == TargetPlatform.android;
  final privacyUrl = _envUrl([
    if (isAndroid) 'ANDROID_PRIVACY_POLICY_URL',
    'PRIVACY_POLICY_URL',
  ], '');
  await _openExternalUrl(context, privacyUrl);
}

Future<void> shareAppLink(BuildContext context) async {
  final info = await PackageInfo.fromPlatform();
  // ignore: use_build_context_synchronously
  final isAndroid = Theme.of(context).platform == TargetPlatform.android;
  final androidStoreUrl = _envUrl(
    ['ANDROID_STORE_URL'],
    'https://play.google.com/store/apps/details?id=com.FutureDialLabs.copymydata.transfer.file.all.data.app',
  );
  final iosStoreUrl = _envUrl([
    'IOS_STORE_URL',
  ], 'https://apps.apple.com/us/app/share-all-file-transfer-app/id6759640831');
  final url = isAndroid ? androidStoreUrl : iosStoreUrl;
  final text = '${info.appName}\n$url';
  // ignore: use_build_context_synchronously
  final box = context.findRenderObject() as RenderBox?;
  final Rect? origin =
      box != null
          ? Rect.fromLTWH(
            box.localToGlobal(Offset.zero).dx,
            box.localToGlobal(Offset.zero).dy,
            box.size.width,
            box.size.height,
          )
          : null;
  // ignore: deprecated_member_use
  await Share.share(text, subject: info.appName, sharePositionOrigin: origin);
}
