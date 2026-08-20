import 'package:flutter/material.dart';
import 'package:kayal_userapp/core/const/app_color.dart';

class RestaurantUnavailableBanner extends StatelessWidget {
  final String notes;

  const RestaurantUnavailableBanner({
    super.key,
    this.notes =
        'This restaurant is currently unavailable.\nOpens today at 10:00 AM',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD6D6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notes:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            notes,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.red,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
