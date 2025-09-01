import 'package:flutter/material.dart';
import '../common/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onNotificationPressed;

  const CustomAppBar({
    super.key,
    required this.title,  
    this.showBackButton = false,
    this.onMenuPressed,
    this.onBackPressed,
    this.onSearchPressed,
    this.onNotificationPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leadingWidth: 40,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: onMenuPressed ?? () {},
            ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black87),
          onPressed: onSearchPressed ?? () {},
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.black87,
              ),
              onPressed: onNotificationPressed ?? () {},
            ),
            const Positioned(
              right: 10,
              top: 12,
              child: CircleAvatar(radius: 4, backgroundColor: Colors.green),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              "https://via.placeholder.com/150",
            ),
          ),
        ),
      ],
    );
  }
}