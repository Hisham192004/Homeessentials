import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeessentials/cubit/addproduct_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit() : super(AddProductInitial());

  Future<void> addProduct({
    required String name,
    required String price,
    required String description,
    required String imageUrl,
  }) async {
    if (name.isEmpty || price.isEmpty) {
      emit(AddProductError("Product name and price are required"));
      return;
    }

    emit(AddProductLoading());

    try {
      await FirebaseFirestore.instance.collection("products").add({
        "name": name.trim(),
        "price": int.tryParse(price.trim()) ?? 0,
        "description": description.trim(),
        "imageUrl": imageUrl.trim(), // ✅ URL only
        "createdAt": Timestamp.now(),
      });

      emit(AddProductSuccess());
    } catch (e) {
      emit(AddProductError("Failed to add product"));
    }
  }
}
