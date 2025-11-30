import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:live_shop/data/models/message_model.dart';
import 'package:live_shop/domain/repositories/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required this.repo,
  }) : super(ChatInitial());
  final ChatRepository repo;

  StreamSubscription<List<MessageModel>>? _messagesSubscription;

  Future<void> loadMessages(String sessionId) async {
    try {
      emit(ChatLoading());

      // Cancel previous subscription if exists
      await _messagesSubscription?.cancel();

      // Subscribe to messages stream
      _messagesSubscription = repo
          .getMessages(sessionId)
          .listen(
            (messages) {
              emit(ChatLoaded(messages));
            },
            onError: (error) {
              emit(ChatError(error.toString()));
            },
          );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> sendMessage({
    required String sessionId,
    required String userId,
    required String userName,
    required String text,
  }) async {
    if (text.trim().isEmpty) return;

    try {
      final result = await repo.sendMessage(
        sessionId,
        userId,
        userName,
        text,
      );

      result.fold(
        (failure) => emit(ChatError(failure.message)),
        (_) {},
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void clearChat() {
    _messagesSubscription?.cancel();
    emit(ChatInitial());
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
