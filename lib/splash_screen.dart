// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _scaleController;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize glow animation controller
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create glow animation (pulsing effect)
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Create scale animation (gentle zoom in)
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _scaleController.forward();
    _glowController.repeat(reverse: true);

    // Navigate after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2746), // dark navy
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/icons/splashBg.svg',
              fit: BoxFit.cover,
            ),
          ),
          // Main content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated icon with brightness effect
                  AnimatedBuilder(
                    animation: Listenable.merge([_glowAnimation, _scaleAnimation]),
                    builder: (context, child) {
                      // Clamp scale value to prevent overflow
                      final scale = _scaleAnimation.value.clamp(0.8, 1.0);
                      return Transform.scale(
                        scale: scale,
                        child: SvgPicture.asset(
                          'assets/icons/splashIcon.svg',
                          width: 130.w,
                          height: 130.h,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.3 + (_glowAnimation.value * 0.4)),
                            BlendMode.modulate,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  // Fade in animation for the vector
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      // Clamp opacity to valid range
                      final opacity = _scaleAnimation.value.clamp(0.0, 1.0);
                      return Opacity(
                        opacity: opacity,
                        child: SvgPicture.asset(
                          'assets/icons/Vector.svg',
                          width: 50.w,
                          height: 30.h,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 8.h),
                  // Fade in animation for the text
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      // Clamp opacity to valid range
                      final opacity = _scaleAnimation.value.clamp(0.0, 1.0);
                      return Opacity(
                        opacity: opacity,
                        child: Text(
                          'CONNECT THE WORLD WITH FOOD',
                          style: GoogleFonts.roboto(
                            fontSize: 10.sp,
                            color: Colors.white70,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}