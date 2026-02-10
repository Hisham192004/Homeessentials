import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_register_state.dart';

class UserRegisterCubit extends Cubit<UserRegisterState> {
  UserRegisterCubit() : super(UserRegisterInitial());

  Future<void> register({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      emit(UserRegisterError("Email & password required"));
      return;
    }

    emit(UserRegisterLoading());

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      emit(UserRegisterSuccess());
    } on FirebaseAuthException catch (e) {
      emit(UserRegisterError(e.message ?? "Registration failed"));
    }
  }
}
