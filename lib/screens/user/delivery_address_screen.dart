import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final addressController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> saveAddress() async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'address': addressController.text.trim(),
    }, SetOptions(merge: true));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Address")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: addressController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Enter your address",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveAddress,
              child: const Text("Save Address"),
            ),
          ],
        ),
      ),
    );
  }
}
