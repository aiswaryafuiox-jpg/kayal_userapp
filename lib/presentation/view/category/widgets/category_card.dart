import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.name,
    required this.image,
    required this.onTap,
    this.isClosed = false,
    super.key,
  });

  final String name;
  final String image;
  final VoidCallback onTap;
  final bool isClosed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          10,
          10,
          10,
          8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // =========================
            // IMAGE
            // =========================
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Opacity(
                  opacity: isClosed ? 0.45 : 1.0,
                  child: Image.asset(
                    image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF5F5F5),
                        child: const Icon(
                          Icons.fastfood,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // =========================
            // NAME
            // =========================
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isClosed
                    ? const Color(0xFF8C9199)
                    : const Color(0xFF202733),
              ),
            ),
          ],
        ),
      ),
    );
  }
}