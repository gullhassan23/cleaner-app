
import 'package:cleaner_app/utils/colors.dart';
import 'package:flutter/material.dart';

class DashboardAppbar extends StatelessWidget {
  const DashboardAppbar({
    super.key,
    required this.child,
    required this.onSettings,
    this.onSort,
 
  });

  final Widget child;
  final VoidCallback onSettings;
  final VoidCallback? onSort;
 

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 12, 4),
          child: Row(
            children: [
              const Text(
                'Cleaner',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.8,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Material(
                color: kDashBlue,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap:
                      () => ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('PRO'))),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.thumb_up_alt_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'PRO',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (onSort != null)
                IconButton(
                  onPressed: onSort,
                  icon: Icon(Icons.sort_rounded, color: kDashGrey, size: 26),
                ),
              IconButton(
                onPressed: onSettings,
                icon: Icon(Icons.settings_outlined, color: kDashGrey, size: 26),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
