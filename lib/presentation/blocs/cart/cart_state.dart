part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartEmpty extends CartState {
  const CartEmpty();
}

class CartLoaded extends CartState {
  final List<ProductModel> cart;

  const CartLoaded(this.cart);

  @override
  List<Object?> get props => [cart];

  // Helper getters
  double get total => cart.fold(0.0, (sum, product) => sum + product.price);

  int get itemCount => cart.length;
}

class CartProcessingOrder extends CartState {
  const CartProcessingOrder();
}

class OrderPlaced extends CartState {
  final OrderModel order;

  const OrderPlaced(this.order);

  @override
  List<Object?> get props => [order];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
