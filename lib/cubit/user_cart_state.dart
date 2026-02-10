import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {}

class CartEmpty extends CartState {}

class CartLoaded extends CartState {
  final List<QueryDocumentSnapshot> items;
  final int totalAmount;

  CartLoaded({
    required this.items,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [items, totalAmount];
}

class CartError extends CartState {
  final String message;

  CartError(this.message);

  @override
  List<Object?> get props => [message];
}
