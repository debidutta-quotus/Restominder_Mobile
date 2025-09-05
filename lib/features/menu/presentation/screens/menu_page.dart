// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/theme/app_colors.dart';
import '../../../../common/widgets/app_bar.dart';
import '../../domain/entities/menu_item.dart';
import '../widgets/index.dart';
import '../providers/index.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    // Fetch menu items when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().fetchMenuItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Menu Management",
        showBackButton: false,
        menuPath: '/menu',
        searchPath: '/search',
        notificationPath: '/notifications',
        profilePath: '/profile',
      ),
      body: Consumer<MenuProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.menuItems.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
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
                    provider.error!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.fetchMenuItems();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              CategoryFilter(
                categories: provider.categories,
                selectedCategory: provider.selectedCategory,
                onCategorySelected: provider.setSelectedCategory,
              ),
              const Divider(color: Colors.grey, thickness: 1, height: 0),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.refreshMenuItems,
                  child: provider.filteredItems.isEmpty
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
                          itemCount: provider.filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = provider.filteredItems[index];
                            return MenuItemCard(
                              item: item,
                              onView: () => _showMenuSheet(context, item, MenuSheetMode.view),
                              onEdit: () => _showMenuSheet(context, item, MenuSheetMode.edit),
                              onDelete: () => _showDeleteConfirmation(context, item),
                              onToggleAvailability: (value) async {
                                await provider.toggleAvailability(item.id);
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMenuSheet(context, null, MenuSheetMode.add),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showMenuSheet(BuildContext context, MenuItem? item, MenuSheetMode mode) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return AddMenuSheet(
          mode: mode,
          itemData: item,
          onSave: (menuData) async {
            final provider = context.read<MenuProvider>();
            bool success = false;

            if (mode == MenuSheetMode.add) {
              success = (await provider.createMenuItem(
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
              )) as bool;
            } else if (mode == MenuSheetMode.edit) {
              success = (await provider.updateMenuItem(
                id: item!.id,
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
              )) as bool;
            }

            if (success) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(mode == MenuSheetMode.add ? 'Item added successfully!' : 'Item updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.error ?? 'Operation failed'),
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

  void _showDeleteConfirmation(BuildContext context, MenuItem item) {
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
                final provider = context.read<MenuProvider>();
                final success = await provider.deleteMenuItem(item.id);
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
                      content: Text(provider.error ?? 'Failed to delete item'),
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
}