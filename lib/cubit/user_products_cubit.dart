import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_products_state.dart';

class UserProductsCubit extends Cubit<UserProductsState> {
  UserProductsCubit() : super(UserProductsInitial()) {
    fetchProducts();
  }

  List<QueryDocumentSnapshot> _allProducts = [];
  List<QueryDocumentSnapshot> _filteredProducts = [];

  /// FETCH PRODUCTS
  Future<void> fetchProducts() async {
  if (isClosed) return;

  emit(UserProductsLoading());

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .get();

    if (isClosed) return;

    _allProducts = snapshot.docs;
    _filteredProducts = _allProducts;

    if (_allProducts.isEmpty) {
      emit(UserProductsEmpty());
    } else {
      emit(UserProductsLoaded(_filteredProducts));
    }
  } catch (e) {
    if (!isClosed) {
      emit(UserProductsError(e.toString()));
    }
  }
}
  /// SEARCH PRODUCTS
  void searchProducts(String query) {
  if (isClosed) return;

  if (query.trim().isEmpty) {
    _filteredProducts = _allProducts;
  } else {
    final lowerQuery = query.toLowerCase();

    _filteredProducts = _allProducts.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final name = data['name']?.toString().toLowerCase() ?? '';
      final description =
          data['description']?.toString().toLowerCase() ?? '';

      return name.contains(lowerQuery) ||
          description.contains(lowerQuery);
    }).toList();
  }

  if (isClosed) return;

  if (_filteredProducts.isEmpty) {
    emit(UserProductsEmpty());
  } else {
    emit(UserProductsLoaded(_filteredProducts));
  }
}
}