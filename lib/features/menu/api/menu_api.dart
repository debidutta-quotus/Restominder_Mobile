import '../../../common/api_manager/api_manager.dart';
import '../model/menu_item_model.dart';

class MenuApi {
  final ApiManager _apiManager = ApiManager.pos();

  // Get all menu items
  Future<List<MenuItemModel>> getMenuItems() async {
    try {
      final response = await _apiManager.getRequest('/menu');
      
      if (response['success'] == true && response['menus'] != null) {
        final List<dynamic> menusJson = response['menus'];
        return menusJson.map((json) => MenuItemModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch menu items');
      }
    } catch (e) {
      throw Exception('Failed to fetch menu items: $e');
    }
  }

  // Create new menu item
  Future<MenuItemModel> createMenuItem(Map<String, dynamic> menuData) async {
    try {
      final response = await _apiManager.postRequest('/menu', menuData);
      
      if (response['success'] == true && response['menu'] != null) {
        return MenuItemModel.fromJson(response['menu']);
      } else {
        throw Exception(response['message'] ?? 'Failed to create menu item');
      }
    } catch (e) {
      throw Exception('Failed to create menu item: $e');
    }
  }

  // Update menu item
  Future<MenuItemModel> updateMenuItem(String id, Map<String, dynamic> menuData) async {
    try {
      final response = await _apiManager.putRequest('/menu/$id', menuData);
      
      if (response['success'] == true && response['menu'] != null) {
        return MenuItemModel.fromJson(response['menu']);
      } else {
        throw Exception(response['message'] ?? 'Failed to update menu item');
      }
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  // Delete menu item
  Future<bool> deleteMenuItem(String id) async {
    try {
      final response = await _apiManager.deleteRequest('/menu/$id');
      
      return response['success'] == true;
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }

  // Get menu item by ID
  Future<MenuItemModel> getMenuItemById(String id) async {
    try {
      final response = await _apiManager.getRequest('/menu/$id');
      
      if (response['success'] == true && response['menu'] != null) {
        return MenuItemModel.fromJson(response['menu']);
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch menu item');
      }
    } catch (e) {
      throw Exception('Failed to fetch menu item: $e');
    }
  }
}