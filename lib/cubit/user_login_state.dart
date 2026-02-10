import 'package:equatable/equatable.dart';

abstract class UserLoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserLoginInitial extends UserLoginState {}

class UserLoginLoading extends UserLoginState {}

class UserLoginSuccess extends UserLoginState {}

class UserLoginError extends UserLoginState {
  final String message;

  UserLoginError(this.message);

  @override
  List<Object?> get props => [message];
}
