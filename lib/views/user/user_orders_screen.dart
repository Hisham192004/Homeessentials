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
            if (state is UserOrdersLoading ||
                state is UserOrdersInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserOrdersEmpty) {
              return const Center(
                child: Text(
                  "You haven’t placed any orders yet 🛒",
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            if (state is UserOrdersError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is UserOrdersLoaded) {
              final orders = state.orders;

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final orderDoc = orders[index];
                  final data =
                      orderDoc.data() as Map<String, dynamic>;

                  // ✅ SAFE FIELD READING
                  final String status =
                      data['status'] ?? 'pending';

                  final int totalAmount =
    (data['totalAmount'] as num?)?.toInt() ?? 0;

                  final List<Map<String, dynamic>> items =
                      (data['items'] ?? [])
                          .map<Map<String, dynamic>>(
                              (item) =>
                                  Map<String, dynamic>.from(item))
                          .toList();

                  final Timestamp? timestamp =
                      data['createdAt'];

                  final DateTime createdAt =
                      timestamp != null
                          ? timestamp.toDate()
                          : DateTime.now();

                  final formattedDate =
                      DateFormat('dd MMM yyyy • hh:mm a')
                          .format(createdAt);

                  return Container(
                    margin:
                        const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ExpansionTile(
                      tilePadding:
                          const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8),
                      childrenPadding:
                          const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      collapsedShape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      title: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          /// LEFT SIDE
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                "Order #${orderDoc.id.substring(0, 8).toUpperCase()}",
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                  height: 4),
                              Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                            horizontal:
                                                10,
                                            vertical:
                                                4),
                                decoration:
                                    BoxDecoration(
                                  color:
                                      _statusColor(
                                              status)
                                          .withOpacity(
                                              0.15),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              20),
                                ),
                                child: Text(
                                  status
                                      .toUpperCase(),
                                  style:
                                      TextStyle(
                                    color:
                                        _statusColor(
                                            status),
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// RIGHT SIDE
                          Text(
                            "₹ $totalAmount",
                            style:
                                const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding:
                            const EdgeInsets.only(
                                top: 6),
                        child: Text(
                          formattedDate,
                          style:
                              const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      /// 🔽 EXPANDED ITEMS
                      children: [
                        const Divider(),
                        Column(
                          children:
                              items.map((item) {
                            final name =
                                item['name'] ??
                                    '';
                            final quantity =
                                item['quantity'] ??
                                    1;
                            final price =
                                item['price'] ??
                                    0;

                            return Padding(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                          vertical:
                                              6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style:
                                          const TextStyle(
                                        fontSize:
                                            14,
                                        fontWeight:
                                            FontWeight
                                                .w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "x$quantity",
                                    style:
                                        const TextStyle(
                                            color: Colors
                                                .grey),
                                  ),
                                  const SizedBox(
                                      width: 12),
                                  Text(
                                    "₹ ${price * quantity}",
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .bold,
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