import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  final LocalStorageService _storage = LocalStorageService();

  static const int pageCount = 3;

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  Future<void> _proceedToLocation() async {
    await _storage.init();
    await _storage.setSeenOnboarding(true);
    _storage.getOrCreateSessionId();
    Get.offAllNamed<void>(AppRoutes.location);
  }

  Future<void> nextPage() async {
    if (currentPage.value >= pageCount - 1) {
      await _proceedToLocation();
      return;
    }

    await pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> previousPage() async {
    if (currentPage.value == 0) {
      return;
    }

    await pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> skipToLastPage() async {
    await _proceedToLocation();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
