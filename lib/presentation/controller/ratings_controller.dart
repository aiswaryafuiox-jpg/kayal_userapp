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
  final selectedChips = <String>{}.obs;

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
    if (rating.value == value) return;

    // Remove previously selected chips from review text
    for (final chip in selectedChips) {
      _removeChipFromText(chip);
    }
    selectedChips.clear();
    rating.value = value;
  }

  List<String> get suggestedChips {
    switch (rating.value) {
      case 5:
        return const [
          'Delicious Food 😋',
          'Hot & Fresh 🔥',
          'Super Fast Delivery ⚡',
          'Great Packaging 📦',
          'Friendly Rider 🛵',
          'Worth Every Penny 💰',
        ];
      case 4:
        return const [
          'Tasty Food 👌',
          'Good Portion Size 🍽️',
          'On-Time Delivery ⏰',
          'Neat Packaging 📦',
          'Polite Rider 😊',
          'Good Value 🥗',
        ];
      case 3:
        return const [
          'Average Taste 😐',
          'Food Was Lukewarm ♨️',
          'Portion Was Small 🥣',
          'Delivery Was Delayed ⏳',
          'Packaging Needs Work 📦',
          'Slightly Overpriced 💸',
        ];
      case 2:
        return const [
          'Cold Food ❄️',
          'Delayed Delivery 🕒',
          'Spilled / Leaking 💧',
          'Poor Taste 👎',
          'Small Portions 📉',
          'Unprofessional Rider 📵',
        ];
      case 1:
        return const [
          'Very Late Delivery ⌛',
          'Food Damaged or Spilled ⚠️',
          'Bad Taste / Stale ❌',
          'Missing Items 📦',
          'Wrong Items Delivered 🚫',
          'Poor Hygiene 🪳',
        ];
      default:
        return const [];
    }
  }

  String get suggestedChipsTitle {
    if (rating.value == 5) {
      return 'What did you love the most?';
    } else if (rating.value == 4) {
      return 'What did you like?';
    } else if (rating.value == 3) {
      return 'What could be improved?';
    } else if (rating.value > 0) {
      return 'What went wrong?';
    }
    return '';
  }

  String get ratingLabel {
    switch (rating.value) {
      case 5:
        return 'Excellent! Loved it 😍';
      case 4:
        return 'Good! Liked it 😊';
      case 3:
        return 'Average! Could be better 😐';
      case 2:
        return 'Poor! Not satisfied 😕';
      case 1:
        return 'Terrible! Very disappointed 😞';
      default:
        return 'Tap to rate your experience';
    }
  }

  void toggleChip(String chip) {
    if (selectedChips.contains(chip)) {
      selectedChips.remove(chip);
      _removeChipFromText(chip);
    } else {
      selectedChips.add(chip);
      _addChipToText(chip);
    }
  }

  void _addChipToText(String chip) {
    final current = reviewTextController.text.trim();
    if (current.isEmpty) {
      reviewTextController.text = chip;
    } else if (!current.contains(chip)) {
      reviewTextController.text = '$current, $chip';
    }
    reviewTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: reviewTextController.text.length),
    );
  }

  void _removeChipFromText(String chip) {
    String currentText = reviewTextController.text;
    currentText = currentText.replaceAll(', $chip', '');
    currentText = currentText.replaceAll('$chip, ', '');
    currentText = currentText.replaceAll(chip, '');
    currentText = currentText.replaceAll(RegExp(r',\s*,'), ',');
    currentText = currentText.trim();
    if (currentText.startsWith(',')) {
      currentText = currentText.substring(1).trim();
    }
    if (currentText.endsWith(',')) {
      currentText = currentText.substring(0, currentText.length - 1).trim();
    }
    reviewTextController.text = currentText;
    reviewTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: reviewTextController.text.length),
    );
  }

  Future<void> submitReview() async {
    if (rating.value == 0) {
      AppNotification.showError(
        title: 'Rating Required',
        message: 'Please tap to select a star rating first.',
      );
      return;
    }

    String reviewText = reviewTextController.text.trim();
    if (reviewText.isEmpty && selectedChips.isNotEmpty) {
      reviewText = selectedChips.join(', ');
      reviewTextController.text = reviewText;
    }

    if (reviewText.isEmpty) {
      AppNotification.showError(
        title: 'Review Required',
        message: 'Please select suggested tags or write a brief review.',
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
