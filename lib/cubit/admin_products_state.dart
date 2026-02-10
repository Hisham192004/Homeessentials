import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class AdminProductsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminProductsLoading extends AdminProductsState {}

class AdminProductsLoaded extends AdminProductsState {
  final List<QueryDocumentSnapshot> products;

  AdminProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class AdminProductsError extends AdminProductsState {
  final String message;

  AdminProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
