import 'package:kayal_userapp/data/model/offers_response_model.dart';
import 'package:kayal_userapp/domain/repository/offers_repository.dart';

class OffersUseCase {
  final OffersRepository _repository;

  OffersUseCase(this._repository);

  Future<OffersResponseModel> call() async {
    return await _repository.getOffers();
  }
}
