part of 'user_orders_cubit.dart';

abstract class UserOrdersState extends Equatable {
  const UserOrdersState();

  @override
  List<Object> get props => [];
}

class UserOrdersInitial extends UserOrdersState {}

class UserOrdersLoading extends UserOrdersState {}

class UserOrdersLoaded extends UserOrdersState {
  final List<QueryDocumentSnapshot> orders;

  const UserOrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

class UserOrdersEmpty extends UserOrdersState {}

class UserOrdersError extends UserOrdersState {
  final String message;

  const UserOrdersError(this.message);

  @override
  List<Object> get props => [message];
}
