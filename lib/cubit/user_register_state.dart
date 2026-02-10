import 'package:equatable/equatable.dart';

abstract class UserRegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserRegisterInitial extends UserRegisterState {}

class UserRegisterLoading extends UserRegisterState {}

class UserRegisterSuccess extends UserRegisterState {}

class UserRegisterError extends UserRegisterState {
  final String message;

  UserRegisterError(this.message);

  @override
  List<Object?> get props => [message];
}
