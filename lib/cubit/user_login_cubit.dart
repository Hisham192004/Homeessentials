import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_login_state.dart';

class UserLoginCubit extends Cubit<UserLoginState> {
  UserLoginCubit() : super(UserLoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(UserLoginLoading());

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      emit(UserLoginSuccess());
    } catch (e) {
      emit(UserLoginError("Invalid email or password"));
    }
  }
}
