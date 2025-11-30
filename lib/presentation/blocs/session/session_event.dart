part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();

  @override
  List<Object?> get props => [];
}

class FetchSessionsEvent extends SessionEvent {
  const FetchSessionsEvent();
}

class RefreshSessionsEvent extends SessionEvent {
  const RefreshSessionsEvent();
}