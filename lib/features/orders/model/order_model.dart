class OrderModel {
  final String id;
  final String storeId;
  final String orderId;
  final List<OrderDetailModel> orderDetails;
  final String orderStatus;
  final double totalAmount;
  final DateTime pickUpTime;
  final CustomerDetailsModel customerDetails;

  OrderModel({
    required this.id,
    required this.storeId,
    required this.orderId,
    required this.orderDetails,
    required this.orderStatus,
    required this.totalAmount,
    required this.pickUpTime,
    required this.customerDetails,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      storeId: json['storeId'] ?? '',
      orderId: json['orderId'] ?? '',
      orderDetails: (json['orderDetails'] as List<dynamic>?)
              ?.map((item) => OrderDetailModel.fromJson(item))
              .toList() ??
          [],
      orderStatus: json['orderStatus'] ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      pickUpTime: DateTime.parse(json['pickUpTime'] ?? DateTime.now().toIso8601String()),
      customerDetails: CustomerDetailsModel.fromJson(json['customerDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'storeId': storeId,
      'orderId': orderId,
      'orderDetails': orderDetails.map((item) => item.toJson()).toList(),
      'orderStatus': orderStatus,
      'totalAmount': totalAmount,
      'pickUpTime': pickUpTime.toIso8601String(),
      'customerDetails': customerDetails.toJson(),
    };
  }

  // Helper methods for order status
  bool get isPending => orderStatus.toLowerCase() == 'pending';
  bool get isAccepted => orderStatus.toLowerCase() == 'ready';
  bool get isHistorical => orderStatus.toLowerCase() == 'reject' || 
                          orderStatus.toLowerCase() == 'completed' ||
                          orderStatus.toLowerCase() == 'dispatched';
  
  int get totalItems => orderDetails.fold(0, (sum, item) => sum + item.quantity);
}

class OrderDetailModel {
  final String id;
  final MenuItemModel? menuId;
  final double price;
  final int quantity;

  OrderDetailModel({
    required this.id,
    this.menuId,
    required this.price,
    required this.quantity,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['_id'] ?? '',
      menuId: json['menuId'] != null ? MenuItemModel.fromJson(json['menuId']) : null,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'menuId': menuId?.toJson(),
      'price': price,
      'quantity': quantity,
    };
  }

  String get itemName => menuId?.name ?? 'Custom Item';
}

class CustomerDetailsModel {
  final String name;
  final String phone;
  final String email;

  CustomerDetailsModel({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory CustomerDetailsModel.fromJson(Map<String, dynamic> json) {
    return CustomerDetailsModel(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}

// Basic MenuItemModel for order details (if not already defined)
class MenuItemModel {
  final String id;
  final String name;
  final double? price;
  final String? description;
  final String? category;
  final bool? isAvailable;

  MenuItemModel({
    required this.id,
    required this.name,
    this.price,
    this.description,
    this.category,
    this.isAvailable,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble(),
      description: json['description'],
      category: json['category'],
      isAvailable: json['isAvailable'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'description': description,
      'category': category,
      'isAvailable': isAvailable,
    };
  }
}