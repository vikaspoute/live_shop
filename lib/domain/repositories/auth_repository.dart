import 'package:dartz/dartz.dart';
import 'package:live_shop/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String phone, String otp);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, String?>> getCurrentUserId();
}