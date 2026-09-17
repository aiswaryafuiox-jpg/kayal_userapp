import 'package:kayal_userapp/data/model/verify_login_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/verify_login_otp_repository.dart';

class VerifyLoginOtpUseCase {
  final VerifyLoginOtpRepository _repository;

  VerifyLoginOtpUseCase(this._repository);

  Future<VerifyLoginOtpResponseModel> call({
    required String phoneNumber,
    required String otpCode,
  }) async {
    return await _repository.verifyLoginOtp(
      phoneNumber: phoneNumber,
      otpCode: otpCode,
    );
  }
}
