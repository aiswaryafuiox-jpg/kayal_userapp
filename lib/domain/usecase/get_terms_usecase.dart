import 'package:kayal_userapp/data/model/get_terms_response_model.dart';
import 'package:kayal_userapp/domain/repository/get_terms_repository.dart';

class GetTermsUseCase {
  final GetTermsRepository _repository;

  GetTermsUseCase(this._repository);

  Future<GetTermsResponseModel> call() {
    return _repository.getTerms();
  }
}
