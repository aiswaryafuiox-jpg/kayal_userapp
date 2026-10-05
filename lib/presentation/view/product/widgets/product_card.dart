import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final ProductController controller;

  const ProductCard({
    super.key,
    required this.product,
    required this.controller,
  });

  String _resolveImageUrl(String path) {
    if (path.isEmpty || path == 'null') return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('assets/')) return path;
    return '${ApiRoutes.imageBaseURL}$path';
  }

  @override
  Widget build(BuildContext context) {
    final bool isClosed = controller.isRestaurantClosed.value;
    final resolvedImage = _resolveImageUrl(product.image);

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: {
        'product': product,
        'isClosed': isClosed,
      }),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE AND FAVORITE ICON
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Opacity(
                      opacity: isClosed ? 0.45 : 1.0,
                      child: resolvedImage.startsWith('http://') ||
                              resolvedImage.startsWith('https://')
                          ? Image.network(
                              resolvedImage,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Image.asset(
                                'assets/images/product1.png',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              resolvedImage.isNotEmpty
                                  ? resolvedImage
                                  : 'assets/images/product1.png',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Image.asset(
                                'assets/images/product1.png',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => controller.toggleFavorite(product.id),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Obx(
                          () => Icon(
                            product.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 14,
                            color: const Color(0xFFE53935),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // DETAILS
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE & TYPE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name.capitalizeWords(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isClosed
                                ? const Color(0xFF8C9199)
                                : const Color(0xFF202733),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: product.isVeg
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFF44336),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: product.isVeg
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFF44336),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Text(
                    product.type.capitalizeWords(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: isClosed
                          ? const Color(0xFF8C9199)
                          : const Color(0xFF5E6573),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // PRICE AND QUANTITY SELECTOR
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (product.oldPrice > product.newPrice &&
                                product.newPrice > 0)
                              Text(
                                '₹${product.oldPrice % 1 == 0 ? product.oldPrice.toInt() : product.oldPrice.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFB0B3BA),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              '₹${((product.newPrice > 0 ? product.newPrice : product.oldPrice) % 1 == 0) ? (product.newPrice > 0 ? product.newPrice : product.oldPrice).toInt() : (product.newPrice > 0 ? product.newPrice : product.oldPrice).toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isClosed
                                    ? const Color(0xFF8C9199)
                                    : const Color(0xFF202733),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Obx(
                        () {
                          final count = controller.getQuantity(product);
                          return Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: isClosed
                                  ? const Color(0xFFFFB58F)
                                  : const Color(0xFFFF823E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => controller.decrementQuantity(product),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$count',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => controller.incrementQuantity(product),
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
