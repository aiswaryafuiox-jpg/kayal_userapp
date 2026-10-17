import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/data/model/get_cart_response_model.dart';

class AnimatedCartItemCard extends StatefulWidget {
  final GetCartItemModel item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Future<void> Function() onRemove;

  const AnimatedCartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  State<AnimatedCartItemCard> createState() => _AnimatedCartItemCardState();
}

class _AnimatedCartItemCardState extends State<AnimatedCartItemCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  bool _isRemoving = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: 1.0,
    );

    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.88, curve: Curves.easeInOutCubic),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: const Offset(-0.25, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRemoveWithAnimation() async {
    if (_isRemoving) return;
    setState(() {
      _isRemoving = true;
    });

    try {
      await _controller.reverse().orCancel;
    } catch (_) {
      // Handled if controller disposed before completion
    }

    if (mounted) {
      await widget.onRemove();
    }
  }

  void _onDecrementPressed() {
    if (_isRemoving) return;
    if ((widget.item.quantity ?? 1) > 1) {
      widget.onDecrement();
    } else {
      _handleRemoveWithAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      alignment: Alignment.center,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dismissible(
              key: ValueKey('dismiss_cart_${widget.item.id}'),
              direction: _isRemoving
                  ? DismissDirection.none
                  : DismissDirection.endToStart,
              background: _buildDismissBackground(),
              onDismissed: (_) {
                widget.onRemove();
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCardContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _resolveImageUrl(String path) {
    final trimmed = path.trim();
    if (trimmed.isEmpty || trimmed == 'null') return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('assets/')) return trimmed;
    return '${ApiRoutes.imageBaseURL}$trimmed';
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCDD2), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Remove',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFE53935),
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            deleteicon,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(
              Color(0xFFE53935),
              BlendMode.srcIn,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(String rawPath) {
    final resolvedUrl = _resolveImageUrl(rawPath);
    final isNetwork =
        resolvedUrl.startsWith('http://') || resolvedUrl.startsWith('https://');

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isNetwork
            ? CachedNetworkImage(
                imageUrl: resolvedUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 30,
                  height: 30,
                  color: const Color(0xFFFFF7F0),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  productImg3,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                resolvedUrl.isNotEmpty ? resolvedUrl : productImg3,
                width: 88,
                height: 88,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Image.asset(
                  productImg3,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  Widget _buildPriceSection(GetCartItemModel item) {
    final hasDiscount = item.oldPrice > item.newPrice && item.newPrice > 0;
    final itemCount = item.qty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '₹${(item.newPrice * itemCount).toInt()}',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF202733),
          ),
        ),
        if (hasDiscount) ...[
          const SizedBox(width: 8),
          Text(
            '₹${(item.oldPrice * itemCount).toInt()}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF9CA3AF),
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuantityAndActions(GetCartItemModel item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Quantity Stepper
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.22),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: _onDecrementPressed,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Icon(Icons.remove, color: Colors.white, size: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  '${item.qty}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: _isRemoving ? null : widget.onIncrement,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Icon(Icons.add, color: Colors.white, size: 15),
                ),
              ),
            ],
          ),
        ),

        // Delete Button
        // Material(
        //   color: Colors.transparent,
        //   child: InkWell(
        //     onTap: _isRemoving ? null : _handleRemoveWithAnimation,
        //     borderRadius: BorderRadius.circular(20),
        //     child: AnimatedContainer(
        //       duration: const Duration(milliseconds: 200),
        //       padding: const EdgeInsets.all(7),
        //       decoration: BoxDecoration(
        //         color: _isRemoving
        //             ? const Color(0xFFFFEBEE)
        //             : const Color(0xFFFFF5F5),
        //         shape: BoxShape.circle,
        //         border: Border.all(color: const Color(0xFFFFE0E2), width: 1),
        //       ),
        //       child: _isRemoving
        //           ? const SizedBox(
        //               width: 16,
        //               height: 16,
        //               child: CircularProgressIndicator(
        //                 strokeWidth: 2,
        //                 color: Color(0xFFE53935),
        //               ),
        //             )
        //           : SvgPicture.asset(
        //               deleteicon,
        //               width: 16,
        //               height: 16,
        //               colorFilter: const ColorFilter.mode(
        //                 Color(0xFFE53935),
        //                 BlendMode.srcIn,
        //               ),
        //             ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildCardContent() {
    final item = widget.item;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isRemoving
              ? const Color(0xFFFFCDD2)
              : const Color(0xFFFFEDE3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          _buildProductImage(item.image),
          const SizedBox(width: 14),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Veg/Non-Veg Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.displayName,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF202733),
                          height: 1.25,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
                const SizedBox(height: 3),

                // Type
                const SizedBox(height: 6),

                // Prices & Offer Tag
                _buildPriceSection(item),
                const SizedBox(height: 10),

                // Quantity Stepper & Delete Button
              ],
            ),
          ),

          Column(children: [_buildQuantityAndActions(item)]),
        ],
      ),
    );
  }
}
