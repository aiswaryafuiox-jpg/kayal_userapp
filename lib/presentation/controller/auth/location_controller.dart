import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:kayal_userapp/core/utils/helper/app_toast.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class LocationController extends GetxController {
  final isLoading = false.obs;

  Future<void> allowLocation() async {
    try {
      isLoading.value = true;

      // 1. Check location service
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        isLoading.value = false;

        AppToast.warning(
          'Please turn on location service',
          title: 'Location Disabled',
        );

        await Geolocator.openLocationSettings();
        return;
      }

      // 2. Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      // 3. Request permission
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // 4. Permission denied
      if (permission == LocationPermission.denied) {
        isLoading.value = false;

        AppToast.warning(
          'Please allow location permission',
          title: 'Permission Denied',
        );

        return;
      }

      // 5. Permission permanently denied
      if (permission == LocationPermission.deniedForever) {
        isLoading.value = false;

        AppToast.warning(
          'Please enable location permission from Settings',
          title: 'Permission Required',
        );

        await Geolocator.openAppSettings();
        return;
      }

      // 6. Get current location with timeout and fallback
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      isLoading.value = false;

      // If position is retrieved or fallback position
      final effectivePosition =
          position ??
          Position(
            latitude: 13.0827,
            longitude: 80.2707,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            altitudeAccuracy: 0.0,
            heading: 0.0,
            headingAccuracy: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
          );

      debugPrint('Latitude: ${effectivePosition.latitude}');
      debugPrint('Longitude: ${effectivePosition.longitude}');

      // Go to Confirm Location screen
      Get.toNamed(AppRoutes.confirmlocation, arguments: effectivePosition);
    } catch (e) {
      isLoading.value = false;
      debugPrint('LOCATION ERROR: $e');

      AppToast.error(e.toString(), title: 'Location Error');
    }
  }

  void notNow() {
    Get.offAllNamed(AppRoutes.notificationUpdate);
  }
}
