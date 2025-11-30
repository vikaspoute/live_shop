import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:live_shop/data/models/product_model.dart';

abstract class CartLocalDataSource {
  Future<List<ProductModel>> getCart();

  Future<void> addToCart(ProductModel product);

  Future<void> removeFromCart(String productId);

  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  CartLocalDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;
  static const String cartKey = 'cart';

  @override
  Future<List<ProductModel>> getCart() async {
    try {
      final cartJson = sharedPreferences.getString(cartKey);
      if (cartJson == null) return [];

      final cartList = json.decode(cartJson) as List<dynamic>;
      return cartList
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get cart: ${e.toString()}');
    }
  }

  @override
  Future<void> addToCart(ProductModel product) async {
    try {
      final cart = await getCart();

      // Check if product already exists
      final existingIndex = cart.indexWhere((p) => p.id == product.id);
      if (existingIndex == -1) {
        cart.add(product);
      }

      final cartJson = json.encode(cart.map((p) => p.toJson()).toList());
      await sharedPreferences.setString(cartKey, cartJson);
    } catch (e) {
      throw Exception('Failed to add to cart: ${e.toString()}');
    }
  }

  @override
  Future<void> removeFromCart(String productId) async {
    try {
      final cart = await getCart();
      cart.removeWhere((p) => p.id == productId);

      final cartJson = json.encode(cart.map((p) => p.toJson()).toList());
      await sharedPreferences.setString(cartKey, cartJson);
    } catch (e) {
      throw Exception('Failed to remove from cart: ${e.toString()}');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await sharedPreferences.remove(cartKey);
    } catch (e) {
      throw Exception('Failed to clear cart: ${e.toString()}');
    }
  }
}
