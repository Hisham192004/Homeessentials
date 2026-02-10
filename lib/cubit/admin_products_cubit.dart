import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_products_state.dart';

class AdminProductsCubit extends Cubit<AdminProductsState> {
  StreamSubscription? _productsSub;

  AdminProductsCubit() : super(AdminProductsLoading()) {
    listenProducts();
  }

  void listenProducts() {
    _productsSub = FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        emit(AdminProductsLoaded(snapshot.docs));
      },
      onError: (_) {
        emit(AdminProductsError("Failed to load products"));
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .delete();
  }

  Future<void> updateProduct({
    required String id,
    required String name,
    required int price,
  }) async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(id)
        .update({
      "name": name,
      "price": price,
    });
  }

  @override
  Future<void> close() {
    _productsSub?.cancel();
    return super.close();
  }
}
