import 'package:flutter/material.dart';

// Import feature pages (now without Scaffold)
import '../../features/menu/screens/menu_page.dart';
import '../../features/orders/screens/orders_page.dart';
import '../../features/profile/presentation/screens/profile_page.dart';
import '../../features/dashboard/presentation/screens/dashboard_page.dart';

// Import bottom nav and app bar
import '../../common/widgets/bottom_navigation_bar.dart'; // Assuming this includes AppBottomNavTransparent
import '../../common/widgets/app_bar.dart'; // Your CustomAppBar

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(), // Now just body content
    MenuPage(),
    OrdersPage(),
    ProfilePage(),
  ];

  // List of app bar configs for each page
  final List<PreferredSizeWidget> _appBars = [
    CustomAppBar(title: 'Dashboard', showBackButton: false, showProfile: true),
    CustomAppBar(title: 'Menu', showBackButton: false, showProfile: true),
    CustomAppBar(title: 'Orders', showBackButton: false, showProfile: true),
    CustomAppBar(title: 'Settings', showBackButton: false, showProfile: true),
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Key: Makes parent background transparent
      extendBody: true, // Key: Allows body to extend behind bottom nav
      appBar: _appBars[_selectedIndex], // Dynamic app bar per page
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavTransparent( // Use transparent version for curve reveal
        currentIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
