import 'package:flutter/material.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantItem restaurant;

  const RestaurantCard({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
                child: Image.asset(
                  restaurant.image,
                  width: double.infinity,
                  height: 145,
                  fit: BoxFit.cover,
                ),
              ),

              // FREE DELIVERY
              if (restaurant.isOpen)
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF252B35),
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
                _detailItem(Icons.restaurant_menu, restaurant.cuisine),

                const SizedBox(width: 16),

                _detailItem(Icons.access_time, restaurant.deliveryTime),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ==========================
          // STATUS
          // ==========================
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 9),
            child: Row(
              children: [
                Icon(
                  restaurant.isOpen ? Icons.circle_outlined : Icons.access_time,
                  size: 12,
                  color: restaurant.isOpen ? Colors.green : Colors.red,
                ),

                const SizedBox(width: 4),

                Text(
                  restaurant.isOpen ? 'Open' : 'Closed',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: restaurant.isOpen ? Colors.green : Colors.red,
                  ),
                ),

                const SizedBox(width: 8),

                const Text('|', style: TextStyle(color: Colors.grey)),

                const SizedBox(width: 8),

                Text(
                  restaurant.openingTime,
                  style: const TextStyle(fontSize: 9, color: Color(0xFF555555)),
                ),

                const Spacer(),

                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.red,
                  size: 12,
                ),

                const SizedBox(width: 2),

                const Text(
                  'Distance',
                  style: TextStyle(color: Colors.red, fontSize: 9),
                ),

                const SizedBox(width: 7),

                const Text('|', style: TextStyle(color: Colors.grey)),

                const SizedBox(width: 7),

                Text(
                  restaurant.distance,
                  style: const TextStyle(fontSize: 9, color: Color(0xFF555555)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFF6F2C), size: 12),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 10, color: Color(0xFF252B35)),
        ),
      ],
    );
  }
}
