// domain/repositories/orders_repository.dart
import 'package:live_shop/data/models/order_model.dart';

mixin OrdersRepository {
  Future<List<OrderModel>> getOrders(String userId);
}
