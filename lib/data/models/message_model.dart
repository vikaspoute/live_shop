import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { user, system, product }

class MessageModel {
  final String id;
  final String sessionId;
  final String userId;
  final String userName;
  final String userImage;
  final String text;
  final DateTime timestamp;
  final MessageType type;

  const MessageModel({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.text,
    required this.timestamp,
    required this.type,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MessageModel(
      id: doc.id,
      sessionId: data['sessionId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userImage: data['userImage'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      type: _messageTypeFromString(data['type'] ?? 'user'),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.name,
    };
  }

  static MessageType _messageTypeFromString(String type) {
    switch (type) {
      case 'system':
        return MessageType.system;
      case 'product':
        return MessageType.product;
      default:
        return MessageType.user;
    }
  }
}
