import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_shop/core/constants/AppSizes.dart';
import 'package:live_shop/l10n/l10n.dart';
import 'package:live_shop/presentation/blocs/auth/auth_bloc.dart';
import 'package:live_shop/presentation/blocs/orders/orders_cubit.dart';
import 'package:live_shop/presentation/widgets/empty_widget.dart';
import 'package:live_shop/presentation/widgets/order_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    final userId = (context.read<AuthBloc>().state as AuthSuccess).userId;
    context.read<OrdersCubit>().loadOrders(userId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myOrders),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: () => context.read<OrdersCubit>().refreshOrders(
              (context.read<AuthBloc>().state as AuthSuccess).userId,
            ),
          ),
        ],
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrdersError) return Center(child: Text(state.message));
          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return EmptyWidget(
                icon: LucideIcons.receipt,
                title: l10n.noOrdersYet,
                subtitle: l10n.startShopping,
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<OrdersCubit>().refreshOrders(
                (context.read<AuthBloc>().state as AuthSuccess).userId,
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSizes.md),
                itemCount: state.orders.length,
                itemBuilder: (_, i) => OrderCard(order: state.orders[i]),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
