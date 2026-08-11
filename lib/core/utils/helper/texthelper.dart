import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayal_userapp/core/const/app_color.dart';


class TextHelper {
  static TextStyle get heading1 {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.textprimary,
    );
  }
  static TextStyle get heading2 {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textprimary,
    );
  }
   static TextStyle get heading3 {
    return GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: AppColors.textprimary,
    );
  }
  static TextStyle get button {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textprimary,
    );
  }
  static TextStyle get locationheading {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.locationtext,
    );
  }
}