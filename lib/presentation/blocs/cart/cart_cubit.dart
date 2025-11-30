import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:live_shop/data/models/order_model.dart';
import 'package:live_shop/data/models/product_model.dart';
import 'package:live_shop/domain/repositories/cart_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository repo;

  CartCubit({
    required this.repo,
  }) : super(const CartInitial());

  Future<void> loadCart() async {
    emit(const CartLoading());

    try {
      final result = await repo.getCart();

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (cart) {
          if (cart.isEmpty) {
            emit(const CartEmpty());
          } else {
            emit(CartLoaded(cart));
          }
        },
      );
    } catch (e) {
      emit(const CartError('Failed to load cart'));
    }
  }

  Future<void> addToCart(ProductModel product) async {
    try {
      // Show loading overlay or keep current state
      final currentState = state;

      final result = await repo.addToCart(product);

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (_) async {
          // Refresh cart after adding
          await loadCart();
        },
      );
    } catch (e) {
      emit(const CartError('Failed to add product to cart'));
    }
  }

  Future<void> removeFromCart(String productId) async {
    try {
      final result = await repo.removeFromCart(productId);

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (_) async {
          // Refresh cart after removing
          await loadCart();
        },
      );
    } catch (e) {
      emit(const CartError('Failed to remove product from cart'));
    }
  }

  Future<void> placeOrder(String userId) async {
    if (state is! CartLoaded) {
      emit(const CartError('Cart is not loaded'));
      return;
    }

    try {
      final cart = (state as CartLoaded).cart;
      final total = cart.fold(0.0, (sum, p) => sum + p.price);

      print(cart);

      emit(const CartProcessingOrder());
      final result = await repo.placeOrder(userId, cart, total);

      result.fold(
        (failure) => emit(CartError(failure.message)),
        (order) async {
          // Clear local cart after successful order
          await clearCart();
          emit(OrderPlaced(order));
        },
      );
    } catch (e) {
      emit(CartError('Failed to place order $e'));
    }
  }

  Future<void> clearCart() async {
    try {
      await repo.clearCart();
      emit(const CartEmpty());
    } catch (e) {
      emit(const CartError('Failed to clear cart'));
    }
  }

  void resetToCart() {
    loadCart();
  }
}
