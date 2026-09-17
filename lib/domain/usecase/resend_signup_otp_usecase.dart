import 'package:kayal_userapp/data/model/resend_signup_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/resend_signup_otp_repository.dart';

class ResendSignupOtpUseCase {
  final ResendSignupOtpRepository _repository;

  ResendSignupOtpUseCase(this._repository);

  Future<ResendSignupOtpResponseModel> call({
    required String phoneNumber,
  }) async {
    return await _repository.resendSignupOtp(
      phoneNumber: phoneNumber,
    );
  }
}
