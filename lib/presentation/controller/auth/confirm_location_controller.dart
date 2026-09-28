import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';

class LocationConfirmController extends GetxController {
  final isLoading = false.obs;

  final address = ''.obs;
  final city = ''.obs;
  final state = ''.obs;
  final pincode = ''.obs;

  Position position = Position(
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

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;

    if (arguments != null && arguments is Position) {
      position = arguments;
    }
    getAddress();
  }

  Future<void> getAddress() async {
    try {
      isLoading.value = true;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        address.value = [
          place.subThoroughfare,
          place.thoroughfare,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        city.value = place.locality ?? '';

        state.value = place.administrativeArea ?? '';

        pincode.value = place.postalCode ?? '';
      }
    } catch (e) {
      debugPrint('Address error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void confirmLocation() {
    Get.offAllNamed(
      AppRoutes.notificationUpdate,
      arguments: {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address.value,
        'city': city.value,
        'state': state.value,
        'pincode': pincode.value,
      },
    );
  }

  void chooseAnotherLocation() {
    Get.back();
  }
}