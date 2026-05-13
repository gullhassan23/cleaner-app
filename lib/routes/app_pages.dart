import 'package:get/get.dart';

import '../bindings/main_shell_binding.dart';
import '../bindings/compress_binding.dart';
import '../features/compress/compress_review_page.dart';
import '../widgets/bottomNavbar.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: AppRoutes.main,
      page: MainShellPage.new,
      binding: MainShellBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.compressReview,
      page: CompressReviewPage.new,
      binding: CompressBinding(),
    ),
  ];
}
