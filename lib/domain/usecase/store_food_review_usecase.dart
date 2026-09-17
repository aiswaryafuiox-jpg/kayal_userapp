import 'package:kayal_userapp/data/model/store_food_review_response_model.dart';
import 'package:kayal_userapp/domain/repository/store_food_review_repository.dart';

class StoreFoodReviewUseCase {
  final StoreFoodReviewRepository _repository;

  StoreFoodReviewUseCase(this._repository);

  Future<StoreFoodReviewResponseModel> call({
    required dynamic foodId,
    required String rating,
    required String review,
  }) async {
    return await _repository.storeFoodReview(
      foodId: foodId,
      rating: rating,
      review: review,
    );
  }
}
