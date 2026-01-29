import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserCartScreen extends StatelessWidget {
  const UserCartScreen({super.key});

  Future<void> placeOrder(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');

    final cartSnapshot = await cartRef.get();
    if (cartSnapshot.docs.isEmpty) return;

    int total = 0;
    List<Map<String, dynamic>> items = [];

    for (var doc in cartSnapshot.docs) {
      int price = (doc['price'] as num).toInt();
      int quantity = (doc['quantity'] as num).toInt();

      total += price * quantity;

      items.add({
        'name': doc['name'],
        'price': price,
        'quantity': quantity,
      });
    }

    await FirebaseFirestore.instance.collection('orders').add({
      'userId': userId,
      'items': items,
      'totalAmount': total,
      'status': 'pending',
      'createdAt': Timestamp.now(),
    });

    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Order placed successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs;

          if (cartItems.isEmpty) {
            return const Center(child: Text("Cart is empty"));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    int price = (item['price'] as num).toInt();
                    int quantity = (item['quantity'] as num).toInt();

                    return ListTile(
                      title: Text(item['name']),
                      subtitle: Text("Qty: $quantity"),
                      trailing: Text("₹ ${price * quantity}"),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => placeOrder(context),
                    child: const Text("Place Order"),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
