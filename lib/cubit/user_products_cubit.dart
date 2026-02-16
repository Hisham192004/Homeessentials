import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'user_products_state.dart';

class UserProductsCubit extends Cubit<UserProductsState> {
  UserProductsCubit() : super(UserProductsInitial()) {
    fetchProducts();
  }

  List<QueryDocumentSnapshot> allProducts = [];

  void fetchProducts() {
    emit(UserProductsLoading());

    FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      allProducts = snapshot.docs;
      if (allProducts.isEmpty) {
        emit(UserProductsEmpty());
      } else {
        emit(UserProductsLoaded(allProducts));
      }
    }, onError: (e) {
      emit(UserProductsError(e.toString()));
    });
  }

  void searchProducts(String query) {
  if (query.trim().isEmpty) {
    emit(UserProductsLoaded(allProducts));
    return;
  }

  final q = query.toLowerCase();

  final filtered = allProducts.where((doc) {
    final data = doc.data() as Map<String, dynamic>;
    final name = (data['name'] ?? '').toString().toLowerCase();
    final description =
        (data['description'] ?? '').toString().toLowerCase();

    return name.contains(q) || description.contains(q);
  }).toList();

  if (filtered.isEmpty) {
    emit(UserProductsEmpty());
  } else {
    emit(UserProductsLoaded(filtered));
  }
}


}
