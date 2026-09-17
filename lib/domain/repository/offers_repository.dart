import 'package:kayal_userapp/data/model/offers_response_model.dart';

abstract class OffersRepository {
  Future<OffersResponseModel> getOffers();
}
