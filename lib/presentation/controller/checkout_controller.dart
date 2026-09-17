import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/saved_address_response_model.dart';
import 'package:kayal_userapp/data/repository/saved_address_repository_impl.dart';
import 'package:kayal_userapp/data/repository/select_active_address_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_saved_address_usecase.dart';
import 'package:kayal_userapp/domain/usecase/select_active_address_usecase.dart';

class CheckoutController extends GetxController {
  final GetSavedAddressUseCase _getSavedAddressUseCase;
  final SelectActiveAddressUseCase _selectActiveAddressUseCase;

  CheckoutController({
    GetSavedAddressUseCase? getSavedAddressUseCase,
    SelectActiveAddressUseCase? selectActiveAddressUseCase,
  })  : _getSavedAddressUseCase = getSavedAddressUseCase ??
            (sl.isRegistered<GetSavedAddressUseCase>()
                ? sl<GetSavedAddressUseCase>()
                : GetSavedAddressUseCase(
                    SavedAddressRepositoryImpl(ApiService()))),
        _selectActiveAddressUseCase = selectActiveAddressUseCase ??
            (sl.isRegistered<SelectActiveAddressUseCase>()
                ? sl<SelectActiveAddressUseCase>()
                : SelectActiveAddressUseCase(
                    SelectActiveAddressRepositoryImpl(ApiService())));

  final selectedAddressIndex = 0.obs;
  final isLoadingAddresses = false.obs;
  final isSelectingAddress = false.obs;
  final errorMessage = ''.obs;

  /// Structured list of saved addresses from API
  final savedAddresses = <SavedAddressModel>[].obs;

  /// Display list for UI backwards-compatibility
  final addresses = <Map<String, String>>[].obs;

  SavedAddressModel? get selectedAddress {
    if (savedAddresses.isNotEmpty &&
        selectedAddressIndex.value >= 0 &&
        selectedAddressIndex.value < savedAddresses.length) {
      return savedAddresses[selectedAddressIndex.value];
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    fetchSavedAddresses();
  }

  Future<void> fetchSavedAddresses({bool showLoading = true}) async {
    if (showLoading) {
      isLoadingAddresses.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _getSavedAddressUseCase();
      if (response.success && response.data.isNotEmpty) {
        savedAddresses.assignAll(response.data);
        addresses.assignAll(
          response.data.map((item) => item.toDisplayMap()).toList(),
        );

        // Find default address index if any
        final defaultIdx = response.data.indexWhere((element) => element.isDefault);
        if (defaultIdx != -1) {
          selectedAddressIndex.value = defaultIdx;
        } else if (selectedAddressIndex.value >= response.data.length) {
          selectedAddressIndex.value = 0;
        }
      } else if (response.data.isEmpty) {
        // If API returns an empty list, keep savedAddresses empty
        savedAddresses.clear();
        addresses.clear();
      } else {
        errorMessage.value = response.formattedErrorMessage;
      }
    } catch (e) {
      debugPrint('Error fetching saved addresses: $e');
      errorMessage.value = e.toString();
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  void selectAddress(int index) {
    if (index >= 0 && index < (savedAddresses.isNotEmpty ? savedAddresses.length : addresses.length)) {
      selectedAddressIndex.value = index;

      if (index < savedAddresses.length) {
        final address = savedAddresses[index];
        if (address.id != null) {
          selectActiveAddressApi(address.id);
        }
      }
    }
  }

  Future<bool> selectActiveAddressApi(dynamic addressId) async {
    isSelectingAddress.value = true;
    try {
      final response = await _selectActiveAddressUseCase(addressId: addressId);
      if (response.success) {
        debugPrint('Active address selected successfully on server: $addressId');
        return true;
      } else {
        debugPrint('Failed to set active address on server: ${response.formattedErrorMessage}');
        return false;
      }
    } catch (e) {
      debugPrint('Error setting active address on server: $e');
      return false;
    } finally {
      isSelectingAddress.value = false;
    }
  }

  void editAddress(int index) async {
    final addressModel = index < savedAddresses.length ? savedAddresses[index] : null;
    final addressMap = index < addresses.length ? addresses[index] : null;

    final result = await Get.toNamed(
      AppRoutes.addAddress,
      arguments: {
        'index': index,
        'address': addressMap,
        'savedAddressModel': addressModel,
        'isEdit': true,
      },
    );

    if (result == true) {
      fetchSavedAddresses(showLoading: false);
    }
  }

  void addNewAddress() async {
    final result = await Get.toNamed(AppRoutes.addAddress);
    if (result == true) {
      fetchSavedAddresses(showLoading: false);
    }
  }

  void continuePayment() {
    dynamic addrId = selectedAddress?.id ??
        (savedAddresses.isNotEmpty &&
                selectedAddressIndex.value < savedAddresses.length
            ? savedAddresses[selectedAddressIndex.value].id
            : null);

    if (addrId != null) {
      if (addrId is num) {
        addrId = addrId.toInt();
      } else {
        final str = addrId.toString().trim();
        final parsed = int.tryParse(str);
        if (parsed != null) {
          addrId = parsed;
        } else {
          final match = RegExp(r'\d+').firstMatch(str);
          if (match != null) {
            addrId = int.tryParse(match.group(0)!) ?? addrId;
          }
        }
      }
    }

    Get.toNamed(
      AppRoutes.paymentMethod,
      arguments: {
        'address_id': addrId,
        'address': selectedAddress,
      },
    );
  }

  void goBack() {
    Get.back();
  }
}
