import 'package:flutter/material.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/core/constants/constants.dart';
import 'package:live_shop/data/models/order_model.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderModel order;

  Color _statusColor() => switch (order.status) {
    OrderStatus.pending => Colors.orange,
    OrderStatus.shipped => Colors.blue,
    OrderStatus.delivered => Colors.green,
    OrderStatus.cancelled => Colors.red,
    _ => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: ShadCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ShadBadge.outline(
                  child: Text(
                    order.status.name.toUpperCase(),
                    style: theme.textTheme.small.copyWith(
                      color: _statusColor(),
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat(AppConstants.dateFormat).format(order.createdAt),
                  style: theme.textTheme.small,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                if (order.products.isNotEmpty)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(order.products.first.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${order.products.length} item${order.products.length > 1 ? 's' : ''}',
                        style: theme.textTheme.small.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '#${order.id.substring(0, 8).toUpperCase()}',
                        style: theme.textTheme.small.copyWith(
                          color: theme.colorScheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(LucideIcons.chevronRight),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            Text(
              '${context.l10n.total}: ${AppConstants.rupeeSymbol}${order.totalAmount.toStringAsFixed(2)}',
              style: theme.textTheme.large.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
