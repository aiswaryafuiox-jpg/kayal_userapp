import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/get_profile_response_model.dart';
import 'package:kayal_userapp/data/repository/get_profile_repository_impl.dart';
import 'package:kayal_userapp/data/repository/logout_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_profile_usecase.dart';
import 'package:kayal_userapp/domain/usecase/logout_usecase.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/notification_controller.dart';
import 'package:kayal_userapp/presentation/controller/orders_controller.dart';
import 'package:kayal_userapp/presentation/controller/wishlist_controller.dart';
import 'package:kayal_userapp/presentation/view/profile/edit_profile_screen.dart';
import 'package:kayal_userapp/presentation/view/profile/privacy_policy_screen.dart';
import 'package:kayal_userapp/presentation/view/profile/terms_condition_screen.dart';

class ProfileController extends GetxController {
  final GetProfileUseCase _getProfileUseCase;
  final LogoutUseCase _logoutUseCase;

  ProfileController({
    GetProfileUseCase? getProfileUseCase,
    LogoutUseCase? logoutUseCase,
  })  : _getProfileUseCase = getProfileUseCase ??
            (sl.isRegistered<GetProfileUseCase>()
                ? sl<GetProfileUseCase>()
                : GetProfileUseCase(GetProfileRepositoryImpl(ApiService()))),
        _logoutUseCase = logoutUseCase ??
            (sl.isRegistered<LogoutUseCase>()
                ? sl<LogoutUseCase>()
                : LogoutUseCase(LogoutRepositoryImpl(ApiService())));

  final profileData = Rxn<ProfileDataModel>();
  final userName = 'User'.obs;
  final phoneNumber = ''.obs;
  final email = ''.obs;
  final profileImageUrl = ''.obs;
  final profileImage = profileImg.obs;

  final isLoggedIn = false.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final loggedIn = LocalStorageService().isLoggedIn();
    isLoggedIn.value = loggedIn;

    if (loggedIn) {
      await fetchProfile();
    } else {
      userName.value = 'User';
      phoneNumber.value = '';
      email.value = '';
      profileImageUrl.value = '';
      profileData.value = null;
    }
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _getProfileUseCase();
      if (response.success && response.data != null) {
        final data = response.data!;
        profileData.value = data;

        if (data.fullName.isNotEmpty) {
          userName.value = data.fullName.capitalizeWords();
        }
        if (data.phone.isNotEmpty) {
          phoneNumber.value = data.phone;
        }
        if (data.email.isNotEmpty) {
          email.value = data.email;
        }
        if (data.profileImage != null && data.profileImage!.isNotEmpty) {
          profileImageUrl.value = data.profileImage!;
        }

        await LocalStorageService().saveUserData(
          fullName: data.fullName,
          phoneNumber: data.phone,
          email: data.email,
        );
      } else {
        errorMessage.value = response.formattedErrorMessage.isNotEmpty
            ? response.formattedErrorMessage
            : 'Failed to fetch profile details';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void editProfile() {
    Get.to(() => const EditProfileScreen(), arguments: profileData.value);
  }

  void openMyOrders() {
    Get.toNamed(AppRoutes.orders);
  }

  void openCart() {
    Get.toNamed(AppRoutes.cart);
  }

  void openSavedAddress() {
    Get.toNamed(AppRoutes.savedAddress);
  }

  void openWishlist() {
    Get.toNamed(AppRoutes.wishlist);
  }

  void openFeedback() {
    Get.toNamed(AppRoutes.feedback);
  }

  void openHelpSupport() {
    Get.toNamed(AppRoutes.helpSupport);
  }

  void openPrivacyPolicy() {
    Get.to(() => const PrivacyPolicyScreen());
  }

  void openTermsCondition() {
    Get.to(() => const TermsConditionScreen());
  }

  final isLoggingOut = false.obs;

  void logOut() {
    isLoggingOut.value = false;
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
              const Icon(
                Icons.logout,
                color: Color(0xFFF03636),
                size: 32,
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you Sure !!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Are you Confirm to Logout ?',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9CA3AF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (!isLoggingOut.value) {
                          Get.back();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFF03636)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF03636),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: isLoggingOut.value
                            ? null
                            : () async {
                                isLoggingOut.value = true;
                                try {
                                  await _logoutUseCase();
                                } catch (_) {
                                  // Continue clearing local session even if API call fails
                                } finally {
                                  await LocalStorageService().clearUserData();

                                  isLoggedIn.value = false;
                                  profileData.value = null;
                                  userName.value = 'User';
                                  phoneNumber.value = '';
                                  email.value = '';
                                  profileImageUrl.value = '';
                                  isLoggingOut.value = false;

                                  // Reset other controllers if active in memory
                                  if (Get.isRegistered<HomeController>()) {
                                    Get.find<HomeController>().loadUserInfo();
                                  }
                                  if (Get.isRegistered<CartController>()) {
                                    Get.find<CartController>().cartItems.clear();
                                    Get.find<CartController>().cartData.value = null;
                                  }
                                  if (Get.isRegistered<WishlistController>()) {
                                    Get.find<WishlistController>().wishlistItems.clear();
                                  }
                                  if (Get.isRegistered<OrdersController>()) {
                                    Get.find<OrdersController>().ordersList.clear();
                                    Get.find<OrdersController>().isLoggedIn.value = false;
                                  }
                                  if (Get.isRegistered<NotificationController>()) {
                                    Get.find<NotificationController>().notifications.clear();
                                    Get.find<NotificationController>().isLoggedIn.value = false;
                                  }

                                  if (Get.isDialogOpen ?? false) {
                                    Get.back();
                                  }
                                  Get.offAllNamed(AppRoutes.login);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF03636),
                          disabledBackgroundColor: const Color(0xFFF03636).withValues(alpha: 0.6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: isLoggingOut.value
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Yes, Sure',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
