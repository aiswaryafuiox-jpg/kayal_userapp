import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/presentation/controller/product_detail_controller.dart';
import 'package:kayal_userapp/presentation/view/product_detail/widgets/product_detail_shimmer.dart';
import 'package:kayal_userapp/presentation/widgets/custom_buttom.dart';
import 'package:kayal_userapp/presentation/widgets/restaurant_unavailable_banner.dart';
import 'package:kayal_userapp/presentation/widgets/shimmer_loading.dart';
import 'package:kayal_userapp/presentation/widgets/view_cart_bottom_bar.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final ProductDetailController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ProductDetailController>()
        ? Get.find<ProductDetailController>()
        : Get.put(ProductDetailController());

    // Trigger dynamic fetch every time screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetAndFetch(Get.arguments);
    });
  }

  @override
  void didUpdateWidget(covariant ProductDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.resetAndFetch(Get.arguments);
  }

  String _resolveImageUrl(String? path) {
    if (path == null || path.trim().isEmpty || path == 'null') return '';
    final trimmed = path.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('assets/')) {
      return trimmed;
    }
    final clean = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    if (clean.startsWith('storage/')) {
      return 'http://64.227.170.206/kayal.com/public/$clean';
    }
    return '${ApiRoutes.imageBaseURL}$clean';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final imageHeight = (screenHeight * 0.44).clamp(280.0, 420.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // 1. Shimmer loading state while fetching detailed data from API
        if (controller.isLoading.value &&
            controller.productDetail.value == null) {
          return const ProductDetailShimmer();
        }

        // 2. Error / Not found state when loading completed but no data available
        if (controller.product.value == null &&
            controller.productDetail.value == null) {
          return _buildErrorOrNotFoundState(context);
        }

        // 3. Render full dynamic product details
        return Stack(
          children: [
            Column(
              children: [
                // Scrollable Body
                Expanded(
                  child: RefreshIndicator(
                    color: const Color(0xFFFF823E),
                    onRefresh: controller.refreshDetails,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hero Image Container
                          SizedBox(
                            width: double.infinity,
                            height: imageHeight,
                            child: _buildHeroImage(),
                          ),

                          // Content Card
                          Transform.translate(
                            offset: const Offset(0, -28),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(32),
                                  topRight: Radius.circular(32),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x08000000),
                                    blurRadius: 16,
                                    offset: Offset(0, -6),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                28,
                                24,
                                24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title & Price Row
                                  _buildTitleAndPrice(),
                                  const SizedBox(height: 12),

                                  // Veg/Non-Veg Tag
                                  _buildDietaryTag(),
                                  const SizedBox(height: 12),

                                  // Offer Badge (only if offer exists)
                                  _buildOfferBadge(),

                                  // Restaurant Unavailable Banner
                                  Obx(() {
                                    if (controller.isRestaurantClosed.value) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 6,
                                          bottom: 14,
                                        ),
                                        child: RestaurantUnavailableBanner(
                                          notes: controller.closedNotes.value,
                                        ),
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  }),

                                  // Description Section (only if description exists)
                                  _buildDescriptionSection(),

                                  const SizedBox(height: 28),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Pinned Action Bar
                _buildBottomActionBar(context),
              ],
            ),

            // Top Floating Header (Back + Favorite)
            _buildFloatingHeader(context),

            // Floating View Cart Bar when cart has items
            Positioned.fill(
              bottom: 130,

              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 290,
                  child: ViewCartBottomBar(isFloating: true),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeroImage() {
    return Obx(() {
      final rawImg =
          controller.productDetail.value?.image ??
          controller.product.value?.image;
      final resolvedUrl = _resolveImageUrl(rawImg);
      final isNetwork =
          resolvedUrl.startsWith('http://') ||
          resolvedUrl.startsWith('https://');

      Widget imageWidget;
      if (resolvedUrl.isEmpty) {
        imageWidget = _buildImagePlaceholder();
      } else if (isNetwork) {
        imageWidget = CachedNetworkImage(
          imageUrl: resolvedUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const ShimmerBox(
            width: double.infinity,
            height: double.infinity,
            borderRadius: 0,
            color: Color(0xFFE5E7EB),
          ),
          errorBuilder: (context, error, stackTrace) =>
              _buildImagePlaceholder(),
        );
      } else if (resolvedUrl.startsWith('assets/')) {
        imageWidget = Image.asset(
          resolvedUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildImagePlaceholder(),
        );
      } else {
        imageWidget = _buildImagePlaceholder();
      }

      return Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          // Subtle dark gradient scrim at the top for header buttons contrast
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 110,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFF3F4F6),
      alignment: Alignment.center,
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
              Icons.restaurant_rounded,
              color: Color(0xFFFF823E),
              size: 36,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Kayal Delights',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.goBack,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF252B35),
                    size: 19,
                  ),
                ),
              ),
            ),

            // Favorite Button
            Obx(
              () => Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: controller.toggleFavorite,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
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
                          ? const Color(0xFFE53935)
                          : const Color(0xFF252B35),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Obx(() {
      final detail = controller.productDetail.value;
      final prod = controller.product.value;

      final title =
          (detail?.name.isNotEmpty == true ? detail!.name : (prod?.name ?? ''))
              .capitalizeWords();

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title.isNotEmpty ? title : 'Product Details',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF202733),
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (oldPrice > price && price > 0) ...[
                Text(
                  '₹$oldPriceStr',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF9E9E9E),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                '₹$priceStr',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF823E),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildDietaryTag() {
    return Obx(() {
      final isVeg =
          controller.productDetail.value?.isVeg ??
          controller.product.value?.isVeg ??
          true;
      final rawType =
          controller.productDetail.value?.type ??
          controller.product.value?.type;
      final type =
          (rawType != null && rawType.trim().isNotEmpty
                  ? rawType.trim()
                  : (isVeg ? 'Veg' : 'Non-Veg'))
              .capitalizeWords();

      return Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              border: Border.all(
                color: isVeg
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFD32F2F),
                width: 1.4,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: isVeg
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFD32F2F),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            type,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildOfferBadge() {
    return Obx(() {
      final offer = controller.offerPercentage.value.trim().isNotEmpty
          ? controller.offerPercentage.value.trim()
          : (controller.productDetail.value?.offerPercentage?.trim() ?? '');

      if (offer.isEmpty ||
          offer == '0%' ||
          offer == '0 %' ||
          offer == '0% OFF') {
        return const SizedBox.shrink();
      }

      final displayText = offer.toUpperCase().contains('OFF')
          ? offer
          : '$offer OFF';

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFC8E6C9), width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_offer_outlined,
                    size: 13,
                    color: Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    displayText,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDescriptionSection() {
    return Obx(() {
      final desc = controller.description.value.trim().isNotEmpty
          ? controller.description.value.trim()
          : (controller.productDetail.value?.description?.trim() ?? '');

      if (desc.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Description',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF202733),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6B7280),
              height: 1.6,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Quantity Row
            const SizedBox(height: 14),

            // Buttons Row (Add to Cart + Place Order)
            Obx(
              () => Row(
                children: [
                  // Add to Cart circular button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: controller.addToCart,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECE0),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFFFDCC9),
                            width: 1.2,
                          ),
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
                  ),
                  const SizedBox(width: 14),

                  // Place Order button
                  Expanded(
                    child: CustomButton(
                      text: controller.isRestaurantClosed.value
                          ? 'Restaurant Closed'
                          : 'Place Order',
                      onPressed: controller.placeOrder,
                      height: 54,
                      backgroundColor: controller.isRestaurantClosed.value
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
    );
  }

  Widget _buildErrorOrNotFoundState(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFECE0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.restaurant_menu_rounded,
                  size: 40,
                  color: Color(0xFFFF823E),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Product Details Unavailable',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF252B35),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Obx(() {
                final msg = controller.errorMessage.value.trim().isNotEmpty
                    ? controller.errorMessage.value
                    : 'The requested product could not be found or loaded.';
                return Text(
                  msg,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                );
              }),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: controller.goBack,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Go Back',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF4B5563),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  ElevatedButton.icon(
                    onPressed: controller.refreshDetails,
                    icon: const Icon(
                      Icons.refresh,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Retry',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF823E),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
