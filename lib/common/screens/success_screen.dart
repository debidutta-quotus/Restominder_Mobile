// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' show cos, sin, pi, Random;

class SuccessScreen extends StatefulWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final Color? primaryColor;
  final IconData? icon;
  final bool showAnimation;

  const SuccessScreen({
    super.key,
    this.title = "Successful",
    this.message = "Operation completed successfully",
    this.buttonText = "Continue",
    this.onButtonPressed,
    this.primaryColor,
    this.icon,
    this.showAnimation = true,
  });

  // Factory constructors for common use cases
  factory SuccessScreen.passwordReset({VoidCallback? onBackToLogin}) {
    return SuccessScreen(
      title: "Successful",
      message: "Your Password has been reset successfully",
      buttonText: "Back to Login",
      onButtonPressed: onBackToLogin,
      primaryColor: const Color(0xFF4CAF50),
    );
  }

  factory SuccessScreen.registration({VoidCallback? onContinue}) {
    return SuccessScreen(
      title: "Welcome!",
      message: "Your account has been created successfully",
      buttonText: "Get Started",
      onButtonPressed: onContinue,
      primaryColor: const Color(0xFF4CAF50),
    );
  }

  factory SuccessScreen.emailVerification({VoidCallback? onContinue}) {
    return SuccessScreen(
      title: "Verified!",
      message: "Your email has been verified successfully",
      buttonText: "Continue",
      onButtonPressed: onContinue,
      primaryColor: const Color(0xFF4CAF50),
    );
  }

  factory SuccessScreen.profileUpdate({VoidCallback? onContinue}) {
    return SuccessScreen(
      title: "Updated!",
      message: "Your profile has been updated successfully",
      buttonText: "Continue",
      onButtonPressed: onContinue,
      primaryColor: const Color(0xFF4CAF50),
    );
  }

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _checkController;
  late AnimationController _particleController;
  late AnimationController _fadeController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _textScaleAnimation;

  final Random _random = Random();
  late List<double> _randomAngles;
  late List<double> _randomSpeeds;
  late List<double> _randomRadii;
  late List<double> _randomSizes; // New list for random sizes

  @override
  void initState() {
    super.initState();

    if (widget.showAnimation) {
      _randomAngles = List.generate(8, (_) => _random.nextDouble() * 2 * pi);
      _randomSpeeds = List.generate(8, (_) => 0.5 + _random.nextDouble() * 1.5);
      _randomRadii = List.generate(8, (_) => 80.0 + _random.nextDouble() * 40.0);
      _randomSizes = List.generate(8, (_) => 8.w + _random.nextDouble() * 8.w); // Generate random sizes

      _initializeAnimations();
      _startAnimations();
    }
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    _checkAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeInOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    _textScaleAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  void _startAnimations() async {
    await _scaleController.forward();
    await _checkController.forward();
    await _fadeController.forward();
    _pulseController.forward(from: 0.0);
  }

  @override
  void dispose() {
    if (widget.showAnimation) {
      _scaleController.dispose();
      _checkController.dispose();
      _particleController.dispose();
      _fadeController.dispose();
      _pulseController.dispose();
    }
    super.dispose();
  }

  void _handleButtonPress() {
    if (widget.onButtonPressed != null) {
      widget.onButtonPressed!();
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.primaryColor ?? const Color(0xFF4CAF50);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: widget.showAnimation
                      ? _buildAnimatedSuccess(color)
                      : _buildStaticSuccess(color),
                ),
              ),
              Expanded(
                flex: 2,
                child: widget.showAnimation
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildContent(),
                      )
                    : _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSuccess(Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Floating particles
        ...List.generate(8, (index) {
          final angle = _randomAngles.elementAt(index);
          final speed = _randomSpeeds.elementAt(index);
          final baseRadius = _randomRadii.elementAt(index);
          final size = _randomSizes.elementAt(index); // Get the random size

          return AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              final radialOffset = 20.0 * sin(_particleController.value * speed * 2 * pi);
              final currentRadius = baseRadius + radialOffset;

              final x = currentRadius * cos(angle);
              final y = currentRadius * sin(angle);

              return Transform.translate(
                offset: Offset(x, y),
                child: Container(
                  width: size, // Use the random size
                  height: size, // Use the random size
                  decoration: BoxDecoration(
                    color: index.isEven ? color : const Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),

        // Main success circle with pulsing effect
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            final pulseScale = 1.0 + _pulseAnimation.value * 0.05;
            return Transform.scale(
              scale: _scaleAnimation.value * pulseScale,
              child: Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: widget.icon != null
                    ? Icon(
                        widget.icon,
                        color: Colors.white,
                        size: 50.sp,
                      )
                    : AnimatedBuilder(
                        animation: _checkAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: CheckMarkPainter(_checkAnimation.value),
                          );
                        },
                      ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStaticSuccess(Color color) {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: widget.icon != null
          ? Icon(
              widget.icon,
              color: Colors.white,
              size: 50.sp,
            )
          : const Icon(
              Icons.check,
              color: Colors.white,
              size: 50,
            ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Success title with animated scaling
        if (widget.showAnimation)
          AnimatedBuilder(
            animation: _textScaleAnimation,
            builder: (context, child) {
              final scale = 1.0 + _textScaleAnimation.value * 0.1;
              return Transform.scale(
                scale: scale,
                child: Text(
                  widget.title,
                  style: GoogleFonts.dmSans(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              );
            },
          )
        else
          Text(
            widget.title,
            style: GoogleFonts.dmSans(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3748),
            ),
          ),

        SizedBox(height: 12.h),

        // Success message
        Text(
          widget.message,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 16.sp,
            color: const Color(0xFF718096),
            height: 1.4,
          ),
        ),

        SizedBox(height: 40.h),

        // Action Button
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: _handleButtonPress,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A5568),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              widget.buttonText,
              style: GoogleFonts.dmSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(height: 40.h),
      ],
    );
  }
}

// Custom painter for the check mark animation
class CheckMarkPainter extends CustomPainter {
  final double progress;

  CheckMarkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0.0) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final checkPath = Path();

    // Define check mark points
    final startPoint = Offset(center.dx - 15, center.dy);
    final middlePoint = Offset(center.dx - 5, center.dy + 10);
    final endPoint = Offset(center.dx + 15, center.dy - 10);

    if (progress <= 0.5) {
      // First half: draw line from start to middle
      final currentProgress = progress * 2;
      final currentX = startPoint.dx + (middlePoint.dx - startPoint.dx) * currentProgress;
      final currentY = startPoint.dy + (middlePoint.dy - startPoint.dy) * currentProgress;

      checkPath.moveTo(startPoint.dx, startPoint.dy);
      checkPath.lineTo(currentX, currentY);
    } else {
      // Second half: draw line from middle to end
      final currentProgress = (progress - 0.5) * 2;
      final currentX = middlePoint.dx + (endPoint.dx - middlePoint.dx) * currentProgress;
      final currentY = middlePoint.dy + (endPoint.dy - middlePoint.dy) * currentProgress;

      checkPath.moveTo(startPoint.dx, startPoint.dy);
      checkPath.lineTo(middlePoint.dx, middlePoint.dy);
      checkPath.lineTo(currentX, currentY);
    }

    canvas.drawPath(checkPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}