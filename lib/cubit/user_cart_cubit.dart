import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homeessentials/cubit/user_cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartLoading()) {
    _listenCart();
  }

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get cartRef =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');

  StreamSubscription? _subscription;

  void _listenCart() {
    _subscription = cartRef.snapshots().listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        emit(CartEmpty());
        return;
      }

      int total = 0;
      for (var doc in snapshot.docs) {
        total += (doc['price'] as num).toInt() *
            (doc['quantity'] as num).toInt();
      }

      emit(CartLoaded(items: snapshot.docs, totalAmount: total));
    });
  }

  Future<void> updateQuantity(String docId, int quantity) async {
    if (quantity < 1) return;
    await cartRef.doc(docId).update({'quantity': quantity});
  }

  Future<void> deleteItem(String docId) async {
    await cartRef.doc(docId).delete();
  }

  Future<void> placeOrder() async {
    if (state is! CartLoaded) return;

    final cartState = state as CartLoaded;

    int total = cartState.totalAmount;

    final items = cartState.items.map((doc) {
      return {
        'name': doc['name'],
        'price': doc['price'],
        'quantity': doc['quantity'],
      };
    }).toList();

    await FirebaseFirestore.instance.collection('orders').add({
      'userId': userId,
      'items': items,
      'totalAmount': total,
      'status': 'pending',
      'createdAt': Timestamp.now(),
    });

    for (var doc in cartState.items) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
