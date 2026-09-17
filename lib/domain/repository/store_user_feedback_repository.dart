import 'package:kayal_userapp/data/model/store_user_feedback_response_model.dart';

abstract class StoreUserFeedbackRepository {
  Future<StoreUserFeedbackResponseModel> storeUserFeedback({
    required String message,
  });
}
