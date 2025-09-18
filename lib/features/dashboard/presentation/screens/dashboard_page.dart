import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/revenue_card.dart';
import '../widgets/order_statistics_chart.dart';
import '../widgets/sales_summary_chart.dart';
import '../../data/api/dashboard_api.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../../domain/usecases/get_dashboard_data.dart';
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
    _initializeDashboard();
  }

  void _initializeDashboard() {
    final dashboardApi = DashboardApi();
    final dashboardRepository = DashboardRepositoryImpl(dashboardApi);
    final getDashboardData = GetDashboardData(dashboardRepository);
    
    _dashboardProvider = DashboardProvider(getDashboardData);
    _dashboardProvider.loadDashboardData();
  }

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
          color: AppColors.primary,
          backgroundColor: AppColors.bgSecondary,
          child: Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.revenueData == null) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }

              if (provider.error != null && provider.revenueData == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.w,
                        color: AppColors.accent,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Failed to load dashboard data',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        provider.error!,
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        onPressed: () {
                          provider.clearError();
                          provider.loadDashboardData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.bgSecondary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 80.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    
                    // Revenue Cards
                    Row(
                      children: [
                        Expanded(
                          child: RevenueCard(
                            title: 'Total Revenue',
                            value: '\$${provider.revenueData?.data.totalRevenue.toStringAsFixed(2) ?? '0.00'}',
                            icon: Icons.trending_up,
                            iconColor: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: RevenueCard(
                            title: 'Dispatched Orders',
                            value: '${provider.revenueData?.data.dispatchedOrderCount ?? 0}',
                            icon: Icons.local_shipping,
                            iconColor: AppColors.labelColor,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Sales Summary Chart
                    if (provider.monthlyRevenue != null)
                      SalesSummaryChart(
                        data: provider.monthlyRevenue!.data,
                        onMonthsCountChanged: (monthsCount) {
                          provider.updateMonthsCount(monthsCount);
                        },
                        currentMonthsCount: provider.currentMonthsCount,
                        isLoading: provider.isLoading,
                      ),
                    
                    SizedBox(height: 24.h),
                    
                    // Order Statistics Chart
                    if (provider.orderStatistics != null)
                      OrderStatisticsChart(
                        data: provider.orderStatistics!.data,
                        onTimeRangeChanged: (timeRange) {
                          provider.updateTimeRange(timeRange);
                        },
                        currentTimeRange: provider.currentTimeRange,
                        isLoading: provider.isLoading,
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

  @override
  void dispose() {
    _dashboardProvider.dispose();
    super.dispose();
  }
}