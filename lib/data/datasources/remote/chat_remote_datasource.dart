import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_shop/core/constants/constants.dart';
import 'package:live_shop/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Stream<List<MessageModel>> getMessages(String sessionId);

  Future<void> sendMessage(
    String sessionId,
    String userId,
    String userName,
    String text,
  );
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  @override
  Stream<List<MessageModel>> getMessages(String sessionId) {
    return firestore
        .collection(AppConstants.sessionsCollection)
        .doc(sessionId)
        .collection(FirebaseConstants.messagesSubCollection)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(MessageModel.fromFirestore).toList(),
        );
  }

  @override
  Future<void> sendMessage(
    String sessionId,
    String userId,
    String userName,
    String text,
  ) async {
    try {
      final message = MessageModel(
        id: '',
        sessionId: sessionId,
        userId: userId,
        userName: userName,
        userImage: 'https://ui-avatars.com/api/?name=$userName',
        text: text,
        timestamp: DateTime.now(),
        type: MessageType.user,
      );

      await firestore
          .collection(AppConstants.sessionsCollection)
          .doc(sessionId)
          .collection(FirebaseConstants.messagesSubCollection)
          .add(message.toFirestore());
    } catch (e) {
      throw Exception('Failed to send message: ${e.toString()}');
    }
  }
}
