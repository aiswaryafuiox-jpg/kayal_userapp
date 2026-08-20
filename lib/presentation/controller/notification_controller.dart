import 'package:get/get.dart';

enum NotificationType { offer, order }

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String time;
  final NotificationType type;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
  });
}

class NotificationController extends GetxController {
  final notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  void _loadNotifications() {
    notifications.assignAll([
      NotificationItem(
        id: '1',
        title: 'Special Offer',
        description: 'Get 20% off on all burgers today.',
        time: '20 mits ago',
        type: NotificationType.offer,
      ),
      NotificationItem(
        id: '2',
        title: 'Order Confirmed',
        description: 'Your order #1023 has been confirmed.',
        time: '45 mits ago',
        type: NotificationType.order,
      ),
      NotificationItem(
        id: '3',
        title: 'Special Offer',
        description: 'Get 20% off on all burgers today.',
        time: '1 hr ago',
        type: NotificationType.offer,
      ),
      NotificationItem(
        id: '4',
        title: 'Order Confirmed',
        description: 'Your order #1023 has been confirmed.',
        time: '2 hr ago',
        type: NotificationType.order,
      ),
      NotificationItem(
        id: '5',
        title: 'Special Offer',
        description: 'Get 20% off on all burgers today.',
        time: '1 day ago',
        type: NotificationType.offer,
      ),
      NotificationItem(
        id: '6',
        title: 'Order Confirmed',
        description: 'Your order #1023 has been confirmed.',
        time: '2 day ago',
        type: NotificationType.order,
      ),
    ]);
  }

  void removeNotification(int index) {
    notifications.removeAt(index);
  }
}
