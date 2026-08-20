import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/help_support_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class HelpSupportScreen extends StatelessWidget {
  HelpSupportScreen({super.key});

  final HelpSupportController controller = Get.put(HelpSupportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: const CustomAppBar(
        title: 'Help & Support',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF252B35),
                ),
              ),
              const SizedBox(height: 8),
              
              // Title text field
              TextField(
                controller: controller.titleController,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF252B35),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB0B7C3),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFFE0D2),
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFFE0D2),
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFF823E),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF252B35),
                ),
              ),
              const SizedBox(height: 8),
              
              // Description text field
              TextField(
                controller: controller.descriptionController,
                maxLines: 6,
                minLines: 5,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF252B35),
                ),
                decoration: InputDecoration(
                  hintText: 'Enter',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB0B7C3),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFFE0D2),
                      width: 1.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFFE0D2),
                      width: 1.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFFF823E),
                      width: 1.2,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Submit Button
              CustomButton(
                text: 'Submit',
                onPressed: controller.submitHelpSupport,
                height: 54,
                backgroundColor: const Color(0xFFFF823E),
                borderRadius: 12,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
