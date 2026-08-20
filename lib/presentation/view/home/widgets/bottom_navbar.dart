import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kayal_userapp/core/const/app_color.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/core/utils/helper/texthelper.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  }) : assert(currentIndex >= 0 && currentIndex < 5);

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _animationDuration = Duration(milliseconds: 420);
  static const _animationCurve = Curves.easeInOutCubicEmphasized;

  static const _items = [
    _NavigationItem(label: 'Home', icon: homeIcon),
    _NavigationItem(label: 'Category', icon: categoryIcon),
    _NavigationItem(label: 'Wishlist', icon: wishlistIcon),
    _NavigationItem(label: 'Orders', icon: ordersIcon),
    _NavigationItem(label: 'Profile', icon: profileIcon),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textprimary.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 7, 16, 7),
        child: SizedBox(
          height: 48,
          child: LayoutBuilder(
            builder: (context, constraints) {
              // The active destination owns a wider cell, so its pill cannot
              // paint over a neighbouring icon. All widths use the same
              // animation and always add up to the available bar width.
              final selectedWidth = (constraints.maxWidth * 0.38).clamp(
                96.0,
                112.0,
              );
              final idleWidth =
                  (constraints.maxWidth - selectedWidth) / (_items.length - 1);

              return Row(
                children: [
                  for (var index = 0; index < _items.length; index++)
                    AnimatedContainer(
                      key: Key('bottom-navigation-cell-$index'),
                      duration: _animationDuration,
                      curve: _animationCurve,
                      width: currentIndex == index ? selectedWidth : idleWidth,
                      height: 46,
                      child: _BottomNavigationItem(
                        item: _items[index],
                        isSelected: currentIndex == index,
                        onTap: () => onTap(index),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  const _BottomNavigationItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('bottom-navigation-${item.label.toLowerCase()}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: AnimatedContainer(
            duration: BottomNavBar._animationDuration,
            curve: BottomNavBar._animationCurve,
            padding: EdgeInsets.symmetric(horizontal: isSelected ? 10 : 4),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFFF9B59), AppColors.primary],
                    )
                  : null,
              borderRadius: BorderRadius.circular(30),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.28),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : const [],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
                    child: child,
                  ),
                ),
                child: isSelected
                    ? Row(
                        key: ValueKey('selected-${item.label}'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _NavigationIcon(item: item, color: AppColors.white),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              item.label,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: TextHelper.button.copyWith(
                                color: AppColors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                    : _NavigationIcon(
                        key: ValueKey('idle-${item.label}'),
                        item: item,
                        color: AppColors.textprimary,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationIcon extends StatelessWidget {
  const _NavigationIcon({required this.item, required this.color, super.key});

  final _NavigationItem item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      item.icon,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({required this.label, required this.icon});

  final String label;
  final String icon;
}
