import 'package:dartz/dartz.dart';
import 'package:live_shop/core/errors/failures.dart';
import 'package:live_shop/data/datasources/remote/auth_remote_datasource.dart';
import 'package:live_shop/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remoteDataSource);

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, String>> login(String phone, String otp) async {
    try {
      final userId = await remoteDataSource.login(phone, otp);
      return Right(userId);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await remoteDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getCurrentUserId() async {
    try {
      final userId = await remoteDataSource.getCurrentUserId();
      return Right(userId);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}
