import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeessentials/cubit/user_orders_cubit.dart';
import 'package:intl/intl.dart';

class UserOrdersScreen extends StatelessWidget {
  const UserOrdersScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserOrdersCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "My Orders",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<UserOrdersCubit, UserOrdersState>(
          builder: (context, state) {
            if (state is UserOrdersLoading || state is UserOrdersInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserOrdersEmpty) {
              return const Center(
                child: Text(
                  "You haven’t placed any orders yet 🛒",
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else if (state is UserOrdersError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is UserOrdersLoaded) {
              final orders = state.orders;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final items = List<Map<String, dynamic>>.from(order['items']);
                  final createdAt = (order['createdAt'] as Timestamp).toDate();
                  final formattedDate =
                      DateFormat('dd MMM yyyy • hh:mm a').format(createdAt);

                  return Container(
  margin: const EdgeInsets.only(bottom: 14),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: ExpansionTile(
    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    collapsedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // LEFT SIDE (Order ID + Status)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order #${order.id.substring(0, 8).toUpperCase()}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(order['status'])
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                order['status'].toString().toUpperCase(),
                style: TextStyle(
                  color: _statusColor(order['status']),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),

        // RIGHT SIDE (Total Amount)
        Text(
          "₹ ${order['totalAmount']}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    ),

    subtitle: Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        formattedDate,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    ),

    children: [
      const Divider(),

      // 🔹 ORDER ITEMS
      Column(
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  "x${item['quantity']}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Text(
                  "₹ ${item['price'] * item['quantity']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  ),
);

                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
