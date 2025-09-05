import '../../data/repositories/menu_repository.dart';
import '../entities/menu_item.dart';

class CreateMenuItem {
  final MenuRepository repository;

  CreateMenuItem(this.repository);

  Future<MenuItem> call({
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
    final menuItemModel = await repository.createMenuItem(
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