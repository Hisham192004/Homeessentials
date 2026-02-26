import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:homeessentials/cubit/admin_dashboard_cubit.dart';
import 'package:homeessentials/cubit/admin_dashboard_state.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminDashboardCubit()..loadDashboard(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Admin Dashboard"),
          centerTitle: true,
        ),
        body: BlocBuilder<AdminDashboardCubit, AdminDashboardState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Overview",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  /// ✅ 4 SUMMARY BOXES (UNCHANGED)
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _card("Total Orders", Icons.shopping_cart,
                          Colors.orange, state.totalOrders),
                      _card("Total Revenue", Icons.currency_rupee,
                          Colors.green, state.totalRevenue,
                          prefix: "₹ "),
                      _card("Products", Icons.inventory,
                          Colors.blue, state.totalProducts),
                      _card("Users", Icons.people,
                          Colors.purple, state.totalUsers),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// ✅ GRAPH (AMOUNT / PROFIT / LOSS)
                  const Text(
                    "Business Summary",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  _buildBarChart(
                    state.totalRevenue,
                    state.profit,
                    state.loss,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _card(String title, IconData icon, Color color, int value,
      {String prefix = ""}) {
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
          Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(
            "$prefix$value",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(int revenue, int profit, int loss) {
    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          maxY: [revenue, profit, loss]
                  .reduce((a, b) => a > b ? a : b) +
              500,
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),

          titlesData: FlTitlesData(
            topTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),

            leftTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: true)),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text("Amount");
                    case 1:
                      return const Text("Profit");
                    case 2:
                      return const Text("Loss");
                    default:
                      return const Text("");
                  }
                },
              ),
            ),
          ),

          barGroups: [
            _bar(0, revenue.toDouble(), Colors.blue),
            _bar(1, profit.toDouble(), Colors.green),
            _bar(2, loss.toDouble(), Colors.red),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 28,
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
      ],
    );
  }
}