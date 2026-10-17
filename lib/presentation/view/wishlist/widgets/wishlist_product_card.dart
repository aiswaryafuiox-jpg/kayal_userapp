import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/get_wishlist_response_model.dart';
import 'package:kayal_userapp/presentation/controller/wishlist_controller.dart';

class WishlistProductCard extends StatelessWidget {
  final WishlistItemModel product;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddTap;
  final VoidCallback? onRemoveTap;
  final bool isClosed;
  final WishlistController? controller;

  WishlistProductCard({
    super.key,
    WishlistItemModel? product,
    WishlistItemModel? item,
    this.onFavoriteTap,
    this.onAddTap,
    this.onRemoveTap,
    this.isClosed = false,
    this.controller,
  }) : product = (product ?? item)!,
       assert(
         product != null || item != null,
         'Either product or item must be provided',
       );

  String _resolveImageUrl(String path) {
    if (path.isEmpty || path == 'null') return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('assets/')) return path;
    return '${ApiRoutes.imageBaseURL}$path';
  }

  @override
  Widget build(BuildContext context) {
    final wishlistController =
        controller ??
        (Get.isRegistered<WishlistController>()
            ? Get.find<WishlistController>()
            : Get.put(WishlistController()));
    final resolvedImage = _resolveImageUrl(product.imageUrl ?? '');

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.productDetail,
        arguments: {
          'product': product.toJson(),
          'productId': product.productId.toString(),
          'id': product.productId.toString(),
          'isClosed': isClosed,
        },
      ),
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
                      opacity: 1.0,
                      child:
                          resolvedImage.startsWith('http://') ||
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
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF202733),
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
                            color: product.isVeg ?? false
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFF44336),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: Icon(
                          Icons.circle,
                          size: 8,
                          color: product.isVeg ?? false
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFF44336),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  const SizedBox(height: 8),

                  // PRICE AND QUANTITY SELECTOR
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (product.mrp! > product.sellPrice! &&
                                product.sellPrice! > 0)
                              Text(
                                '₹${product.mrp! % 1 == 0 ? product.mrp!.toInt() : product.mrp!.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFB0B3BA),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              '₹${(product.sellPrice! % 1 == 0) ? product.sellPrice?.toInt() : product.sellPrice?.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF202733),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Obx(() {
                        final count =
                            wishlistController?.getQuantity(product) ?? 0;

                        if (count == 0) {
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap:
                                  onAddTap ??
                                  () => wishlistController?.incrementQuantity(
                                    product,
                                  ),
                              child: Ink(
                                height: 32,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isClosed
                                      ? const Color(0xFFFFB58F)
                                      : const Color(0xFFFF823E),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      'ADD',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
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
                                onTap:
                                    onRemoveTap ??
                                    () => wishlistController?.decrementQuantity(
                                      product,
                                    ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              Text(
                                '$count',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap:
                                    onAddTap ??
                                    () => wishlistController?.incrementQuantity(
                                      product,
                                    ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
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
                      }),
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
