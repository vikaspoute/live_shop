import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:live_shop/domain/repositories/auth_repository.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<LoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
  }

  final AuthRepository repo;

  Future<void> _onLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await repo.login(event.phone, event.otp);

      result.fold(
        (failure) => emit(AuthError(failure.message)),
        (userId) => emit(AuthSuccess(userId)),
      );
    } catch (e) {
      emit(const AuthError('An unexpected error occurred'));
    }
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthInitial());
  }

  Future<void> _onCheckAuthStatusEvent(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Check if user is already logged in
    // This can be implemented if needed
    emit(AuthInitial());
  }
}
