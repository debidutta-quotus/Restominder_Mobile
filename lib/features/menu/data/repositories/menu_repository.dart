import '../api/menu_api.dart';
import '../models/menu_item_model.dart';

class MenuRepository {
  final MenuApi _menuApi;

  MenuRepository({MenuApi? menuApi}) : _menuApi = menuApi ?? MenuApi();

  // Fetch all menu items
  Future<List<MenuItemModel>> fetchMenuItems() async {
    try {
      return await _menuApi.getMenuItems();
    } catch (e) {
      throw Exception('Failed to fetch menu items: $e');
    }
  }

  // Create a new menu item
  Future<MenuItemModel> createMenuItem({
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
      return await _menuApi.createMenuItem(menuData);
    } catch (e) {
      throw Exception('Failed to create menu item: $e');
    }
  }

  // Update an existing menu item
  Future<MenuItemModel> updateMenuItem({
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
        'available': available,
      };
      return await _menuApi.updateMenuItem(id, menuData);
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  // Delete a menu item
  Future<bool> deleteMenuItem(String id) async {
    try {
      return await _menuApi.deleteMenuItem(id);
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }

  // Fetch a menu item by ID
  Future<MenuItemModel> fetchMenuItemById(String id) async {
    try {
      return await _menuApi.getMenuItemById(id);
    } catch (e) {
      throw Exception('Failed to fetch menu item: $e');
    }
  }
}