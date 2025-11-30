import 'package:flutter/material.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    required this.icon,
    required this.subtitle,
    required this.title,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;

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
            Icon(
              icon,
              size: 80,
              color: theme.colorScheme.mutedForeground,
            ),
            const SizedBox(height: AppSizes.md),
            Text(title, style: theme.textTheme.h3),
            const SizedBox(height: AppSizes.sm),
            Text(subtitle, style: theme.textTheme.muted),
          ],
        ),
      ),
    );
  }
}
