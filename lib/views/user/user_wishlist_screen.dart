import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserWishlistScreen extends StatelessWidget {
  const UserWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('wishlist')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Your wishlist is empty ❤️"),
            );
          }

          final wishlistItems = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              final data =
                  wishlistItems[index].data()
                      as Map<String, dynamic>;

              final String imageUrl =
                  data['imageUrl'] ?? '';
              final String name =
                  data['name'] ?? '';
              final int price =
                  data['price'] ?? 0;
              final String productId =
                  data['productId'];

              return Stack(
  children: [
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    color: Colors.grey.shade200,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "₹ $price",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                /// ADD TO BAG BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('cart')
                          .doc(productId)
                          .set({
                        'productId': productId,
                        'name': name,
                        'price': price,
                        'imageUrl': imageUrl,
                        'quantity': 1,
                        'isSelected': true,
                        'createdAt': Timestamp.now(),
                      });

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text("Added to bag"),
                        ),
                      );
                    },
                    child: const Text("Add to Bag"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    /// ❤️ REMOVE FROM WISHLIST (TOP RIGHT)
    Positioned(
      top: 8,
      right: 8,
      child: GestureDetector(
        onTap: () async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('wishlist')
              .doc(productId)
              .delete();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Removed from wishlist"),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ),
    ),
  ],
);

            },
          );
        },
      ),
    );
  }
}
