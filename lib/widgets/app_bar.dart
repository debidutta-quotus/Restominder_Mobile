import 'package:flutter/material.dart';
import '../common/theme/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final String? menuPath;
  final String? searchPath;
  final String? notificationPath;
  final String? profilePath;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.menuPath,
    this.searchPath,
    this.notificationPath,
    this.profilePath,
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
              onPressed: () => Navigator.of(context).pop(),
            )
          : IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: menuPath != null
                  ? () => Navigator.pushNamed(context, menuPath!)
                  : () {},
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
          onPressed: searchPath != null
              ? () => Navigator.pushNamed(context, searchPath!)
              : () {},
        ),
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: Colors.black87,
              ),
              onPressed: notificationPath != null
                  ? () => Navigator.pushNamed(context, notificationPath!)
                  : () {},
            ),
            const Positioned(
              right: 10,
              top: 12,
              child: CircleAvatar(radius: 4, backgroundColor: Colors.green),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GestureDetector(
            onTap: profilePath != null
                ? () => Navigator.pushNamed(context, profilePath!)
                : () {},
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                "https://res.cloudinary.com/drxnoxxah/image/upload/v1752666601/main-sample.png",
              ),
            ),
          ),
        ),
      ],
    );
  }
}
