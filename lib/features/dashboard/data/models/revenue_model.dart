class RevenueModel {
  final bool success;
  final int statusCode;
  final String message;
  final RevenueData data;

  RevenueModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory RevenueModel.fromJson(Map<String, dynamic> json) {
    return RevenueModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: RevenueData.fromJson(json['data']),
    );
  }
}

class RevenueData {
  final double totalRevenue;
  final int dispatchedOrderCount;
  final String storeId;

  RevenueData({
    required this.totalRevenue,
    required this.dispatchedOrderCount,
    required this.storeId,
  });

  factory RevenueData.fromJson(Map<String, dynamic> json) {
    return RevenueData(
      totalRevenue: json['totalRevenue'].toDouble(),
      dispatchedOrderCount: json['dispatchedOrderCount'],
      storeId: json['storeId'],
    );
  }
}