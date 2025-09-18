import '../../../common/api_manager/api_manager.dart';
import '../model/order_model.dart';
import 'dart:convert';

class OrdersApi {
  final ApiManager _apiManager = ApiManager.pos();

  // Get all orders
  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _apiManager.getRequest('/order');

      if (response['data'] != null) {
        final List<dynamic> ordersJson = response['data'];
        return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch orders');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  // Get orders by status
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    try {
      final response = await _apiManager.getRequest('/order?status=$status');

      if (response['data'] != null) {
        final List<dynamic> ordersJson = response['data'];
        return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception(
          response['message'] ?? 'Failed to fetch orders by status',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch orders by status: $e');
    }
  }

  // Get pending orders
  Future<List<OrderModel>> getPendingOrders() async {
    try {
      final allOrders = await getOrders();
      return allOrders.where((order) => order.isPending).toList();
    } catch (e) {
      throw Exception('Failed to fetch pending orders: $e');
    }
  }

  // Get accepted/ready orders
  Future<List<OrderModel>> getAcceptedOrders() async {
    try {
      final allOrders = await getOrders();
      return allOrders.where((order) => order.isAccepted).toList();
    } catch (e) {
      throw Exception('Failed to fetch accepted orders: $e');
    }
  }

  // Get historical orders (rejected/completed)
  Future<List<OrderModel>> getHistoricalOrders() async {
    try {
      final allOrders = await getOrders();
      return allOrders.where((order) => order.isHistorical).toList();
    } catch (e) {
      throw Exception('Failed to fetch historical orders: $e');
    }
  }

  // Update order status

  Future<OrderModel> updateOrderStatus(String orderId, String status) async {
    try {
      final response = jsonDecode(
        await _apiManager.putRequest('/order/$orderId', {
          'orderStatus': status,
        }),
      );

      if (response['order'] != null &&
          response['order'] is Map<String, dynamic>) {
        return OrderModel.fromJson(response['order']);
      } else {
        throw Exception(
          response['message'] ??
              'Failed to update order status: Invalid response format',
        );
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Accept order
  Future<OrderModel> acceptOrder(String orderId) async {
    try {
      return await updateOrderStatus(orderId, 'accepted');
    } catch (e) {
      throw Exception('Failed to accept order: $e');
    }
  }

  // Reject order
  Future<OrderModel> rejectOrder(String orderId) async {
    try {
      return await updateOrderStatus(orderId, 'reject');
    } catch (e) {
      throw Exception('Failed to reject order: $e');
    }
  }

  // Dispatch order
  Future<OrderModel> dispatchOrder(String orderId) async {
    try {
      return await updateOrderStatus(orderId, 'dispatched');
    } catch (e) {
      throw Exception('Failed to dispatch order: $e');
    }
  }

  // Get order by ID
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final response = await _apiManager.getRequest('/order/$orderId');

      if (response['data'] != null) {
        return OrderModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch order');
      }
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  // Create new order (if needed for your app)
  Future<OrderModel> createOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await _apiManager.postRequest('/order', orderData);

      if (response['order'] != null) {
        return OrderModel.fromJson(response['order']);
      } else {
        throw Exception(response['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Delete order
  Future<bool> deleteOrder(String orderId) async {
    try {
      final response = await _apiManager.deleteRequest('/order/$orderId');

      return response['success'] == true;
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }
}
