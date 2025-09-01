// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'verification_screen.dart';

import '../../../common/theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  bool isEmailMode = true;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMode(bool emailMode) {
    setState(() {
      isEmailMode = emailMode;
    });
    if (emailMode) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Title
            Text(
              "Forgot Password",
              style: GoogleFonts.dmSans(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              isEmailMode
                  ? "Please enter your email to get verification code"
                  : "Please enter your phone number to get verification code",
              style: GoogleFonts.dmSans(
                fontSize: 15.sp,
                color: const Color(0xFF718096),
              ),
            ),

            SizedBox(height: 24.h),

            // Enhanced Toggle Button with Sliding Animation
            Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                children: [
                  // Sliding Background
                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return Positioned(
                        left:
                            _slideAnimation.value *
                            (MediaQuery.of(context).size.width - 48) /
                            2,
                        top: 2.h,
                        bottom: 2.h,
                        width: (MediaQuery.of(context).size.width - 48) / 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Toggle Buttons
                  Row(
                    children: [
                      _buildToggleButton("Email", isEmailMode, () {
                        _toggleMode(true);
                      }),
                      _buildToggleButton("Phone", !isEmailMode, () {
                        _toggleMode(false);
                      }),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Input Label
            Text(
              isEmailMode ? "Email" : "Phone",
              style: GoogleFonts.dmSans(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 8.h),

            // Input Field
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                keyboardType:
                    isEmailMode
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                cursorColor: AppColors.cursor,
                style: GoogleFonts.dmSans(fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: isEmailMode ? "test@gmail.com" : "+91 1236 162745",
                  hintStyle: GoogleFonts.dmSans(
                    color: const Color(0xFFA0AEC0),
                    fontSize: 16.sp,
                  ),
                  suffixIcon: Icon(
                    isEmailMode ? Icons.email_outlined : Icons.phone_outlined,
                    color: const Color(0xFFA0AEC0),
                    size: 20.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                ),
              ),
            ),

            SizedBox(height: 40.h),

            // Send Code Button
            SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => VerificationScreen(
                            contactInfo:
                                isEmailMode
                                    ? "your email"
                                    : "your phone number",
                          ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  "Send Code",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            style: GoogleFonts.dmSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: selected ? AppColors.primary : const Color(0xFFCBD5E0),
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
