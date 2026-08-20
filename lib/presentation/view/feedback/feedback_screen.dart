import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/feedback_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final FeedbackController controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: const CustomAppBar(
        title: 'Feedback',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'How was your experience?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF252B35),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Write a review...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF252B35),
                ),
              ),
              const SizedBox(height: 10),

              // Feedback Text Input Area
              Container(
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFFFE0D2),
                    width: 1.2,
                  ),
                ),
                child: TextField(
                  controller: controller.feedbackTextController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Enter..',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB0B7C3),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),
              ),

              const Spacer(),

              // Submit Button
              CustomButton(
                text: 'Submit',
                onPressed: controller.submitFeedback,
                height: 54,
                backgroundColor: const Color(0xFFFF823E),
                borderRadius: 16,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
