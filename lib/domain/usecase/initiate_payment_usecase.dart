import 'package:kayal_userapp/data/model/initiate_payment_response_model.dart';
import 'package:kayal_userapp/domain/repository/initiate_payment_repository.dart';

class InitiatePaymentUseCase {
  final InitiatePaymentRepository _repository;

  InitiatePaymentUseCase(this._repository);

  Future<InitiatePaymentResponseModel> call({
    required dynamic orderId,
    required dynamic amount,
  }) async {
    return await _repository.initiatePayment(
      orderId: orderId,
      amount: amount,
    );
  }
}
