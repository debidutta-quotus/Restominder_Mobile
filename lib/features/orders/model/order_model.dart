class OrderModel {
  final String id;
  final String storeId;
  final String orderId;
  final List<OrderDetailModel> orderDetails;
  final String orderStatus;
  final double totalAmount;
  final DateTime pickUpTime;
  final CustomerDetailsModel customerDetails;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.storeId,
    required this.orderId,
    required this.orderDetails,
    required this.orderStatus,
    required this.totalAmount,
    required this.pickUpTime,
    required this.customerDetails,
    this.createdAt,
    this.updatedAt,
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
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Helper methods for order status - matching web implementation
  bool get isPending => orderStatus.toLowerCase() == 'pending';
  bool get isAccepted => ['accept', 'preparing', 'ready'].contains(orderStatus.toLowerCase());
  bool get isHistorical => ['reject', 'dispatched'].contains(orderStatus.toLowerCase());
  
  // Specific status checks
  bool get isAcceptStatus => orderStatus.toLowerCase() == 'accept';
  bool get isPreparing => orderStatus.toLowerCase() == 'preparing';
  bool get isReady => orderStatus.toLowerCase() == 'ready';
  bool get isDispatched => orderStatus.toLowerCase() == 'dispatched';
  bool get isRejected => orderStatus.toLowerCase() == 'reject';
  
  int get totalItems => orderDetails.fold(0, (sum, item) => sum + item.quantity);

  // Get next possible status based on current status
  String? get nextStatus {
    switch (orderStatus.toLowerCase()) {
      case 'pending':
        return 'accept'; // or 'reject'
      case 'accept':
        return 'preparing';
      case 'preparing':
        return 'ready';
      case 'ready':
        return 'dispatched';
      default:
        return null; // No next status for dispatched/rejected
    }
  }

  // Check if order can be progressed to next status
  bool get canProgress {
    return nextStatus != null && !isHistorical;
  }

  // Get time difference for pickup
  String get pickupTimeText {
    final now = DateTime.now();
    final difference = pickUpTime.difference(now);
    
    if (difference.isNegative) {
      return 'ASAP';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins';
    } else {
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;
      if (minutes == 0) {
        return '${hours}h';
      }
      return '${hours}h ${minutes}m';
    }
  }

  // Get time since order was placed
  String get timeSinceOrder {
    if (createdAt == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
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
  double get totalPrice => price * quantity;
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

// Menu Item Model for order details
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