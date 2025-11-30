import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';

enum OrderStatus { pending, paid, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String userId;
  final List<ProductModel> products;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final productsList = (data['products'] as List<dynamic>).map((p) {
      final map = Map<String, dynamic>.from(p);
      return ProductModel.fromMap(map, map['id']);
    }).toList();

    return OrderModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      products: productsList,
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      status: _orderStatusFromString(data['status'] ?? 'pending'),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'products': products.map((p) => p.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static OrderStatus _orderStatusFromString(String status) {
    switch (status) {
      case 'paid':
        return OrderStatus.paid;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }
}
