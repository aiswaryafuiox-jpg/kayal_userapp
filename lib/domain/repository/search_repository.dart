import 'package:kayal_userapp/data/model/search_response_model.dart';

abstract class SearchRepository {
  Future<SearchResponseModel> search({
    required String query,
  });
}
