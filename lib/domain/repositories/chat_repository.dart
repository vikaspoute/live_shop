import 'package:dartz/dartz.dart';
import 'package:live_shop/core/errors/failures.dart';
import 'package:live_shop/data/models/message_model.dart';

abstract class ChatRepository {
  Stream<List<MessageModel>> getMessages(String sessionId);

  Future<Either<Failure, void>> sendMessage(
    String sessionId,
    String userId,
    String userName,
    String text,
  );
}
