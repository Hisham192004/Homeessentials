import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class AdminOrdersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdminOrdersLoading extends AdminOrdersState {}

class AdminOrdersLoaded extends AdminOrdersState {
  final List<QueryDocumentSnapshot> orders;

  AdminOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class AdminOrdersError extends AdminOrdersState {
  final String message;

  AdminOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
