import '../../data/repositories/menu_repository.dart';
import '../entities/menu_item.dart';

class FetchMenuItems {
  final MenuRepository repository;

  FetchMenuItems(this.repository);

  Future<List<MenuItem>> call() async {
    final menuItemModels = await repository.fetchMenuItems();
    return menuItemModels
        .map((model) => MenuItem(
              id: model.id,
              name: model.name,
              description: model.description,
              price: model.price,
              minPrepTime: model.minPrepTime,
              maxPrepTime: model.maxPrepTime,
              maxPossibleOrders: model.maxPossibleOrders,
              available: model.available,
              images: model.images,
              tags: model.tags,
              category: model.category,
              dietary: model.dietary,
              storeId: model.storeId,
              createdAt: model.createdAt,
              updatedAt: model.updatedAt,
            ))
        .toList();
  }
}