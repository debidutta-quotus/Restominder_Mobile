// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/theme/app_colors.dart';
import '../../../common/screens/success_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscureNewPassword = true;
  bool _obscureReTypePassword = true;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _reTypePasswordController =
      TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _reTypePasswordController.dispose();
    super.dispose();
  }

  // Password validation method
  bool _isValidPassword(String password) {
    // Check if password meets requirements:
    // At least 8 characters, 1 lowercase, 1 uppercase, 1 number, 1 special character
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  // Handle password reset
  void _handlePasswordReset() {
    String newPassword = _newPasswordController.text.trim();
    String reTypePassword = _reTypePasswordController.text.trim();

    // Validation checks
    if (newPassword.isEmpty || reTypePassword.isEmpty) {
      _showErrorSnackBar("Please fill in both password fields");
      return;
    }

    if (newPassword != reTypePassword) {
      _showErrorSnackBar("Passwords do not match");
      return;
    }

    if (!_isValidPassword(newPassword)) {
      _showErrorSnackBar("Password doesn't meet the requirements");
      return;
    }

    // For now, we'll simulate a successful reset
    _resetPassword(newPassword);
  }

  // Simulate API call for password reset
  Future<void> _resetPassword(String password) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    // Hide loading indicator
    // ignore: use_build_context_synchronously
    Navigator.pop(context);

    // Navigate to success screen
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder:
            (context) => SuccessScreen.passwordReset(
              onBackToLogin: () {
                // Navigate back to login screen (first screen)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
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
        padding: const EdgeInsets.symmetric(horizontal: 24).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            // Title
            Text(
              "Reset Password",
              style: GoogleFonts.dmSans(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              "Your password must be at least 8 characters long including 1 lowercase letter, 1 uppercase letter, 1 number and 1 special character.",
              style: GoogleFonts.dmSans(
                fontSize: 15.sp,
                color: const Color(0xFF718096),
              ),
            ),

            SizedBox(height: 24.h),

            // New Password Field
            Text(
              "Enter new Password",
              style: GoogleFonts.dmSans(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                cursorColor: AppColors.cursor,
                style: GoogleFonts.dmSans(fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: "Enter new password",
                  hintStyle: GoogleFonts.dmSans(
                    color: const Color(0xFFA0AEC0),
                    fontSize: 16.sp,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    child: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFFA0AEC0),
                      size: 20.sp,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Re-type Password Field
            Text(
              "Re-type Password",
              style: GoogleFonts.dmSans(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextField(
                controller: _reTypePasswordController,
                obscureText: _obscureReTypePassword,
                cursorColor: AppColors.cursor,
                style: GoogleFonts.dmSans(fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: "Re-type new password",
                  hintStyle: GoogleFonts.dmSans(
                    color: const Color(0xFFA0AEC0),
                    fontSize: 16.sp,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureReTypePassword = !_obscureReTypePassword;
                      });
                    },
                    child: Icon(
                      _obscureReTypePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFFA0AEC0),
                      size: 20.sp,
                    ),
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

            // Reset Password Button
            SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                onPressed:
                    _handlePasswordReset, // Updated to use the new method
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: Text(
                  "Reset Password",
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
}
