class AppConstants {
  static const String appName = 'Live Shop';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String sessionsCollection = 'sessions';
  static const String messagesCollection = 'messages';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';

  // Mock OTP
  static const String mockOTP = '123456';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ind rupee symbol
  static const String rupeeSymbol = '₹';

  // date time formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'hh:mm a';

}

class FirebaseConstants {
  static const String messagesSubCollection = 'messages';
  static const String productsSubCollection = 'highlighted_products';
}