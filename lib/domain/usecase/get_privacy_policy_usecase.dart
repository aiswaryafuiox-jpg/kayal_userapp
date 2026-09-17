import 'package:kayal_userapp/data/model/get_privacy_policy_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_privacy_policy_repository.dart';

class GetPrivacyPolicyUseCase {
  final GetPrivacyPolicyRepository _repository;

  GetPrivacyPolicyUseCase(this._repository);

  Future<GetPrivacyPolicyResponseModel> call() {
    return _repository.getPrivacyPolicy();
  }
}
