import 'package:kayal_userapp/data/model/get_notifications_response_model.dart';

abstract class GetNotificationsRepository {
  Future<GetNotificationsResponseModel> getNotifications({int page = 1});
}
