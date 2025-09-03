import 'package:flutter/material.dart';
import '../api/menu_api.dart';
import '../model/menu_item_model.dart';

class MenuControllers extends ChangeNotifier {
  final MenuApi _menuApi = MenuApi();
  
  List<MenuItemModel> _menuItems = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = "All Categories";

  // Getters
  List<MenuItemModel> get menuItems => _menuItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  // Get filtered items based on selected category
  List<MenuItemModel> get filteredItems {
    if (_selectedCategory == "All Categories") {
      return _menuItems;
    }
    return _menuItems.where((item) => item.category == _selectedCategory).toList();
  }

  // Get unique categories from menu items
  List<String> get categories {
    final Set<String> categorySet = _menuItems.map((item) => item.category).toSet();
    return ["All Categories"] + categorySet.toList();
  }

  // Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error state
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Set selected category
  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Fetch all menu items
  Future<void> fetchMenuItems() async {
    _setLoading(true);
    _setError(null);

    try {
      _menuItems = await _menuApi.getMenuItems();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create new menu item
  Future<bool> createMenuItem({
    required String name,
    required String description,
    required double price,
    required int minPrepTime,
    required int maxPrepTime,
    required int maxPossibleOrders,
    required List<String> tags,
    required String category,
    required String dietary,
    List<String>? images,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final menuData = {
        'name': name,
        'description': description,
        'price': price,
        'minPrepTime': minPrepTime,
        'maxPrepTime': maxPrepTime,
        'maxPossibleOrders': maxPossibleOrders,
        'tags': tags,
        'category': category,
        'dietary': dietary,
        'images': images ?? [],
        'available': true,
      };

      print("################ Creating menu item with data: $menuData");

      final newItem = await _menuApi.createMenuItem(menuData);
      
      print("################ Successfully created menu item: ${newItem.id}");
      
      _menuItems.add(newItem);
      notifyListeners();
      return true;
    } catch (e) {
      print("################ Error creating menu item: $e");
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update menu item
  Future<bool> updateMenuItem({
    required String id,
    required String name,
    required String description,
    required double price,
    required int minPrepTime,
    required int maxPrepTime,
    required int maxPossibleOrders,
    required List<String> tags,
    required String category,
    required String dietary,
    List<String>? images,
    bool? available,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final menuData = {
        'name': name,
        'description': description,
        'price': price,
        'minPrepTime': minPrepTime,
        'maxPrepTime': maxPrepTime,
        'maxPossibleOrders': maxPossibleOrders,
        'tags': tags,
        'category': category,
        'dietary': dietary,
        'images': images ?? [],
        'available': available ?? true,
      };

      print("################ Updating menu item: $id");

      final updatedItem = await _menuApi.updateMenuItem(id, menuData);

      print("################ Successfully updated menu item: $id");

      // Update the item in the local list
      final index = _menuItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _menuItems[index] = updatedItem;
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      print("################ Error updating menu item: $e");
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete menu item
  Future<bool> deleteMenuItem(String id) async {
    _setLoading(true);
    _setError(null);

    try {
      print("################ Deleting menu item: $id");
      
      final success = await _menuApi.deleteMenuItem(id);
      
      if (success) {
        _menuItems.removeWhere((item) => item.id == id);
        notifyListeners();
        print("################ Successfully deleted menu item: $id");
      }
      
      return success;
    } catch (e) {
      print("################ Error deleting menu item: $e");
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Optimized toggle menu item availability - no loading state to prevent UI rebuilds
  Future<bool> toggleAvailability(String id) async {
    // Clear any existing errors but don't set loading to prevent UI rebuilds
    _setError(null);

    final itemIndex = _menuItems.indexWhere((item) => item.id == id);
    if (itemIndex == -1) {
      _setError('Menu item not found');
      return false;
    }

    final item = _menuItems[itemIndex];
    final originalAvailability = item.available;
    
    try {
      // Optimistic update - update UI immediately using copyWith
      _menuItems[itemIndex] = item.copyWith(available: !originalAvailability);
      notifyListeners(); // Update UI immediately

      final menuData = {
        'name': item.name,
        'description': item.description,
        'price': item.price,
        'minPrepTime': item.minPrepTime,
        'maxPrepTime': item.maxPrepTime,
        'maxPossibleOrders': item.maxPossibleOrders,
        'tags': item.tags,
        'category': item.category,
        'dietary': item.dietary,
        'images': item.images,
        'available': !originalAvailability,
      };

      print("################ Toggling availability for item: $id to ${!originalAvailability}");

      final updatedItem = await _menuApi.updateMenuItem(id, menuData);

      print("################ Successfully toggled availability for item: $id");

      // Update with the actual server response
      _menuItems[itemIndex] = updatedItem;
      notifyListeners();
      
      return true;
    } catch (e) {
      print("################ Error toggling availability: $e");
      
      // Revert the optimistic update on error using copyWith
      _menuItems[itemIndex] = item.copyWith(available: originalAvailability);
      
      _setError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // Refresh menu items
  Future<void> refreshMenuItems() async {
    await fetchMenuItems();
  }
}