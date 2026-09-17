import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/saved_address_response_model.dart';
import 'package:kayal_userapp/data/repository/add_address_repository_impl.dart';
import 'package:kayal_userapp/data/repository/update_address_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/add_address_usecase.dart';
import 'package:kayal_userapp/domain/usecase/update_address_usecase.dart';
import 'package:kayal_userapp/presentation/controller/checkout_controller.dart';

class AddAddressController extends GetxController {
  final AddAddressUseCase _addAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;

  AddAddressController({
    AddAddressUseCase? addAddressUseCase,
    UpdateAddressUseCase? updateAddressUseCase,
  })  : _addAddressUseCase = addAddressUseCase ??
            (sl.isRegistered<AddAddressUseCase>()
                ? sl<AddAddressUseCase>()
                : AddAddressUseCase(
                    AddAddressRepositoryImpl(ApiService()))),
        _updateAddressUseCase = updateAddressUseCase ??
            (sl.isRegistered<UpdateAddressUseCase>()
                ? sl<UpdateAddressUseCase>()
                : UpdateAddressUseCase(
                    UpdateAddressRepositoryImpl(ApiService())));

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressController = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final locationTypeController = TextEditingController();

  final isEdit = false.obs;
  final isLoading = false.obs;
  int? editIndex;
  dynamic addressId;
  SavedAddressModel? editModel;

  @override
  void onInit() {
    super.onInit();
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
        locationTypeController.text = editModel!.type;
        addressController.text = editModel!.address;
        landmarkController.text = editModel!.landmark ?? '';
        cityController.text = editModel!.city;
        stateController.text = editModel!.state;
        pincodeController.text = editModel!.pincode;
      } else {
        final addressData = arguments['address'];
        if (addressData is Map) {
          nameController.text = "Lunna";
          phoneController.text = "896745321";
          locationTypeController.text = addressData['type'] ?? '';
          addressController.text = addressData['address'] ?? '';
          cityController.text = "Chennai";
          stateController.text = "Tamil nadu";
          pincodeController.text = "624001";
        }
      }
    }
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
            locationType: locationTypeController.text.trim().isNotEmpty
                ? locationTypeController.text.trim()
                : 'Home',
            city: cityController.text.trim().isNotEmpty
                ? cityController.text.trim()
                : null,
            state: stateController.text.trim().isNotEmpty
                ? stateController.text.trim()
                : null,
          );

          if (response.success) {
            if (editIndex != null && Get.isRegistered<CheckoutController>()) {
              final checkoutController = Get.find<CheckoutController>();
              if (editIndex! < checkoutController.addresses.length) {
                checkoutController.addresses[editIndex!] = {
                  'type': locationTypeController.text.trim().isNotEmpty
                      ? locationTypeController.text.trim()
                      : 'Home',
                  'address': addressController.text.trim(),
                };
              }
            }

            Get.snackbar(
              'Success',
              response.message.isNotEmpty
                  ? response.message
                  : 'Address updated successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.black87,
              colorText: Colors.white,
            );
            Get.back(result: true);
          } else {
            Get.snackbar(
              'Error',
              response.formattedErrorMessage.isNotEmpty
                  ? response.formattedErrorMessage
                  : 'Failed to update address',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        } else {
          // Fallback if no targetId (local/preview mode)
          if (editIndex != null && Get.isRegistered<CheckoutController>()) {
            final checkoutController = Get.find<CheckoutController>();
            if (editIndex! < checkoutController.addresses.length) {
              checkoutController.addresses[editIndex!] = {
                'type': locationTypeController.text.trim().isNotEmpty
                    ? locationTypeController.text.trim()
                    : 'Home',
                'address': addressController.text.trim(),
              };
            }
          }

          Get.snackbar(
            'Success',
            'Address updated successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
          );
          Get.back(result: true);
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
          locationType: locationTypeController.text.trim().isNotEmpty
              ? locationTypeController.text.trim()
              : 'Home',
          city: cityController.text.trim().isNotEmpty
              ? cityController.text.trim()
              : null,
          state: stateController.text.trim().isNotEmpty
              ? stateController.text.trim()
              : null,
        );

        if (response.success) {
          Get.snackbar(
            'Success',
            response.message.isNotEmpty
                ? response.message
                : 'Address saved successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            colorText: Colors.white,
          );
          Get.back(result: true);
        } else {
          Get.snackbar(
            'Error',
            response.formattedErrorMessage.isNotEmpty
                ? response.formattedErrorMessage
                : 'Failed to save address',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
