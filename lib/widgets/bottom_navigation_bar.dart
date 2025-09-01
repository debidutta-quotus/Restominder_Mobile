import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _NavBarClipper(),
      child: Container(
        height: 80, // increased height
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE9EDF8), Color(0xFFDDE3F0)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.dashboard, "Dashboard", 0),
            _buildNavItem(Icons.shopping_cart, "Orders", 1),
            _buildNavItem(Icons.settings, "Settings", 2),
            _buildNavItem(Icons.storefront, "+Merchant", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return Expanded(
      // make the whole area tappable
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior:
            HitTestBehavior
                .translucent, // ensures taps outside child are detected
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.black54),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Creates a subtle top curve
class _NavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 10); // less drop on left
    path.quadraticBezierTo(
      size.width / 2,
      -10, // smaller curve
      size.width,
      10, // right side
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
