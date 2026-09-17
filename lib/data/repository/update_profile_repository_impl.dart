import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/update_profile_response_model.dart';
import 'package:kayal_userapp/domain/repository/update_profile_repository.dart';

class UpdateProfileRepositoryImpl implements UpdateProfileRepository {
  final ApiService _apiService;

  UpdateProfileRepositoryImpl(this._apiService);

  @override
  Future<UpdateProfileResponseModel> updateProfile({
    required String fullName,
    required String email,
    required String address,
    String? locationType,
    dynamic profileImageFile,
  }) async {
    try {
      final Map<String, dynamic> formMap = {
        'full_name': fullName.trim(),
        'email': email.trim(),
        'address': address.trim(),
      };

      if (locationType != null && locationType.trim().isNotEmpty) {
        formMap['location_type'] = locationType.trim();
      }

      if (profileImageFile != null) {
        if (profileImageFile is MultipartFile) {
          formMap['profile_image'] = profileImageFile;
        } else if (profileImageFile is String && profileImageFile.isNotEmpty) {
          formMap['profile_image'] = await MultipartFile.fromFile(profileImageFile);
        }
      }

      final formData = FormData.fromMap(formMap);

      final response = await _apiService.post(
        ApiRoutes.updateProfile,
        data: formData,
        useFormData: true,
      );

      return UpdateProfileResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return UpdateProfileResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to update profile');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
