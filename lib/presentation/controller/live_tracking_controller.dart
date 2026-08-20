import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class LiveTrackingController extends GetxController {
  final MapController mapController = MapController();

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 5), () {
      if (Get.currentRoute == AppRoutes.liveTracking) {
        Get.offNamed(AppRoutes.orderDeliveredSuccess);
      }
    });
  }

  // Coordinates
  final LatLng restaurantLocation = const LatLng(48.0772, 7.3585); // Example location
  final LatLng driverLocation = const LatLng(48.0750, 7.3550);
  
  final List<LatLng> routePoints = [
    const LatLng(48.0750, 7.3550), // Driver
    const LatLng(48.0740, 7.3560),
    const LatLng(48.0745, 7.3580),
    const LatLng(48.0755, 7.3570),
    const LatLng(48.0760, 7.3590),
    const LatLng(48.0772, 7.3585), // Restaurant
  ];

  void callDeliveryPartner() {
    Get.snackbar('Calling', 'Calling Miller at +91 9856345239...');
  }
}
