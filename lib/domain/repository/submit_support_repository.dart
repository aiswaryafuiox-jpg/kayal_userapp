import 'package:kayal_userapp/data/model/submit_support_response_model.dart';

abstract class SubmitSupportRepository {
  Future<SubmitSupportResponseModel> submitSupport({
    required String title,
    required String description,
  });
}
