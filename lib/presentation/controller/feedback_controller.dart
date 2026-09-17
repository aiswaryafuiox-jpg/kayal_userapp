import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/repository/store_user_feedback_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/store_user_feedback_usecase.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';

class FeedbackController extends GetxController {
  final StoreUserFeedbackUseCase _storeUserFeedbackUseCase;

  FeedbackController({StoreUserFeedbackUseCase? storeUserFeedbackUseCase})
      : _storeUserFeedbackUseCase = storeUserFeedbackUseCase ??
            (sl.isRegistered<StoreUserFeedbackUseCase>()
                ? sl<StoreUserFeedbackUseCase>()
                : StoreUserFeedbackUseCase(
                    StoreUserFeedbackRepositoryImpl(ApiService()),
                  ));

  final rating = 5.obs;
  final feedbackTextController = TextEditingController();
  final selectedCategoryIndex = 0.obs;
  final isLoading = false.obs;

  final categories = [
    'Food Quality',
    'Delivery Service',
    'App Experience',
    'Customer Support',
    'Other',
  ];

  void setRating(int value) {
    rating.value = value;
  }

  void selectCategory(int index) {
    selectedCategoryIndex.value = index;
  }

  Future<void> submitFeedback() async {
    final message = feedbackTextController.text.trim();
    if (message.isEmpty) {
      AppNotification.showError(
        title: 'Feedback Required',
        message: 'Please enter your comments before submitting.',
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _storeUserFeedbackUseCase(
        message: message,
      );

      if (response.success) {
        feedbackTextController.clear();

        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF2E7D32),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Thank You!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    response.message.isNotEmpty
                        ? response.message
                        : 'Your feedback helps us improve our service.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // close dialog
                        Get.back(); // return to previous screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF823E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        final errorMsg = response.formattedErrorMessage.isNotEmpty
            ? response.formattedErrorMessage
            : response.message;
        AppNotification.showError(
          title: 'Submission Failed',
          message: errorMsg.isNotEmpty ? errorMsg : 'Failed to submit feedback.',
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

  @override
  void onClose() {
    feedbackTextController.dispose();
    super.onClose();
  }
}
