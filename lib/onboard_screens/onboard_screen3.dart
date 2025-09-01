import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/theme/app_colors.dart';
import 'onboard_screen4.dart';

class OnboardScreen3 extends StatelessWidget {
  const OnboardScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image Section - takes about 65% of screen
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.85.h,
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Image.asset(
                'assets/icons/onboardImage3.png',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_not_supported,
                            color: Colors.white,
                            size: 64.sp,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Image not found',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Check assets/icons/onboardImage4.png',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // White bottom container with subtle curve - takes about 40% of screen
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: screenHeight * 0.4.h,
            child: ClipPath(
              clipper: SubtleCurveClipper(),
              child: Container(
                decoration:  BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x15000000),
                      blurRadius: 20,
                      offset: Offset(0, -5),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Color(0xFF66C2FF).withOpacity(0.96), // Light blue with 96% opacity
                      blurRadius: 25,
                      offset: Offset(0, 4),
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 50.h, 24.w, 40.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Get\nordering',
                        style: GoogleFonts.dmSans(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          height: 1.1.h,
                          letterSpacing: -0.8,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'Add your favorite dishes to your cart, check out, and we’ll bring it to your door in no time!',
                        style: GoogleFonts.dmSans(
                          fontSize: 13.sp,
                          color: Color(0xFF64748B),
                          height: 1.6.h,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          // Skip Tour Button
                          Expanded(
                            child: SizedBox(
                              height: 53.h,
                              child: OutlinedButton(
                                onPressed: () {
                                  // Skip action
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF64748B),
                                  side: BorderSide(
                                    color: Color(0xFFE2E8F0),
                                    width: 1.5.w,
                                  ),
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Skip Tour',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          // Next Button
                          Expanded(
                            child: SizedBox(
                              height: 53.h,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const OnboardScreen4()),
                                  );
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                ),
                                child: Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubtleCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from left side, leaving space for rounded corner
    path.moveTo(0, 30);

    // Add rounded corner at top-left
    path.quadraticBezierTo(0, 10, 20, 10);

    // Create the subtle center curve
    path.quadraticBezierTo(
      size.width * 0.5, // Control point at center
      0, // Very shallow curve
      size.width - 20, // End before right corner
      10, // Same height as left side
    );

    // Add rounded corner at top-right
    path.quadraticBezierTo(size.width, 10, size.width, 30);

    // Complete the rectangle
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}