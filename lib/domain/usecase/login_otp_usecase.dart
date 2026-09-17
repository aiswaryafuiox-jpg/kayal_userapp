import 'package:kayal_userapp/data/model/login_otp_response_model.dart';
import 'package:kayal_userapp/domain/repository/login_otp_repository.dart';

class LoginOtpUseCase {
  final LoginOtpRepository _repository;

  LoginOtpUseCase(this._repository);

  Future<LoginOtpResponseModel> call({
    required String phoneNumber,
  }) async {
    return await _repository.loginOtp(
      phoneNumber: phoneNumber,
    );
  }
}
