// ignore_for_file: file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/theme/app_colors.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureRePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Bottom SVG
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SvgPicture.asset(
              'assets/icons/restBg.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 125.h,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h),

                    // Title
                    Text(
                      'Sign Up',
                      style: GoogleFonts.dmSans(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Please Sign Up to get started',
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        color: const Color(0xFF718096),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 25.h),

                    // Name Field
                    Text(
                      "Name",
                      style: GoogleFonts.dmSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    _buildInputField(hint: "John Doe", icon: Icons.person_outline),

                    SizedBox(height: 15.h),

                    // Email Field
                    Text(
                      "Email",
                      style: GoogleFonts.dmSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    _buildInputField(hint: "test@gmail.com", icon: Icons.email_outlined),

                    SizedBox(height: 15.h),

                    // Password Field
                    Text(
                      "Password",
                      style: GoogleFonts.dmSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    _buildPasswordField(
                      hint: "••••••••",
                      obscureText: _obscurePassword,
                      toggle: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),

                    SizedBox(height: 15.h),

                    // Re-type Password
                    Text(
                      "Re-type Password",
                      style: GoogleFonts.dmSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    _buildPasswordField(
                      hint: "••••••••",
                      obscureText: _obscureRePassword,
                      toggle: () => setState(() => _obscureRePassword = !_obscureRePassword),
                    ),

                    SizedBox(height: 32.h),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 45.h,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Login Text
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFF718096),
                            fontSize: 16.sp,
                          ),
                          children: [
                            TextSpan(
                              text: "Have an account? ",
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                              ),
                            ),
                            TextSpan(
                              text: "Login",
                              style: GoogleFonts.dmSans(
                                color: AppColors.cursor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 150.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({required String hint, required IconData icon}) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        cursorColor: AppColors.cursor,
        style: GoogleFonts.dmSans(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(
            color: const Color(0xFFA0AEC0),
            fontSize: 16.sp,
          ),
          suffixIcon: Icon(
            icon,
            color: const Color(0xFFA0AEC0),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String hint,
    required bool obscureText,
    required VoidCallback toggle,
  }) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        obscureText: obscureText,
        cursorColor: AppColors.cursor,
        style: GoogleFonts.dmSans(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(
            color: const Color(0xFFA0AEC0),
            fontSize: 16.sp,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFFA0AEC0),
              size: 20.sp,
            ),
            onPressed: toggle,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
      ),
    );
  }
}
