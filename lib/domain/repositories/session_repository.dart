import 'package:dartz/dartz.dart';
import 'package:live_shop/core/errors/failures.dart';
import 'package:live_shop/data/models/session_model.dart';

abstract class SessionRepository {
  Future<Either<Failure, List<SessionModel>>> getSessions();
  Future<Either<Failure, SessionModel>> getSessionById(String sessionId);
  Stream<List<SessionModel>> watchSessions();
}