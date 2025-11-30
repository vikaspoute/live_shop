import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/core/constants/constants.dart';
import 'package:live_shop/data/models/product_model.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:live_shop/presentation/blocs/auth/auth_bloc.dart';
import 'package:live_shop/presentation/blocs/cart/cart_cubit.dart';
import 'package:live_shop/presentation/pages/order_success_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadCart();
  }

  void _checkout() {
    final userId = context.read<AuthBloc>().state is AuthSuccess
        ? (context.read<AuthBloc>().state as AuthSuccess).userId
        : 'guest';

    showShadDialog(
      context: context,
      builder: (_) => ShadDialog(
        title: Text(context.l10n.confirmOrder),
        description: Text(context.l10n.confirmOrderDesc),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
          ),
          ShadButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<CartCubit>().placeOrder(userId);
            },
            child: Text(context.l10n.placeOrder),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shoppingCart)),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) async {
          if (state is OrderPlaced) {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => OrderSuccessPage(order: state.order),
              ),
            );
          } else if (state is CartError) {
            ShadToaster.of(context).show(
              ShadToast.destructive(
                title: Text(context.l10n.error),
                description: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartEmpty) return const EmptyCartWidget();
          if (state is CartProcessingOrder) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppSizes.lg),
                  Text(l10n.processingOrder, style: theme.textTheme.large),
                ],
              ),
            );
          }

          if (state is CartLoaded) {
            const taxRate = 0.1;
            final tax = state.total * taxRate;
            final total = state.total + tax;

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.md),
                    itemCount: state.cart.length,
                    itemBuilder: (context, i) =>
                        CartItemCard(product: state.cart[i]),
                  ),
                ),
                CartSummary(total: total, tax: tax, onCheckout: _checkout),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = ShadTheme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.shoppingCart, size: 80, color: Colors.grey),
          const SizedBox(height: AppSizes.lg),
          Text(l10n.yourCartIsEmpty, style: theme.textTheme.h3),
          const SizedBox(height: AppSizes.sm),
          Text(l10n.addItemsFromLive, style: theme.textTheme.muted),
          const SizedBox(height: AppSizes.lg),
          ShadButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.browseSessions),
          ),
        ],
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard({required this.product, super.key});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadCard(
      padding: const EdgeInsets.all(AppSizes.sm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.sm),
            child: Image.network(
              product.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.small.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  product.category,
                  style: theme.textTheme.small.copyWith(
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  '${AppConstants.rupeeSymbol}${product.price.toStringAsFixed(2)}',
                  style: theme.textTheme.large.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ShadButton.ghost(
            onPressed: () =>
                context.read<CartCubit>().removeFromCart(product.id),
            child: const Icon(LucideIcons.trash2, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

class CartSummary extends StatelessWidget {
  const CartSummary({
    required this.total,
    required this.tax,
    required this.onCheckout,
    super.key,
  });

  final double total;
  final double tax;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = ShadTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSizes.xl),
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        border: Border(top: BorderSide(color: theme.colorScheme.border)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _SummaryRow(
              label: l10n.subtotal,
              value:
                  '${AppConstants.rupeeSymbol}${(total - tax).toStringAsFixed(2)}',
            ),
            _SummaryRow(
              label: l10n.shipping,
              value: l10n.free,
              valueColor: theme.colorScheme.primary,
            ),
            _SummaryRow(
              label: l10n.tax,
              value: '${AppConstants.rupeeSymbol}${tax.toStringAsFixed(2)}',
            ),
            const Divider(height: 32),
            _SummaryRow(
              label: l10n.total,
              value: '${AppConstants.rupeeSymbol}${total.toStringAsFixed(2)}',
              isBold: true,
            ),
            const SizedBox(height: AppSizes.lg),
            ShadButton(
              width: double.infinity,
              onPressed: onCheckout,
              child: Text(l10n.proceedToCheckout),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? theme.textTheme.large : theme.textTheme.small,
          ),
          Text(
            value,
            style: isBold
                ? theme.textTheme.large.copyWith(
                    color: theme.colorScheme.primary,
                  )
                : theme.textTheme.small.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
