import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeessentials/cubit/admin_orders_cubit.dart';
import 'package:homeessentials/cubit/admin_orders_state.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminOrdersCubit(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text(
            "Orders",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
          builder: (context, state) {
            if (state is AdminOrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AdminOrdersError) {
              return Center(child: Text(state.message));
            }

            if (state is AdminOrdersLoaded) {
              if (state.orders.isEmpty) {
                return const Center(child: Text("No orders found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  return _OrderTile(
                    orderDoc: state.orders[index],
                    onMarkDelivered: () {
                      context
                          .read<AdminOrdersCubit>()
                          .markDelivered(state.orders[index].id);
                    },
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
class _OrderTile extends StatefulWidget {
  final dynamic orderDoc;
  final VoidCallback onMarkDelivered;

  const _OrderTile({
    required this.orderDoc,
    required this.onMarkDelivered,
  });

  @override
  State<_OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<_OrderTile> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.orderDoc.data() as Map<String, dynamic>;

    final List items = data['items'] ?? [];
    final String status = data['status'] ?? 'pending';
    final int total =
    (data['totalAmount'] as num?)?.toInt() ?? 0;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          /// TOP ROW
          InkWell(
            onTap: () {
              setState(() => expanded = !expanded);
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Order #${widget.orderDoc.id}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    "₹ $total",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),

          /// ITEMS
          if (expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: items.map<Widget>((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${item['name']} × ${item['quantity']}",
                          ),
                        ),
                        Text(
                          "₹ ${item['price'] * item['quantity']}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          const Divider(height: 1),

          /// BOTTOM ACTION
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    status.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor:
                      status == 'pending' ? Colors.orange : Colors.green,
                ),
                if (status == 'pending')
                  TextButton(
                    onPressed: widget.onMarkDelivered,
                    child: const Text("Mark Delivered"),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
