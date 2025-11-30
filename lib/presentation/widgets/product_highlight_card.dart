import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/data/models/product_model.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:live_shop/presentation/blocs/cart/cart_cubit.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ProductHighlightCard extends StatelessWidget {
  const ProductHighlightCard({required this.product, super.key});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.muted.withOpacity(0.1),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.sm),
              image: DecorationImage(
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShadBadge(
                  shape: BoxBorder.all(strokeAlign: 3),
                  backgroundColor: Colors.green,
                  child: Text(
                    l10n.featured,
                    style: theme.textTheme.lead.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
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
                  '\$${product.price.toStringAsFixed(2)}',
                  style: theme.textTheme.large.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                ShadButton(
                  height: AppSizes.xl,
                  onPressed: () => context.read<CartCubit>().addToCart(product),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.circlePlus, size: 16),
                      const SizedBox(width: AppSizes.xs),
                      Text(l10n.addToCart),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
