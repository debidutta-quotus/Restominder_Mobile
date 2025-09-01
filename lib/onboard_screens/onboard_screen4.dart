import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resto_minder/features/auth/screens/login_screen.dart';

import '../common/theme/app_colors.dart';

class OnboardScreen4 extends StatelessWidget {
  const OnboardScreen4({super.key});

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
            height: screenHeight * 0.93.h,
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Image.asset(
                'assets/icons/onboardImage4.png',
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
                decoration: BoxDecoration(
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
                      const Spacer(),
                      // Top divider
                      Container(
                        height: 3.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x00FFFFFF), // #FFFFFF00 (transparent white)
                              Color(0xFF29304A), // #29304A
                              Color(0x00FFFFFF), // #FFFFFF00 (transparent white)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Food is the ingredient\nthat binds us together.',
                        style: GoogleFonts.dmSans(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w500,
                          color:AppColors.primary,
                          height: 1.1.h,
                          letterSpacing: -0.8,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Bottom divider
                      Container(
                        height: 3.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0x00FFFFFF), // #FFFFFF00 (transparent white)
                              Color(0xFF29304A), // #29304A
                              Color(0x00FFFFFF), // #FFFFFF00 (transparent white)
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),

                      const Spacer(),
                      Row(
                        children: [
                          // Skip Tour Button
                          Expanded(
                            // ignore: sized_box_for_whitespace
                            child: Container(
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
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              height: 53.h,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
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
                                  'Get started',
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

          // Circular container positioned on the border of the bottom container
          Positioned(
            left: 0,
            right: 0,
            bottom: screenHeight * 0.4.h - 40.h, // Position it on the top border of bottom container
            child: Center(
              child: Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '❛❛',
                    style: GoogleFonts.dmSans(
                      fontSize: 28.sp,
                      color: Color(0xFF334155),
                      fontWeight: FontWeight.w300,
                    ),
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