import 'package:flutter/material.dart';
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
      body: ShimmerLoading(
        child: Column(
          children: [
            // Top Image Area + Header Buttons
            Expanded(
              child: Stack(
                children: [
                  // Full Screen / Scrollable Skeleton
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image banner shimmer
                        ShimmerBox(
                          width: double.infinity,
                          height: imageHeight,
                          borderRadius: 0,
                          color: const Color(0xFFE5E7EB),
                        ),

                        // Content card
                        Transform.translate(
                          offset: const Offset(0, -28),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
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
                                // Title & Price row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    ShimmerBox(width: 180, height: 24, borderRadius: 6),
                                    ShimmerBox(width: 72, height: 24, borderRadius: 6),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // Veg tag & Type
                                Row(
                                  children: const [
                                    ShimmerBox(width: 18, height: 18, borderRadius: 4),
                                    SizedBox(width: 8),
                                    ShimmerBox(width: 80, height: 14, borderRadius: 4),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                // Offer badge
                                const ShimmerBox(width: 120, height: 24, borderRadius: 6),
                                const SizedBox(height: 18),

                                // Description Header
                                const ShimmerBox(width: 100, height: 18, borderRadius: 4),
                                const SizedBox(height: 10),

                                // Description multiline paragraph
                                const ShimmerBox(
                                  width: double.infinity,
                                  height: 14,
                                  borderRadius: 4,
                                ),
                                const SizedBox(height: 8),
                                const ShimmerBox(
                                  width: double.infinity,
                                  height: 14,
                                  borderRadius: 4,
                                ),
                                const SizedBox(height: 8),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return ShimmerBox(
                                      width: constraints.maxWidth * 0.75,
                                      height: 14,
                                      borderRadius: 4,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Header buttons shimmer
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          ShimmerBox(
                            width: 44,
                            height: 44,
                            borderRadius: 12,
                            color: Colors.white,
                          ),
                          ShimmerBox.circular(
                            size: 44,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom pinned action bar shimmer
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Quantity row shimmer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ShimmerBox(width: 120, height: 18, borderRadius: 4),
                        ShimmerBox(width: 88, height: 32, borderRadius: 8),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Action buttons row shimmer
                    Row(
                      children: const [
                        ShimmerBox.circular(size: 56),
                        SizedBox(width: 16),
                        Expanded(
                          child: ShimmerBox(
                            height: 56,
                            borderRadius: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
