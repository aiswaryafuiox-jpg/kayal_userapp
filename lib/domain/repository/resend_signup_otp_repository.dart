import 'package:kayal_userapp/data/model/resend_signup_otp_response_model.dart';

abstract class ResendSignupOtpRepository {
  Future<ResendSignupOtpResponseModel> resendSignupOtp({
    required String phoneNumber,
  });
}
