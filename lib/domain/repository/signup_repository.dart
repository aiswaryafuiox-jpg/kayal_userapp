import 'package:kayal_userapp/data/model/signup_response_model.dart';

abstract class SignupRepository {
  Future<SignupResponseModel> signup({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
  });
}
