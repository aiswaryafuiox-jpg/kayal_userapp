import 'package:kayal_userapp/data/model/mark_as_read_response_model.dart';

abstract class MarkAsReadRepository {
  Future<MarkAsReadResponseModel> markAsRead({
    required dynamic notificationId,
  });
}
