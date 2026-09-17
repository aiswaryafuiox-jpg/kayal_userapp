import 'package:kayal_userapp/data/model/delete_notification_response_model.dart';
import 'package:kayal_userapp/domain/repository/delete_notification_repository.dart';

class DeleteNotificationUseCase {
  final DeleteNotificationRepository _repository;

  DeleteNotificationUseCase(this._repository);

  Future<DeleteNotificationResponseModel> call({required dynamic notificationId}) {
    return _repository.deleteNotification(notificationId: notificationId);
  }
}
