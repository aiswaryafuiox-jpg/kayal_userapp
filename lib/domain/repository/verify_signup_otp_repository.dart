import 'package:kayal_userapp/data/model/verify_signup_otp_response_model.dart';

abstract class VerifySignupOtpRepository {
  Future<VerifySignupOtpResponseModel> verifySignupOtp({
    required String phoneNumber,
    required String otpCode,
  });
}
