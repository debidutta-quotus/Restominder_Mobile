import '../../data/repositories/menu_repository.dart';

class DeleteMenuItem {
  final MenuRepository repository;

  DeleteMenuItem(this.repository);

  Future<bool> call(String id) async {
    return await repository.deleteMenuItem(id);
  }
}