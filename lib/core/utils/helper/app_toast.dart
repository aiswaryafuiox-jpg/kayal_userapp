import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ToastType { success, error, warning, info }

class AppToast {
  const AppToast._();

  static void show(
    String title,
    String message, {
    ToastType? type,
    Duration duration = const Duration(milliseconds: 1800),
  }) {
    // Determine type if not specified
    final resolvedType = type ?? _inferType(title, message);

    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (resolvedType) {
      case ToastType.success:
        icon = Icons.check_circle_rounded;
        iconColor = const Color(0xFF22C55E);
        iconBg = const Color(0xFF22C55E).withValues(alpha: 0.18);
        break;
      case ToastType.error:
        icon = Icons.error_rounded;
        iconColor = const Color(0xFFEF4444);
        iconBg = const Color(0xFFEF4444).withValues(alpha: 0.18);
        break;
      case ToastType.warning:
        icon = Icons.warning_amber_rounded;
        iconColor = const Color(0xFFFF823E);
        iconBg = const Color(0xFFFF823E).withValues(alpha: 0.18);
        break;
      case ToastType.info:
        icon = Icons.info_outline_rounded;
        iconColor = const Color(0xFF38BDF8);
        iconBg = const Color(0xFF38BDF8).withValues(alpha: 0.18);
        break;
    }

    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.rawSnackbar(
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: EdgeInsets.zero,
      duration: duration,
      animationDuration: const Duration(milliseconds: 250),
      messageText: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.12),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title.trim().isNotEmpty) ...[
                    Text(
                      title.trim(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message.trim(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFCBD5E1),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void success(
    String message, {
    String title = 'Success',
    Duration duration = const Duration(milliseconds: 1800),
  }) {
    show(title, message, type: ToastType.success, duration: duration);
  }

  static void error(
    String message, {
    String title = 'Error',
    Duration duration = const Duration(milliseconds: 2000),
  }) {
    show(title, message, type: ToastType.error, duration: duration);
  }

  static void warning(
    String message, {
    String title = 'Warning',
    Duration duration = const Duration(milliseconds: 1800),
  }) {
    show(title, message, type: ToastType.warning, duration: duration);
  }

  static void info(
    String message, {
    String title = 'Info',
    Duration duration = const Duration(milliseconds: 1800),
  }) {
    show(title, message, type: ToastType.info, duration: duration);
  }

  static ToastType _inferType(String title, String message) {
    final combined = '${title.toLowerCase()} ${message.toLowerCase()}';
    if (combined.contains('error') ||
        combined.contains('denied') ||
        combined.contains('failed') ||
        combined.contains('invalid') ||
        combined.contains('wrong')) {
      return ToastType.error;
    }
    if (combined.contains('success') ||
        combined.contains('saved') ||
        combined.contains('added') ||
        combined.contains('cleared') ||
        combined.contains('updated')) {
      return ToastType.success;
    }
    if (combined.contains('unavailable') ||
        combined.contains('closed') ||
        combined.contains('warning') ||
        combined.contains('cancelled') ||
        combined.contains('cancel')) {
      return ToastType.warning;
    }
    return ToastType.info;
  }
}
