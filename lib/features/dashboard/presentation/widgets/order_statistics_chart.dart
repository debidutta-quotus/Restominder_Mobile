// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/order_statistics_model.dart';
import '../../../../common/theme/app_colors.dart';

class OrderStatisticsChart extends StatelessWidget {
  final OrderStatisticsData data;
  final Function(String) onTimeRangeChanged;
  final String currentTimeRange;
  final bool isLoading;

  const OrderStatisticsChart({
    super.key,
    required this.data,
    required this.onTimeRangeChanged,
    required this.currentTimeRange,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final total = data.totalOrders;
    if (total == 0 && !isLoading) return const SizedBox();

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary, // Updated to white secondary background
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.textPrimary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Statistics',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: GestureDetector(
                  onTap: () => _showTimeRangeSelector(context),
                  child: Row(
                    children: [
                      Text(
                        _getTimeRangeLabel(currentTimeRange),
                        style: TextStyle(
                          color: AppColors.textPrimary.withOpacity(0.7),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textPrimary.withOpacity(0.7),
                        size: 16.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          // CHART SECTION - Shows skeleton or actual chart
          isLoading ? _buildSkeletonLoader() : _buildChartContent(),
        ],
      ),
    );
  }

  // SKELETON LOADER - Matches donut chart and legend layout exactly
  Widget _buildSkeletonLoader() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 200.h,
            child: CustomPaint(
              painter: SkeletonDonutChartPainter(),
              child: Container(),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkeletonLegendItem(),
              _buildSkeletonLegendItem(),
              _buildSkeletonLegendItem(),
              _buildSkeletonLegendItem(),
              _buildSkeletonLegendItem(),
              _buildSkeletonLegendItem(),
            ],
          ),
        ),
      ],
    );
  }

  // ACTUAL CHART CONTENT - Original chart layout
  Widget _buildChartContent() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 200.h,
            child: CustomPaint(
              painter: DonutChartPainter(data),
              child: Container(),
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLegendItem(
                'Pending Orders',
                data.pendingOrders,
                AppColors.primary,
              ),
              _buildLegendItem(
                'Accepted Orders',
                data.acceptedOrders,
                AppColors.cursor,
              ),
              _buildLegendItem(
                'Preparing Orders',
                data.preparingOrders,
                AppColors.accent,
              ),
              _buildLegendItem(
                'Ready Orders',
                data.readyOrders,
                AppColors.labelColor,
              ),
              _buildLegendItem(
                'Dispatched Orders',
                data.dispatchedOrders,
                const Color(0xFF9C27B0),
              ),
              _buildLegendItem(
                'Rejected Orders',
                data.rejectedOrders,
                const Color(0xFFFF5722),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // SKELETON LEGEND ITEM - Matches legend item layout
  Widget _buildSkeletonLegendItem() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: AppColors.textPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 12.h,
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeRangeLabel(String timeRange) {
    switch (timeRange) {
      case 'today':
        return 'Today';
      case 'week':
        return 'This Week';
      case 'month':
        return 'This Month';
      case 'year':
        return 'This Year';
      default:
        return 'Today';
    }
  }

  void _showTimeRangeSelector(BuildContext context) {
    final timeRanges = [
      {'value': 'today', 'label': 'Today'},
      {'value': 'week', 'label': 'This Week'},
      {'value': 'month', 'label': 'This Month'},
      {'value': 'year', 'label': 'This Year'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Time Range',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              ...timeRanges.map((range) {
                return ListTile(
                  title: Text(
                    range['label']!,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                    ),
                  ),
                  trailing:
                      currentTimeRange == range['value']
                          ? Icon(Icons.check, color: AppColors.primary)
                          : null,
                  onTap: () {
                    Navigator.pop(context);
                    onTimeRangeChanged(range['value']!);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, int value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.h,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.7),
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Skeleton donut chart painter
class SkeletonDonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final innerRadius = radius * 0.6;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius - innerRadius
      ..color = AppColors.textPrimary.withOpacity(0.08);

    // Draw skeleton donut ring
    canvas.drawCircle(
      center,
      radius - (radius - innerRadius) / 2,
      paint,
    );

    // Add some skeleton segments with different opacities
    final segmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius - innerRadius;

    final skeletonSegments = [
      {'angle': 1.5, 'opacity': 0.12},
      {'angle': 1.0, 'opacity': 0.10},
      {'angle': 0.8, 'opacity': 0.08},
    ];

    double startAngle = -90 * (3.14159 / 180);

    for (final segment in skeletonSegments) {
      final sweepAngle = segment['angle'] as double;
      final opacity = segment['opacity'] as double;

      segmentPaint.color = AppColors.textPrimary.withOpacity(opacity);
      canvas.drawArc(
        Rect.fromCircle(
          center: center,
          radius: radius - (radius - innerRadius) / 2,
        ),
        startAngle,
        sweepAngle,
        false,
        segmentPaint,
      );

      startAngle += sweepAngle + 0.2; // Small gap between segments
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DonutChartPainter extends CustomPainter {
  final OrderStatisticsData data;

  DonutChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final innerRadius = radius * 0.6;

    final total = data.totalOrders;
    if (total == 0) return;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius - innerRadius;

    double startAngle = -90 * (3.14159 / 180);

    final segments = [
      {'value': data.pendingOrders, 'color': AppColors.primary},
      {'value': data.acceptedOrders, 'color': AppColors.cursor},
      {'value': data.preparingOrders, 'color': AppColors.accent},
      {'value': data.readyOrders, 'color': AppColors.labelColor},
      {'value': data.dispatchedOrders, 'color': const Color(0xFF9C27B0)},
      {'value': data.rejectedOrders, 'color': const Color(0xFFFF5722)},
    ];

    for (final segment in segments) {
      final value = segment['value'] as int;
      final color = segment['color'] as Color;

      if (value > 0) {
        final sweepAngle = (value / total) * 2 * 3.14159;

        paint.color = color;
        canvas.drawArc(
          Rect.fromCircle(
            center: center,
            radius: radius - (radius - innerRadius) / 2,
          ),
          startAngle,
          sweepAngle,
          false,
          paint,
        );

        startAngle += sweepAngle;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}