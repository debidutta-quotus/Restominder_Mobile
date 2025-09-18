import '../models/revenue_model.dart';
import '../models/order_statistics_model.dart';
import '../models/monthly_revenue_model.dart';
import '../api/dashboard_api.dart';

abstract class DashboardRepository {
  Future<RevenueModel> getTotalRevenue();
  Future<OrderStatisticsModel> getOrderStatistics({String timeRange = 'today'});
  Future<MonthlyRevenueModel> getMonthlyRevenue({int monthsCount = 5});
}

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardApi _dashboardApi;

  DashboardRepositoryImpl(this._dashboardApi);

  @override
  Future<RevenueModel> getTotalRevenue() async {
    try {
      final response = await _dashboardApi.getTotalRevenue();
      return RevenueModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch total revenue: $e');
    }
  }

  @override
  Future<OrderStatisticsModel> getOrderStatistics({String timeRange = 'today'}) async {
    try {
      final response = await _dashboardApi.getOrderStatistics(timeRange: timeRange);
      return OrderStatisticsModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch order statistics: $e');
    }
  }

  @override
  Future<MonthlyRevenueModel> getMonthlyRevenue({int monthsCount = 5}) async {
    try {
      final response = await _dashboardApi.getMonthlyRevenue(monthsCount: monthsCount);
      return MonthlyRevenueModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch monthly revenue: $e');
    }
  }
}