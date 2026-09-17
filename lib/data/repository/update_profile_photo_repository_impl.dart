import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/update_profile_photo_response_model.dart';
import 'package:kayal_userapp/domain/repository/update_profile_photo_repository.dart';

class UpdateProfilePhotoRepositoryImpl implements UpdateProfilePhotoRepository {
  final ApiService _apiService;

  UpdateProfilePhotoRepositoryImpl(this._apiService);

  @override
  Future<UpdateProfilePhotoResponseModel> updateProfilePhoto({
    required dynamic imageFile,
  }) async {
    try {
      dynamic fileField;
      if (imageFile is MultipartFile) {
        fileField = imageFile;
      } else if (imageFile is String && imageFile.isNotEmpty) {
        final filename = imageFile.split(RegExp(r'[\\/]')).last;
        fileField = await MultipartFile.fromFile(
          imageFile,
          filename: filename,
        );
      } else {
        throw Exception('Invalid image file provided');
      }

      final formData = FormData.fromMap({
        'image_file': fileField,
      });

      final response = await _apiService.post(
        ApiRoutes.updateProfilePhoto,
        data: formData,
        useFormData: true,
      );

      return UpdateProfilePhotoResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return UpdateProfilePhotoResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to update profile photo');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
