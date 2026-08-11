import 'package:flutter/material.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantItem restaurant;

  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ==========================
          // IMAGE
          // ==========================

          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.asset(
                  restaurant.image,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),

              // FREE DELIVERY
              Positioned(
                left: 10,
                bottom: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF823E),
                    borderRadius:
                        BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Free Delivery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
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
            padding: const EdgeInsets.fromLTRB(
              18,
              8,
              18,
              8,
            ),
            child: Text(
              restaurant.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF252B35),
              ),
            ),
          ),

          // ==========================
          // DETAILS
          // ==========================

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: Row(
              children: [
                _detailItem(
                  Icons.restaurant_menu,
                  restaurant.cuisine,
                ),

                const SizedBox(width: 18),

                _detailItem(
                  Icons.access_time,
                  restaurant.deliveryTime,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ==========================
          // STATUS
          // ==========================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              18,
              0,
              18,
              10,
            ),
            child: Row(
              children: [
                Icon(
                  restaurant.isOpen
                      ? Icons.circle_outlined
                      : Icons.access_time,
                  size: 14,
                  color: restaurant.isOpen
                      ? Colors.green
                      : Colors.red,
                ),

                const SizedBox(width: 4),

                Text(
                  restaurant.isOpen
                      ? 'Open'
                      : 'Closed',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: restaurant.isOpen
                        ? Colors.green
                        : Colors.red,
                  ),
                ),

                const SizedBox(width: 8),

                const Text(
                  '|',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  restaurant.openingTime,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF555555),
                  ),
                ),

                const Spacer(),

                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.red,
                  size: 14,
                ),

                const SizedBox(width: 2),

                const Text(
                  'Distance',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(width: 7),

                const Text(
                  '|',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(width: 7),

                Text(
                  restaurant.distance,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF555555),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFFF6F2C),
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF252B35),
          ),
        ),
      ],
    );
  }
}