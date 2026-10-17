import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class RestaurantDetailsCard extends StatelessWidget {
  final RestaurantItem restaurant;
  final bool isClosed;

  const RestaurantDetailsCard({
    super.key,
    required this.restaurant,
    required this.isClosed,
  });

  @override
  Widget build(BuildContext context) {
    final isOpen = restaurant.isOpen && !isClosed;
    final muted = const Color(0xFF737782);
    final titleColor = const Color(0xFF20232A);
    final accent = const Color(0xFFFF6F2C);

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEEF0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Restaurant cover image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
            child: SizedBox(
              height: 175,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: restaurant.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: const Color(0xFFF3F4F6),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.restaurant,
                        size: 34,
                        color: Color(0xFFB8BBC2),
                      ),
                    ),
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/homeimg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x99000000)],
                        stops: [0.42, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name.capitalizeWords(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,

                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  restaurant.cuisine.capitalizeWords(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: muted,
                    fontSize: 12,

                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 14),

                // Delivery facts: only real fields from RestaurantItem.
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _DetailChip(
                      icon: Icons.schedule_rounded,
                      label: restaurant.deliveryTime.capitalizeFirstLetter(),
                      iconColor: accent,
                    ),
                    _DetailChip(
                      icon: Icons.near_me_outlined,
                      label: restaurant.distance,
                      iconColor: const Color(0xFF667085),
                    ),
                    _DetailChip(
                      icon: Icons.star_border_outlined,
                      label: (restaurant.rating).toString(),
                      iconColor: const Color(0xFF667085),
                    ),
                  ],
                ),
                if (!isOpen) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFEDEEF0)),
                  const SizedBox(height: 12),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isOpen)
                      Icon(
                        Icons.info_rounded,
                        size: 17,
                        color: isOpen
                            ? const Color(0xFF16834A)
                            : const Color(0xFFD97706),
                      ),
                    const SizedBox(width: 7),
                    if (!isOpen)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOpen
                                  ? 'Accepting orders'
                                  : 'Not accepting orders right now',
                              style: TextStyle(
                                color: isOpen
                                    ? const Color(0xFF18794E)
                                    : const Color(0xFFB45309),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (restaurant.openingTime.trim().isNotEmpty) ...[
                              const SizedBox(height: 3),
                              Text(
                                'Hours: ${restaurant.openingTime.trim()}',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _DetailChip({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        // color: const Color(0xFFF8F8F9),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFEDEEF0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label.trim().isEmpty ? '—' : label,
            style: TextStyle(
              color: const Color(0xFF383B43),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
