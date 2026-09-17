import 'package:kayal_userapp/data/model/get_profile_response_model.dart';

abstract class GetProfileRepository {
  Future<GetProfileResponseModel> getProfile();
}
