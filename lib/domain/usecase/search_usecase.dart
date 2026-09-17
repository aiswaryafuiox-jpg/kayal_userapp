import 'package:kayal_userapp/data/model/search_response_model.dart';
import 'package:kayal_userapp/domain/repository/search_repository.dart';

class SearchUseCase {
  final SearchRepository _repository;

  SearchUseCase(this._repository);

  Future<SearchResponseModel> call({
    required String query,
  }) async {
    return await _repository.search(
      query: query,
    );
  }
}
