import 'package:dartz/dartz.dart';
import 'package:live_shop/core/errors/failures.dart';
import 'package:live_shop/data/models/order_model.dart';
import 'package:live_shop/data/models/product_model.dart';

abstract class CartRepository {
  Future<Either<Failure, List<ProductModel>>> getCart();

  Future<Either<Failure, void>> addToCart(ProductModel product);

  Future<Either<Failure, void>> removeFromCart(String productId);

  Future<Either<Failure, void>> clearCart();

  Future<Either<Failure, OrderModel>> placeOrder(
    String userId,
    List<ProductModel> products,
    double total,
  );
}
