import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  Future<int> getCount(String collection) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.length;
  }

  Future<int> getTotalRevenue() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('orders').get();

    int total = 0;
    for (var doc in snapshot.docs) {
      total += (doc['totalAmount'] as num).toInt();
    }
    return total;
  }
  Future<Map<String, int>> getProductWiseSales() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('orders').get();

    Map<String, int> data = {};

    for (var doc in snapshot.docs) {
      final items = List.from(doc['items']);

      for (var item in items) {
        final name = item['name'];
        final qty = item['quantity'];

        data[name] = (data[name] ?? 0) + (qty as int);
      }
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text("Admin Dashboard"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

            const Text(
              "Overview",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _dashboardCard(
                  title: "Total Orders",
                  icon: Icons.shopping_cart,
                  color: Colors.orange,
                  future: getCount('orders'),
                ),
                _dashboardCard(
                  title: "Total Revenue",
                  icon: Icons.currency_rupee,
                  color: Colors.green,
                  future: getTotalRevenue(),
                  prefix: "₹ ",
                ),
                _dashboardCard(
                  title: "Products",
                  icon: Icons.inventory,
                  color: Colors.blue,
                  future: getCount('products'),
                ),
                _dashboardCard(
                  title: "Users",
                  icon: Icons.people,
                  color: Colors.purple,
                  future: getCount('users'),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              "Product-wise Sales",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, int>>(
              future: getProductWiseSales(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No sales data"));
                }

                final data = snapshot.data!;
                final colors = [
                  Colors.blue,
                  Colors.green,
                  Colors.orange,
                  Colors.purple,
                  Colors.red,
                  Colors.teal,
                ];

                return Column(
                  children: [
                    SizedBox(
                      height: 230,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: List.generate(data.length, (i) {
                            final entry = data.entries.elementAt(i);
                            return PieChartSectionData(
                              value: entry.value.toDouble(),
                              title: entry.value.toString(), // ONLY NUMBER
                              radius: 75,
                              color: colors[i % colors.length],
                              titleStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: data.entries.map((entry) {
                        final index =
                            data.keys.toList().indexOf(entry.key);
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color:
                                    colors[index % colors.length],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${entry.key} (${entry.value})",
                              style:
                                  const TextStyle(fontSize: 13),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required Future<int> future,
    String prefix = "",
  }) {
    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 30, color: color),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                snapshot.hasData
                    ? "$prefix${snapshot.data}"
                    : "...",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
