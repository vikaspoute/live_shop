import 'package:dartz/dartz.dart';
import 'package:live_shop/core/errors/failures.dart';
import 'package:live_shop/data/datasources/remote/chat_remote_datasource.dart';
import 'package:live_shop/data/models/message_model.dart';
import 'package:live_shop/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this.remoteDataSource);

  final ChatRemoteDataSource remoteDataSource;

  @override
  Stream<List<MessageModel>> getMessages(String sessionId) {
    return remoteDataSource.getMessages(sessionId);
  }

  @override
  Future<Either<Failure, void>> sendMessage(
    String sessionId,
    String userId,
    String userName,
    String text,
  ) async {
    try {
      await remoteDataSource.sendMessage(sessionId, userId, userName, text);
      return const Right(null);
    } catch (e) {
      return Left(FirebaseFailure(e.toString()));
    }
  }
}
