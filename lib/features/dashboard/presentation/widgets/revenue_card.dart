// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/theme/app_colors.dart';

class RevenueCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final bool isLoading;
  final int minLoadingDurationMs; // Minimum loading duration in milliseconds

  const RevenueCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.isLoading = false,
    this.minLoadingDurationMs = 1500, // Default 1.5 seconds minimum loading
  });

  @override
  State<RevenueCard> createState() => _RevenueCardState();
}

class _RevenueCardState extends State<RevenueCard> {
  bool _showSkeleton = false;
  DateTime? _loadingStartTime;

  @override
  void initState() {
    super.initState();
    _showSkeleton = widget.isLoading;
    if (widget.isLoading) {
      _loadingStartTime = DateTime.now();
    }
  }

  @override
  void didUpdateWidget(RevenueCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle loading state changes
    if (widget.isLoading && !oldWidget.isLoading) {
      // Started loading
      _loadingStartTime = DateTime.now();
      setState(() {
        _showSkeleton = true;
      });
    } else if (!widget.isLoading && oldWidget.isLoading) {
      // Finished loading - check if minimum duration has passed
      _handleLoadingComplete();
    }
  }

  void _handleLoadingComplete() {
    if (_loadingStartTime == null) {
      setState(() {
        _showSkeleton = false;
      });
      return;
    }

    final elapsed = DateTime.now().difference(_loadingStartTime!).inMilliseconds;
    final remaining = widget.minLoadingDurationMs - elapsed;

    if (remaining <= 0) {
      // Minimum duration already passed
      setState(() {
        _showSkeleton = false;
      });
    } else {
      // Wait for remaining time
      Future.delayed(Duration(milliseconds: remaining), () {
        if (mounted) {
          setState(() {
            _showSkeleton = false;
          });
        }
      });
    }
  }

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
      child: _showSkeleton ? _buildSkeletonLoader() : _buildContent(),
    );
  }

  // SKELETON LOADER - Matches card layout exactly
  Widget _buildSkeletonLoader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Skeleton icon container
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.textPrimary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Skeleton title text
            Expanded(
              child: Container(
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            // Add some spacing at the end to make it look more realistic
            SizedBox(width: 40.w),
          ],
        ),
        SizedBox(height: 16.h),
        // Skeleton value text
        Container(
          height: 28.h, // Matches the font size of the value text
          width: 120.w, // Approximate width for typical revenue values
          decoration: BoxDecoration(
            color: AppColors.textPrimary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }

  // ACTUAL CONTENT - Original card content
  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: widget.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: AppColors.textPrimary.withOpacity(0.7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          widget.value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}