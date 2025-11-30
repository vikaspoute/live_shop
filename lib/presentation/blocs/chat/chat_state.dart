part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  const ChatLoaded(this.messages);

  final List<MessageModel> messages;

  @override
  List<Object?> get props => [messages];
}

class ChatError extends ChatState {
  const ChatError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
