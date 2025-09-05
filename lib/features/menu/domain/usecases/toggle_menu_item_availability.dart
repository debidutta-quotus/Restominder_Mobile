import '../../data/repositories/menu_repository.dart';
import '../entities/menu_item.dart';

class ToggleMenuItemAvailability {
  final MenuRepository repository;

  ToggleMenuItemAvailability(this.repository);

  Future<MenuItem> call({
    required String id,
    required bool currentAvailability,
  }) async {
    final menuItemModel = await repository.updateMenuItem(
      id: id,
      name: '', // Placeholder, will be overwritten by server
      description: '',
      price: 0.0,
      minPrepTime: 0,
      maxPrepTime: 0,
      maxPossibleOrders: 0,
      tags: [],
      category: '',
      dietary: '',
      images: [],
      available: !currentAvailability,
    );
    return MenuItem(
      id: menuItemModel.id,
      name: menuItemModel.name,
      description: menuItemModel.description,
      price: menuItemModel.price,
      minPrepTime: menuItemModel.minPrepTime,
      maxPrepTime: menuItemModel.maxPrepTime,
      maxPossibleOrders: menuItemModel.maxPossibleOrders,
      available: menuItemModel.available,
      images: menuItemModel.images,
      tags: menuItemModel.tags,
      category: menuItemModel.category,
      dietary: menuItemModel.dietary,
      storeId: menuItemModel.storeId,
      createdAt: menuItemModel.createdAt,
      updatedAt: menuItemModel.updatedAt,
    );
  }
}