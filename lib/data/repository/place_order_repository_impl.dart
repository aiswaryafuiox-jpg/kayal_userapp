import 'package:dio/dio.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/data/model/place_order_response_model.dart';
import 'package:kayal_userapp/domain/repository/place_order_repository.dart';

class PlaceOrderRepositoryImpl implements PlaceOrderRepository {
  final ApiService _apiService;

  PlaceOrderRepositoryImpl(this._apiService);

  @override
  Future<PlaceOrderResponseModel> placeOrder({
    required dynamic addressId,
    required String paymentMethod,
    String? specialInstructions,
    String? tipAmount,
  }) async {
    try {
      dynamic cleanAddressId = addressId;
      if (addressId != null) {
        if (addressId is num) {
          cleanAddressId = addressId.toInt();
        } else {
          final str = addressId.toString().trim();
          final parsed = int.tryParse(str);
          if (parsed != null) {
            cleanAddressId = parsed;
          } else {
            final match = RegExp(r'\d+').firstMatch(str);
            if (match != null) {
              cleanAddressId = int.tryParse(match.group(0)!) ?? str;
            }
          }
        }
      }

      final dataMap = <String, dynamic>{
        'address_id': cleanAddressId,
        'payment_method': paymentMethod,
      };

      if (specialInstructions != null && specialInstructions.isNotEmpty) {
        dataMap['special_instructions'] = specialInstructions;
      }
      if (tipAmount != null && tipAmount.isNotEmpty) {
        dataMap['tip_amount'] = tipAmount;
      }

      final response = await _apiService.post(
        ApiRoutes.placeOrder,
        useFormData: true,
        data: dataMap,
      );

      return PlaceOrderResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response?.data != null && e.response!.data is Map<String, dynamic>) {
        return PlaceOrderResponseModel.fromJson(
          e.response!.data as Map<String, dynamic>,
        );
      }
      throw Exception(e.message ?? 'Failed to place order');
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
