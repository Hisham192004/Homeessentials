import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProductDetailsScreen extends StatelessWidget {
  final String productId;
  final String name;
  final int price;
  final String description;
  final String imageUrl;

  const UserProductDetailsScreen({
    super.key,
    required this.productId,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  /// ✅ ADD TO CART
  Future<void> addToCart(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(productId)
        .set({
      'productId': productId,
      'name': name,
      'price': price,
      'quantity': 1,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to Cart")),
    );
  }

  /// ✅ ADD TO WISHLIST
  Future<void> addToWishlist(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(productId)
        .set({
      'productId': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to wishlist ❤️")),
    );
  }
  /// ✅ ADD TO BAG
Future<void> addToBag(BuildContext context) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('bag')   // 🔥 This is different from cart
      .doc(productId)
      .set({
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': 1,
    'imageUrl': imageUrl,
    'createdAt': Timestamp.now(),
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Added to Bag 🛍")),
  );
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 IMAGE WITH WISHLIST ICON
            Stack(
              children: [
                imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          imageUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 250,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      ),

                /// ❤️ WISHLIST BUTTON (TOP RIGHT)
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => addToWishlist(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// PRODUCT NAME
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            /// DESCRIPTION
            Text(description),

            const SizedBox(height: 12),

            /// PRICE
            Text(
              "₹ $price",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => addToBag(context),
                    child: const Text("Add to Bag"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => addToCart(context),
                    child: const Text("Add to Cart"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}