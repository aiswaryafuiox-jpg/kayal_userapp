import 'package:flutter/material.dart';
import 'package:kayal_userapp/core/utils/helper/texthelper.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            title,
            style:TextHelper.heading1
          ),
          const Spacer(),

          GestureDetector(
            onTap: onTap,
            child: const Text(
              'View',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF6F2C),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
