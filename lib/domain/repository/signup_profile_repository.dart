import 'package:kayal_userapp/data/model/signup_profile_response_model.dart';

abstract class SignupProfileRepository {
  Future<SignupProfileResponseModel> signupProfile({
    required String fullName,
    required String email,
  });
}
