// presentation/blocs/orders/orders_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:live_shop/data/models/order_model.dart';
import 'package:live_shop/domain/repositories/orders_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit({required this.repo}) : super(const OrdersInitial());
  final OrdersRepository repo;

  Future<void> loadOrders(String userId) async {
    emit(const OrdersLoading());
    try {
      final orders = await repo.getOrders(userId);
      emit(orders.isEmpty ? const OrdersEmpty() : OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError('Failed to load orders: $e'));
    }
  }

  Future<void> refreshOrders(String userId) async {
    await loadOrders(userId);
  }
}
