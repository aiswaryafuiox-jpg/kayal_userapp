import 'package:kayal_userapp/data/model/submit_support_response_model.dart';
import 'package:kayal_userapp/domain/repository/submit_support_repository.dart';

class SubmitSupportUseCase {
  final SubmitSupportRepository _repository;

  SubmitSupportUseCase(this._repository);

  Future<SubmitSupportResponseModel> call({
    required String title,
    required String description,
  }) async {
    return await _repository.submitSupport(
      title: title,
      description: description,
    );
  }
}
