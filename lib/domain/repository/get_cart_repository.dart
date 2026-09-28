import 'package:kayal_userapp/data/model/get_cart_response_model.dart';

abstract class GetCartRepository {
  Future<GetCartResponseModel> getCart({dynamic sessionId});
}
