import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/profile_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_embedded_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    controller.checkLoginStatus();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final Widget content = SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100), // Padding for bottom nav
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header & Profile Card Stack
              SizedBox(
                height: 280,
                child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    // Orange Background Header
                    SizedBox(
                      height: 210,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(26),
                          bottomRight: Radius.circular(26),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            const AppEmbeddedImage(
                              asset: hometop,
                              fit: BoxFit.cover,
                              fallback: ColoredBox(color: AppColors.primary),
                            ),
                            SafeArea(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Profile',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Profile Card Overlapping
                    Positioned(
                      top: 130,
                      left: 24,
                      right: 24,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Profile Image
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Obx(
                                  () => Image.asset(
                                    controller
                                        .profileImage
                                        .value, // Should be replaced with actual user image
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const ColoredBox(
                                          color: Colors.grey,
                                          child: Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => Text(
                                      controller.userName.value,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textprimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(
                                    () => Text(
                                      controller.phoneNumber.value,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: controller.editProfile,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.primary,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Edit Profile',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            SvgPicture.asset(
                                              editicon,
                                              width: 14,
                                              height: 14,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                    AppColors.primary,
                                                    BlendMode.srcIn,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Activity',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textprimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _menuItem(
                      svgAsset: ordericon,
                      iconColor: AppColors.primary,
                      title: 'My Orders',
                      onTap: controller.openMyOrders,
                    ),
                    const SizedBox(height: 12),

                    _menuItem(
                      svgAsset: carticon,
                      iconColor: AppColors.primary,
                      title: 'Cart',
                      onTap: controller.openCart,
                    ),
                    const SizedBox(height: 12),

                    _menuItem(
                      svgAsset: savedAddressicon,
                      iconColor: AppColors.primary,
                      title: 'Saved Address',
                      onTap: controller.openSavedAddress,
                    ),
                    const SizedBox(height: 12),

                    _menuItem(
                      svgAsset: wishlistIcon,
                      iconColor: AppColors.primary,
                      title: 'Wishlist',
                      onTap: controller.openWishlist,
                    ),
                    const SizedBox(height: 12),

                    _menuItem(
                      svgAsset: feedbackicon,
                      iconColor: AppColors.primary,
                      title: 'Feedback',
                      onTap: controller.openFeedback,
                    ),
                    const SizedBox(height: 12),

                    _menuItem(
                      icon: Icons.help_outline,
                      iconColor: AppColors.primary,
                      title: 'Help & Support',
                      onTap: controller.openHelpSupport,
                    ),
                    const SizedBox(height: 12),

                    _menuItem(
                      svgAsset: privacypolicyicon,
                      iconColor: AppColors.primary,
                      title: 'Privacy & Policy',
                      onTap: controller.openPrivacyPolicy,
                    ),
                    const SizedBox(height: 12),

                    _menuItem(
                      svgAsset: termsicon,
                      iconColor: AppColors.primary,
                      title: 'Terms & Condition',
                      onTap: controller.openTermsCondition,
                    ),
                    const SizedBox(height: 12),

                    _menuItem(
                      icon: Icons.logout,
                      iconColor: AppColors.red,
                      title: 'Log out',
                      titleColor: AppColors.red,
                      onTap: controller.logOut,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        if (!controller.isLoggedIn.value) {
          return Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                child: content,
              ),
              Container(color: Colors.black.withOpacity(0.12)),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 28),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.all(16),
                      //   decoration: const BoxDecoration(
                      //     color: Color(0xFFFFF1EB),
                      //     shape: BoxShape.circle,
                      //   ),
                      //   child: const Icon(
                      //     Icons.lock_open_rounded,
                      //     size: 38,
                      //     color: AppColors.primary,
                      //   ),
                      // ),
                      // const SizedBox(height: 18),
                      // const Text(
                      //   'Unlock your Profile',
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.w700,
                      //     color: AppColors.textprimary,
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      const Text(
                        'Log in to check out your orders, view saved addresses, and manage your account details.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textprimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.toNamed(
                              AppRoutes.login,
                              arguments: {'redirect': AppRoutes.home, 'tab': 4},
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Log in / Sign up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return content;
      }),
    );
  }

  Widget _menuItem({
    String? svgAsset,
    IconData? icon,
    required Color iconColor,
    required String title,
    Color titleColor = AppColors.textprimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            if (svgAsset != null)
              SvgPicture.asset(
                svgAsset,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              )
            else if (icon != null)
              Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
