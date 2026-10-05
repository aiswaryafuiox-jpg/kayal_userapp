import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/presentation/controller/saved_address_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class SavedAddressScreen extends StatelessWidget {
  SavedAddressScreen({super.key});

  final SavedAddressController controller = Get.put(SavedAddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Saved Address',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => controller.fetchSavedAddresses(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const Text(
                    //       'Delivery Address',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w700,
                    //         color: AppColors.grey,
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: controller.addNewAddress,
                    //       child: Container(
                    //         padding: const EdgeInsets.symmetric(
                    //           horizontal: 14,
                    //           vertical: 6,
                    //         ),
                    //         decoration: BoxDecoration(
                    //           color: AppColors.checkoutbackground,
                    //           borderRadius: BorderRadius.circular(8),
                    //         ),
                    //         child: const Row(
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Icon(
                    //               Icons.add,
                    //               size: 14,
                    //               color: AppColors.primary,
                    //             ),
                    //             SizedBox(width: 4),
                    //             Text(
                    //               'Add New',
                    //               style: TextStyle(
                    //                 fontSize: 12,
                    //                 fontWeight: FontWeight.w600,
                    //                 color: AppColors.primary,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 16),

                    // Addresses List
                    Obx(
                      () {
                        if (controller.isLoadingAddresses.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }

                        if (controller.savedAddresses.isEmpty) {
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 32,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFF0F0F0),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_off_outlined,
                                  size: 48,
                                  color: AppColors.grey.withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'No saved addresses found',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Add a delivery address to easily place your orders',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        // Track selected index
                        final _ = controller.selectedAddressIndex.value;

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.savedAddresses.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final address = controller.savedAddresses[index];
                            final isSelected =
                                controller.selectedAddressIndex.value == index;

                            return GestureDetector(
                              onTap: () => controller.selectAddress(index),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.checkoutbackground
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.checkoutbackground
                                        : const Color(0xFFF0F0F0),
                                    width: 1.5,
                                  ),
                                  boxShadow: isSelected
                                      ? []
                                      : [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.02),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                address.type.isNotEmpty
                                                    ? address.type
                                                    : 'Address',
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                              if (address.isDefault) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary
                                                        .withValues(alpha: 0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                  ),
                                                  child: const Text(
                                                    'Default',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w600,
                                                      color: AppColors.primary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          if (address.name.isNotEmpty ||
                                              address.phone.isNotEmpty) ...[
                                            const SizedBox(height: 6),
                                            Text(
                                              [
                                                if (address.name.isNotEmpty)
                                                  address.name,
                                                if (address.phone.isNotEmpty)
                                                  address.phone,
                                              ].join(' • '),
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF4B5563),
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 8),
                                          Text(
                                            address.formattedAddress.isNotEmpty
                                                ? address.formattedAddress
                                                : address.address,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.grey,
                                              height: 1.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () =>
                                              controller.editAddress(index),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 2,
                                            ),
                                            child: Text(
                                              'Edit Address',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Icon(
                                          isSelected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                          color: AppColors.primary,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    // Space for bottom button
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Bottom Action Button
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: Obx(
                () => CustomButton(
                  text: controller.isSelectionMode.value
                      ? 'Select Address'
                      : 'Add New Address',
                  onPressed: controller.onBottomButtonPressed,
                  height: 56,
                  backgroundColor: AppColors.primary,
                  borderRadius: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
