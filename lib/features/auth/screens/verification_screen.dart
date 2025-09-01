// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reset_password_screen.dart';

import '../../../common/theme/app_colors.dart';

class VerificationScreen extends StatefulWidget {
  final String contactInfo; // email/phone from ForgotPassword
  const VerificationScreen({super.key, required this.contactInfo});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _verifyCode() {
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      // If verification is successful, then navigate

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      );

      // Or if you want to replace the current screen entirely:
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const ResetPasswordScreen(),
      //   ),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the complete code")),
      );
    }
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      height: 55.h,
      width: 55.h,
      child: TextField(
        controller: _otpControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.dmSans(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            // ignore: deprecated_member_use
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            // Move to next field
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            // Move to previous field on backspace
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),

            // Illustration
            Center(
              child: Container(
                height: 160.h,
                width: 160.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF7FAFC),
                ),
                child: Icon(
                  Icons.lock_outline,
                  color: AppColors.primary,
                  size: 70.sp,
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Title
            Text(
              "Verification",
              style: GoogleFonts.dmSans(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 8.h),

            // Subtitle
            Text(
              "We have sent a code to your ${widget.contactInfo}",
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 15.sp,
                color: const Color(0xFF718096),
              ),
            ),

            SizedBox(height: 30.h),

            // OTP Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildOtpBox(index)),
            ),

            SizedBox(height: 20.h),

            // Resend OTP
            TextButton(
              onPressed: () {
                
              },
              child: Text(
                "Didn’t get the code? Resend it.",
                style: GoogleFonts.dmSans(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 30.h),

            // Verify Button
            SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                onPressed: _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  "Verify",
                  style: GoogleFonts.dmSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
