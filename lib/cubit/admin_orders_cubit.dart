import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_orders_state.dart';

class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  StreamSubscription? _ordersSub;

  AdminOrdersCubit() : super(AdminOrdersLoading()) {
    listenOrders();
  }

  void listenOrders() {
    _ordersSub = FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        emit(AdminOrdersLoaded(snapshot.docs));
      },
      onError: (_) {
        emit(AdminOrdersError("Failed to load orders"));
      },
    );
  }

  Future<void> markDelivered(String orderId) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({'status': 'delivered'});
  }

  @override
  Future<void> close() {
    _ordersSub?.cancel();
    return super.close();
  }
}
