import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/app_color.dart';

import 'package:kayal_userapp/presentation/controller/home_controller.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SizedBox(
      height: 120,
      child: Obx(() {
        if (controller.isCategoriesLoading.value &&
            controller.categories.isEmpty) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          );
        }

        if (controller.categories.isEmpty) {
          return const Center(
            child: Text(
              'No Data',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
          );
        }

        final selectedIndex = controller.selectedCategory.value;

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final item = controller.categories[index];
            final selected = selectedIndex == index;

            return GestureDetector(
              onTap: () => controller.selectCategory(index),
              child: Column(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    padding: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(22),

                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image:
                            item.image.startsWith('http://') ||
                                item.image.startsWith('https://')
                            ? NetworkImage(item.image)
                            : AssetImage(item.image),
                      ),
                      border: selected
                          ? Border.all(
                              width: selected ? 2 : 0,
                              color: selected
                                  ? AppColors.primary
                                  : const Color(0xFFE2E8F0),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    item.name,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.primary : AppColors.black,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
