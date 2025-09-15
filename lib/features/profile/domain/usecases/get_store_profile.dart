import '../entities/store_entity.dart';
import '../../data/repositories/profile_repository.dart';

class GetStoreProfile {
  final ProfileRepository _repository;

  GetStoreProfile(this._repository);

  Future<StoreEntity> call() async {
    try {
      return await _repository.getStoreProfile();
    } catch (e) {
      throw Exception('UseCase: Failed to get store profile - $e');
    }
  }
}