import 'package:flutter/material.dart';
import '../../domain/usecases/get_dashboard_data.dart';
import '../../data/models/revenue_model.dart';
import '../../data/models/order_statistics_model.dart';
import '../../data/models/monthly_revenue_model.dart';

class DashboardProvider extends ChangeNotifier {
  final GetDashboardData _getDashboardData;

  DashboardProvider(this._getDashboardData);

  bool _isLoading = false;
  String? _error;
  RevenueModel? _revenueData;
  OrderStatisticsModel? _orderStatistics;
  MonthlyRevenueModel? _monthlyRevenue;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  RevenueModel? get revenueData => _revenueData;
  OrderStatisticsModel? get orderStatistics => _orderStatistics;
  MonthlyRevenueModel? get monthlyRevenue => _monthlyRevenue;

  // Current filter states
  String _currentTimeRange = 'today';
  int _currentMonthsCount = 5;

  String get currentTimeRange => _currentTimeRange;
  int get currentMonthsCount => _currentMonthsCount;

  Future<void> loadDashboardData() async {
    _setLoading(true);
    _error = null;
    notifyListeners();

    try {
      // Load all dashboard data concurrently
      final results = await Future.wait([
        _getDashboardData.getTotalRevenue(),
        _getDashboardData.getOrderStatistics(timeRange: _currentTimeRange),
        _getDashboardData.getMonthlyRevenue(monthsCount: _currentMonthsCount),
      ]);

      _revenueData = results[0] as RevenueModel;
      _orderStatistics = results[1] as OrderStatisticsModel;
      _monthlyRevenue = results[2] as MonthlyRevenueModel;
    } catch (e) {
      _error = e.toString();
      debugPrint('Dashboard data loading error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTimeRange(String timeRange) async {
    if (_currentTimeRange == timeRange) return;
    
    _currentTimeRange = timeRange;
    _setLoading(true);
    notifyListeners();

    try {
      _orderStatistics = await _getDashboardData.getOrderStatistics(timeRange: timeRange);
    } catch (e) {
      _error = e.toString();
      debugPrint('Order statistics update error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateMonthsCount(int monthsCount) async {
    if (_currentMonthsCount == monthsCount) return;
    
    _currentMonthsCount = monthsCount;
    _setLoading(true);
    notifyListeners();

    try {
      _monthlyRevenue = await _getDashboardData.getMonthlyRevenue(monthsCount: monthsCount);
    } catch (e) {
      _error = e.toString();
      debugPrint('Monthly revenue update error: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}