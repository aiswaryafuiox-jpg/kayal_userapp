import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/get_profile_response_model.dart';
import 'package:kayal_userapp/data/repository/get_profile_repository_impl.dart';
import 'package:kayal_userapp/data/repository/update_profile_photo_repository_impl.dart';
import 'package:kayal_userapp/data/repository/update_profile_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/get_profile_usecase.dart';
import 'package:kayal_userapp/domain/usecase/update_profile_photo_usecase.dart';
import 'package:kayal_userapp/domain/usecase/update_profile_usecase.dart';
import 'package:kayal_userapp/presentation/controller/profile_controller.dart';

class EditProfileController extends GetxController {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final UpdateProfilePhotoUseCase _updateProfilePhotoUseCase;

  EditProfileController({
    GetProfileUseCase? getProfileUseCase,
    UpdateProfileUseCase? updateProfileUseCase,
    UpdateProfilePhotoUseCase? updateProfilePhotoUseCase,
  })  : _getProfileUseCase = getProfileUseCase ??
            (sl.isRegistered<GetProfileUseCase>()
                ? sl<GetProfileUseCase>()
                : GetProfileUseCase(GetProfileRepositoryImpl(ApiService()))),
        _updateProfileUseCase = updateProfileUseCase ??
            (sl.isRegistered<UpdateProfileUseCase>()
                ? sl<UpdateProfileUseCase>()
                : UpdateProfileUseCase(UpdateProfileRepositoryImpl(ApiService()))),
        _updateProfilePhotoUseCase = updateProfilePhotoUseCase ??
            (sl.isRegistered<UpdateProfilePhotoUseCase>()
                ? sl<UpdateProfilePhotoUseCase>()
                : UpdateProfilePhotoUseCase(UpdateProfilePhotoRepositoryImpl(ApiService())));

  final profileImageUrl = ''.obs;
  final profileImage = profileImg.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final isUploadingPhoto = false.obs;

  final ImagePicker _picker = ImagePicker();

  // Text Controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final locationTypeController = TextEditingController(text: 'Home');

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProfileDataModel) {
      populateData(args);
    } else if (Get.isRegistered<ProfileController>() &&
        Get.find<ProfileController>().profileData.value != null) {
      populateData(Get.find<ProfileController>().profileData.value!);
    } else {
      fetchLatestProfile();
    }
  }

  void populateData(ProfileDataModel data) {
    fullNameController.text = data.fullName;
    phoneController.text = data.phone;
    emailController.text = data.email;
    if (data.defaultAddress != null) {
      addressController.text = data.defaultAddress!.text;
      locationTypeController.text = data.defaultAddress!.locationType;
    }
    if (data.profileImage != null && data.profileImage!.isNotEmpty) {
      profileImageUrl.value = data.profileImage!;
    }
  }

  Future<void> fetchLatestProfile() async {
    isLoading.value = true;
    try {
      final response = await _getProfileUseCase();
      if (response.success && response.data != null) {
        populateData(response.data!);
      }
    } catch (_) {
      // Ignored
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    locationTypeController.dispose();
    super.onClose();
  }

  void changePhoto() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Profile Photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_camera, color: AppColors.primary),
              ),
              title: const Text(
                'Take Photo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              onTap: () {
                Get.back();
                _pickAndUploadImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library, color: AppColors.primary),
              ),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              onTap: () {
                Get.back();
                _pickAndUploadImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) return;

      isUploadingPhoto.value = true;

      Get.snackbar(
        'Uploading Photo',
        'Please wait while your profile photo is being uploaded...',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      final response = await _updateProfilePhotoUseCase(
        imageFile: pickedFile.path,
      );

      if (response.success && response.photoUrl.isNotEmpty) {
        profileImageUrl.value = response.photoUrl;

        // Update active ProfileController instance
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().profileImageUrl.value = response.photoUrl;
          Get.find<ProfileController>().fetchProfile();
        }

        Get.snackbar(
          'Photo Updated',
          response.message.isNotEmpty
              ? response.message
              : 'Profile photo updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Upload Failed',
          response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : 'Failed to upload profile photo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
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
      isUploadingPhoto.value = false;
    }
  }

  Future<void> saveProfile() async {
    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final address = addressController.text.trim();
    final locationType = locationTypeController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your full name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (email.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isSaving.value = true;

    try {
      final response = await _updateProfileUseCase(
        fullName: name,
        email: email,
        address: address,
        locationType: locationType.isNotEmpty ? locationType : null,
      );

      if (response.success) {
        // Refresh active profile controller
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchProfile();
        }

        Get.back();

        Get.snackbar(
          'Success',
          response.message.isNotEmpty
              ? response.message
              : 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Update Failed',
          response.formattedErrorMessage.isNotEmpty
              ? response.formattedErrorMessage
              : 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
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
      isSaving.value = false;
    }
  }
}
