import 'package:kayal_userapp/data/model/login_otp_response_model.dart';

abstract class LoginOtpRepository {
  Future<LoginOtpResponseModel> loginOtp({
    required String phoneNumber,
  });
}
