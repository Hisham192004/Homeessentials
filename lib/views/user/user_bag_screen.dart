import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homeessentials/screens/user/delivery_address_screen.dart';

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
            .collection('bag') // ✅ FIXED HERE
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final bagItems = snapshot.data!.docs;

          if (bagItems.isEmpty) {
            return const Center(child: Text("Your bag is empty 🛍"));
          }

          double total = 0;

          for (var doc in bagItems) {
            final data = doc.data() as Map<String, dynamic>;
            total += (data['price'] ?? 0) * (data['quantity'] ?? 1);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: bagItems.length,
                  itemBuilder: (context, index) {
                    final data =
                        bagItems[index].data() as Map<String, dynamic>;

                    final String docId = bagItems[index].id;
                    final String name = data['name'];
                    final String imageUrl = data['imageUrl'] ?? '';
                    final int price = data['price'] ?? 0;
                    final int quantity = data['quantity'] ?? 1;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
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
                                  Text(name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text("₹ $price",
                                      style: const TextStyle(
                                          color: Colors.green)),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Text("Qty: "),
                                      IconButton(
                                        onPressed: () async {
                                          if (quantity > 1) {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(userId)
                                                .collection('bag') // ✅ FIXED
                                                .doc(docId)
                                                .update({
                                              'quantity': quantity - 1,
                                            });
                                          }
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text("$quantity"),
                                      IconButton(
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(userId)
                                              .collection('bag') // ✅ FIXED
                                              .doc(docId)
                                              .update({
                                            'quantity': quantity + 1,
                                          });
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .collection('bag') // ✅ FIXED
                                    .doc(docId)
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

              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "₹ ${total.toStringAsFixed(0)}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
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

 void showCheckoutSheet(BuildContext context, double total) {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String selectedPayment = "UPI";

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get(),
            builder: (context, snapshot) {
              String address = "Add your delivery address";

              if (snapshot.hasData && snapshot.data!.exists) {
                address =
                    snapshot.data!['address'] ?? "Add your delivery address";
              }

              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// 🔹 Top Indicator
                      Center(
                        child: Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "Checkout",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 📍 Address Card
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Delivery Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(address),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const DeliveryAddressScreen(),
                                  ),
                                );
                                showCheckoutSheet(context, total);
                              },
                              child: const Text("Change"),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 💳 Payment Methods
                      const Text(
                        "Payment Method",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),

                      const SizedBox(height: 10),

                      _paymentTile(
                          "UPI",
                          selectedPayment,
                          (val) => setState(
                              () => selectedPayment = val)),
                      _paymentTile(
                          "Card",
                          selectedPayment,
                          (val) => setState(
                              () => selectedPayment = val)),
                      _paymentTile(
                          "Cash on Delivery",
                          selectedPayment,
                          (val) => setState(
                              () => selectedPayment = val)),

                      const SizedBox(height: 25),

                      /// 💰 Total + Pay Button
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹${total.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
  if (address == "Add your delivery address") {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Please add delivery address"),
      ),
    );
    return;
  }

  final userId = FirebaseAuth.instance.currentUser!.uid;

  // 🔹 Get bag items
  final bagSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('bag')
      .get();

  if (bagSnapshot.docs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bag is empty")),
    );
    return;
  }

  // 🔹 Save Order (Recommended 🔥)
  await FirebaseFirestore.instance.collection('orders').add({
  'userId': userId,
  'totalAmount': total, // ✅ FIXED
  'paymentMethod': selectedPayment,
  'address': address,
  'status': 'pending', // ✅ IMPORTANT
  'items': bagSnapshot.docs.map((doc) => doc.data()).toList(),
  'createdAt': Timestamp.now(),
});

  // 🔹 Clear Bag
  for (var doc in bagSnapshot.docs) {
    await doc.reference.delete();
  }

  Navigator.pop(context);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Order placed successfully 🎉"),
    ),
  );
},
                              child: const Text("Pay Now"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}Widget _paymentTile(
    String title,
    String selected,
    Function(String) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected == title
                ? Colors.black
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            if (selected == title)
              const Icon(Icons.check_circle,
                  color: Colors.black)
          ],
        ),
      ),
    );
  }
}