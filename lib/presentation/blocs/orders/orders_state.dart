// orders_state.dart
part of 'orders_cubit.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  const OrdersLoaded(this.orders);

  final List<OrderModel> orders;

  @override
  List<Object?> get props => [orders];
}

class OrdersEmpty extends OrdersState {
  const OrdersEmpty();
}

class OrdersError extends OrdersState {
  const OrdersError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
