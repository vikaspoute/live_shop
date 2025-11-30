import 'package:dartz/dartz.dart';
import 'package:live_shop/core/errors/failures.dart';
import 'package:live_shop/data/datasources/remote/session_remote_datasource.dart';
import 'package:live_shop/data/models/session_model.dart';
import 'package:live_shop/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  SessionRepositoryImpl(this.remoteDataSource);

  final SessionRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, List<SessionModel>>> getSessions() async {
    try {
      final sessions = await remoteDataSource.getSessions();
      return Right(sessions);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SessionModel>> getSessionById(
    String sessionId,
  ) async {
    try {
      final session = await remoteDataSource.getSessionById(sessionId);
      return Right(session);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<SessionModel>> watchSessions() {
    return remoteDataSource.watchSessions();
  }
}
