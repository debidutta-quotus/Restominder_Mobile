// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../../widgets/app_bar.dart';
import '../constants/menu_items.dart';
import '../../../common/theme/app_colors.dart';
import 'add_menu_sheet.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _selectedCategory = "All Categories";

  @override
  Widget build(BuildContext context) {
    // Extract unique categories
    final categories =
        ["All Categories"] +
        items.map((item) => item["category"] as String).toSet().toList();

    // Filter items based on selected category
    final filteredItems =
        _selectedCategory == "All Categories"
            ? items
            : items
                .where((item) => item["category"] == _selectedCategory)
                .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Menu Management",
        showBackButton: false,
        onMenuPressed: () {
          // Add menu button action here, e.g., open drawer
        },
        onSearchPressed: () {
          // Add search action here
        },
        onNotificationPressed: () {
          // Add notification action here
        },
      ),
      body: Column(
        children: [
          // Category Filter Tabs
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            color: AppColors.background,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? Colors.blue : Colors.black87,
                              fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (isSelected)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              height: 2,
                              width: 50,
                              color: Colors.blue,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Divider Line
          const Divider(color: Colors.grey, thickness: 1, height: 0),
          // List of Menu Items with RefreshIndicator
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                item["image"]!,
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["name"]!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    item["type"]!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: true,
                              onChanged: (_) {},
                              activeColor: Colors.green,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: Colors.grey[700],
                              ),
                              onPressed: () => _showMenuOptions(context, item),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoText(
                              "Delivery Time:",
                              item["time"]!,
                              AppColors.labelColor,
                              AppColors.textPrimary,
                            ),
                            _infoText(
                              "Price:",
                              item["price"]!,
                              AppColors.labelColor,
                              AppColors.textPrimary,
                            ),
                            _infoText(
                              "Tag:",
                              item["tag"]!,
                              AppColors.labelColor,
                              AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenuSheet(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Method to show the Add New Item bottom sheet
  void _showAddMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddMenuSheet(
          mode: MenuSheetMode.add,
          onAdd: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item added successfully!')),
            );
            Navigator.pop(context);
            setState(() {}); // Refresh the list
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  // Method to show menu options (View, Edit, Delete)
  void _showMenuOptions(BuildContext context, Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item["name"]!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuOption(
                icon: Icons.visibility_outlined,
                title: 'View Details',
                onTap: () {
                  Navigator.pop(context);
                  _viewMenuItem(context, item);
                },
              ),
              _buildMenuOption(
                icon: Icons.edit_outlined,
                title: 'Edit Item',
                onTap: () {
                  Navigator.pop(context);
                  _editMenuItem(context, item);
                },
              ),
              _buildMenuOption(
                icon: Icons.delete_outline,
                title: 'Delete Item',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _deleteMenuItem(context, item);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  // Method to view menu item details
  void _viewMenuItem(BuildContext context, Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddMenuSheet(
          mode: MenuSheetMode.view,
          itemData: item,
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  // Method to edit menu item
  void _editMenuItem(BuildContext context, Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddMenuSheet(
          mode: MenuSheetMode.edit,
          itemData: item,
          onAdd: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item updated successfully!')),
            );
            Navigator.pop(context);
            setState(() {}); // Refresh the list
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  // Method to delete menu item
  void _deleteMenuItem(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete "${item["name"]}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item["name"]} deleted successfully')),
                );
                setState(() {}); // Refresh the list
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle refresh
  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  Widget _infoText(
    String label,
    String value,
    Color labelColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.labelColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
