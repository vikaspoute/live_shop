import 'package:flutter/material.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    required this.error,
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.circleAlert, size: 64, color: Colors.red),
            const SizedBox(height: AppSizes.md),
            Text(l10n.errorLoadingSessions, style: theme.textTheme.large),
            const SizedBox(height: AppSizes.sm),
            Text(
              message,
              style: theme.textTheme.muted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            ShadButton(onPressed: onRetry, child: Text(l10n.retry)),
          ],
        ),
      ),
    );
  }
}
