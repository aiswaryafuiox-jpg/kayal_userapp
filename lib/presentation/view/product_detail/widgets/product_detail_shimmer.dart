import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/widgets/shimmer_loading.dart';

class ProductDetailShimmer extends StatelessWidget {
  const ProductDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final imageHeight = (screenHeight * 0.44).clamp(280.0, 420.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ==========================================
          // SCROLLABLE SKELETON BODY
          // ==========================================
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image Banner Skeleton
                      SizedBox(
                        width: double.infinity,
                        height: imageHeight,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Base shimmering hero background
                            const ShimmerLoading(
                              baseColor: Color(0xFFEFF1F5),
                              highlightColor: Color(0xFFF9FAFB),
                              child: ShimmerBox(
                                width: double.infinity,
                                height: double.infinity,
                                borderRadius: 0,
                                color: Color(0xFFEFF1F5),
                              ),
                            ),

                            // Center brand / culinary badge
                            Center(
                              child: Container(
                                width: 76,
                                height: 76,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFFECE0,
                                  ).withValues(alpha: 0.8),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.restaurant_rounded,
                                  color: Color(0xFFFFB27A),
                                  size: 36,
                                ),
                              ),
                            ),

                            // Top gradient scrim for header button contrast
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: 110,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withValues(alpha: 0.28),
                                      Colors.transparent,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Content Card with overlapping rounded top
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
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                          child: ShimmerLoading(
                            baseColor: const Color(0xFFEDEDF0),
                            highlightColor: const Color(0xFFF8F9FA),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title & Price row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          ShimmerBox(
                                            width: 190,
                                            height: 22,
                                            borderRadius: 6,
                                          ),
                                          SizedBox(height: 8),
                                          ShimmerBox(
                                            width: 115,
                                            height: 14,
                                            borderRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const ShimmerBox(
                                      width: 82,
                                      height: 26,
                                      borderRadius: 6,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Dietary tag & Rating pills row
                                Row(
                                  children: [
                                    const ShimmerBox(
                                      width: 16,
                                      height: 16,
                                      borderRadius: 4,
                                    ),
                                    const SizedBox(width: 8),
                                    const ShimmerBox(
                                      width: 65,
                                      height: 14,
                                      borderRadius: 4,
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFD1D5DB),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const ShimmerBox(
                                      width: 72,
                                      height: 20,
                                      borderRadius: 10,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Offer tag pill skeleton
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: const Color(0xFFC8E6C9),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.local_offer_outlined,
                                        size: 13,
                                        color: Color(0xFF81C784),
                                      ),
                                      SizedBox(width: 6),
                                      ShimmerBox(
                                        width: 60,
                                        height: 12,
                                        borderRadius: 3,
                                        color: Color(0xFFC8E6C9),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Hairline Divider
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                  color: const Color(0xFFF3F4F6),
                                ),
                                const SizedBox(height: 20),

                                // Highlights / Quick specs row
                                Row(
                                  children: [
                                    _buildHighlightCard(width: 85),
                                    const SizedBox(width: 10),
                                    _buildHighlightCard(width: 95),
                                    const SizedBox(width: 10),
                                    _buildHighlightCard(width: 80),
                                  ],
                                ),
                                const SizedBox(height: 24),

                                // Description Header
                                const ShimmerBox(
                                  width: 100,
                                  height: 16,
                                  borderRadius: 4,
                                ),
                                const SizedBox(height: 12),

                                // Description Multiline Paragraph
                                const ShimmerBox(
                                  width: double.infinity,
                                  height: 13,
                                  borderRadius: 4,
                                ),
                                const SizedBox(height: 8),
                                const ShimmerBox(
                                  width: double.infinity,
                                  height: 13,
                                  borderRadius: 4,
                                ),
                                const SizedBox(height: 8),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return ShimmerBox(
                                      width: constraints.maxWidth * 0.68,
                                      height: 13,
                                      borderRadius: 4,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ==========================================
              // BOTTOM PINNED ACTION BAR SKELETON
              // ==========================================
              SafeArea(
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
                  child: ShimmerLoading(
                    baseColor: const Color(0xFFFFEBE3),
                    highlightColor: const Color(0xFFFFF6F0),
                    child: Row(
                      children: const [
                        // Circular Add to Cart button skeleton
                        ShimmerBox.circular(size: 54, color: Color(0xFFFFECE0)),
                        SizedBox(width: 14),

                        // Expanded Place Order button skeleton
                        Expanded(
                          child: ShimmerBox(
                            height: 54,
                            borderRadius: 16,
                            color: Color(0xFFFFD4BE),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ==========================================
          // TOP FLOATING HEADER (ACTIVE & RESPONSIVE)
          // ==========================================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Functional Back Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.back(),
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

                  // Favorite Button Skeleton (Clean Circular Container)
                  Container(
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
                    child: const Icon(
                      Icons.favorite_border,
                      color: Color(0xFFB0B5C0),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildHighlightCard({required double width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          ShimmerBox(
            width: 18,
            height: 18,
            borderRadius: 4,
            color: Color(0xFFE5E7EB),
          ),
          SizedBox(height: 6),
          ShimmerBox(
            width: double.infinity,
            height: 10,
            borderRadius: 3,
            color: Color(0xFFE5E7EB),
          ),
        ],
      ),
    );
  }
}
