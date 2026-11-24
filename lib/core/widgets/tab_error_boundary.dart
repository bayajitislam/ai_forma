import 'package:flutter/material.dart';
import 'package:ai_forma/core/theme/app_colors.dart';
import 'package:ai_forma/core/theme/app_fonts.dart';

/// Catches render errors within a single tab so the entire app shell
/// doesn't crash to the global [AppErrorWidget] screen.
///
/// When a child subtree throws during build/layout/paint, this widget
/// replaces that subtree with a friendly retry card. Tapping "Tap to retry"
/// clears the error flag and rebuilds the child from scratch.
class TabErrorBoundary extends StatefulWidget {
  const TabErrorBoundary({super.key, required this.child});
  final Widget child;

  @override
  State<TabErrorBoundary> createState() => _TabErrorBoundaryState();
}

class _TabErrorBoundaryState extends State<TabErrorBoundary> {
  Object? _error;
  int _rebuildKey = 0;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardBorder.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.brandTeal,
                  size: 32,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Could not load this tab',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'An error occurred while loading. Tap below to try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() {
                  _error = null;
                  _rebuildKey++;
                }),
                child: const Text(
                  'Tap to retry',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    color: AppColors.brandTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return KeyedSubtree(
      key: ValueKey<int>(_rebuildKey),
      child: widget.child,
    );
  }
}
