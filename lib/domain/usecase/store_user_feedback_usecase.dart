import 'package:kayal_userapp/data/model/store_user_feedback_response_model.dart';
import 'package:kayal_userapp/domain/repository/store_user_feedback_repository.dart';

class StoreUserFeedbackUseCase {
  final StoreUserFeedbackRepository _repository;

  StoreUserFeedbackUseCase(this._repository);

  Future<StoreUserFeedbackResponseModel> call({
    required String message,
  }) async {
    return await _repository.storeUserFeedback(
      message: message,
    );
  }
}
