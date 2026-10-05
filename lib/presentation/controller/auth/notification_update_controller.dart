import 'package:get/get.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class NotificationUpdateController extends GetxController {
  final isLoading = false.obs;
  final LocalStorageService _storage = LocalStorageService();

  @override
  void onInit() {
    super.onInit();
    _saveLocationIfPassed();
  }

  Future<void> _saveLocationIfPassed() async {
    final args = Get.arguments;
    if (args is Map) {
      await _storage.init();
      final double? lat = args['latitude'] is double
          ? args['latitude']
          : double.tryParse(args['latitude']?.toString() ?? '');
      final double? lng = args['longitude'] is double
          ? args['longitude']
          : double.tryParse(args['longitude']?.toString() ?? '');
      if (lat != null && lng != null) {
        await _storage.saveLocation(
          latitude: lat,
          longitude: lng,
          address: args['address']?.toString(),
          city: args['city']?.toString(),
          state: args['state']?.toString(),
          pincode: args['pincode']?.toString(),
        );
      }
    }
  }

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
