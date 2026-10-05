import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/presentation/controller/product_detail_controller.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';

class ProductDetailScreen extends StatelessWidget {
  ProductDetailScreen({super.key});

  final ProductDetailController controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    controller.updateArguments(Get.arguments);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.product.value == null &&
            controller.productDetail.value == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFFF823E),
            ),
          );
        }

        if (controller.product.value == null &&
            controller.productDetail.value == null) {
          return SafeArea(
            child: Center(
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
                  const Text(
                    'No Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF252B35),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Product details not found',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: controller.goBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF823E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Stack(
          children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Obx(
              () {
                final img = controller.product.value?.image ??
                    controller.productDetail.value?.image ??
                    productImg2;
                final isNetwork =
                    img.startsWith('http://') || img.startsWith('https://');

                if (isNetwork) {
                  return Image.network(
                    img,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      productImg2,
                      fit: BoxFit.cover,
                    ),
                  );
                }

                return Image.asset(
                  img,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    productImg2,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

          // Header Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: controller.goBack,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF252B35),
                        size: 20,
                      ),
                    ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: controller.toggleFavorite,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          controller.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: controller.isFavorite.value
                              ? Colors.red
                              : const Color(0xFF252B35),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.52,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            (controller.product.value?.name ??
                                    controller.productDetail.value?.name ??
                                    'Product Details')
                                .capitalizeWords(),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF252B35),
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () {
                          final detail = controller.productDetail.value;
                          final prod = controller.product.value;

                          final double price = (detail != null && detail.price > 0)
                              ? detail.price
                              : (prod != null && prod.newPrice > 0
                                  ? prod.newPrice
                                  : (detail?.oldPrice ?? prod?.oldPrice ?? 0.0));

                          final double oldPrice = (detail != null && detail.oldPrice > 0)
                              ? detail.oldPrice
                              : (prod?.oldPrice ?? price);

                          final String priceStr = price % 1 == 0
                              ? price.toInt().toString()
                              : price.toStringAsFixed(2);
                          final String oldPriceStr = oldPrice % 1 == 0
                              ? oldPrice.toInt().toString()
                              : oldPrice.toStringAsFixed(2);

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (oldPrice > price && price > 0) ...[
                                Text(
                                  '₹$oldPriceStr',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF9E9E9E),
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                '₹$priceStr',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF252B35),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Veg / Non-Veg Tag
                  Obx(
                    () {
                      final isVeg = controller.product.value?.isVeg ??
                          controller.productDetail.value?.isVeg ??
                          false;
                      final type = (controller.product.value?.type ??
                              controller.productDetail.value?.type ??
                              'Non-Veg')
                          .capitalizeWords();

                      return Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isVeg ? Colors.green : Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isVeg ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            type,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Offer Badge
                  Obx(
                    () {
                      final offer = controller.offerPercentage.value.isNotEmpty
                          ? controller.offerPercentage.value
                          : (controller.productDetail.value?.offerPercentage ?? '');

                      if (offer.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Text(
                              'Offer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4B5563),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                offer,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF252B35),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: RefreshIndicator(
                      color: const Color(0xFFFF823E),
                      onRefresh: controller.refreshDetails,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        child: Obx(
                          () {
                            final desc = controller.description.value.isNotEmpty
                                ? controller.description.value
                                : (controller.productDetail.value?.description ??
                                    "Our Chicken Burger is made with a crispy, golden-fried chicken fillet served in a soft toasted bun. Layered with fresh lettuce, juicy tomatoes, creamy mayonnaise, and melted cheese, every bite is packed with rich flavor. It's the perfect choice for a delicious and satisfying meal.");

                            return Text(
                              desc,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6B7280),
                                height: 1.5,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Bottom Section
                  const SizedBox(height: 14),

                  // Quantity
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Quantity',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF252B35),
                        ),
                      ),
                      Obx(
                        () => Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF823E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: controller.decrementQuantity,
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              Text(
                                '${controller.currentQuantity}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.incrementQuantity,
                                child: const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Buttons
                  Obx(
                    () => Row(
                      children: [
                        GestureDetector(
                          onTap: controller.addToCart,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFECE0),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                carticon,
                                width: 24,
                                height: 24,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFFFF823E),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: 'Place Order',
                            onPressed: controller.placeOrder,
                            height: 56,
                            backgroundColor:
                                controller.isRestaurantClosed.value
                                    ? const Color(0xFFFFDECD)
                                    : const Color(0xFFFF823E),
                            textColor: Colors.white,
                            borderRadius: 16,
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
      );
    }),
    );
  }
}
