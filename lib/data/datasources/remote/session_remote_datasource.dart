import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_shop/core/constants/constants.dart';
import 'package:live_shop/data/models/session_model.dart';

abstract class SessionRemoteDataSource {
  Future<List<SessionModel>> getSessions();

  Future<SessionModel> getSessionById(String sessionId);

  Stream<List<SessionModel>> watchSessions();
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {

  SessionRemoteDataSourceImpl(this.firestore);
  final FirebaseFirestore firestore;

  @override
  Future<List<SessionModel>> getSessions() async {
    try {
      final querySnapshot = await firestore
          .collection(AppConstants.sessionsCollection)
          .where('isLive', isEqualTo: true)
          .orderBy('startedAt', descending: true)
          .get();

      return querySnapshot.docs.map(SessionModel.fromFirestore).toList();
    } catch (e) {
      throw Exception('Failed to fetch sessions: ${e.toString()}');
    }
  }

  @override
  Future<SessionModel> getSessionById(String sessionId) async {
    try {
      final doc = await firestore
          .collection(AppConstants.sessionsCollection)
          .doc(sessionId)
          .get();

      if (!doc.exists) {
        throw Exception('Session not found');
      }

      return SessionModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch session: ${e.toString()}');
    }
  }

  @override
  Stream<List<SessionModel>> watchSessions() {
    return firestore
        .collection(AppConstants.sessionsCollection)
        .where('isLive', isEqualTo: true)
        .orderBy('startedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SessionModel.fromFirestore(doc))
              .toList(),
        );
  }
}
