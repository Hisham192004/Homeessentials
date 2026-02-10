part of 'user_settings_cubit.dart';

abstract class UserSettingsState extends Equatable {
  const UserSettingsState();

  @override
  List<Object?> get props => [];
}

class UserSettingsInitial extends UserSettingsState {}

class UserSettingsLoading extends UserSettingsState {}

class UserSettingsLoggedOut extends UserSettingsState {}

class UserSettingsError extends UserSettingsState {
  final String message;

  const UserSettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
