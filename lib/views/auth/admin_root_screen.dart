import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeessentials/cubit/admin_root_cubit.dart';
import 'package:homeessentials/cubit/admin_root_state.dart';
import 'package:homeessentials/views/admin/admin_dashboard.dart';
import 'package:homeessentials/views/admin/admin_orders_screen.dart';
import 'package:homeessentials/views/admin/admin_products_screen.dart';

class AdminRootScreen extends StatelessWidget {
  const AdminRootScreen({super.key});

  static const List<Widget> _pages = [
    AdminDashboardScreen(),
    AdminOrdersScreen(),
    AdminProductsScreen(),
    Center(child: Text("Settings")),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminRootCubit(),
      child: BlocBuilder<AdminRootCubit, AdminRootState>(
        builder: (context, state) {
          return Scaffold(
            body: _pages[state.index],

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.index,
              onTap: (i) =>
                  context.read<AdminRootCubit>().changeTab(i),
              selectedItemColor: const Color(0xFF2563EB),
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: "Orders",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory),
                  label: "Products",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: "Settings",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
