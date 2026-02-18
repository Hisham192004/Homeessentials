import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyBagScreen extends StatelessWidget {
  const MyBagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bag"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final cartItems = snapshot.data!.docs;

          if (cartItems.isEmpty) {
            return const Center(
              child: Text("Your bag is empty 🛍"),
            );
          }

          double total = 0;

          for (var doc in cartItems) {
            final data = doc.data() as Map<String, dynamic>;
            total += (data['price'] ?? 0) *
                (data['quantity'] ?? 1);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final data =
                        cartItems[index].data()
                            as Map<String, dynamic>;

                    final String productId =
                        data['productId'];
                    final String name =
                        data['name'];
                    final String imageUrl =
                        data['imageUrl'] ?? '';
                    final int price =
                        data['price'] ?? 0;
                    final int quantity =
                        data['quantity'] ?? 1;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            imageUrl.isNotEmpty
                                ? Image.network(
                                    imageUrl,
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 70,
                                    width: 70,
                                    color: Colors.grey.shade200,
                                  ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "₹ $price",
                                    style: const TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Text("Qty: "),
                                      IconButton(
                                        onPressed: () async {
                                          if (quantity > 1) {
                                            await FirebaseFirestore
                                                .instance
                                                .collection('users')
                                                .doc(userId)
                                                .collection('cart')
                                                .doc(productId)
                                                .update({
                                              'quantity':
                                                  quantity - 1
                                            });
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.remove),
                                      ),
                                      Text("$quantity"),
                                      IconButton(
                                        onPressed: () async {
                                          await FirebaseFirestore
                                              .instance
                                              .collection('users')
                                              .doc(userId)
                                              .collection('cart')
                                              .doc(productId)
                                              .update({
                                            'quantity':
                                                quantity + 1
                                          });
                                        },
                                        icon: const Icon(
                                            Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(userId)
                                    .collection('cart')
                                    .doc(productId)
                                    .delete();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// Bottom Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "₹ ${total.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showCheckoutSheet(context, total);
                      },
                      child: const Text("Proceed to Pay"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ✅ BOTTOM SHEET METHOD
  void showCheckoutSheet(BuildContext context, double total) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "Pay ₹${total.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Cash on Delivery",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Order Placed Successfully 🎉"),
                      ),
                    );
                  },
                  child: Text(
                      "Pay ₹${total.toStringAsFixed(0)}"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
