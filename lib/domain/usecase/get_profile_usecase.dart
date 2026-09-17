import 'package:kayal_userapp/data/model/get_profile_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_profile_repository.dart';

class GetProfileUseCase {
  final GetProfileRepository _repository;

  GetProfileUseCase(this._repository);

  Future<GetProfileResponseModel> call() {
    return _repository.getProfile();
  }
}
