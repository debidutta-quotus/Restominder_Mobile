// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/theme/app_colors.dart';
import '../controller/menu_controller.dart';
import '../model/menu_item_model.dart';
import 'add_menu_sheet.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with SingleTickerProviderStateMixin {
  late MenuControllers _menuController;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _menuController = Provider.of<MenuControllers>(context, listen: false);
    _loadMenuItems();
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController!.removeListener(_onTabChanged);
      _tabController!.dispose();
    }
    super.dispose();
  }

  Future<void> _loadMenuItems() async {
    await _menuController.fetchMenuItems();
    if (mounted) {
      // Initialize TabController with categories from controller (includes "All Categories")
      _tabController = TabController(
        length: _menuController.categories.length,
        vsync: this,
      );
      _tabController!.addListener(_onTabChanged);
      // Set default to "All Categories" to match controller default
      _menuController.setSelectedCategory('All Categories');
      setState(() {});
    }
  }

  void _onTabChanged() {
    if (_tabController == null || _tabController!.indexIsChanging) return;
    final selectedCategory = _menuController.categories[_tabController!.index];
    _menuController.setSelectedCategory(selectedCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<MenuControllers>(
        builder: (context, controller, child) {
          // Show loading indicator while fetching data or if _tabController is not initialized
          if (controller.isLoading || _tabController == null) {
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

          // Check if we have any menu items at all
          if (controller.menuItems.isEmpty) {
            return Center(
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
            );
          }

          return Column(
            children: [
              // Category Filter Tabs
              Container(
                color: AppColors.background,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                  tabs: controller.categories.map((category) {
                    final itemCount = category == 'All Categories'
                        ? controller.menuItems.length
                        : controller.menuItems.where((item) => item.category == category).length;
                    return Tab(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              category,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '($itemCount)',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              // List of Menu Items
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: controller.categories.map((category) {
                    // Use controller's filteredItems for "All Categories", specific filtering for others
                    final categoryItems = category == 'All Categories'
                        ? controller.menuItems
                        : controller.menuItems.where((item) => item.category == category).toList();
                    
                    return RefreshIndicator(
                      onRefresh: controller.refreshMenuItems,
                      child: categoryItems.isEmpty
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
                                    category == 'All Categories'
                                        ? 'No menu items found'
                                        : 'No items in $category',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category == 'All Categories'
                                        ? 'Add your first menu item to get started'
                                        : 'Add items to this category',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              itemCount: categoryItems.length,
                              itemBuilder: (context, index) {
                                final item = categoryItems[index];
                                return _buildMenuItemCard(item, controller);
                              },
                            ),
                    );
                  }).toList(),
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