import 'package:flutter/material.dart';

// Import feature pages
import '../../features/menu/screens/menu_page.dart';
import '../../features/orders/screens/orders_page.dart';
import '../../features/profile/screens/profile_page.dart';

// Import bottom nav widget
import '../../widgets/bottom_navigation_bar.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    MenuPage(),
    OrdersPage(),
    ProfilePage(),
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
