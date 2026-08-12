import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    final items = [
      const _NavItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Home',
      ),
      const _NavItem(
        icon: Icons.grid_view_outlined,
        selectedIcon: Icons.grid_view_rounded,
        label: 'Category',
      ),
      const _NavItem(
        icon: Icons.favorite_border,
        selectedIcon: Icons.favorite,
        label: 'Wishlist',
      ),
      const _NavItem(
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        label: 'Orders',
      ),
      const _NavItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: List.generate(
            items.length,
            (index) {
              final item = items[index];

              final currentRoute = Get.currentRoute;
              int activeIndex = controller.selectedBottomIndex.value;
              if (currentRoute == '/home') {
                activeIndex = 0;
              } else if (currentRoute == '/category') {
                activeIndex = 1;
              }
              
              final selected = activeIndex == index;

              return GestureDetector(
                onTap: () =>
                    controller.changeBottomIndex(index),
                child: AnimatedContainer(
                  duration:
                      const Duration(milliseconds: 250),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFFF823E)
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? item.selectedIcon
                            : item.icon,
                        size: 21,
                        color: selected
                            ? Colors.white
                            : const Color(
                                0xFF252B35,
                              ),
                      ),

                      if (selected) ...[
                        const SizedBox(width: 6),
                        Text(
                          item.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}