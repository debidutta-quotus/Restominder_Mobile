// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/app_bar.dart';
import '../../../common/theme/app_colors.dart';
import '../controller/menu_controller.dart';
import '../model/menu_item_model.dart';
import 'add_menu_sheet.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late MenuControllers _menuController;

  @override
  void initState() {
    super.initState();
    _menuController = Provider.of<MenuControllers>(context, listen: false);
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    await _menuController.fetchMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Menu Management",
        showBackButton: false,
        onMenuPressed: () {
          // Add menu button action here
        },
        onSearchPressed: () {
          // Add search action here
        },
        onNotificationPressed: () {
          // Add notification action here
        },
      ),
      body: Consumer<MenuControllers>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.menuItems.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading menu items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.error!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.clearError();
                      _loadMenuItems();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Category Filter Tabs
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                color: AppColors.background,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.categories.map((category) {
                      final isSelected = controller.selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          controller.setSelectedCategory(category);
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
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
              // List of Menu Items
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshMenuItems,
                  child: controller.filteredItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No menu items found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add your first menu item to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          itemCount: controller.filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = controller.filteredItems[index];
                            return _buildMenuItemCard(item, controller);
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMenuSheet(context, null),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItemModel item, MenuControllers controller) {
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
                child: Image.network(
                  item.primaryImage,
                  height: 45,
                  width: 45,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.restaurant,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      item.dietaryDisplayText,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: item.available,
                onChanged: (value) async {
                  await controller.toggleAvailability(item.id);
                },
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
                item.timeRange,
                AppColors.labelColor,
                AppColors.textPrimary,
              ),
              _infoText(
                "Price:",
                item.formattedPrice,
                AppColors.labelColor,
                AppColors.textPrimary,
              ),
              _infoText(
                "Tags:",
                item.tags.isNotEmpty ? item.tags.first : "No tags",
                AppColors.labelColor,
                AppColors.textPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to show the Add New Item bottom sheet
  void _showAddMenuSheet(BuildContext context, MenuItemModel? item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddMenuSheet(
          mode: item == null ? MenuSheetMode.add : MenuSheetMode.edit,
          itemData: item,
          onSave: (menuData) async {
            final controller = Provider.of<MenuControllers>(context, listen: false);
            bool success = false;

            if (item == null) {
              // Add new item
              success = await controller.createMenuItem(
                name: menuData['name'],
                description: menuData['description'],
                price: menuData['price'],
                minPrepTime: menuData['minPrepTime'],
                maxPrepTime: menuData['maxPrepTime'],
                maxPossibleOrders: menuData['maxPossibleOrders'],
                tags: menuData['tags'],
                category: menuData['category'],
                dietary: menuData['dietary'],
                images: menuData['images'],
              );
            } else {
              // Update existing item
              success = await controller.updateMenuItem(
                id: item.id,
                name: menuData['name'],
                description: menuData['description'],
                price: menuData['price'],
                minPrepTime: menuData['minPrepTime'],
                maxPrepTime: menuData['maxPrepTime'],
                maxPossibleOrders: menuData['maxPossibleOrders'],
                tags: menuData['tags'],
                category: menuData['category'],
                dietary: menuData['dietary'],
                images: menuData['images'],
                available: menuData['available'],
              );
            }

            if (success) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(item == null ? 'Item added successfully!' : 'Item updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(controller.error ?? 'Operation failed'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  // Method to show menu options (View, Edit, Delete)
  void _showMenuOptions(BuildContext context, MenuItemModel item) {
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
                item.name,
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
                  _showAddMenuSheet(context, item);
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
  void _viewMenuItem(BuildContext context, MenuItemModel item) {
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

  // Method to delete menu item
  void _deleteMenuItem(BuildContext context, MenuItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Are you sure you want to delete "${item.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                
                final controller = Provider.of<MenuControllers>(context, listen: false);
                final success = await controller.deleteMenuItem(item.id);
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.name} deleted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(controller.error ?? 'Failed to delete item'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
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