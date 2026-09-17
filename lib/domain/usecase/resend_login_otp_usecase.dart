import 'package:kayal_userapp/data/model/resend_login_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/resend_login_otp_repository.dart';

class ResendLoginOtpUseCase {
  final ResendLoginOtpRepository _repository;

  ResendLoginOtpUseCase(this._repository);

  Future<ResendLoginOtpResponseModel> call({
    required String phoneNumber,
  }) async {
    return await _repository.resendLoginOtp(
      phoneNumber: phoneNumber,
    );
  }
}
