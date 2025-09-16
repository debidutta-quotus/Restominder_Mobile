import '../models/revenue_model.dart';
import '../models/order_statistics_model.dart';
import '../models/monthly_revenue_model.dart';

abstract class DashboardRepository {
  Future<RevenueModel> getTotalRevenue();
  Future<OrderStatisticsModel> getOrderStatistics();
  Future<MonthlyRevenueModel> getMonthlyRevenue();
}

class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<RevenueModel> getTotalRevenue() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Dummy data based on your API response
    final dummyData = {
      "success": true,
      "statusCode": 200,
      "message": "Success",
      "data": {
        "totalRevenue": 4681.59,
        "dispatchedOrderCount": 41,
        "storeId": "2ae6bc6a-a5d0-4c27-9d53-fc5aa98f3c1a"
      }
    };
    
    return RevenueModel.fromJson(dummyData);
  }

  @override
  Future<OrderStatisticsModel> getOrderStatistics() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Dummy data based on your API response
    final dummyData = {
      "success": true,
      "statusCode": 200,
      "message": "Success",
      "data": {
        "pendingOrders": 121,
        "acceptedOrders": 0,
        "rejectedOrders": 28,
        "preparingOrders": 0,
        "readyOrders": 0,
        "dispatchedOrders": 41
      }
    };
    
    return OrderStatisticsModel.fromJson(dummyData);
  }

  @override
  Future<MonthlyRevenueModel> getMonthlyRevenue() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Dummy data based on your API response
    final dummyData = {
      "success": true,
      "statusCode": 200,
      "message": "Success",
      "data": [
        {
          "year": 2025,
          "month": 5,
          "orderCount": 7,
          "totalRevenue": 356.93
        },
        {
          "year": 2025,
          "month": 6,
          "orderCount": 4,
          "totalRevenue": 203.96
        },
        {
          "year": 2025,
          "month": 7,
          "orderCount": 18,
          "totalRevenue": 2323.81
        },
        {
          "year": 2025,
          "month": 8,
          "orderCount": 2,
          "totalRevenue": 534.96
        },
        {
          "year": 2025,
          "month": 9,
          "orderCount": 0,
          "totalRevenue": 0
        }
      ]
    };
    
    return MonthlyRevenueModel.fromJson(dummyData);
  }
}