import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kayal_userapp/core/const/app_color.dart';


class AppEmbeddedImage extends StatelessWidget {
  const AppEmbeddedImage({
    required this.asset,
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.backgroundColor = AppColors.primary,
    this.borderRadius = 16,
  });

  final String asset;
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Color backgroundColor;

  bool get _isSvg => asset.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
              imageUrl!,
              width: width,
              height: height,
              fit: fit,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _fallback(),
            )
          : _isSvg
          ? SvgPicture.asset(
              asset,
              width: width,
              height: height,
              fit: fit,
              placeholderBuilder: (_) => _fallback(),
            )
          : Image.asset(
              asset,
              width: width,
              height: height,
              fit: fit,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _fallback(),
            ),
    );
  }

  Widget _fallback() {
    return ColoredBox(color: backgroundColor, child: const SizedBox.expand());
  }
}
