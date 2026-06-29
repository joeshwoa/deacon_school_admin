import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Core/data/auth_repository.dart';
import '../../../../Core/services/supabase_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;

  AuthCubit({AuthRepository? repository})
      : _repo = repository ?? AuthRepository(),
        super(const AuthState());

  bool get isLoggedIn => _repo.isLoggedIn;
  String? get email => _repo.currentEmail;

  void togglePassword() =>
      emit(state.copyWith(showPassword: !state.showPassword));

  Future<bool> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, errorKey: null));
    try {
      await _repo.signIn(email: email, password: password);
      emit(state.copyWith(status: AuthStatus.authenticated));
      return true;
    } on BackendNotConnected {
      emit(state.copyWith(
          status: AuthStatus.error, errorKey: 'backendNotConnected'));
      return false;
    } catch (_) {
      emit(state.copyWith(status: AuthStatus.error, errorKey: 'loginFailed'));
      return false;
    }
  }

  Future<bool> sendReset(String email) async {
    try {
      await _repo.sendPasswordReset(email);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    await _repo.signOut();
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
