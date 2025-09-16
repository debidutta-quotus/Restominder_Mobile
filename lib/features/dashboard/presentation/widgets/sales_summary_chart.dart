// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/monthly_revenue_model.dart';
import '../../../../common/theme/app_colors.dart';

class SalesSummaryChart extends StatelessWidget {
  final List<MonthlyRevenueData> data;

  const SalesSummaryChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary, // Updated to white secondary background
        borderRadius: BorderRadius.circular(12.r),
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
                'Sales Summary',
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
                child: Row(
                  children: [
                    Text(
                      '5 months',
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
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _buildLegendItem('Revenue (\$)', AppColors.labelColor),
              SizedBox(width: 20.w),
              _buildLegendItem('Orders', AppColors.primary),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 200.h,
            child: CustomPaint(
              painter: LineChartPainter(data),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary.withOpacity(0.7),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<MonthlyRevenueData> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill;

    final maxRevenue = data.map((e) => e.totalRevenue).reduce((a, b) => a > b ? a : b);
    final maxOrders = data.map((e) => e.orderCount).reduce((a, b) => a > b ? a : b);

    final chartWidth = size.width - 40;
    final chartHeight = size.height - 60;
    final stepX = chartWidth / (data.length - 1);

    paint.color = AppColors.labelColor;
    final revenuePoints = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = 20 + i * stepX;
      final y = 20 + chartHeight - (data[i].totalRevenue / maxRevenue * chartHeight);
      revenuePoints.add(Offset(x, y));
    }

    for (int i = 0; i < revenuePoints.length - 1; i++) {
      canvas.drawLine(revenuePoints[i], revenuePoints[i + 1], paint);
    }

    dotPaint.color = AppColors.labelColor;
    for (final point in revenuePoints) {
      canvas.drawCircle(point, 4, dotPaint);
    }

    paint.color = AppColors.primary;
    final orderPoints = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = 20 + i * stepX;
      final y = 20 + chartHeight - (data[i].orderCount / maxOrders * chartHeight);
      orderPoints.add(Offset(x, y));
    }

    for (int i = 0; i < orderPoints.length - 1; i++) {
      _drawDashedLine(canvas, orderPoints[i], orderPoints[i + 1], paint);
    }

    dotPaint.color = AppColors.primary;
    for (final point in orderPoints) {
      canvas.drawCircle(point, 4, dotPaint);
    }

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < data.length; i++) {
      final x = 20 + i * stepX;
      textPainter.text = TextSpan(
        text: data[i].monthName,
        style: TextStyle(
          color: AppColors.textPrimary.withOpacity(0.7),
          fontSize: 12.sp,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 20),
      );
    }

    final revenueSteps = 5;
    for (int i = 0; i <= revenueSteps; i++) {
      final value = (maxRevenue / revenueSteps * i);
      final y = 20 + chartHeight - (i / revenueSteps * chartHeight);

      textPainter.text = TextSpan(
        text: '\$${value.toInt()}',
        style: TextStyle(
          color: AppColors.textPrimary.withOpacity(0.7),
          fontSize: 10.sp,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    for (int i = 0; i <= revenueSteps; i++) {
      final value = (maxOrders / revenueSteps * i);
      final y = 20 + chartHeight - (i / revenueSteps * chartHeight);

      textPainter.text = TextSpan(
        text: value.toInt().toString(),
        style: TextStyle(
          color: AppColors.textPrimary.withOpacity(0.7),
          fontSize: 10.sp,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(size.width - textPainter.width, y - textPainter.height / 2),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < dashCount; i++) {
      final startOffset = start + (end - start) * (i * (dashWidth + dashSpace) / distance);
      final endOffset = start + (end - start) * ((i * (dashWidth + dashSpace) + dashWidth) / distance);
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}