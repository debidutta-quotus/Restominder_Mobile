import '../entities/menu_item.dart';

class MenuService {
  List<MenuItem> filterItemsByCategory(List<MenuItem> items, String category) {
    if (category == 'All Categories') {
      return items;
    }
    return items.where((item) => item.category == category).toList();
  }

  List<String> getCategories(List<MenuItem> items) {
    final Set<String> categorySet = items.map((item) => item.category).toSet();
    return ['All Categories'] + categorySet.toList();
  }
}