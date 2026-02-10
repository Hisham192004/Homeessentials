import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'user_orders_state.dart';

class UserOrdersCubit extends Cubit<UserOrdersState> {
  UserOrdersCubit() : super(UserOrdersInitial()) {
    fetchOrders();
  }

  void fetchOrders() {
    emit(UserOrdersLoading());

    final userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        emit(UserOrdersEmpty());
      } else {
        emit(UserOrdersLoaded(snapshot.docs));
      }
    }, onError: (e) {
      emit(UserOrdersError(e.toString()));
    });
  }
}
