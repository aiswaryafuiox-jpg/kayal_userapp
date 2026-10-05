import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/di/service_locator.dart';
import 'package:kayal_userapp/core/service/api_service.dart';
import 'package:kayal_userapp/core/service/local_storage_service.dart';
import 'package:kayal_userapp/data/model/get_notifications_response_model.dart';
import 'package:kayal_userapp/data/repository/delete_notification_repository_impl.dart';
import 'package:kayal_userapp/data/repository/get_notifications_repository_impl.dart';
import 'package:kayal_userapp/data/repository/mark_as_read_repository_impl.dart';
import 'package:kayal_userapp/domain/usecase/delete_notification_usecase.dart';
import 'package:kayal_userapp/domain/usecase/get_notifications_usecase.dart';
import 'package:kayal_userapp/domain/usecase/mark_as_read_usecase.dart';

class NotificationController extends GetxController {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final MarkAsReadUseCase _markAsReadUseCase;

  NotificationController({
    GetNotificationsUseCase? getNotificationsUseCase,
    DeleteNotificationUseCase? deleteNotificationUseCase,
    MarkAsReadUseCase? markAsReadUseCase,
  })  : _getNotificationsUseCase = getNotificationsUseCase ??
            (sl.isRegistered<GetNotificationsUseCase>()
                ? sl<GetNotificationsUseCase>()
                : GetNotificationsUseCase(
                    GetNotificationsRepositoryImpl(ApiService()))),
        _deleteNotificationUseCase = deleteNotificationUseCase ??
            (sl.isRegistered<DeleteNotificationUseCase>()
                ? sl<DeleteNotificationUseCase>()
                : DeleteNotificationUseCase(
                    DeleteNotificationRepositoryImpl(ApiService()))),
        _markAsReadUseCase = markAsReadUseCase ??
            (sl.isRegistered<MarkAsReadUseCase>()
                ? sl<MarkAsReadUseCase>()
                : MarkAsReadUseCase(
                    MarkAsReadRepositoryImpl(ApiService())));

  final notifications = <NotificationItemModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isLoggedIn = false.obs;

  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final totalCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginAndFetch();
  }

  Future<void> checkLoginAndFetch() async {
    isLoggedIn.value = LocalStorageService().isLoggedIn();

    if (isLoggedIn.value) {
      await fetchNotifications();
    } else {
      notifications.clear();
    }
  }

  Future<void> fetchNotifications({bool isRefresh = false, int page = 1}) async {
    if (!isRefresh) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final response = await _getNotificationsUseCase(page: page);
      if (response.success) {
        if (response.data != null) {
          currentPage.value = response.data!.currentPage;
          lastPage.value = response.data!.lastPage;
          totalCount.value = response.data!.total;
        }

        if (page == 1) {
          notifications.assignAll(response.notifications);
        } else {
          notifications.addAll(response.notifications);
        }
      } else {
        errorMessage.value = response.formattedErrorMessage.isNotEmpty
            ? response.formattedErrorMessage
            : 'Failed to load notifications';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(NotificationItemModel item, int index) async {
    if (item.isRead) return;

    // Optimistically update read status
    notifications[index] = NotificationItemModel(
      id: item.id,
      title: item.title,
      description: item.description,
      time: item.time,
      type: item.type,
      imageUrl: item.imageUrl,
      isRead: true,
    );

    if (item.id.isNotEmpty) {
      try {
        await _markAsReadUseCase(notificationId: item.id);
      } catch (_) {
        // Silently ignore network failure on read status update
      }
    }
  }

  Future<void> removeNotification(int index) async {
    if (index < 0 || index >= notifications.length) return;

    final removedItem = notifications[index];
    notifications.removeAt(index);

    if (removedItem.id.isNotEmpty) {
      try {
        final response =
            await _deleteNotificationUseCase(notificationId: removedItem.id);
        if (!response.success) {
          // Restore item if server returned error
          notifications.insert(index, removedItem);
          Get.snackbar(
            'Failed',
            response.formattedErrorMessage.isNotEmpty
                ? response.formattedErrorMessage
                : 'Failed to delete notification',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        notifications.insert(index, removedItem);
        Get.snackbar(
          'Error',
          e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    }
  }
}
