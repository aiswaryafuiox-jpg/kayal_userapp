import 'package:flutter/material.dart';
import 'package:flutter_ionicons/flutter_ionicons.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/view/cart/widgets/animated_cart_item_card.dart';
import 'package:kayal_userapp/presentation/view/home/widgets/home_header.dart';
import 'package:kayal_userapp/presentation/widgets/app_embedded_image.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController controller = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final homecontroller = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      // appBar: const CustomAppBar(title: 'Cart', showBackButton: true,),
      appBar: AppBar(
        leadingWidth: 50,
        toolbarHeight: 70,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deliver to',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF1F2937),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: homecontroller.isLocationEnabled.value
                          ? null
                          : homecontroller.showEnableLocationDialog,
                      child: Row(
                        children: [
                          Icon(
                            homecontroller.isLocationEnabled.value
                                ? Ionicons.location_sharp
                                : Ionicons.location_outline,
                            size: 16,
                            color: const Color(0xFF1F2937),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: homecontroller.isLocationEnabled.value
                                ? Text(
                                    homecontroller.userLocation.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : const LocationNewsTicker(
                                    text:
                                        'Please enable location  •  Tap here to enable location',
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(12),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 22,
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Color(0xff3A4A7A),
              ),
            ),
          ),
        ),
        flexibleSpace: AppEmbeddedImage(
          asset: hometopbg,
          width: double.infinity,
          height: 210,
          fit: BoxFit.cover,
          backgroundColor: AppColors.splashBackground.withValues(alpha: .6),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoadingCart.value && controller.cartItems.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF823E)),
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: controller.cartItems.isEmpty
                ? KeyedSubtree(
                    key: const ValueKey('empty_cart_view'),
                    child: _buildEmptyCart(context),
                  )
                : KeyedSubtree(
                    key: const ValueKey('cart_content_view'),
                    child: RefreshIndicator(
                      color: const Color(0xFFFF823E),
                      onRefresh: () => controller.fetchCart(),
                      child: Column(
                        children: [
                          // Cart items list with smooth removal animation
                          Expanded(
                            child: ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                16,
                                24,
                                16,
                              ),
                              itemCount: controller.cartItems.length,
                              itemBuilder: (context, index) {
                                final item = controller.cartItems[index];
                                return AnimatedCartItemCard(
                                  key: ValueKey('cart_item_${item.id}'),
                                  item: item,
                                  onIncrement: () {
                                    final idx =
                                        (index < controller.cartItems.length &&
                                            controller.cartItems[index].id ==
                                                item.id)
                                        ? index
                                        : controller.cartItems.indexWhere(
                                            (i) =>
                                                (item.cartItemId != null &&
                                                    i.cartItemId ==
                                                        item.cartItemId) ||
                                                (item.productId != null &&
                                                    i.productId ==
                                                        item.productId) ||
                                                i.id == item.id,
                                          );
                                    if (idx != -1) {
                                      controller.incrementQuantity(idx);
                                    }
                                  },
                                  onDecrement: () {
                                    final idx =
                                        (index < controller.cartItems.length &&
                                            controller.cartItems[index].id ==
                                                item.id)
                                        ? index
                                        : controller.cartItems.indexWhere(
                                            (i) =>
                                                (item.cartItemId != null &&
                                                    i.cartItemId ==
                                                        item.cartItemId) ||
                                                (item.productId != null &&
                                                    i.productId ==
                                                        item.productId) ||
                                                i.id == item.id,
                                          );
                                    if (idx != -1) {
                                      controller.decrementQuantity(idx);
                                    }
                                  },
                                  onRemove: () async {
                                    final productIdToRemove =
                                        (item.productId != null &&
                                            item.productId! > 0)
                                        ? item.productId.toString()
                                        : (item.cartItemId != null &&
                                              item.cartItemId!.isNotEmpty)
                                        ? item.cartItemId!
                                        : item.id;
                                    await controller.removeItemById(
                                      productIdToRemove,
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          // Bottom Section (Total Amount + Checkout Button)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Total Amount Card
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(0xFFFFDCC9),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Total Amount',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF252B35),
                                        ),
                                      ),
                                      Obx(
                                        () => AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          transitionBuilder:
                                              (child, animation) =>
                                                  FadeTransition(
                                                    opacity: animation,
                                                    child: child,
                                                  ),
                                          child: Text(
                                            '₹${controller.totalAmount.toStringAsFixed(2)}',
                                            key: ValueKey(
                                              'total_${controller.totalAmount.toInt()}',
                                            ),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFFFF823E),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Proceed to Checkout Button
                                CustomButton(
                                  text: 'Procced to checkout',
                                  onPressed: controller.proceedToCheckout,
                                  height: 54,
                                  backgroundColor: const Color(0xFFFF823E),
                                  borderRadius: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        }),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFFFF823E),
      onRefresh: () => controller.fetchCart(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    const EmptyCartBasketWidget(size: 160),
                    const SizedBox(height: 32),
                    const Text(
                      'Your Cart Is Empty !',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your perfect look starts here',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF80142C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Get.back();
                          } else {
                            Get.offAllNamed(AppRoutes.home);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF823E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Continue Ordering',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EmptyCartBasketWidget extends StatelessWidget {
  final double size;

  const EmptyCartBasketWidget({super.key, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFFFDECC),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SizedBox(
          width: 86,
          height: 78,
          child: CustomPaint(painter: _BasketPainter()),
        ),
      ),
    );
  }
}

class _BasketPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final handlePaint = Paint()
      ..color = const Color(0xFF232B38)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Handles
    canvas.drawLine(const Offset(22, 18), const Offset(32, 0), handlePaint);
    canvas.drawLine(const Offset(64, 18), const Offset(54, 0), handlePaint);

    // Basket Rim
    final rimRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(3, 18, 80, 13),
      const Radius.circular(3),
    );
    final rimPaint = Paint()
      ..color = const Color(0xFFFFB300)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rimRect, rimPaint);

    // Basket Body (Trapezoid with rounded bottom)
    final bodyPath = Path()
      ..moveTo(9, 31)
      ..lineTo(77, 31)
      ..lineTo(68, 72)
      ..quadraticBezierTo(68, 76, 64, 76)
      ..lineTo(22, 76)
      ..quadraticBezierTo(18, 76, 18, 72)
      ..close();

    final bodyPaint = Paint()
      ..color = const Color(0xFFFF7A00)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bodyPath, bodyPaint);

    // 3 White Vertical Slats
    final slatPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (final x in [32.0, 43.0, 54.0]) {
      final slatRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - 2.5, 41, 5, 23),
        const Radius.circular(3),
      );
      canvas.drawRRect(slatRRect, slatPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
