import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class OfferTimer extends StatelessWidget {
  const OfferTimer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: const DecorationImage(
          image: AssetImage(
            'assets/images/offer_background.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Text(
            'Limited Time Offer End in:',
            style: TextStyle(
              color: Color(0xFFFF823E),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(width: 5),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Obx(
              () => Text(
                controller.formattedOfferTime,
                style: const TextStyle(
                  color: Color(0xFFFF823E),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const Spacer(),

          GestureDetector(
            onTap: controller.viewOffers,
            child: const Text(
              'View',
              style: TextStyle(
                color: Color(0xFFFF823E),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                decoration:
                    TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}