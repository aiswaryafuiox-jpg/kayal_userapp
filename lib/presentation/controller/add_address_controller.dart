import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/saved_address_response_model.dart';
import 'package:kayal_userapp/data/repository/add_address_repository_impl.dart';
import 'package:kayal_userapp/data/repository/get_profile_repository_impl.dart';
import 'package:kayal_userapp/data/repository/update_address_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/add_address_usecase.dart';
import 'package:kayal_userapp/domain/usecase/get_profile_usecase.dart';
import 'package:kayal_userapp/domain/usecase/update_address_usecase.dart';
import 'package:kayal_userapp/presentation/controller/auth/signin_controller.dart';
import 'package:kayal_userapp/presentation/controller/checkout_controller.dart';
import 'package:kayal_userapp/presentation/controller/profile_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_notification.dart';

class AddAddressController extends GetxController {
  final AddAddressUseCase _addAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;
  final GetProfileUseCase _getProfileUseCase;

  AddAddressController({
    AddAddressUseCase? addAddressUseCase,
    UpdateAddressUseCase? updateAddressUseCase,
    GetProfileUseCase? getProfileUseCase,
  })  : _addAddressUseCase = addAddressUseCase ??
            (sl.isRegistered<AddAddressUseCase>()
                ? sl<AddAddressUseCase>()
                : AddAddressUseCase(
                    AddAddressRepositoryImpl(ApiService()))),
        _updateAddressUseCase = updateAddressUseCase ??
            (sl.isRegistered<UpdateAddressUseCase>()
                ? sl<UpdateAddressUseCase>()
                : UpdateAddressUseCase(
                    UpdateAddressRepositoryImpl(ApiService()))),
        _getProfileUseCase = getProfileUseCase ??
            (sl.isRegistered<GetProfileUseCase>()
                ? sl<GetProfileUseCase>()
                : GetProfileUseCase(
                    GetProfileRepositoryImpl(ApiService())));

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final locationTypeController = TextEditingController(text: 'Home');
  final selectedLocationType = 'Home'.obs;

  final isEdit = false.obs;
  final isLoading = false.obs;
  int? editIndex;
  dynamic addressId;
  SavedAddressModel? editModel;
  double? latitude;
  double? longitude;

  String normalizeLocationType(String? type) {
    if (type == null || type.trim().isEmpty) return 'Home';
    final lower = type.trim().toLowerCase();
    if (lower == 'home' || lower.contains('home')) return 'Home';
    if (lower == 'work' || lower == 'office' || lower.contains('work') || lower.contains('office')) return 'Work';
    if (lower == 'other' || lower.contains('other')) return 'Other';
    return 'Home';
  }

  void setLocationType(String type) {
    final normalized = normalizeLocationType(type);
    selectedLocationType.value = normalized;
    locationTypeController.text = normalized;
  }

  @override
  void onInit() {
    super.onInit();
    _initAddressData();
  }

  Future<void> _initAddressData() async {
    final arguments = Get.arguments;

    if (arguments is Map && arguments['isEdit'] == true) {
      isEdit.value = true;
      editIndex = arguments['index'];
      addressId = arguments['addressId'] ?? arguments['id'];

      if (arguments['savedAddressModel'] is SavedAddressModel) {
        editModel = arguments['savedAddressModel'] as SavedAddressModel;
        addressId ??= editModel!.id;
        nameController.text = editModel!.name;
        phoneController.text = editModel!.phone;
        setLocationType(editModel!.type);
        addressController.text = editModel!.address;
        landmarkController.text = editModel!.landmark ?? '';
        cityController.text = editModel!.city;
        stateController.text = editModel!.state;
        pincodeController.text = editModel!.pincode;
        latitude = editModel!.latitude;
        longitude = editModel!.longitude;
      } else {
        final addressData = arguments['address'];
        if (addressData is Map) {
          nameController.text = addressData['name']?.toString() ??
              addressData['full_name']?.toString() ??
              '';
          phoneController.text = addressData['phone']?.toString() ??
              addressData['phone_number']?.toString() ??
              '';
          setLocationType(
            addressData['type']?.toString() ??
                addressData['location_type']?.toString() ??
                'Home',
          );
          addressController.text = addressData['address']?.toString() ?? '';
          landmarkController.text = addressData['landmark']?.toString() ?? '';
          cityController.text = addressData['city']?.toString() ?? '';
          stateController.text = addressData['state']?.toString() ?? '';
          pincodeController.text = addressData['pincode']?.toString() ?? '';
          if (addressData['latitude'] != null) {
            latitude = double.tryParse(addressData['latitude'].toString());
          }
          if (addressData['longitude'] != null) {
            longitude = double.tryParse(addressData['longitude'].toString());
          }
        }
      }
    } else {
      setLocationType('Home');

      // 1. Pre-fill from navigation arguments if passed
      if (arguments is Map) {
        final argName = arguments['fullName'] ??
            arguments['name'] ??
            arguments['userName'] ??
            arguments['user_name'];
        if (argName != null && argName.toString().trim().isNotEmpty) {
          nameController.text = argName.toString().trim();
        }

        final argPhone = arguments['phoneNumber'] ??
            arguments['phone'] ??
            arguments['phone_number'] ??
            arguments['user_phone'];
        if (argPhone != null && argPhone.toString().trim().isNotEmpty) {
          phoneController.text = argPhone.toString().trim();
        }

        if (arguments['latitude'] != null) {
          latitude = double.tryParse(arguments['latitude'].toString());
        }
        if (arguments['longitude'] != null) {
          longitude = double.tryParse(arguments['longitude'].toString());
        }
      }

      // 2. Pre-fill from LocalStorageService
      final storage = LocalStorageService();
      if (nameController.text.trim().isEmpty) {
        final savedName = storage.getFullName() ??
            storage.getString('full_name') ??
            storage.getString('user_name') ??
            storage.getString('name');
        if (savedName != null && savedName.trim().isNotEmpty) {
          nameController.text = savedName.trim();
        }
      }

      if (phoneController.text.trim().isEmpty) {
        final savedPhone = storage.getPhoneNumber() ??
            storage.getString('phone_number') ??
            storage.getString('phone') ??
            storage.getString('user_phone');
        if (savedPhone != null && savedPhone.trim().isNotEmpty) {
          phoneController.text = savedPhone.trim();
        }
      }

      // 3. Pre-fill from active SignupController if registered and still in memory
      if (Get.isRegistered<SignupController>()) {
        final signupCtrl = Get.find<SignupController>();
        if (nameController.text.trim().isEmpty) {
          final full = signupCtrl.fullNameController.text.trim();
          if (full.isNotEmpty) {
            nameController.text = full;
          }
        }
        if (phoneController.text.trim().isEmpty) {
          final phone = signupCtrl.phoneController.text.trim();
          if (phone.isNotEmpty) {
            phoneController.text = phone;
          }
        }
      }

      // 4. Pre-fill from active ProfileController if registered
      if (Get.isRegistered<ProfileController>()) {
        final profileCtrl = Get.find<ProfileController>();
        if (nameController.text.trim().isEmpty &&
            profileCtrl.userName.value.isNotEmpty &&
            profileCtrl.userName.value != 'User') {
          nameController.text = profileCtrl.userName.value;
        }
        if (phoneController.text.trim().isEmpty &&
            profileCtrl.phoneNumber.value.isNotEmpty) {
          phoneController.text = profileCtrl.phoneNumber.value;
        }
      }

      // 5. If still empty, fetch user's profile from API
      final token = storage.getString('auth_token');
      if ((nameController.text.trim().isEmpty ||
              phoneController.text.trim().isEmpty) &&
          token != null &&
          token.isNotEmpty &&
          !token.startsWith('pms_token_')) {
        try {
          final profileRes = await _getProfileUseCase();
          if (profileRes.success && profileRes.data != null) {
            final data = profileRes.data!;
            if (nameController.text.trim().isEmpty &&
                data.fullName.isNotEmpty) {
              nameController.text = data.fullName;
              await storage.saveString('full_name', data.fullName);
              await storage.saveString('user_name', data.fullName);
            }
            if (phoneController.text.trim().isEmpty &&
                data.phone.isNotEmpty) {
              phoneController.text = data.phone;
              await storage.saveString('phone_number', data.phone);
            }
          }
        } catch (e) {
          debugPrint('AddAddressController profile fetch error: $e');
        }
      }
    }
  }

  Future<void> _determineCoordinates() async {
    if (latitude != null && longitude != null && latitude != 0.0 && longitude != 0.0) {
      return;
    }

    // 1. Try Geocoding from entered address
    try {
      final queryParts = [
        addressController.text.trim(),
        cityController.text.trim(),
        stateController.text.trim(),
        pincodeController.text.trim(),
        'India'
      ].where((s) => s.isNotEmpty).toList();

      if (queryParts.isNotEmpty) {
        final locations = await locationFromAddress(queryParts.join(', '));
        if (locations.isNotEmpty) {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
          return;
        }
      }
    } catch (_) {}

    // 2. Try Geocoding from city / pincode fallback
    try {
      final cityOrPin = [
        cityController.text.trim(),
        pincodeController.text.trim(),
        'India'
      ].where((s) => s.isNotEmpty).toList();

      if (cityOrPin.isNotEmpty) {
        final locations = await locationFromAddress(cityOrPin.join(', '));
        if (locations.isNotEmpty) {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
          return;
        }
      }
    } catch (_) {}

    // 3. Try to get position from device GPS
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        Position? position = await Geolocator.getLastKnownPosition();
        position ??= await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 4),
          ),
        );
        latitude = position.latitude;
        longitude = position.longitude;
        return;
      }
    } catch (_) {}

    // 4. Fallback default coordinates
    latitude ??= 13.0827;
    longitude ??= 80.2707;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    pincodeController.dispose();
    addressController.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    locationTypeController.dispose();
    super.onClose();
  }

  Future<void> saveAddress() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    final locType = normalizeLocationType(
      selectedLocationType.value.isNotEmpty
          ? selectedLocationType.value
          : locationTypeController.text,
    );

    await _determineCoordinates();

    try {
      if (isEdit.value) {
        final targetId = addressId ?? editModel?.id;

        if (targetId != null) {
          final response = await _updateAddressUseCase(
            addressId: targetId,
            fullName: nameController.text.trim(),
            phoneNumber: phoneController.text.trim(),
            pincode: pincodeController.text.trim(),
            address: addressController.text.trim(),
            landmark: landmarkController.text.trim().isNotEmpty
                ? landmarkController.text.trim()
                : null,
            locationType: locType,
            city: cityController.text.trim().isNotEmpty
                ? cityController.text.trim()
                : null,
            state: stateController.text.trim().isNotEmpty
                ? stateController.text.trim()
                : null,
            latitude: latitude,
            longitude: longitude,
          );

          if (response.success) {
            if (editIndex != null && Get.isRegistered<CheckoutController>()) {
              final checkoutController = Get.find<CheckoutController>();
              if (editIndex! < checkoutController.addresses.length) {
                checkoutController.addresses[editIndex!] = {
                  'type': locType,
                  'address': addressController.text.trim(),
                };
              }
            }

            AppNotification.showSuccess(
              title: 'Success',
              message: response.message.isNotEmpty
                ? response.message
                : 'Address updated successfully',
            );
            _handleNavigationOnSuccess();
          } else {
            final errorMsg = response.formattedErrorMessage.isNotEmpty
                ? response.formattedErrorMessage
                : response.message;
            AppNotification.showError(
              title: 'Error',
              message: errorMsg.isNotEmpty ? errorMsg : 'Failed to update address',
            );
          }
        } else {
          // Fallback if no targetId (local/preview mode)
          if (editIndex != null && Get.isRegistered<CheckoutController>()) {
            final checkoutController = Get.find<CheckoutController>();
            if (editIndex! < checkoutController.addresses.length) {
              checkoutController.addresses[editIndex!] = {
                'type': locType,
                'address': addressController.text.trim(),
              };
            }
          }

          AppNotification.showSuccess(
            title: 'Success',
            message: 'Address updated successfully',
          );
          _handleNavigationOnSuccess();
        }
      } else {
        final response = await _addAddressUseCase(
          fullName: nameController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          pincode: pincodeController.text.trim(),
          address: addressController.text.trim(),
          landmark: landmarkController.text.trim().isNotEmpty
              ? landmarkController.text.trim()
              : null,
          locationType: locType,
          city: cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
          state: stateController.text.trim().isNotEmpty
              ? stateController.text.trim()
              : null,
          latitude: latitude,
          longitude: longitude,
        );

        if (response.success) {
          AppNotification.showSuccess(
            title: 'Success',
            message: response.message.isNotEmpty
                ? response.message
                : 'Address saved successfully',
          );
          _handleNavigationOnSuccess();
        } else {
          final errorMsg = response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : response.message;
          AppNotification.showError(
            title: 'Error',
            message: errorMsg.isNotEmpty ? errorMsg : 'Failed to save address',
          );
        }
      }
    } catch (e) {
      AppNotification.showError(
        title: 'Error',
        message: e.toString().replaceAll('Exception: ', ''),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _handleNavigationOnSuccess() {
    final arguments = Get.arguments;
    final bool canPop = (Get.context != null && Navigator.canPop(Get.context!)) ||
        (Get.key.currentState?.canPop() ?? false);

    if (canPop &&
        Get.previousRoute.isNotEmpty &&
        Get.previousRoute != AppRoutes.signin &&
        Get.previousRoute != AppRoutes.otpVerification &&
        Get.previousRoute != AppRoutes.verificationSuccess) {
      Get.back(result: true);
    } else if (arguments is Map && arguments['redirect'] != null) {
      final redirect = arguments['redirect'].toString();
      if (redirect == AppRoutes.home && arguments['tab'] != null) {
        Get.offAllNamed<void>(
          redirect,
          arguments: {'tab': arguments['tab']},
        );
      } else {
        Get.offAllNamed<void>(redirect);
      }
    } else {
      Get.offAllNamed<void>(AppRoutes.location);
    }
  }
}
