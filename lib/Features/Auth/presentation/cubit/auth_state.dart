part of 'auth_cubit.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final bool showPassword;
  final String? errorKey;

  const AuthState({
    this.status = AuthStatus.initial,
    this.showPassword = false,
    this.errorKey,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? showPassword,
    String? errorKey,
  }) {
    return AuthState(
      status: status ?? this.status,
      showPassword: showPassword ?? this.showPassword,
      errorKey: errorKey,
    );
  }
}
