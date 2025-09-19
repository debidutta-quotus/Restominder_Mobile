// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/monthly_revenue_model.dart';
import '../../../../common/theme/app_colors.dart';

class SalesSummaryChart extends StatefulWidget {
  final List<MonthlyRevenueData> data;
  final Function(int) onMonthsCountChanged;
  final int currentMonthsCount;
  final bool isLoading;

  const SalesSummaryChart({
    super.key,
    required this.data,
    required this.onMonthsCountChanged,
    required this.currentMonthsCount,
    this.isLoading = false,
  });

  @override
  State<SalesSummaryChart> createState() => _SalesSummaryChartState();
}

class _SalesSummaryChartState extends State<SalesSummaryChart> {
  int? selectedDataPointIndex; // For tooltip functionality
  String? selectedDataType; // 'revenue' or 'orders'

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
                child: GestureDetector(
                  onTap: () => _showMonthsSelector(context),
                  child: Row(
                    children: [
                      Text(
                        '${widget.currentMonthsCount} months',
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
          SizedBox(height: 20.h),
          Row(
            children: [
              _buildLegendItem('Revenue (\$)', AppColors.labelColor),
              SizedBox(width: 20.w),
              _buildLegendItem('Orders', AppColors.primary),
            ],
          ),
          SizedBox(height: 20.h),
          // INTERACTIVE CHART SECTION - Modify chart behavior here
          SizedBox(
            height: 200.h,
            child: Stack(
              children: [
                GestureDetector(
                  onTapUp: (details) => _handleTap(details),
                  child: CustomPaint(
                    painter: LineChartPainter(
                      widget.data,
                      selectedDataPointIndex,
                      selectedDataType,
                    ),
                    child: Container(),
                  ),
                ),
                // Tooltip overlay
                if (selectedDataPointIndex != null && selectedDataType != null)
                  _buildTooltip(),
                if (widget.isLoading)
                  _buildSkeletonLoader(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAP HANDLING - Modify touch interaction behavior here
  void _handleTap(TapUpDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = details.localPosition;
    
    // Chart positioning constants - MODIFY THESE TO ADJUST CHART LAYOUT
    const double leftMargin = 50.0; // Space for left Y-axis labels
    const double rightMargin = 40.0; // Space for right Y-axis labels  
    const double topMargin = 20.0;
    const double bottomMargin = 60.0;
    
    final chartWidth = renderBox.size.width - leftMargin - rightMargin - 20; // -20 for container padding
    final chartHeight = 200 - topMargin - bottomMargin;
    final stepX = chartWidth / (widget.data.length - 1);
    
    // Find closest data point
    int? closestIndex;
    String? dataType;
    double minDistance = double.infinity;
    
    for (int i = 0; i < widget.data.length; i++) {
      final x = leftMargin + 10 + i * stepX; // +10 for container padding
      
      // Check revenue points
      final maxRevenue = widget.data.map((e) => e.totalRevenue).reduce((a, b) => a > b ? a : b);
      final revenueY = topMargin + 10 + chartHeight - (widget.data[i].totalRevenue / maxRevenue * chartHeight);
      final revenueDistance = (localPosition - Offset(x, revenueY)).distance;
      
      if (revenueDistance < minDistance && revenueDistance < 25) { // 25px tap radius
        minDistance = revenueDistance;
        closestIndex = i;
        dataType = 'revenue';
      }
      
      // Check order points
      final maxOrders = widget.data.map((e) => e.orderCount).reduce((a, b) => a > b ? a : b);
      final orderY = topMargin + 10 + chartHeight - (widget.data[i].orderCount / maxOrders * chartHeight);
      final orderDistance = (localPosition - Offset(x, orderY)).distance;
      
      if (orderDistance < minDistance && orderDistance < 25) { // 25px tap radius
        minDistance = orderDistance;
        closestIndex = i;
        dataType = 'orders';
      }
    }
    
    setState(() {
      selectedDataPointIndex = closestIndex;
      selectedDataType = dataType;
    });
  }

  // TOOLTIP WIDGET - Modify tooltip appearance here
  Widget _buildTooltip() {
    if (selectedDataPointIndex == null || selectedDataType == null) {
      return const SizedBox.shrink();
    }
    
    final data = widget.data[selectedDataPointIndex!];
    final isRevenue = selectedDataType == 'revenue';
    
    // Chart positioning constants (same as in _handleTap)
    const double leftMargin = 50.0;
    const double rightMargin = 40.0;  
    const double topMargin = 20.0;
    const double bottomMargin = 60.0;
    
    final chartWidth = MediaQuery.of(context).size.width - leftMargin - rightMargin - 40; // -40 for container padding
    final chartHeight = 200 - topMargin - bottomMargin;
    final stepX = chartWidth / (widget.data.length - 1);
    
    // Calculate tooltip position with screen boundary detection
    final x = leftMargin + 10 + selectedDataPointIndex! * stepX;
    
    final maxValue = isRevenue 
        ? widget.data.map((e) => e.totalRevenue).reduce((a, b) => a > b ? a : b)
        : widget.data.map((e) => e.orderCount).reduce((a, b) => a > b ? a : b);
    final currentValue = isRevenue ? data.totalRevenue : data.orderCount;
    final y = topMargin + 10 + chartHeight - (currentValue / maxValue * chartHeight);
    
    // TOOLTIP POSITIONING - Prevent going off screen
    const double tooltipWidth = 80.0; // Approximate tooltip width
    double tooltipX = x - 40; // Default: center on point
    
    // Check if tooltip would go off left edge
    if (tooltipX < 0) {
      tooltipX = 5; // Keep 5px from left edge
    }
    
    // Check if tooltip would go off right edge
    final screenWidth = MediaQuery.of(context).size.width;
    if (tooltipX + tooltipWidth > screenWidth) {
      tooltipX = screenWidth - tooltipWidth - 5; // Keep 5px from right edge
    }
    
    return Positioned(
      left: tooltipX,
      top: y - 60, // Position above the point
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.textPrimary,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data.monthName,
              style: TextStyle(
                color: AppColors.bgSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              isRevenue 
                  ? '\$${data.totalRevenue.toStringAsFixed(0)}'
                  : '${data.orderCount} orders',
              style: TextStyle(
                color: AppColors.bgSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            // Small triangle pointer
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: CustomPaint(
                size: Size(8.w, 4.h),
                painter: TrianglePainter(AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SKELETON LOADER - Matches chart shape and size exactly
  Widget _buildSkeletonLoader() {
    return Container(
      color: AppColors.bgSecondary.withOpacity(1),
      child: CustomPaint(
        painter: SkeletonChartPainter(),
        child: Container(),
      ),
    );
  }

  void _showMonthsSelector(BuildContext context) {
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
                'Select Time Period',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              ...List.generate(6, (index) {
                final months = (index + 1) * 3; // 3, 6, 9, 12, 15, 18 months
                return ListTile(
                  title: Text(
                    '$months months',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                    ),
                  ),
                  trailing: widget.currentMonthsCount == months
                      ? Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    widget.onMonthsCountChanged(months);
                  },
                );
              }),
            ],
          ),
        );
      },
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

// Skeleton loader painter that matches the chart layout exactly
class SkeletonChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textPrimary.withOpacity(0.1)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Match exact chart dimensions
    const double leftMargin = 50.0;
    const double rightMargin = 40.0;
    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - 60;
    
    // Draw skeleton data points (5 points to match typical chart)
    final skeletonPoints = <Offset>[];
    const pointCount = 5;
    final stepX = chartWidth / (pointCount - 1);
    
    for (int i = 0; i < pointCount; i++) {
      final x = leftMargin + i * stepX;
      final y = 20 + chartHeight * 0.3 + (i % 3) * (chartHeight * 0.4); // Varied heights
      skeletonPoints.add(Offset(x, y));
    }
    
    // Draw skeleton revenue line
    if (skeletonPoints.length > 1) {
      final path = Path();
      path.moveTo(skeletonPoints[0].dx, skeletonPoints[0].dy);
      for (int i = 1; i < skeletonPoints.length; i++) {
        path.lineTo(skeletonPoints[i].dx, skeletonPoints[i].dy);
      }
      canvas.drawPath(path, paint);
    }
    
    // Draw skeleton order line (dashed)
    paint.style = PaintingStyle.stroke;
    final orderPoints = <Offset>[];
    for (int i = 0; i < pointCount; i++) {
      final x = leftMargin + i * stepX;
      final y = 20 + chartHeight * 0.5 + ((i + 1) % 3) * (chartHeight * 0.3);
      orderPoints.add(Offset(x, y));
    }
    
    if (orderPoints.length > 1) {
      for (int i = 0; i < orderPoints.length - 1; i++) {
        _drawSkeletonDashedLine(canvas, orderPoints[i], orderPoints[i + 1], paint);
      }
    }
    
    // Draw skeleton dots
    final dotPaint = Paint()
      ..color = AppColors.textPrimary.withOpacity(0.1)
      ..style = PaintingStyle.fill;
      
    for (final point in skeletonPoints) {
      canvas.drawCircle(point, 5, dotPaint);
      canvas.drawCircle(point, 2, Paint()..color = AppColors.bgSecondary);
    }
    
    for (final point in orderPoints) {
      canvas.drawCircle(point, 5, dotPaint);
      canvas.drawCircle(point, 2, Paint()..color = AppColors.bgSecondary);
    }
    
    // Draw skeleton Y-axis labels
    final textPaint = Paint()
      ..color = AppColors.textPrimary.withOpacity(0.08)
      ..style = PaintingStyle.fill;
      
    // Left Y-axis skeleton labels
    for (int i = 0; i <= 5; i++) {
      final y = 20 + chartHeight - (i / 5 * chartHeight);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(8, y - 6, 30, 12),
          Radius.circular(4),
        ),
        textPaint,
      );
    }
    
    // Right Y-axis skeleton labels
    for (int i = 0; i <= 5; i++) {
      final y = 20 + chartHeight - (i / 5 * chartHeight);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width - rightMargin + 8, y - 6, 20, 12),
          Radius.circular(4),
        ),
        textPaint,
      );
    }
    
    // Draw skeleton month labels
    for (int i = 0; i < pointCount; i++) {
      final x = leftMargin + i * stepX;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - 15, size.height - 15, 30, 10),
          Radius.circular(4),
        ),
        textPaint,
      );
    }
  }
  
  void _drawSkeletonDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 4.0;
    
    final distance = (end - start).distance;
    final dashCount = (distance / (dashWidth + dashSpace)).floor();
    
    for (int i = 0; i < dashCount; i++) {
      final startOffset = start + (end - start) * (i * (dashWidth + dashSpace) / distance);
      final endOffset = start + (end - start) * ((i * (dashWidth + dashSpace) + dashWidth) / distance);
      canvas.drawLine(startOffset, endOffset, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Triangle painter for tooltip pointer
class TrianglePainter extends CustomPainter {
  final Color color;
  
  TrianglePainter(this.color);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  final List<MonthlyRevenueData> data;
  final int? selectedIndex;
  final String? selectedType;

  LineChartPainter(this.data, [this.selectedIndex, this.selectedType]);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaint = Paint()
      ..style = PaintingStyle.fill;

    final maxRevenue = data.map((e) => e.totalRevenue).reduce((a, b) => a > b ? a : b);
    final maxOrders = data.map((e) => e.orderCount).reduce((a, b) => a > b ? a : b);

    // CHART LAYOUT CONSTANTS - Modify these to adjust spacing
    const double leftMargin = 50.0; // Space for left Y-axis labels  
    const double rightMargin = 40.0; // Space for right Y-axis labels
    final chartWidth = size.width - leftMargin - rightMargin; // Balanced margins
    final chartHeight = size.height - 60;
    final stepX = chartWidth / (data.length - 1);

    // Draw smooth revenue line
    paint.color = AppColors.labelColor;
    final revenuePoints = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + i * stepX; // Centered positioning
      final y = 20 + chartHeight - (data[i].totalRevenue / maxRevenue * chartHeight);
      revenuePoints.add(Offset(x, y));
    }

    if (revenuePoints.length > 1) {
      final revenuePath = _createSmoothPath(revenuePoints);
      canvas.drawPath(revenuePath, paint);
    }

    // Draw revenue dots with selection highlighting
    dotPaint.color = AppColors.labelColor;
    for (int i = 0; i < revenuePoints.length; i++) {
      final point = revenuePoints[i];
      final isSelected = selectedIndex == i && selectedType == 'revenue';
      
      // Draw larger dot if selected
      canvas.drawCircle(point, isSelected ? 7 : 5, dotPaint);
      // Add white center for better visibility
      canvas.drawCircle(point, isSelected ? 3 : 2, Paint()..color = AppColors.bgSecondary);
    }

    // Draw smooth orders line (dashed)
    paint.color = AppColors.primary;
    final orderPoints = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + i * stepX; // Centered positioning
      final y = 20 + chartHeight - (data[i].orderCount / maxOrders * chartHeight);
      orderPoints.add(Offset(x, y));
    }

    if (orderPoints.length > 1) {
      final orderPath = _createSmoothPath(orderPoints);
      _drawDashedPath(canvas, orderPath, paint);
    }

    // Draw order dots with selection highlighting
    dotPaint.color = AppColors.primary;
    for (int i = 0; i < orderPoints.length; i++) {
      final point = orderPoints[i];
      final isSelected = selectedIndex == i && selectedType == 'orders';
      
      // Draw larger dot if selected
      canvas.drawCircle(point, isSelected ? 7 : 5, dotPaint);
      // Add white center for better visibility
      canvas.drawCircle(point, isSelected ? 3 : 2, Paint()..color = AppColors.bgSecondary);
    }

    // Draw labels (month names)
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < data.length; i++) {
      final x = leftMargin + i * stepX; // Centered positioning
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

    // Draw Y-axis labels (revenue on left)
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
      textPainter.paint(canvas, Offset(8, y - textPainter.height / 2)); // Left Y-axis labels
    }

    // Draw Y-axis labels (orders on right)
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
        Offset(size.width - rightMargin + 8, y - textPainter.height / 2), // Right Y-axis labels
      );
    }
  }

  // Create smooth curved path using cubic Bézier curves for ultra-smooth lines
  Path _createSmoothPath(List<Offset> points) {
    final path = Path();
    
    if (points.isEmpty) return path;
    
    path.moveTo(points[0].dx, points[0].dy);
    
    if (points.length == 1) return path;
    
    if (points.length == 2) {
      path.lineTo(points[1].dx, points[1].dy);
      return path;
    }
    
    // Create ultra-smooth curves using cubic Bézier with calculated control points
    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      
      // Calculate control points for smooth cubic curves
      final Offset controlPoint1;
      final Offset controlPoint2;
      
      if (i == 0) {
        // First segment
        final nextNext = i + 2 < points.length ? points[i + 2] : next;
        controlPoint1 = Offset(
          current.dx + (next.dx - current.dx) * 0.3,
          current.dy,
        );
        controlPoint2 = Offset(
          next.dx - (nextNext.dx - current.dx) * 0.15,
          next.dy,
        );
      } else if (i == points.length - 2) {
        // Last segment
        final prev = points[i - 1];
        controlPoint1 = Offset(
          current.dx + (next.dx - prev.dx) * 0.15,
          current.dy,
        );
        controlPoint2 = Offset(
          next.dx - (next.dx - current.dx) * 0.3,
          next.dy,
        );
      } else {
        // Middle segments - create very smooth transitions
        final prev = points[i - 1];
        final nextNext = points[i + 2];
        
        // Calculate smooth control points based on surrounding points
        final smoothnessFactor = 0.2;
        
        controlPoint1 = Offset(
          current.dx + (next.dx - prev.dx) * smoothnessFactor,
          current.dy,
        );
        controlPoint2 = Offset(
          next.dx - (nextNext.dx - current.dx) * smoothnessFactor,
          next.dy,
        );
      }
      
      // Use cubic Bézier curve for ultra-smooth lines
      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        next.dx, next.dy,
      );
    }
    
    return path;
  }

  // Draw dashed path for orders line
  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 4.0;
    
    final pathMetrics = path.computeMetrics();
    
    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      
      while (distance < pathMetric.length) {
        final length = draw ? dashWidth : dashSpace;
        final endDistance = (distance + length).clamp(0.0, pathMetric.length);
        
        if (draw) {
          final extractPath = pathMetric.extractPath(distance, endDistance);
          canvas.drawPath(extractPath, paint);
        }
        
        distance = endDistance;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}