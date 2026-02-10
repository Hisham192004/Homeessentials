import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeessentials/cubit/admin_products_cubit.dart';
import 'package:homeessentials/cubit/admin_products_state.dart';
import 'add_product_screen.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminProductsCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Products",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF2563EB),
          icon: const Icon(Icons.add,color: Colors.white,),
          label: const Text("Add Product",style: TextStyle(color: Colors.white),),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddProductScreen()),
            );
          },
        ),
        body: BlocBuilder<AdminProductsCubit, AdminProductsState>(
          builder: (context, state) {
            if (state is AdminProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminProductsError) {
              return Center(child: Text(state.message));
            }

            if (state is AdminProductsLoaded) {
              if (state.products.isEmpty) {
                return const Center(child: Text("No products available"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final doc = state.products[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final String imageUrl = data['imageUrl'] ?? '';
                  final name = data['name'];
                  final price = data['price'];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
  children: [
    /// PRODUCT IMAGE
    Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported),
            )
          : const Icon(
              Icons.inventory_2,
              color: Color(0xFF2563EB),
            ),
    ),

    const SizedBox(width: 12),

    /// NAME + PRICE
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "₹ $price",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ),


                          /// ACTIONS
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.blue),
                            onPressed: () {
                              _showEditDialog(
                                context,
                                doc.id,
                                name,
                                price,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel,
                                color: Colors.red),
                            onPressed: () {
                              context
                                  .read<AdminProductsCubit>()
                                  .deleteProduct(doc.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// EDIT DIALOG (LOGIC UNCHANGED)
  static void _showEditDialog(
    BuildContext context,
    String docId,
    String oldName,
    int oldPrice,
  ) {
    final nameController = TextEditingController(text: oldName);
    final priceController =
        TextEditingController(text: oldPrice.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Edit Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: "Product Name"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: () {
              context.read<AdminProductsCubit>().updateProduct(
                    id: docId,
                    name: nameController.text.trim(),
                    price:
                        int.parse(priceController.text.trim()),
                  );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
