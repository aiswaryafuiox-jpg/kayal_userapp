import 'package:kayal_userapp/data/model/product_details_response_model.dart';
import 'package:kayal_userapp/domain/repository/product_details_repository.dart';

class GetProductDetailsUseCase {
  final ProductDetailsRepository _repository;

  GetProductDetailsUseCase(this._repository);

  Future<ProductDetailsResponseModel> call({
    required dynamic productId,
  }) async {
    return await _repository.getProductDetails(
      productId: productId,
    );
  }
}
