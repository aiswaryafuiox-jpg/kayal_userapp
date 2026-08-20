import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/notification_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: const CustomAppBar(
        title: 'Notifications',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.notifications.isEmpty) {
            return const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = controller.notifications[index];
              return _buildNotificationCard(item, index);
            },
          );
        }),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFE5E5),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon (Tag or Bell in Golden/Orange)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  item.type == NotificationType.offer
                      ? Icons.local_offer_outlined
                      : Icons.notifications_none_outlined,
                  color: const Color(0xFFD49B25),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF252B35),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF4B5563),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),

              // Close / Dismiss Icon
              GestureDetector(
                onTap: () => controller.removeNotification(index),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8, top: 2),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Time aligned to bottom right
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              item.time,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFFD9777F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
