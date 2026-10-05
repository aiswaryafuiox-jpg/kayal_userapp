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
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFECE0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.category_outlined,
                    size: 36,
                    color: Color(0xFFFF823E),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF252B35),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'No categories available',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
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