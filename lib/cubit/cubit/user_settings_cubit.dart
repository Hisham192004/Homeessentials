import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_settings_state.dart';

class UserSettingsCubit extends Cubit<UserSettingsState> {
  UserSettingsCubit() : super(UserSettingsInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> logout() async {
    emit(UserSettingsLoading());
    try {
      await _auth.signOut();
      emit(UserSettingsLoggedOut());
    } catch (e) {
      emit(UserSettingsError(e.toString()));
    }
  }
}