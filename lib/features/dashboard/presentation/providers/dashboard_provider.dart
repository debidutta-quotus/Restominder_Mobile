import 'package:flutter/material.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../data/models/revenue_model.dart';
import '../../data/models/order_statistics_model.dart';
import '../../data/models/monthly_revenue_model.dart';

class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository;

  DashboardProvider(this._repository);

  bool _isLoading = false;
  String? _error;
  RevenueModel? _revenueData;
  OrderStatisticsModel? _orderStatistics;
  MonthlyRevenueModel? _monthlyRevenue;

  bool get isLoading => _isLoading;
  String? get error => _error;
  RevenueModel? get revenueData => _revenueData;
  OrderStatisticsModel? get orderStatistics => _orderStatistics;
  MonthlyRevenueModel? get monthlyRevenue => _monthlyRevenue;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _repository.getTotalRevenue(),
        _repository.getOrderStatistics(),
        _repository.getMonthlyRevenue(),
      ]);

      _revenueData = results[0] as RevenueModel;
      _orderStatistics = results[1] as OrderStatisticsModel;
      _monthlyRevenue = results[2] as MonthlyRevenueModel;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}