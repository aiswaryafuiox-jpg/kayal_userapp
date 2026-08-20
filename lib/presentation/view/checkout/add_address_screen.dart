import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/presentation/controller/add_address_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class AddAddressScreen extends StatelessWidget {
  AddAddressScreen({super.key});

  final AddAddressController controller = Get.put(AddAddressController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: controller.isEdit.value ? 'Edit Address' : 'Add Address',
          showBackButton: true,
        ),
        body: SafeArea(
          child: Form(
            key: controller.formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField('Full Name', controller.nameController),
                      const SizedBox(height: 16),
                      _buildInputField('Phone number', controller.phoneController, keyboardType: TextInputType.phone),
                      const SizedBox(height: 16),
                      _buildInputField('Pincode', controller.pincodeController, keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      _buildInputField('Address', controller.addressController, maxLines: 4),
                      const SizedBox(height: 16),
                      _buildInputField('Landmark (Optional)', controller.landmarkController),
                      const SizedBox(height: 16),
                      _buildInputField('City', controller.cityController),
                      const SizedBox(height: 16),
                      _buildInputField('State', controller.stateController),
                      const SizedBox(height: 16),
                      _buildInputField('Location Type', controller.locationTypeController),
                      
                      // Space for bottom button
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
                
                // Save Button at bottom
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: CustomButton(
                    text: controller.isEdit.value ? 'Update Address' : 'Save Address',
                    onPressed: controller.saveAddress,
                    height: 56,
                    backgroundColor: AppColors.primary,
                    borderRadius: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label, 
    TextEditingController textController, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: textController,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.grey,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFFCE1D4), // Soft orange border as per design
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: AppColors.red,
                width: 1,
              ),
            ),
          ),
          validator: (value) {
            if (label.contains('Optional')) return null;
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        ),
      ],
    );
  }
}
