class MonthlyRevenueModel {
  final bool success;
  final int statusCode;
  final String message;
  final List<MonthlyRevenueData> data;

  MonthlyRevenueModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory MonthlyRevenueModel.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenueModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => MonthlyRevenueData.fromJson(item))
          .toList(),
    );
  }
}

class MonthlyRevenueData {
  final int year;
  final int month;
  final int orderCount;
  final double totalRevenue;

  MonthlyRevenueData({
    required this.year,
    required this.month,
    required this.orderCount,
    required this.totalRevenue,
  });

  factory MonthlyRevenueData.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenueData(
      year: json['year'],
      month: json['month'],
      orderCount: json['orderCount'],
      totalRevenue: json['totalRevenue'].toDouble(),
    );
  }

  String get monthName {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
}