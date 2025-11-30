import 'package:dartz/dartz.dart';
import 'package:live_shop/core/errors/failures.dart';
import 'package:live_shop/data/datasources/local/cart_local_datasource.dart';
import 'package:live_shop/data/datasources/remote/cart_remote_datasource.dart';
import 'package:live_shop/data/models/order_model.dart';
import 'package:live_shop/data/models/product_model.dart';
import 'package:live_shop/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<ProductModel>>> getCart() async {
    try {
      final cart = await localDataSource.getCart();
      return Right(cart);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(ProductModel product) async {
    try {
      await localDataSource.addToCart(product);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(String productId) async {
    try {
      await localDataSource.removeFromCart(productId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderModel>> placeOrder(
    String userId,
    List<ProductModel> products,
    double total,
  ) async {
    try {
      final order = await remoteDataSource.placeOrder(userId, products, total);

      // Clear local cart after successful order
      await localDataSource.clearCart();

      return Right(order);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }
}
