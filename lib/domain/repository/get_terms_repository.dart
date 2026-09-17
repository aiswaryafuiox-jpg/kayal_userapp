import 'package:kayal_userapp/data/model/get_terms_response_model.dart';

abstract class GetTermsRepository {
  Future<GetTermsResponseModel> getTerms();
}
