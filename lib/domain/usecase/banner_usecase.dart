import 'package:kayal_userapp/data/model/banner_response_model.dart';
import 'package:kayal_userapp/domain/repository/banner_repository.dart';

class BannerUseCase {
  final BannerRepository _repository;

  BannerUseCase(this._repository);

  Future<BannerResponseModel> call() async {
    return await _repository.getBanners();
  }
}
