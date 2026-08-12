import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SizedBox(
      height: 40,
      child: Obx(() {
        // Read the Rx value while Obx is building. List item builders run
        // lazily, outside GetX's dependency-tracking scope.
        final selectedIndex = controller.selectedCategory.value;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final item = controller.categories[index];
            final selected = selectedIndex == index;

            return GestureDetector(
              onTap: () => controller.selectCategory(index),
              child: Container(
                height: 38,
                padding: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFFFFF5EF) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFFF823E)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.only(left: 2),
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Image.asset(item.image, fit: BoxFit.cover),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? const Color(0xFFFF6F2C)
                            : const Color(0xFF252B35),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
