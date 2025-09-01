import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/theme/app_colors.dart';
import '../../../register_store/screens/basic_info_screen.dart';
import 'forgotPassword_screen.dart';
import '../../../layouts/main_shell/main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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

          // Main content
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
                      'Login',
                      style: GoogleFonts.dmSans(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Please login into your existing account',
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        color: Color(0xFF718096),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 25.h),

                    // Email
                    Text(
                      "Email",
                      style: GoogleFonts.dmSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                            selectionHandleColor: AppColors.cursor,
                            // ignore: deprecated_member_use
                            selectionColor: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: TextField(
                          cursorColor: AppColors.cursor,
                          style: GoogleFonts.dmSans(fontSize: 16.sp),
                          decoration: InputDecoration(
                            hintText: "test@gmail.com",
                            hintStyle: GoogleFonts.dmSans(
                              color: Color(0xFFA0AEC0),
                              fontSize: 16.sp,
                            ),
                            suffixIcon: Icon(
                              Icons.email_outlined,
                              color: Color(0xFFA0AEC0),
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
                    ),
                    SizedBox(height: 15.h),

                    // Password
                    Text(
                      "Password",
                      style: GoogleFonts.dmSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                            selectionHandleColor: AppColors.cursor,
                            // ignore: deprecated_member_use
                            selectionColor: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: TextField(
                          obscureText: _obscurePassword,
                          cursorColor: AppColors.cursor,
                          style: GoogleFonts.dmSans(fontSize: 16.sp),
                          decoration: InputDecoration(
                            hintText: "X23cdT@3g^",
                            hintStyle: GoogleFonts.dmSans(
                              color: Color(0xFFA0AEC0),
                              fontSize: 16.sp,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFFA0AEC0),
                                size: 20.sp,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Remember me & Forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value!;
                                  });
                                },
                                activeColor: AppColors.cursor,
                                checkColor: Colors.white,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Remember me",
                              style: GoogleFonts.dmSans(
                                fontSize: 14.sp,
                                color: Color(0xFF4A5568),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.dmSans(
                              color: AppColors.cursor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 45.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainShell(),
                            ),
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFFE2E8F0),
                            thickness: 1.w,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Sign in with Google or Facebook",
                            style: GoogleFonts.dmSans(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFFE2E8F0),
                            thickness: 1.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    // Social Buttons
                    Row(
                      children: [
                        Expanded(
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            height: 45.h,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.string(
                                    '''
                                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                      <path d="M19.8055 8.0415H19V8H10V12H15.6515C14.827 14.3285 12.6115 16 10 16C6.6865 16 4 13.3135 4 10C4 6.6865 6.6865 4 10 4C11.5295 4 12.921 4.577 13.9805 5.5195L16.809 2.691C15.023 1.0265 12.634 0 10 0C4.4775 0 0 4.4775 0 10C0 15.5225 4.4775 20 10 20C15.5225 20 20 15.5225 20 10C20 9.3295 19.931 8.675 19.8055 8.0415Z" fill="#FFC107"/>
                                      <path d="M1.1533 5.3455L4.4383 7.755C5.3258 5.554 7.4803 4 9.9998 4C11.5293 4 12.9208 4.577 13.9803 5.5195L16.8088 2.691C15.0228 1.0265 12.6338 0 9.9998 0C6.1588 0 2.8278 2.1685 1.1533 5.3455Z" fill="#FF3D00"/>
                                      <path d="M10.0001 20C12.5831 20 14.9271 19.0115 16.7046 17.404L13.6081 14.785C12.5837 15.5742 11.3304 16.0011 10.0001 16C7.3991 16 5.1906 14.3415 4.3581 12.027L1.0996 14.5395C2.7521 17.778 6.1136 20 10.0001 20Z" fill="#4CAF50"/>
                                      <path d="M19.8055 8.0415H19V8H10V12H15.6515C15.2571 13.1082 14.5467 14.0766 13.6065 14.785L13.6082 14.784L16.7047 17.403C16.4767 17.6115 20 15 20 10C20 9.3295 19.931 8.675 19.8055 8.0415Z" fill="#1976D2"/>
                                    </svg>
                                    ''',
                                    width: 20.w,
                                    height: 20.h,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    "Google",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            height: 45.h,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFE2E8F0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.string(
                                    '''
                                    <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
                                      <path d="M20 10C20 4.4775 15.5225 0 10 0S0 4.4775 0 10C0 14.991 3.6565 19.1283 8.4375 19.8785V12.8906H5.8984V10H8.4375V7.7969C8.4375 5.2906 9.9305 3.9063 12.2146 3.9063C13.3084 3.9063 14.4531 4.1016 14.4531 4.1016V6.5625H13.1922C11.95 6.5625 11.5625 7.3334 11.5625 8.125V10H14.3359L13.8926 12.8906H11.5625V19.8785C16.3435 19.1283 20 14.9910 20 10Z" fill="#1877F2"/>
                                    </svg>
                                    ''',
                                    width: 20.w,
                                    height: 20.h,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    "Facebook",
                                    style: GoogleFonts.dmSans(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),

                    // Sign Up Text
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.dmSans(
                            color: const Color(0xFF718096),
                            fontSize: 16.sp,
                          ),
                          children: [
                            TextSpan(
                              text: "Don't have an account? ",
                              style: GoogleFonts.dmSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp,
                              ),
                            ),
                            TextSpan(
                              text: "Sign Up",
                              style: GoogleFonts.dmSans(
                                color: AppColors.cursor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    // ..onTap = () {
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                    //   );
                                    // },
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const BasicInformationPage(),
                                        ),
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
}
