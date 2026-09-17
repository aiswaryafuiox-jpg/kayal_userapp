import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/data/model/get_orders_response_model.dart';

class OrderCard extends StatelessWidget {
  final UserOrderItemModel order;
  final VoidCallback onViewTap;
  final VoidCallback onReorderTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.onViewTap,
    required this.onReorderTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusBgColor;
    Color statusTextColor;

    switch (order.rawStatus.toUpperCase().trim()) {
      case 'CANCELLED':
        statusBgColor = const Color(0xFFFFEBEE);
        statusTextColor = const Color(0xFFE53935);
        break;
      case 'PENDING':
        statusBgColor = const Color(0xFFFFF3E0);
        statusTextColor = const Color(0xFFE65100);
        break;
      case 'FOOD_READY':
        statusBgColor = const Color(0xFFE3F2FD);
        statusTextColor = const Color(0xFF1565C0);
        break;
      case 'OUT_FOR_DELIVERY':
      case 'OUT OF DELIVERY':
        statusBgColor = const Color(0xFFEDE7F6);
        statusTextColor = const Color(0xFF512DA8);
        break;
      case 'DELIVERED':
      default:
        statusBgColor = const Color(0xFFE8F5E9);
        statusTextColor = const Color(0xFF2E7D32);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image (Network or Asset Fallback)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 86,
              height: 86,
              child: (order.imageUrl != null &&
                      order.imageUrl!.trim().startsWith('http'))
                  ? Image.network(
                      order.imageUrl!.trim(),
                      width: 86,
                      height: 86,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          productImg1,
                          width: 86,
                          height: 86,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      productImg1,
                      width: 86,
                      height: 86,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 14),

          // Order Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title, Veg Icon and View Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              order.productName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textprimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: order.isVeg
                                    ? AppColors.green
                                    : AppColors.red,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Center(
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: order.isVeg
                                      ? AppColors.green
                                      : AppColors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onViewTap,
                      child: const Text(
                        'View',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // Type & Order ID
                Row(
                  children: [
                    Text(
                      order.type,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    if (order.orderId.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        '#${order.orderId}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),

                // Date and Time
                Text(
                  order.date,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 4),

                // Price
                Text(
                  '₹${order.totalAmount.toInt()}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),

                // Status and Action Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        order.displayStatus,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        if (order.isOutForDelivery) {
                          Get.toNamed('/liveTracking');
                        } else if (order.isTrackable) {
                          Get.toNamed('/trackOrder', arguments: {
                            'order_id': order.orderId,
                            'custom_order_id': '#${order.orderId}',
                          });
                        } else {
                          onReorderTap();
                        }
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          order.isOutForDelivery
                              ? 'Live Track'
                              : (order.isTrackable ? 'Track Order' : 'Re-Order'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
