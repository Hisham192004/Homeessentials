import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeessentials/cubit/user_cart_cubit.dart';
import 'package:homeessentials/cubit/user_cart_state.dart';

class UserCartScreen extends StatelessWidget {
  const UserCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit('cart'),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("My Cart", style: TextStyle(color: Colors.black)),
          centerTitle: true,
        ),
        body: BlocConsumer<CartCubit, CartState>(
          listener: (context, state) {
            if (state is CartEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cart is empty")),
              );
            }
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CartEmpty) {
              return const Center(child: Text("Your cart is empty 🛒"));
            }

            if (state is CartLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        int price = item['price'];
                        int quantity = item['quantity'];

                        return _CartItem(
                          item: item,
                          price: price,
                          quantity: quantity,
                        );
                      },
                    ),
                  ),

                  _CartBottomBar(total: state.totalAmount),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final item;
  final int price;
  final int quantity;

  const _CartItem({
    required this.item,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          /// ✅ PRODUCT IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item['imageUrl'] != null &&
                    item['imageUrl'].toString().isNotEmpty
                ? Image.network(
                    item['imageUrl'],
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 70,
                    width: 70,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image),
                  ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹ $price",
                  style: const TextStyle(color: Colors.green),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () =>
                          cubit.updateQuantity(item.id, quantity - 1),
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () =>
                          cubit.updateQuantity(item.id, quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => cubit.deleteItem(item.id),
          ),
        ],
      ),
    );
  }
}

class _CartBottomBar extends StatelessWidget {
  final int total;

  const _CartBottomBar({required this.total});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total Amount",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("₹ $total",
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                await cubit.addToBag();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Added to Bag successfully")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
              ),
              child: const Text("Add to Bag",
                  style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
