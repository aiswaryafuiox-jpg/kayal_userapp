import 'package:kayal_userapp/data/model/delete_notification_response_model.dart';

abstract class DeleteNotificationRepository {
  Future<DeleteNotificationResponseModel> deleteNotification({
    required dynamic notificationId,
  });
}
