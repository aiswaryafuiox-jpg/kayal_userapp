import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/repository/store_food_review_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/store_food_review_usecase.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';

class RatingsController extends GetxController {
  final StoreFoodReviewUseCase _storeFoodReviewUseCase;

  RatingsController({StoreFoodReviewUseCase? storeFoodReviewUseCase})
      : _storeFoodReviewUseCase = storeFoodReviewUseCase ??
            (sl.isRegistered<StoreFoodReviewUseCase>()
                ? sl<StoreFoodReviewUseCase>()
                : StoreFoodReviewUseCase(
                    StoreFoodReviewRepositoryImpl(ApiService()),
                  ));

  final rating = 0.obs;
  final reviewTextController = TextEditingController();
  final isLoading = false.obs;

  dynamic get foodId {
    final args = Get.arguments;
    if (args is Map) {
      return args['food_id'] ?? args['foodId'] ?? args['id'] ?? args['product_id'] ?? '5';
    }
    if (args is String || args is int) {
      return args;
    }
    return '5';
  }

  void setRating(int value) {
    rating.value = value;
  }

  Future<void> submitReview() async {
    if (rating.value == 0) {
      AppNotification.showError(
        title: 'Rating Required',
        message: 'Please tap to select a star rating first.',
      );
      return;
    }

    final reviewText = reviewTextController.text.trim();
    if (reviewText.isEmpty) {
      AppNotification.showError(
        title: 'Review Required',
        message: 'Please write a brief review of your experience.',
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _storeFoodReviewUseCase(
        foodId: foodId,
        rating: rating.value.toString(),
        review: reviewText,
      );

      if (response.success) {
        AppNotification.showSuccess(
          title: 'Review Submitted',
          message: response.message.isNotEmpty
              ? response.message
              : 'Thank you for your rating of ${rating.value} stars!',
        );

        // Navigate back to Home
        Get.offAllNamed(AppRoutes.home);
      } else {
        final errorMsg = response.formattedErrorMessage.isNotEmpty
            ? response.formattedErrorMessage
            : response.message;
        AppNotification.showError(
          title: 'Submission Failed',
          message: errorMsg.isNotEmpty ? errorMsg : 'Failed to submit review.',
        );
      }
    } catch (e) {
      AppNotification.showError(
        title: 'Error',
        message: e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void skip() {
    Get.offAllNamed(AppRoutes.home);
  }

  @override
  void onClose() {
    reviewTextController.dispose();
    super.onClose();
  }
}
