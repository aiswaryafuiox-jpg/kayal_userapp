import 'package:kayal_userapp/data/model/product_details_response_model.dart';

abstract class ProductDetailsRepository {
  Future<ProductDetailsResponseModel> getProductDetails({
    required dynamic productId,
  });
}
