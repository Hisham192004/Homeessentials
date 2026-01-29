import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();

 Future<void> addProduct() async {
  if (nameController.text.isEmpty || priceController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter all fields")),
    );
    return;
  }

  await FirebaseFirestore.instance.collection("products").add({
    "name": nameController.text.trim(),
    "price": int.parse(priceController.text.trim()),
    "createdAt": Timestamp.now(),
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Product added")),
  );

  Navigator.pop(context);
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addProduct,
              child: const Text("Add Product"),
            )
          ],
        ),
      ),
    );
  }
}
