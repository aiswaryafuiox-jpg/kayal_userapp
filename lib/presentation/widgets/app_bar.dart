import 'package:flutter/material.dart';
import 'package:kayal_userapp/core/const/app_color.dart';


class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.actionText,
    this.onActionPressed,
    this.onBackPressed,
    this.showBackButton = true,
  });

  final String title;
  final List<Widget>? actions;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final VoidCallback? onBackPressed;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,

      // =========================================
      // BACK BUTTON
      // =========================================

      leadingWidth: showBackButton ? 60 : 24,

      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                onTap: onBackPressed ??
                    () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 35,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(.06),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Color(0xff3A4A7A),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),

      // =========================================
      // TITLE
      // =========================================

      titleSpacing: showBackButton ? 8 : 20,

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),

      // =========================================
      // ACTIONS
      // =========================================

      actions: [
        if (actionText != null)
          Padding(
            padding:
                const EdgeInsets.only(right: 16),
            child: SizedBox(
              height: 34,
              child: ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor:
                      const Color(0xffFF8A3D),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionText!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(70);
}