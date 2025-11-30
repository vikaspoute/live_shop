import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_shop/core/constants/constants.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String phone, String otp);

  Future<void> logout();

  Future<bool> isLoggedIn();

  Future<String?> getCurrentUserId();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this.firebaseAuth);

  final FirebaseAuth firebaseAuth;

  @override
  Future<String> login(String phone, String otp) async {
    try {
      // Mock OTP validation
      if (otp != AppConstants.mockOTP) {
        throw Exception('Invalid OTP');
      }

      // For demo purposes, sign in anonymously
      // In production, you'd use phone authentication
      final userCredential = await firebaseAuth.signInAnonymously();

      return userCredential.user!.uid;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return firebaseAuth.currentUser != null;
  }

  @override
  Future<String?> getCurrentUserId() async {
    return firebaseAuth.currentUser?.uid;
  }
}
