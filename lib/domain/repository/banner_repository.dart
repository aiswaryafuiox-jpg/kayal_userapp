import 'package:kayal_userapp/data/model/banner_response_model.dart';

abstract class BannerRepository {
  Future<BannerResponseModel> getBanners();
}
