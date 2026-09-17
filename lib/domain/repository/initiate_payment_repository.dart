import 'package:kayal_userapp/data/model/initiate_payment_response_model.dart';

abstract class InitiatePaymentRepository {
  Future<InitiatePaymentResponseModel> initiatePayment({
    required dynamic orderId,
    required dynamic amount,
  });
}
