import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_dashboard_state.dart';

class AdminDashboardCubit extends Cubit<AdminDashboardState> {
  AdminDashboardCubit() : super(const AdminDashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true));

    try {
      final ordersSnap =
          await FirebaseFirestore.instance.collection('orders').get();
      final productsSnap =
          await FirebaseFirestore.instance.collection('products').get();
      final usersSnap =
          await FirebaseFirestore.instance.collection('users').get();

      int revenue = 0;

      for (var doc in ordersSnap.docs) {
        revenue += (doc['totalAmount'] as num).toInt();
      }

      // 🔹 BUSINESS LOGIC
      final int profit = (revenue * 0.20).toInt();
      final int loss = (revenue * 0.05).toInt();

      emit(state.copyWith(
        isLoading: false,
        totalOrders: ordersSnap.docs.length,
        totalRevenue: revenue,
        totalProducts: productsSnap.docs.length,
        totalUsers: usersSnap.docs.length,
        profit: profit,
        loss: loss,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Failed to load dashboard",
      ));
    }
  }
}
