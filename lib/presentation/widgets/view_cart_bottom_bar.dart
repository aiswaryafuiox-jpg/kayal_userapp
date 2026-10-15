import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';

class ViewCartBottomBar extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final bool isFloating;

  const ViewCartBottomBar({super.key, this.margin, this.isFloating = false});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CartController>()) {
      return const SizedBox.shrink();
    }

    final cartController = Get.find<CartController>();

    return Obx(() {
      final totalItems = cartController.totalQuantity;
      final bool hasItems =
          cartController.cartItems.isNotEmpty && totalItems > 0;

      if (isFloating) {
        return AnimatedScale(
          scale: hasItems ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 260),
          curve: hasItems ? Curves.easeOutBack : Curves.easeInBack,
          child: AnimatedOpacity(
            opacity: hasItems ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 180),
            child: hasItems
                ? _buildBar(context, cartController, totalItems)
                : const SizedBox.shrink(),
          ),
        );
      }

      return AnimatedSize(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOutCubic,
        alignment: Alignment.topCenter,
        child: hasItems
            ? _buildBar(context, cartController, totalItems)
            : const SizedBox.shrink(),
      );
    });
  }

  Widget _buildBar(
    BuildContext context,
    CartController cartController,
    int totalItems,
  ) {
    final double totalAmount = cartController.totalAmount;
    final String priceStr = totalAmount % 1 == 0
        ? totalAmount.toInt().toString()
        : totalAmount.toStringAsFixed(2);
    final String itemsStr = totalItems == 1 ? '1 ITEM' : '$totalItems ITEMS';

    final screenWidth = MediaQuery.of(context).size.width;
    final double barWidth = screenWidth > 450 ? 420.0 : (screenWidth - 32);

    final Widget barContent = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.cart),
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.white.withValues(alpha: 0.15),
        highlightColor: Colors.white.withValues(alpha: 0.08),
        child: Ink(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF823E), Color(0xFFFF661E)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFFFF823E,
                ).withValues(alpha: isFloating ? 0.42 : 0.38),
                blurRadius: isFloating ? 18 : 14,
                offset: Offset(0, isFloating ? 6 : 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon badge
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    carticon,
                    width: 17,
                    height: 17,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Item count & price
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        itemsStr,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 3.5,
                        height: 3.5,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        '₹$priceStr',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Extra charges may apply',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Action on right: VIEW CART ->
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'VIEW CART',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (isFloating) {
      return SizedBox(
        width: barWidth,
        child: Padding(padding: margin ?? EdgeInsets.zero, child: barContent),
      );
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: margin ?? const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: barContent,
      ),
    );
  }
}
