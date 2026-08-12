import 'package:flutter/material.dart';
import 'package:kayal_userapp/core/const/app_color.dart';


import 'package:kayal_userapp/presentation/controller/category_controller.dart';

class CategorySearchBar extends StatelessWidget {
  const CategorySearchBar({
    required this.controller,
    super.key,
  });

  final CategoryController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        24,
        24,
        24,
        0,
      ),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.searchbackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [

            const SizedBox(width: 15),

            // =========================
            // SEARCH ICON
            // =========================

            const Icon(
              Icons.search,
              color: Color(0xFFFF823E),
              size: 24,
            ),

            const SizedBox(width: 10),

            // =========================
            // SEARCH FIELD
            // =========================

            Expanded(
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.searchCategory,
                decoration: const InputDecoration(
                  hintText: 'Search for food or categories',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7B7F87),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),

            // =========================
            // FILTER
            // =========================

            GestureDetector(
              onTap: controller.openFilter,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                ),
                child: Icon(
                  Icons.tune,
                  color: Color(0xFFFF823E),
                  size: 23,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}