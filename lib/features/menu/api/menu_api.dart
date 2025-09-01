import '../../../common/api_manager/api_manager.dart';

class MenuApi {
  final ApiManager _api = ApiManager();

  // Fetch all menu items
  Future<List<dynamic>> getMenu() async {
    final data = await _api.getRequest("/menu"); // endpoint from backend
    // Assuming backend response: { items: [...] }
    return data['items'];
  }

  // Create a new menu item
  Future<Map<String, dynamic>> createMenu(Map<String, dynamic> menuItem) async {
    final data = await _api.postRequest("/menu", menuItem);
    return data; // backend response after creation
  }
}
