// data/datasources/remote/orders_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_shop/data/models/order_model.dart';

mixin OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders(String userId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl(this.firestore);

  final FirebaseFirestore firestore;

  @override
  Future<List<OrderModel>> getOrders(String userId) async {
    final snapshot = await firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map(OrderModel.fromFirestore).toList();
  }
}
