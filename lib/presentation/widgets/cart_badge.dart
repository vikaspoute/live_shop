import 'package:flutter/material.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(LucideIcons.shoppingCart),
        if (count > 0)
          Positioned(
            right: -(AppSizes.sm + AppSizes.xs),
            top: -(AppSizes.sm + AppSizes.xs),
            child: ShadBadge.destructive(
              child: Text(
                '$count',
                style: theme.textTheme.small,
              ),
            ),
          ),
      ],
    );
  }
}
