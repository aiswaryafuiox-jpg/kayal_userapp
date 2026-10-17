import 'package:kayal_userapp/core/utils/helper/app_toast.dart';

class AppNotification {
  const AppNotification._();

  static void showError({required String title, required String message}) {
    AppToast.error(message, title: title);
  }

  static void showSuccess({required String title, required String message}) {
    AppToast.success(message, title: title);
  }

  static void showWarning({required String title, required String message}) {
    AppToast.warning(message, title: title);
  }

  static void showInfo({required String title, required String message}) {
    AppToast.info(message, title: title);
  }
}
