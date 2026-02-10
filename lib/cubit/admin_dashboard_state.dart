import 'package:equatable/equatable.dart';

class AdminDashboardState extends Equatable {
  final bool isLoading;
  final int totalOrders;
  final int totalRevenue;
  final int totalProducts;
  final int totalUsers;
  final int profit;
  final int loss;
  final String? error;

  const AdminDashboardState({
    this.isLoading = false,
    this.totalOrders = 0,
    this.totalRevenue = 0,
    this.totalProducts = 0,
    this.totalUsers = 0,
    this.profit = 0,
    this.loss = 0,
    this.error,
  });

  AdminDashboardState copyWith({
    bool? isLoading,
    int? totalOrders,
    int? totalRevenue,
    int? totalProducts,
    int? totalUsers,
    int? profit,
    int? loss,
    String? error,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      totalOrders: totalOrders ?? this.totalOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalProducts: totalProducts ?? this.totalProducts,
      totalUsers: totalUsers ?? this.totalUsers,
      profit: profit ?? this.profit,
      loss: loss ?? this.loss,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        totalOrders,
        totalRevenue,
        totalProducts,
        totalUsers,
        profit,
        loss,
        error,
      ];
}
