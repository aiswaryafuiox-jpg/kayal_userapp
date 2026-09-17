import 'package:kayal_userapp/data/model/resend_login_otp_response_model.dart';

abstract class ResendLoginOtpRepository {
  Future<ResendLoginOtpResponseModel> resendLoginOtp({
    required String phoneNumber,
  });
}
