import 'package:flutter/material.dart';
import 'package:kayal_userapp/presentation/view/category/widgets/category_card.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({
    required this.categories,
    required this.onCategoryTap,
    this.isClosed = false,
    super.key,
  });

  final List<Map<String, String>> categories;
  final Function(String) onCategoryTap;
  final bool isClosed;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(
        child: Text(
          'No categories found',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        24,
        0,
        24,
        100,
      ),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 14,
        childAspectRatio: 0.92,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];

        return CategoryCard(
          name: category['name']!,
          image: category['image']!,
          isClosed: isClosed,
          onTap: () {
            onCategoryTap(
              category['name']!,
            );
          },
        );
      },
    );
  }
}