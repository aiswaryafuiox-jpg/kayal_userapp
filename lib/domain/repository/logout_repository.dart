import 'package:kayal_userapp/data/model/logout_response_model.dart';

abstract class LogoutRepository {
  Future<LogoutResponseModel> logout();
}
