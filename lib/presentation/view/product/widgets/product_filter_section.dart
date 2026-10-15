import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';

class ProductFilterSection extends StatelessWidget {
  final ProductController controller;

  const ProductFilterSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ==========================================
        // SEARCH BAR & FILTER TUNE BUTTON
        // ==========================================
        Row(
          children: [
            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFFEBE3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Color(0xFFFF823E),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.onSearchChanged,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: const Color(0xFF252B35),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search in menu...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF9E9E9E),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Obx(() {
                      if (controller.searchQuery.value.trim().isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return GestureDetector(
                        onTap: controller.clearSearch,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Tune / Filter Button
            GestureDetector(
              onTap: controller.openFilter,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFFEBE3),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(() {
                  final bool hasActive = controller.hasActiveFilters;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.tune_rounded,
                        color: hasActive
                            ? const Color(0xFFFF823E)
                            : const Color(0xFF6B7280),
                        size: 20,
                      ),
                      if (hasActive)
                        Positioned(
                          top: 9,
                          right: 9,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF823E),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ==========================================
        // HORIZONTAL FILTER CHIPS ROW
        // ==========================================
        Obx(() {
          final isVegSelected = controller.selectedDietary.value == 'Veg';
          final isNonVegSelected =
              controller.selectedDietary.value == 'Non-Veg';
          final bool hasActive = controller.hasActiveFilters;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // Sort By Dropdown
                _sortDropdown(),
                const SizedBox(width: 8),

                // Veg Chip
                _filterChip(
                  label: 'Veg',
                  isSelected: isVegSelected,
                  selectedColor: const Color(0xFF16A34A),
                  prefixIcon: Container(
                    width: 13,
                    height: 13,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF16A34A),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  onTap: () => controller.toggleDietary('Veg'),
                ),
                const SizedBox(width: 8),

                // Non-Veg Chip
                _filterChip(
                  label: 'Non-Veg',
                  isSelected: isNonVegSelected,
                  selectedColor: const Color(0xFFDC2626),
                  prefixIcon: Container(
                    width: 13,
                    height: 13,
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFDC2626),
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDC2626),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  onTap: () => controller.toggleDietary('Non-Veg'),
                ),

                if (hasActive) ...[
                  const SizedBox(width: 8),
                  // Clear / Reset Chip
                  GestureDetector(
                    onTap: controller.resetFilters,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0E6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFF823E),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.close_rounded,
                            size: 13,
                            color: Color(0xFFFF823E),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Reset',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFF823E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }),

        const SizedBox(height: 14),

        // ==========================================
        // SECTION LABEL & COUNT
        // ==========================================
        Obx(() {
          final count = controller.filteredProducts.length;
          final bool hasActive = controller.hasActiveFilters;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hasActive ? 'Filtered Dishes' : 'Menu Items',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF252B35),
                ),
              ),
              Text(
                '$count dishes',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFF823E),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _sortDropdown() {
    final currentSort = controller.selectedSort.value;
    final bool isCustomSort = currentSort != 'Popularity';

    return PopupMenuButton<String>(
      tooltip: 'Sort By',
      onSelected: controller.setSort,
      offset: const Offset(0, 36),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFEDEEF0), width: 1),
      ),
      color: Colors.white,
      elevation: 8,
      itemBuilder: (context) => [
        _sortMenuItem(
          value: 'Popularity',
          icon: Icons.local_fire_department_outlined,
          isSelected: currentSort == 'Popularity',
        ),
        _sortMenuItem(
          value: 'Ratings',
          icon: Icons.star_rounded,
          isSelected: currentSort == 'Ratings',
        ),
        _sortMenuItem(
          value: 'Price : Low --> High',
          icon: Icons.arrow_upward_rounded,
          isSelected: currentSort == 'Price : Low --> High',
        ),
        _sortMenuItem(
          value: 'Price : High --> Low',
          icon: Icons.arrow_downward_rounded,
          isSelected: currentSort == 'Price : High --> Low',
        ),
      ],
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isCustomSort
              ? const Color(0xFFFF823E).withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCustomSort
                ? const Color(0xFFFF823E)
                : const Color(0xFFE5E7EB),
            width: isCustomSort ? 1.4 : 1,
          ),
          boxShadow: isCustomSort
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF823E).withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sort_rounded,
              size: 14,
              color: isCustomSort
                  ? const Color(0xFFFF823E)
                  : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 5),
            Text(
              isCustomSort ? currentSort : 'Sort By',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isCustomSort ? FontWeight.w700 : FontWeight.w500,
                color: isCustomSort
                    ? const Color(0xFFFF823E)
                    : const Color(0xFF4B5563),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down_rounded,
              size: 18,
              color: isCustomSort
                  ? const Color(0xFFFF823E)
                  : const Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _sortMenuItem({
    required String value,
    required IconData icon,
    required bool isSelected,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: 42,
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isSelected
                ? const Color(0xFFFF823E)
                : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFFFF823E)
                    : const Color(0xFF252B35),
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_rounded, size: 16, color: Color(0xFFFF823E)),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required Widget prefixIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? selectedColor : const Color(0xFFE5E7EB),
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: selectedColor.withValues(alpha: 0.12),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            prefixIcon,
            const SizedBox(width: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? selectedColor : const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
