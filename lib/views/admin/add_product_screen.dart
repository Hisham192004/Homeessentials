import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeessentials/cubit/addproduct_cubit.dart';
import 'package:homeessentials/cubit/addproduct_state.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddProductCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          title: const Text("Add Product"),
          centerTitle: true,
        ),
        body: BlocListener<AddProductCubit, AddProductState>(
          listener: (context, state) {
            if (state is AddProductSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Product added successfully")),
              );
              Navigator.pop(context, true);
            } else if (state is AddProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildField(
                  controller: nameController,
                  label: "Product Name",
                ),
                const SizedBox(height: 12),

                _buildField(
                  controller: priceController,
                  label: "Price",
                  keyboard: TextInputType.number,
                ),
                const SizedBox(height: 12),

                _buildField(
                  controller: imageUrlController,
                  label: "Image URL (optional)",
                ),
                const SizedBox(height: 12),

                _buildField(
                  controller: descriptionController,
                  label: "Description",
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                /// IMAGE PREVIEW
                if (imageUrlController.text.isNotEmpty)
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        imageUrlController.text,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                BlocBuilder<AddProductCubit, AddProductState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: state is AddProductLoading
                            ? null
                            : () {
                                context.read<AddProductCubit>().addProduct(
                                      name: nameController.text,
                                      price: priceController.text,
                                      description:
                                          descriptionController.text,
                                      imageUrl:
                                          imageUrlController.text,
                                    );
                              },
                        child: state is AddProductLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Add Product",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (_) => setState(() {}),
    );
  }
}
