import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool showPassword = false;

  void togglePassword() {
    showPassword =!showPassword;
    emit(TogglePasswordState());
    emit(AnyState());
  }
}
