import 'package:kayal_userapp/data/model/verify_login_otp_response_model.dart';

abstract class VerifyLoginOtpRepository {
  Future<VerifyLoginOtpResponseModel> verifyLoginOtp({
    required String phoneNumber,
    required String otpCode,
  });
}
