import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Container(
      height: 168,
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 18,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFFF823E),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // Background food doodle
          Positioned.fill(
            child: Opacity(
              opacity: 0.20,
              child: Image.asset(
                'assets/images/home_pattern.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              // PROFILE IMAGE
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // USER DETAILS
              Expanded(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello, John !',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: const [
                        Icon(
                          Icons.location_on,
                          size: 15,
                          color: Colors.black,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Chennai, Tamil Nadu',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // FAVORITE
              _headerButton(
                icon: Icons.favorite_border,
                onTap: controller.openFavorites,
              ),

              const SizedBox(width: 8),

              // NOTIFICATION
              _headerButton(
                icon: Icons.notifications_none,
                onTap: controller.openNotifications,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF17202A),
          size: 25,
        ),
      ),
    );
  }
}