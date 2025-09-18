// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/theme/app_colors.dart';
import '../api/orders_api.dart';
import '../model/order_model.dart';
import 'order_details_sheet.dart';
import 'order_history.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final orders = await _ordersApi.getOrders();
      
      setState(() {
        _pendingOrders = orders.where((order) => order.isPending).toList();
        _acceptedOrders = orders.where((order) => order.isAccepted).toList();
        _historicalOrders = orders.where((order) => 
          order.orderStatus.toLowerCase() == 'dispatched' || 
          order.orderStatus.toLowerCase() == 'reject' ||
          order.orderStatus.toLowerCase() == 'completed'
        ).toList();
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

    // Show only first 10 items
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
    final now = DateTime.now();
    final timeDifference = order.pickUpTime.difference(now);
    
    String timeText;
    if (timeDifference.isNegative) {
      timeText = 'Just now';
    } else if (timeDifference.inMinutes < 60) {
      timeText = '${timeDifference.inMinutes} Mins';
    } else {
      timeText = '${timeDifference.inHours}h ${timeDifference.inMinutes % 60}m';
    }

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
                timeText,
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
                                timeText,
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
                        onPressed: () => _rejectOrder(order),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
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
                        onPressed: () => _acceptOrder(order),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D3748),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
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
      case 'ready':
        backgroundColor = Colors.green;
        displayText = 'Ready';
        break;
      case 'dispatched':
        backgroundColor = Colors.blue;
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

  Future<void> _acceptOrder(OrderModel order) async {
    try {
      await _ordersApi.acceptOrder(order.orderId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ${order.orderId} accepted!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Refresh orders to update the UI
      await _refreshOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to accept order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _rejectOrder(OrderModel order) async {
    try {
      await _ordersApi.rejectOrder(order.orderId);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ${order.orderId} rejected!'),
          backgroundColor: Colors.red,
        ),
      );
      
      // Refresh orders to update the UI
      await _refreshOrders();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to reject order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderDetailsSheet(
        order: order,
        onStatusUpdate: (orderId, newStatus) async {
          try {
            if (newStatus == 'dispatched') {
              await _ordersApi.dispatchOrder(orderId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order ${order.orderId} dispatched!'),
                  backgroundColor: Colors.blue,
                ),
              );
              await _refreshOrders();
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update order: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
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