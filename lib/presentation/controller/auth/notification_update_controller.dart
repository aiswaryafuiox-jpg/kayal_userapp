import 'package:get/get.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class NotificationUpdateController extends GetxController {
  final isLoading = false.obs;
  final LocalStorageService _storage = LocalStorageService();

  Future<void> onContinue() async {
    await _storage.init();
    await _storage.setSeenOnboarding(true);
    _storage.getOrCreateSessionId();
    Get.offAllNamed(AppRoutes.home);
  }

  Future<void> onNotNow() async {
    await _storage.init();
    await _storage.setSeenOnboarding(true);
    _storage.getOrCreateSessionId();
    Get.offAllNamed(AppRoutes.home);
  }
}
