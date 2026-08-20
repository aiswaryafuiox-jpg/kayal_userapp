import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/presentation/controller/track_order_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class TrackOrderScreen extends StatelessWidget {
  TrackOrderScreen({super.key});

  final TrackOrderController controller = Get.put(TrackOrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Track Order',
        showBackButton: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Progress',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Oder ID #1025',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Placed on 8 june 2026, 10:30pm',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Timeline
                  _buildTimelineNode(
                    icon: Icons.check,
                    iconBgColor: AppColors.green,
                    iconColor: Colors.white,
                    title: 'Order confrimed',
                    subtitle: 'Your Order has been recevied at ',
                    timeText: '11:00 Am',
                    timeColor: AppColors.green,
                    isLast: false,
                    lineColor: AppColors.green,
                  ),
                  _buildTimelineNode(
                    icon: Icons.check,
                    iconBgColor: AppColors.green,
                    iconColor: Colors.white,
                    title: 'Order Picked',
                    subtitle: 'The chef is packing your delicious meals at\n',
                    timeText: '12:30 Pm',
                    timeColor: AppColors.green,
                    isLast: false,
                    lineColor: AppColors.green,
                  ),
                  _buildTimelineNode(
                    icon: Icons.check,
                    iconBgColor: AppColors.green,
                    iconColor: Colors.white,
                    title: 'Order Shipped',
                    subtitle: 'Hand over to the delivery partner at ',
                    timeText: '2.30 PM',
                    timeColor: AppColors.green,
                    isLast: false,
                    lineColor: AppColors.green,
                  ),
                  _buildTimelineNode(
                    icon: Icons.near_me,
                    iconBgColor: const Color(0xFFFFC107),
                    iconColor: Colors.white,
                    title: 'Out Of Delivery',
                    subtitle: 'Our ride is 2.5 KM away from your location',
                    isLast: false,
                    lineColor: const Color(0xFF9CA3AF),
                  ),
                  _buildTimelineNode(
                    icon: Icons.location_on,
                    iconBgColor: const Color(0xFFFFE4E6),
                    iconColor: AppColors.red,
                    title: 'Delivered',
                    subtitle: 'Expected around 4.30 PM',
                    isLast: true,
                  ),
                  const SizedBox(height: 24),

                  // Contact Restaurant Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.storefront,
                                color: AppColors.green,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contact Restaurant',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Saravana Bavan',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '+91 9856345239',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: controller.callRestaurant,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDCFCE7),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.call,
                                  color: AppColors.green,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFFF3F4F6), height: 1),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Estimated Arrival',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '4:30 PM',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFC05912),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text(
                                  'Order Status',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Out for Delivery',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // // Tips Card
                  // Obx(() {
                  //   if (controller.tipAmount.value > 0) {
                  //     return Container(
                  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xFFDCFCE7),
                  //         borderRadius: BorderRadius.circular(16),
                  //       ),
                  //       child: Row(
                  //         children: [
                  //           Container(
                  //             width: 48,
                  //             height: 48,
                  //             decoration: BoxDecoration(
                  //               color: AppColors.green,
                  //               borderRadius: BorderRadius.circular(12),
                  //             ),
                  //             alignment: Alignment.center,
                  //             child: const Icon(
                  //               Icons.check,
                  //               color: Colors.white,
                  //               size: 24,
                  //             ),
                  //           ),
                  //           const SizedBox(width: 16),
                  //           Expanded(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 const Text(
                  //                   'Tip Added',
                  //                   style: TextStyle(
                  //                     fontSize: 15,
                  //                     fontWeight: FontWeight.w700,
                  //                     color: AppColors.grey,
                  //                   ),
                  //                 ),
                  //                 const SizedBox(height: 4),
                  //                 Text(
                  //                   'Thank you your tip of \$${controller.tipAmount.value} has been sent',
                  //                   style: const TextStyle(
                  //                     fontSize: 13,
                  //                     fontWeight: FontWeight.w500,
                  //                     color: Color(0xFF6B7280),
                  //                     height: 1.4,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   }
                    
                  //   return Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.checkoutbackground,
                  //       borderRadius: BorderRadius.circular(16),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         GestureDetector(
                  //           onTap: controller.addTip,
                  //           child: Container(
                  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  //             decoration: BoxDecoration(
                  //               color: Colors.white,
                  //               borderRadius: BorderRadius.circular(8),
                  //             ),
                  //             child: const Text(
                  //               'Add Tips',
                  //               style: TextStyle(
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.w700,
                  //                 color: AppColors.primary,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         const SizedBox(width: 16),
                  //         const Expanded(
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text(
                  //                 'Enjoying our service',
                  //                 style: TextStyle(
                  //                   fontSize: 14,
                  //                   fontWeight: FontWeight.w700,
                  //                   color: AppColors.grey,
                  //                 ),
                  //               ),
                  //               SizedBox(height: 4),
                  //               Text(
                  //                 'Thank you delivery partner with a tip',
                  //                 style: TextStyle(
                  //                   fontSize: 12,
                  //                   fontWeight: FontWeight.w500,
                  //                   color: Color(0xFF6B7280),
                  //                   height: 1.4,
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }),

                  // Space for bottom button
                  const SizedBox(height: 100),
                ],
              ),
            ),
            
            // Track Live Button at bottom
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: CustomButton(
                text: 'Track Live',
                onPressed: controller.trackLive,
                height: 56,
                backgroundColor: AppColors.primary,
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineNode({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? timeText,
    Color? timeColor,
    bool isLast = false,
    Color lineColor = Colors.transparent,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column (Icon + Line)
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 18,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 24, // Space to align the dotted line
                    alignment: Alignment.center,
                    child: CustomPaint(
                      size: const Size(2, double.infinity),
                      painter: DottedLinePainter(color: lineColor),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Right Column (Texts)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0), // Spacing between nodes
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF9CA3AF),
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(text: subtitle),
                        if (timeText != null)
                          TextSpan(
                            text: timeText,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: timeColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;

  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = 4.0;

    while (startY < size.height - 4) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
