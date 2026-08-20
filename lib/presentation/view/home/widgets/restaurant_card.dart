import 'package:flutter/material.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantItem restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final bool isOpen = restaurant.isOpen;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==========================
          // IMAGE
          // ==========================
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Opacity(
                  opacity: isOpen ? 1.0 : 0.45,
                  child: Image.asset(
                    restaurant.image,
                    width: double.infinity,
                    height: 145,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // FREE DELIVERY BADGE
              if (isOpen)
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF823E),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Free Delivery',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // ==========================
          // RESTAURANT NAME
          // ==========================
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
            child: Text(
              restaurant.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isOpen
                    ? const Color(0xFF252B35)
                    : const Color(0xFF8C9199),
              ),
            ),
          ),

          // ==========================
          // DETAILS
          // ==========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _detailItem(
                  Icons.restaurant_menu,
                  restaurant.cuisine,
                  isOpen: isOpen,
                ),

                const SizedBox(width: 16),

                _detailItem(
                  Icons.access_time,
                  restaurant.deliveryTime,
                  isOpen: isOpen,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ==========================
          // STATUS
          // ==========================
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 13,
                  color: isOpen
                      ? const Color(0xFF22C55E)
                      : const Color(0xFFFF383C),
                ),

                const SizedBox(width: 4),

                Text(
                  isOpen ? 'Opened' : 'Closed',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isOpen
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFFF383C),
                  ),
                ),

                const SizedBox(width: 6),

                const Text(
                  '|',
                  style: TextStyle(
                    color: Color(0xFFD1D5DB),
                    fontSize: 10,
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  restaurant.openingTime,
                  style: TextStyle(
                    fontSize: 9,
                    color: isOpen
                        ? const Color(0xFF555555)
                        : const Color(0xFF8C9199),
                  ),
                ),

                const Spacer(),

                Icon(
                  Icons.location_on_outlined,
                  color: isOpen
                      ? const Color(0xFFFF383C)
                      : const Color(0xFFFCA5A5),
                  size: 13,
                ),

                const SizedBox(width: 3),

                Text(
                  'Distance',
                  style: TextStyle(
                    color: isOpen
                        ? const Color(0xFFFF383C)
                        : const Color(0xFFFCA5A5),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(width: 6),

                const Text(
                  '|',
                  style: TextStyle(
                    color: Color(0xFFD1D5DB),
                    fontSize: 10,
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  restaurant.distance,
                  style: TextStyle(
                    fontSize: 9,
                    color: isOpen
                        ? const Color(0xFF555555)
                        : const Color(0xFF8C9199),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(IconData icon, String text, {required bool isOpen}) {
    return Row(
      children: [
        Icon(
          icon,
          color: isOpen ? const Color(0xFFFF6F2C) : const Color(0xFFD1A996),
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: isOpen ? const Color(0xFF252B35) : const Color(0xFF8C9199),
          ),
        ),
      ],
    );
  }
}
