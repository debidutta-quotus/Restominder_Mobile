import 'package:flutter/material.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/usecases/index.dart';
import '../../domain/services/menu_service.dart';

class MenuProvider extends ChangeNotifier {
  final FetchMenuItems fetchMenuItems;
  final CreateMenuItem createMenuItem;
  final UpdateMenuItem updateMenuItem;
  final DeleteMenuItem deleteMenuItem;
  final ToggleMenuItemAvailability toggleMenuItemAvailability;
  final MenuService menuService;

  List<MenuItem> _menuItems = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = "All Categories";

  MenuProvider({
    required this.fetchMenuItems,
    required this.createMenuItem,
    required this.updateMenuItem,
    required this.deleteMenuItem,
    required this.toggleMenuItemAvailability,
    required this.menuService,
  });

  // Getters
  List<MenuItem> get menuItems => _menuItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  List<MenuItem> get filteredItems => menuService.filterItemsByCategory(_menuItems, _selectedCategory);
  List<String> get categories => menuService.getCategories(_menuItems);

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
  Future<void> fetchAllMenuItems() async {
    _setLoading(true);
    _setError(null);

    try {
      _menuItems = await fetchMenuItems();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create new menu item
  Future<bool> createMenuItemAction({
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
      final newItem = await createMenuItem(
        name: name,
        description: description,
        price: price,
        minPrepTime: minPrepTime,
        maxPrepTime: maxPrepTime,
        maxPossibleOrders: maxPossibleOrders,
        tags: tags,
        category: category,
        dietary: dietary,
        images: images,
      );
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
  Future<bool> updateMenuItemAction({
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
    required bool available,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final updatedItem = await updateMenuItem(
        id: id,
        name: name,
        description: description,
        price: price,
        minPrepTime: minPrepTime,
        maxPrepTime: maxPrepTime,
        maxPossibleOrders: maxPossibleOrders,
        tags: tags,
        category: category,
        dietary: dietary,
        images: images,
        available: available,
      );
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
  Future<bool> removeMenuItem(String id) async {
    _setLoading(true);
    _setError(null);

    try {
      final success = await deleteMenuItem(id);
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
    _setError(null);

    final itemIndex = _menuItems.indexWhere((item) => item.id == id);
    if (itemIndex == -1) {
      _setError('Menu item not found');
      return false;
    }

    final item = _menuItems[itemIndex];
    final originalAvailability = item.available;

    try {
      // Optimistic update
      _menuItems[itemIndex] = item.copyWith(available: !originalAvailability);
      notifyListeners();

      final updatedItem = await toggleMenuItemAvailability(
        id: id,
        currentAvailability: originalAvailability,
      );

      // Update with server response
      _menuItems[itemIndex] = updatedItem;
      notifyListeners();
      return true;
    } catch (e) {
      // Revert on error
      _menuItems[itemIndex] = item.copyWith(available: originalAvailability);
      _setError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // Refresh menu items
  Future<void> refreshMenuItems() async {
    await fetchAllMenuItems();
  }
}