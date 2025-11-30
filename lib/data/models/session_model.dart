import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerImage;
  final String title;
  final String description;
  final bool isLive;
  final int viewerCount;
  final DateTime startedAt;
  final String? thumbnailUrl;

  const SessionModel({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerImage,
    required this.title,
    required this.description,
    required this.isLive,
    required this.viewerCount,
    required this.startedAt,
    this.thumbnailUrl,
  });

  factory SessionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return SessionModel(
      id: doc.id,
      sellerId: data['sellerId'] ?? '',
      sellerName: data['sellerName'] ?? '',
      sellerImage: data['sellerImage'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isLive: data['isLive'] ?? false,
      viewerCount: data['viewerCount'] ?? 0,
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      thumbnailUrl: data['thumbnailUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerImage': sellerImage,
      'title': title,
      'description': description,
      'isLive': isLive,
      'viewerCount': viewerCount,
      'startedAt': Timestamp.fromDate(startedAt),
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
