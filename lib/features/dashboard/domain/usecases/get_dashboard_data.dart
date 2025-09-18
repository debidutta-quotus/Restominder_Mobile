import '../../../dashboard/data/models/revenue_model.dart';
import '../../../dashboard/data/models/order_statistics_model.dart';
import '../../../dashboard/data/models/monthly_revenue_model.dart';
import '../../../dashboard/data/repositories/dashboard_repository.dart';

class GetDashboardData {
  final DashboardRepository _repository;

  GetDashboardData(this._repository);

  Future<RevenueModel> getTotalRevenue() async {
    return await _repository.getTotalRevenue();
  }

  Future<OrderStatisticsModel> getOrderStatistics({String timeRange = 'today'}) async {
    return await _repository.getOrderStatistics(timeRange: timeRange);
  }

  Future<MonthlyRevenueModel> getMonthlyRevenue({int monthsCount = 5}) async {
    return await _repository.getMonthlyRevenue(monthsCount: monthsCount);
  }
}