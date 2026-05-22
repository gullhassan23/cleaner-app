
import 'package:cleaner_app/utils/colors.dart';
import 'package:cleaner_app/widgets/clean_guide/guide_back_button.dart';
import 'package:cleaner_app/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CleanupGuideFlowPage extends StatefulWidget {
  const CleanupGuideFlowPage({super.key});

  @override
  State<CleanupGuideFlowPage> createState() => _CleanupGuideFlowPageState();
}

class _CleanupGuideFlowPageState extends State<CleanupGuideFlowPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  static const int _stepCount = 4;

  List<String> _stepSubtitles(BuildContext context) {
    final l10n = context.l10n;
    return [
      l10n.guideStepOpenSettings,
      l10n.guideStepClickGeneral,
      l10n.guideStepTapIphoneStorage,
      l10n.guideStepEnableOffload,
    ];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage >= _stepCount - 1) {
      Get.back<void>();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = Theme.of(context).colorScheme;
    final isLast = _currentPage >= _stepCount - 1;
    final subtitles = _stepSubtitles(context);

    return Scaffold(
      backgroundColor: cs.groupedBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  GuideFlowBackButton(onPressed: () => Get.back<void>()),
                  const Spacer(),
                  const SizedBox(width: 40),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.guideFlowTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                subtitles[_currentPage],
                key: ValueKey<int>(_currentPage),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _stepCount,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: Image.asset(
                        offloadStepAssets[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
            _PageDots(currentIndex: _currentPage, count: _stepCount),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _onNext,
                  style: FilledButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isLast ? l10n.guideFlowClose : l10n.guideFlowNext,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.currentIndex, required this.count});

  final int currentIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final active = index == currentIndex;
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? cs.primary : cs.outlineVariant,
          ),
        );
      }),
    );
  }
}
