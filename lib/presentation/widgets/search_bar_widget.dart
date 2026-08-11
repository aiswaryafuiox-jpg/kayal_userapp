import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search Your Favorites Here !!',
            hintStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777777),
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFFFF6F2C),
              size: 21,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}