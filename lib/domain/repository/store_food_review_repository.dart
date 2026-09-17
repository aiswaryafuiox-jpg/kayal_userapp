import 'package:kayal_userapp/data/model/store_food_review_response_model.dart';

abstract class StoreFoodReviewRepository {
  Future<StoreFoodReviewResponseModel> storeFoodReview({
    required dynamic foodId,
    required String rating,
    required String review,
  });
}
