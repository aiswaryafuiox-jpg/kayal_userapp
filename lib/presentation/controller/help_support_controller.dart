import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/repository/submit_support_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/submit_support_usecase.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';

class HelpSupportController extends GetxController {
  final SubmitSupportUseCase _submitSupportUseCase;

  HelpSupportController({SubmitSupportUseCase? submitSupportUseCase})
      : _submitSupportUseCase = submitSupportUseCase ??
            (sl.isRegistered<SubmitSupportUseCase>()
                ? sl<SubmitSupportUseCase>()
                : SubmitSupportUseCase(
                    SubmitSupportRepositoryImpl(ApiService()),
                  ));

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final isLoading = false.obs;

  Future<void> submitHelpSupport() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      AppNotification.showError(
        title: 'Help & Support',
        message: 'Please enter a title for your query.',
      );
      return;
    }

    if (description.isEmpty) {
      AppNotification.showError(
        title: 'Help & Support',
        message: 'Please enter a description for your query.',
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _submitSupportUseCase(
        title: title,
        description: description,
      );

      if (response.success) {
        titleController.clear();
        descriptionController.clear();

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
                        : 'Your query has been submitted. Our support team will contact you soon.',
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
          message:
              errorMsg.isNotEmpty ? errorMsg : 'Failed to submit support query',
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
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
