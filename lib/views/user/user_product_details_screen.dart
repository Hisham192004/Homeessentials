import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProductDetailsScreen extends StatefulWidget {
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

  @override
  State<UserProductDetailsScreen> createState() =>
      _UserProductDetailsScreenState();
}

class _UserProductDetailsScreenState
    extends State<UserProductDetailsScreen> {
  bool isWishlisted = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    checkWishlistStatus();
  }

  /// 🔎 CHECK IF PRODUCT IS ALREADY WISHLISTED
  Future<void> checkWishlistStatus() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(widget.productId)
        .get();

    setState(() {
      isWishlisted = doc.exists;
    });
  }

  /// ❤️ TOGGLE WISHLIST
  Future<void> toggleWishlist() async {
    final wishlistRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(widget.productId);

    if (isWishlisted) {
      await wishlistRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from wishlist")),
      );
    } else {
      await wishlistRef.set({
        'productId': widget.productId,
        'name': widget.name,
        'price': widget.price,
        'imageUrl': widget.imageUrl,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added to wishlist ❤️")),
      );
    }

    setState(() {
      isWishlisted = !isWishlisted;
    });
  }

  /// 🛍 ADD TO CART
  Future<void> addToCart() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart')
        .doc(widget.productId)
        .set({
      'productId': widget.productId,
      'name': widget.name,
      'price': widget.price,
      'imageUrl': widget.imageUrl,
      'quantity': 1,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Added to bag")),
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
            /// IMAGE + HEART
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.imageUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 250,
                          color: Colors.grey.shade200,
                        ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: toggleWishlist,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isWishlisted
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(widget.description),

            const SizedBox(height: 12),

            Text(
              "₹ ${widget.price}",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            /// BUTTONS
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addToCart,
                child: const Text("Add to Bag"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
