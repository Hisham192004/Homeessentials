import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeessentials/cubit/user_products_cubit.dart';
import 'package:homeessentials/views/user/user_bag_screen.dart';
import 'package:homeessentials/views/user/user_wishlist_screen.dart';
import 'user_product_details_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserProductsCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Products"),
              centerTitle: true,
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserWishlistScreen(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined,
                      color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyBagScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: Column(
              children: [
                /// SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      context.read<UserProductsCubit>().searchProducts(value);
                    },
                  ),
                ),

                /// PRODUCTS GRID
                Expanded(
                  child: BlocBuilder<UserProductsCubit, UserProductsState>(
                    builder: (context, state) {
                      if (state is UserProductsLoading ||
                          state is UserProductsInitial) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      if (state is UserProductsEmpty) {
                        return const Center(
                          child: Text("No products found 😕"),
                        );
                      }

                      if (state is UserProductsError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (state is UserProductsLoaded) {
                        final products = state.products;

                        return GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.72,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final data =
                                product.data() as Map<String, dynamic>;

                            final String imageUrl =
                                data['imageUrl'] ?? '';
                            final String name =
                                data['name'] ?? '';
                            final int price =
                                data['price'] ?? 0;
                            final String description =
                                data['description'] ?? '';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        UserProductDetailsScreen(
                                      productId: product.id,
                                      name: name,
                                      price: price,
                                      description: description,
                                      imageUrl: imageUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  /// PRODUCT CARD
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                            child: imageUrl.isNotEmpty
                                                ? Image.network(
                                                    imageUrl,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(
                                                    color: Colors.grey.shade200,
                                                    child: const Center(
                                                      child: Icon(Icons
                                                          .image_not_supported),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                description,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors
                                                      .grey.shade600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                name,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
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
                                                  fontWeight:
                                                      FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// ❤️ WISHLIST ICON
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance
                                              .currentUser!.uid)
                                          .collection('wishlist')
                                          .doc(product.id)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        final isWishlisted =
                                            snapshot.data != null &&
                                                snapshot.data!.exists;

                                        return GestureDetector(
                                          onTap: () async {
                                            final wishlistRef =
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid)
                                                    .collection('wishlist')
                                                    .doc(product.id);

                                            if (isWishlisted) {
                                              await wishlistRef.delete();
                                            } else {
                                              await wishlistRef.set({
                                                'productId': product.id,
                                                'name': name,
                                                'price': price,
                                                'imageUrl': imageUrl,
                                                'createdAt':
                                                    Timestamp.now(),
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding:
                                                const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              isWishlisted
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              size: 18,
                                              color: Colors.red,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}