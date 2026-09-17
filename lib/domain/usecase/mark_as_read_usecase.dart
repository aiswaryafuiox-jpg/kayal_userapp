import 'package:kayal_userapp/data/model/mark_as_read_response_model.dart';
import 'package:kayal_userapp/domain/repository/mark_as_read_repository.dart';

class MarkAsReadUseCase {
  final MarkAsReadRepository _repository;

  MarkAsReadUseCase(this._repository);

  Future<MarkAsReadResponseModel> call({required dynamic notificationId}) {
    return _repository.markAsRead(notificationId: notificationId);
  }
}
