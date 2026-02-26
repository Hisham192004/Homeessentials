part of 'user_products_cubit.dart';

abstract class UserProductsState {}

class UserProductsInitial extends UserProductsState {}

class UserProductsLoading extends UserProductsState {}

class UserProductsLoaded extends UserProductsState {
  final List<QueryDocumentSnapshot> products;

  UserProductsLoaded(this.products);
}

class UserProductsEmpty extends UserProductsState {}

class UserProductsError extends UserProductsState {
  final String message;

  UserProductsError(this.message);
}