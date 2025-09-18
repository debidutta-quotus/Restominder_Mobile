// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/theme/app_colors.dart';
import '../api/orders_api.dart';
import '../model/order_model.dart';
import 'order_details_sheet.dart';
import 'order_history.dart';
import 'dart:async';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final OrdersApi _ordersApi = OrdersApi();
  
  List<OrderModel> _pendingOrders = [];
  List<OrderModel> _acceptedOrders = [];
  List<OrderModel> _historicalOrders = [];
  
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;

  // Loading states for individual orders
  // ignore: prefer_final_fields
  Set<String> _loadingOrders = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOrders();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  // Auto refresh every 5 seconds like web version
  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        _loadOrders(showLoading: false);
      }
    });
  }

  Future<void> _loadOrders({bool showLoading = true}) async {
    try {
      if (showLoading) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      final orders = await _ordersApi.getOrders();
      
      // Sort orders by pickup time (latest first) like web version
      orders.sort((a, b) => b.pickUpTime.compareTo(a.pickUpTime));
      
      setState(() {
        _pendingOrders = orders.where((order) => order.isPending).toList();
        _acceptedOrders = orders.where((order) => order.isAccepted).toList();
        _historicalOrders = orders.where((order) => order.isHistorical).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshOrders() async {
    await _loadOrders();
  }

  // Handle order status changes - matching web functionality
  Future<void> _handleStatusChange(OrderModel order, String newStatus) async {
    if (_loadingOrders.contains(order.orderId)) return;

    setState(() {
      _loadingOrders.add(order.orderId);
    });

    try {
      final response = await _ordersApi.updateOrderStatus(order.orderId, newStatus);
      
      if (response['success'] == true) {
        // Show success message based on status
        String message = _getStatusChangeMessage(order.orderId, newStatus);
        _showSnackBar(message, Colors.green);
        
        // Refresh orders to update UI
        await _loadOrders(showLoading: false);
      } else {
        _showSnackBar('Failed to update order status', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error updating order: $e', Colors.red);
    } finally {
      setState(() {
        _loadingOrders.remove(order.orderId);
      });
    }
  }

  String _getStatusChangeMessage(String orderId, String status) {
    switch (status.toLowerCase()) {
      case 'accept':
        return 'Order $orderId has been accepted';
      case 'preparing':
        return 'Order $orderId is now being prepared';
      case 'ready':
        return 'Order $orderId preparation is complete';
      case 'dispatched':
        return 'Order $orderId has been dispatched';
      case 'reject':
        return 'Order $orderId has been rejected';
      default:
        return 'Order $orderId status updated';
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorWidget()
              : Column(
                  children: [
                    Container(
                      color: AppColors.background,
                      padding: const EdgeInsets.only(top: 0),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'New Orders',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '(${_pendingOrders.length})',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Accepted Orders',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '(${_acceptedOrders.length})',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'History',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '(${_historicalOrders.length})',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildNewOrdersTab(),
                          _buildAcceptedOrdersTab(),
                          _buildRecentActivityTab(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _refreshOrders,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewOrdersTab() {
    if (_pendingOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'No New Orders',
        subtitle: 'New orders will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 70),
        itemCount: _pendingOrders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(_pendingOrders[index], showActions: true);
        },
      ),
    );
  }

  Widget _buildAcceptedOrdersTab() {
    if (_acceptedOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'No Accepted Orders',
        subtitle: 'Accepted orders will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: _acceptedOrders.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(_acceptedOrders[index], showActions: false, onTap: () {
            _showOrderDetails(_acceptedOrders[index]);
          });
        },
      ),
    );
  }

  Widget _buildRecentActivityTab() {
    if (_historicalOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        title: 'No Recent Activity',
        subtitle: 'Order history will appear here',
      );
    }

    // Show only first 10 items like web version
    final displayOrders = _historicalOrders.take(10).toList();

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: displayOrders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(displayOrders[index], showActions: false);
              },
            ),
          ),
          if (_historicalOrders.length > 10)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.transparent
              ),
              child: ElevatedButton(
                onPressed: _showFullOrderHistory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.history, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'View Full Order History (${_historicalOrders.length} orders)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 75.h),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, {required bool showActions, VoidCallback? onTap}) {
    final isLoading = _loadingOrders.contains(order.orderId);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.orderId,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildStatusBadge(order.orderStatus),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                order.timeSinceOrder,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Items',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              order.totalItems.toString().padLeft(2, '0'),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Pickup in',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                order.pickupTimeText,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...order.orderDetails.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.itemName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'x${item.quantity}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (showActions && order.isPending) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoading ? null : () => _handleStatusChange(order, 'reject'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(
                                'Reject',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () => _handleStatusChange(order, 'accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3748),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Accept',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    String displayText;
    
    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange;
        displayText = 'Pending';
        break;
      case 'accept':
        backgroundColor = Colors.blue;
        displayText = 'Accepted';
        break;
      case 'preparing':
        backgroundColor = Colors.purple;
        displayText = 'Preparing';
        break;
      case 'ready':
        backgroundColor = Colors.green;
        displayText = 'Ready';
        break;
      case 'dispatched':
        backgroundColor = Colors.teal;
        displayText = 'Dispatched';
        break;
      case 'reject':
        backgroundColor = Colors.red;
        displayText = 'Rejected';
        break;
      default:
        backgroundColor = Colors.grey;
        displayText = status.toUpperCase();
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        displayText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsSheet(
        order: order,
        onStatusUpdate: (orderId, newStatus) async {
          await _handleStatusChange(order, newStatus);
        },
      ),
    );
  }

  void _showFullOrderHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const OrderHistoryPage(),
    );
  }
}