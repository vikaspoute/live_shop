import 'package:flutter/material.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/core/constants/constants.dart';
import 'package:live_shop/data/models/order_model.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:live_shop/presentation/pages/sessions_list_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({required this.order, super.key});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = ShadTheme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.xl),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(
                LucideIcons.circleCheck,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: AppSizes.lg),
              Text(
                l10n.orderPlacedSuccess,
                style: theme.textTheme.h2.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                l10n.thankYouPurchase,
                style: theme.textTheme.muted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              ShadCard(
                title: Text(l10n.orderDetails),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: LucideIcons.receipt,
                      label: l10n.orderId,
                      value: '#${order.id.substring(0, 8).toUpperCase()}',
                    ),
                    _DetailRow(
                      icon: LucideIcons.calendar,
                      label: l10n.date,
                      value: DateFormat(
                        AppConstants.dateFormat,
                      ).format(order.createdAt),
                    ),
                    _DetailRow(
                      icon: LucideIcons.clock,
                      label: l10n.time,
                      value: DateFormat(
                        AppConstants.timeFormat,
                      ).format(order.createdAt),
                    ),
                    _DetailRow(
                      icon: LucideIcons.dollarSign,
                      label: l10n.totalAmount,
                      value:
                          '${AppConstants.rupeeSymbol}${order.totalAmount.toStringAsFixed(2)}',
                      bold: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.xl),
              ShadButton(
                width: double.infinity,
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const SessionsListPage()),
                  (_) => false,
                ),
                child: Text(l10n.continueShopping),
              ),
              const SizedBox(height: AppSizes.md),
              ShadButton.outline(
                width: double.infinity,
                onPressed: () => ShadToaster.of(context).show(
                  ShadToast(description: Text(context.l10n.comingSoon)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.truck),
                    const SizedBox(width: AppSizes.sm),
                    Text(context.l10n.trackOrder),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.bold = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppSizes.iconSm,
            color: theme.colorScheme.mutedForeground,
          ),
          const SizedBox(width: AppSizes.sm),
          Text(label, style: theme.textTheme.small),
          const Spacer(),
          Text(
            value,
            style: bold
                ? theme.textTheme.large.copyWith(
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.small,
          ),
        ],
      ),
    );
  }
}
