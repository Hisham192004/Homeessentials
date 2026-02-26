import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final String collectionName;

  CartCubit(this.collectionName) : super(CartLoading()) {
    _listenItems();
  }

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get itemRef =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(collectionName);

  StreamSubscription? _subscription;

  void _listenItems() {
    _subscription = itemRef.snapshots().listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        emit(CartEmpty());
        return;
      }

      int total = 0;

      for (var doc in snapshot.docs) {
        int price = (doc['price'] as num).toInt();
        int quantity = (doc['quantity'] as num?)?.toInt() ?? 1;
        total += price * quantity;
      }

      emit(CartLoaded(items: snapshot.docs, totalAmount: total));
    });
  }

  Future<void> updateQuantity(String docId, int quantity) async {
    if (quantity < 1) return;
    await itemRef.doc(docId).update({'quantity': quantity});
  }

  Future<void> deleteItem(String docId) async {
    await itemRef.doc(docId).delete();
  }

  Future<void> addToBag() async {
  if (state is! CartLoaded) return;

  final cartState = state as CartLoaded;

  final bagRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('bag');

  for (var doc in cartState.items) {
    await bagRef.add({
      'name': doc['name'],
      'price': doc['price'],
      'quantity': doc['quantity'] ?? 1,
      'imageUrl': doc['imageUrl'],
      'createdAt': Timestamp.now(),
    });

    // delete from cart
    await doc.reference.delete();
  }
}

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}