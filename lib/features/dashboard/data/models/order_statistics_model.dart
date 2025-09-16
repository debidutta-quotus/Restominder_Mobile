class OrderStatisticsModel {
  final bool success;
  final int statusCode;
  final String message;
  final OrderStatisticsData data;

  OrderStatisticsModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OrderStatisticsModel.fromJson(Map<String, dynamic> json) {
    return OrderStatisticsModel(
      success: json['success'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: OrderStatisticsData.fromJson(json['data']),
    );
  }
}

class OrderStatisticsData {
  final int pendingOrders;
  final int acceptedOrders;
  final int rejectedOrders;
  final int preparingOrders;
  final int readyOrders;
  final int dispatchedOrders;

  OrderStatisticsData({
    required this.pendingOrders,
    required this.acceptedOrders,
    required this.rejectedOrders,
    required this.preparingOrders,
    required this.readyOrders,
    required this.dispatchedOrders,
  });

  factory OrderStatisticsData.fromJson(Map<String, dynamic> json) {
    return OrderStatisticsData(
      pendingOrders: json['pendingOrders'],
      acceptedOrders: json['acceptedOrders'],
      rejectedOrders: json['rejectedOrders'],
      preparingOrders: json['preparingOrders'],
      readyOrders: json['readyOrders'],
      dispatchedOrders: json['dispatchedOrders'],
    );
  }

  int get totalOrders =>
      pendingOrders +
      acceptedOrders +
      rejectedOrders +
      preparingOrders +
      readyOrders +
      dispatchedOrders;
}