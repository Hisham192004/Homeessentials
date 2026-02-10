import 'package:bloc/bloc.dart';
import 'admin_login_state.dart';

class AdminLoginCubit extends Cubit<AdminLoginState> {
  AdminLoginCubit() : super(AdminLoginInitial());

  void login({
    required String email,
    required String password,
  }) async {
    emit(AdminLoginLoading());

    await Future.delayed(const Duration(milliseconds: 800)); // UI smooth

    if (email == "admin@gmail.com" && password == "admin123") {
      emit(AdminLoginSuccess());
    } else {
      emit(AdminLoginError("Invalid Admin Credentials"));
    }
  }
}
