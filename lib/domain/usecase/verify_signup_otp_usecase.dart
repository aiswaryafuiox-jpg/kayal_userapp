import 'package:kayal_userapp/data/model/verify_signup_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/verify_signup_otp_repository.dart';

class VerifySignupOtpUseCase {
  final VerifySignupOtpRepository _repository;

  VerifySignupOtpUseCase(this._repository);

  Future<VerifySignupOtpResponseModel> call({
    required String phoneNumber,
    required String otpCode,
  }) async {
    return await _repository.verifySignupOtp(
      phoneNumber: phoneNumber,
      otpCode: otpCode,
    );
  }
}
