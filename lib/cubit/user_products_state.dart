part of 'user_products_cubit.dart';

abstract class UserProductsState extends Equatable {
  const UserProductsState();

  @override
  List<Object> get props => [];
}

class UserProductsInitial extends UserProductsState {}

class UserProductsLoading extends UserProductsState {}

class UserProductsLoaded extends UserProductsState {
  final List<QueryDocumentSnapshot> products;

  const UserProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class UserProductsEmpty extends UserProductsState {}

class UserProductsError extends UserProductsState {
  final String message;

  const UserProductsError(this.message);

  @override
  List<Object> get props => [message];
}
