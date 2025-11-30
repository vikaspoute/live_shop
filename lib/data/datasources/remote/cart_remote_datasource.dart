import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_shop/core/constants/constants.dart';
import 'package:live_shop/data/models/order_model.dart';
import 'package:live_shop/data/models/product_model.dart';

abstract class CartRemoteDataSource {
  Future<OrderModel> placeOrder(
    String userId,
    List<ProductModel> products,
    double total,
  );
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl(this.firestore);

  final FirebaseFirestore firestore;

  @override
  Future<OrderModel> placeOrder(
    String userId,
    List<ProductModel> products,
    double total,
  ) async {
    try {
      final order = OrderModel(
        id: '',
        userId: userId,
        products: products,
        totalAmount: total,
        status: OrderStatus.paid,
        createdAt: DateTime.now(),
      );

      final docRef = await firestore
          .collection(AppConstants.ordersCollection)
          .add(order.toFirestore());

      return OrderModel(
        id: docRef.id,
        userId: userId,
        products: products,
        totalAmount: total,
        status: OrderStatus.paid,
        createdAt: order.createdAt,
      );
    } catch (e) {
      throw Exception('Failed to place order: ${e.toString()}');
    }
  }
}
