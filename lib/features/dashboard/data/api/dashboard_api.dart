import '../../../../common/api_manager/api_manager.dart';

class DashboardApi {
  final ApiManager _apiManager = ApiManager.base();

  Future<Map<String, dynamic>> getTotalRevenue() async {
    return await _apiManager.getRequest('/order/dashboard/total-revenue');
  }

  Future<Map<String, dynamic>> getOrderStatistics({String timeRange = 'today'}) async {
    return await _apiManager.getRequest('/order/dashboard/stats?timeRange=$timeRange');
  }

  Future<Map<String, dynamic>> getMonthlyRevenue({int monthsCount = 5}) async {
    return await _apiManager.getRequest('/order/dashboard/order-revenue?monthsCount=$monthsCount');
  }
}