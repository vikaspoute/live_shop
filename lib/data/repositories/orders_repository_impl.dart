// data/repositories/orders_repository_impl.dart
import 'package:live_shop/data/datasources/remote/orders_remote_datasource.dart';
import 'package:live_shop/data/models/order_model.dart';
import 'package:live_shop/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this.remote);

  final OrdersRemoteDataSource remote;

  @override
  Future<List<OrderModel>> getOrders(String userId) {
    return remote.getOrders(userId);
  }
}
