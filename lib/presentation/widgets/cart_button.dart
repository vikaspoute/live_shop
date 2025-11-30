import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_shop/presentation/blocs/cart/cart_cubit.dart';
import 'package:live_shop/presentation/pages/cart_page.dart';
import 'package:live_shop/presentation/widgets/cart_badge.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final count = state is CartLoaded ? state.itemCount : 0;
        return ShadButton.ghost(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartPage()),
          ),
          child: CartBadge(count: count),
        );
      },
    );
  }
}
