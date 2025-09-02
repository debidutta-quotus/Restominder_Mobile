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

      final newItem = await _menuApi.createMenuItem(menuData);
      _menuItems.add(newItem);
      notifyListeners();
      return true;
    } catch (e) {
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

      final updatedItem = await _menuApi.updateMenuItem(id, menuData);
      
      // Update the item in the local list
      final index = _menuItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _menuItems[index] = updatedItem;
        notifyListeners();
      }
      
      return true;
    } catch (e) {
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
      final success = await _menuApi.deleteMenuItem(id);
      
      if (success) {
        _menuItems.removeWhere((item) => item.id == id);
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Toggle menu item availability
  Future<bool> toggleAvailability(String id) async {
    final item = _menuItems.firstWhere((item) => item.id == id);
    
    return await updateMenuItem(
      id: id,
      name: item.name,
      description: item.description,
      price: item.price,
      minPrepTime: item.minPrepTime,
      maxPrepTime: item.maxPrepTime,
      maxPossibleOrders: item.maxPossibleOrders,
      tags: item.tags,
      category: item.category,
      dietary: item.dietary,
      images: item.images,
      available: !item.available,
    );
  }

  // Refresh menu items
  Future<void> refreshMenuItems() async {
    await fetchMenuItems();
  }
}