import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/presentation/view/product/widgets/product_card.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';
import 'package:kayal_userapp/presentation/widgets/restaurant_unavailable_banner.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late final ProductController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.updateArguments(Get.arguments);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Obx(
          () => CustomAppBar(
            title: controller.title.value,
            showBackButton: true,
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
                        int count = 0;
                        if (Get.isRegistered<CartController>()) {
                          final cartController = Get.find<CartController>();
                          count = cartController.cartItems.length;
                        }
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
                                right: 6,
                                top: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$count',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFFFF823E),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        height: 1.0,
                                      ),
                                    ),
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
        ),
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
                child: RefreshIndicator(
                  color: const Color(0xFFFF823E),
                  onRefresh: controller.refreshProducts,
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.products.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFFF823E),
                        ),
                      );
                    }

                    if (controller.products.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFECE0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.fastfood_outlined,
                                    size: 36,
                                    color: Color(0xFFFF823E),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No Data',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF252B35),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'No products found',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }

                    return GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: controller.products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.70,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: controller.products[index],
                          controller: controller,
                        );
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
