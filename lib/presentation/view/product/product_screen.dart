import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/presentation/view/product/widgets/product_card.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/restaurant_unavailable_banner.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    controller.updateArguments(Get.arguments);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: CustomAppBar(
        title: 'Product List',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: controller.viewCart,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF823E),
                    shape: BoxShape.circle,
                  ),
                  child: Obx(() {
                    final cartController = Get.find<CartController>();
                    final count = cartController.cartItems.fold<int>(
                      0,
                      (sum, item) => sum + item.quantity.value,
                    );
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset(
                          carticon,
                          width: 22,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        if (count > 0)
                          Positioned(
                            right: 7,
                            top: 5,
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Obx(
                () => controller.isRestaurantClosed.value
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: RestaurantUnavailableBanner(
                          notes: controller.closedNotes.value,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(
                  () => GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio:
                          0.75, // Adjust based on your image and content
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: controller.products[index],
                        controller: controller,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
