import 'package:kayal_userapp/data/model/get_notifications_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_notifications_repository.dart';

class GetNotificationsUseCase {
  final GetNotificationsRepository _repository;

  GetNotificationsUseCase(this._repository);

  Future<GetNotificationsResponseModel> call({int page = 1}) {
    return _repository.getNotifications(page: page);
  }
}
