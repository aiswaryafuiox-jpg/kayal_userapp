import 'package:kayal_userapp/data/model/get_privacy_policy_response_model.dart';

abstract class GetPrivacyPolicyRepository {
  Future<GetPrivacyPolicyResponseModel> getPrivacyPolicy();
}
