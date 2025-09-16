import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import '../../../../common//widgets//app_bar.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/revenue_card.dart';
import '../widgets/order_statistics_chart.dart';
import '../widgets/sales_summary_chart.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../../../common/theme/app_colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardProvider _dashboardProvider;

  @override
  void initState() {
    super.initState();
    _dashboardProvider = DashboardProvider(DashboardRepositoryImpl());
    _dashboardProvider.loadDashboardData();
  }

  // Handler for pull-to-refresh
  Future<void> _onRefresh() async {
    await _dashboardProvider.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _dashboardProvider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary, // Refresh indicator color
          backgroundColor: AppColors.bgSecondary, // Refresh background
          child: Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (provider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${provider.error}',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => provider.loadDashboardData(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.bgSecondary,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 80.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: RevenueCard(
                            title: 'Total Revenue',
                            value:
                                '\$${provider.revenueData?.data.totalRevenue.toStringAsFixed(2) ?? '0.00'}',
                            icon: Icons.trending_up,
                            iconColor: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: RevenueCard(
                            title: 'Dispatched Orders',
                            value:
                                '${provider.revenueData?.data.dispatchedOrderCount ?? 0}',
                            icon: Icons.local_shipping,
                            iconColor: AppColors.labelColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    if (provider.monthlyRevenue != null)
                      SalesSummaryChart(data: provider.monthlyRevenue!.data),
                    SizedBox(height: 8.h),
                    if (provider.orderStatistics != null)
                      OrderStatisticsChart(
                        data: provider.orderStatistics!.data,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
