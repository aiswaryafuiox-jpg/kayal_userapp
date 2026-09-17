import 'package:kayal_userapp/data/model/logout_response_model.dart';
import 'package:kayal_userapp/domain/repository/logout_repository.dart';

class LogoutUseCase {
  final LogoutRepository _repository;

  LogoutUseCase(this._repository);

  Future<LogoutResponseModel> call() async {
    return await _repository.logout();
  }
}
