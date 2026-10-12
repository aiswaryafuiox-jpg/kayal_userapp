import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/controller/cart_controller.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/widgets/app_embedded_image.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SizedBox(
      height: 171,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AppEmbeddedImage(
              asset: hometop,
              fit: BoxFit.cover,
              fallback: ColoredBox(color: Color(0xFFFF8A3D)),
            ),
            Positioned(
              left: 24,
              right: 24,
              top: 66,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: controller.openProfile,
                    child: Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(profileImg, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${controller.userName.value} !',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: controller.isLocationEnabled.value
                                ? null
                                : controller.showEnableLocationDialog,
                            child: Row(
                              children: [
                                Icon(
                                  controller.isLocationEnabled.value
                                      ? Icons.location_on
                                      : Icons.location_off_rounded,
                                  size: 16,
                                  color: const Color(0xFF1F2937),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: controller.isLocationEnabled.value
                                      ? Text(
                                          controller.userLocation.value,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: _locationTextStyle,
                                        )
                                      : const _LocationNewsTicker(
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
                  Obx(() {
                    int count = 0;
                    if (Get.isRegistered<CartController>()) {
                      final cartController = Get.find<CartController>();
                      count = cartController.cartItems.length;
                    }
                    return _headerButton(
                      asset: carticon,
                      onTap: controller.openCart,
                      count: count,
                      iconColor: const Color(0xFF1F2937),
                    );
                  }),
                  const SizedBox(width: 8),
                  _headerButton(
                    asset: 'assets/images/notificationicon.svg',
                    onTap: controller.openNotifications,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const TextStyle _locationTextStyle = TextStyle(
    color: Color(0xFF1F2937),
    fontSize: 9,
    fontWeight: FontWeight.w500,
  );

  Widget _headerButton({
    required String asset,
    required VoidCallback onTap,
    int count = 0,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: const Color(0xFFE3E5E8), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                asset,
                width: 22,
                height: 22,
                colorFilter: iconColor != null
                    ? ColorFilter.mode(iconColor, BlendMode.srcIn)
                    : null,
              ),
            ),
            if (count > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF823E),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationNewsTicker extends StatefulWidget {
  final String text;

  const _LocationNewsTicker({required this.text});

  @override
  State<_LocationNewsTicker> createState() => _LocationNewsTickerState();
}

class _LocationNewsTickerState extends State<_LocationNewsTicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const style = HomeHeader._locationTextStyle;
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return SizedBox(
      height: 14,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final travel = constraints.maxWidth + painter.width;
            return AnimatedBuilder(
              animation: _controller,
              child: Text(widget.text, maxLines: 1, style: style),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    constraints.maxWidth - (travel * _controller.value),
                    0,
                  ),
                  child: child,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
