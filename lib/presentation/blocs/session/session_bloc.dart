import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:live_shop/data/models/session_model.dart';
import 'package:live_shop/domain/repositories/session_repository.dart';

part 'session_event.dart';

part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  SessionBloc({required this.repo}) : super(SessionInitial()) {
    on<FetchSessionsEvent>(_onFetchSessions);
    on<RefreshSessionsEvent>(_onRefreshSessions);
  }

  final SessionRepository repo;

  Future<void> _onFetchSessions(
    FetchSessionsEvent event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());

    try {
      final result = await repo.getSessions();

      result.fold(
        (failure) => emit(SessionError(failure.message)),
        (sessions) => emit(SessionLoaded(sessions)),
      );
    } catch (e) {
      emit(const SessionError('Failed to load sessions'));
    }
  }

  Future<void> _onRefreshSessions(
    RefreshSessionsEvent event,
    Emitter<SessionState> emit,
  ) async {
    // Don't show loading for refresh
    try {
      final result = await repo.getSessions();

      result.fold(
        (failure) => emit(SessionError(failure.message)),
        (sessions) => emit(SessionLoaded(sessions)),
      );
    } catch (e) {
      emit(const SessionError('Failed to refresh sessions'));
    }
  }
}
