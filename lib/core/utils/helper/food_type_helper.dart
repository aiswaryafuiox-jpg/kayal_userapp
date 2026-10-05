class FoodTypeHelper {
  /// Determines if an item is vegetarian.
  /// Backend specification:
  /// - food_type: 0 -> Veg
  /// - food_type: 1 -> Non-Veg
  /// - is_veg: true / 1 -> Veg, false / 0 -> Non-Veg
  /// - type string: 'Veg' vs 'Non-Veg'
  static bool determineIsVeg({
    dynamic foodType,
    dynamic isVeg,
    dynamic vegStatus,
    String? type,
    String? productName,
  }) {
    // 1. Check explicit name keywords
    final nameLower = (productName ?? '').toLowerCase().trim();
    if (nameLower.isNotEmpty) {
      const nonVegKeywords = [
        'chicken',
        'mutton',
        'beef',
        'pork',
        'fish',
        'prawn',
        'prawns',
        'crab',
        'egg',
        'eggs',
        'meat',
        'bacon',
        'duck',
        'turkey',
        'squid',
        'shrimp',
        'non-veg',
        'nonveg',
        'non veg',
      ];
      for (final kw in nonVegKeywords) {
        if (nameLower.contains(kw)) {
          return false;
        }
      }
    }

    // 2. Check explicit foodType integer or string
    if (foodType != null) {
      final ftStr = foodType.toString().trim().toLowerCase();
      if (ftStr == '1' || ftStr.contains('non')) {
        return false;
      }
      if (ftStr == '0' || (ftStr.contains('veg') && !ftStr.contains('non'))) {
        return true;
      }
    }

    // 3. Check explicit type string
    if (type != null && type.trim().isNotEmpty) {
      final t = type.trim().toLowerCase();
      if (t.contains('non')) {
        return false;
      }
      if (t.contains('veg')) {
        return true;
      }
    }

    // 4. Check explicit isVeg / vegStatus flag
    if (isVeg != null) {
      if (isVeg == false || isVeg == 0 || isVeg == '0' || isVeg == 'false') {
        return false;
      }
      if (isVeg == true || isVeg == 1 || isVeg == '1' || isVeg == 'true') {
        return true;
      }
    }

    if (vegStatus != null) {
      final vs = vegStatus.toString().trim().toLowerCase();
      if (vs == '0' || vs == 'false' || vs.contains('non')) {
        return false;
      }
      if (vs == '1' || vs == 'true' || vs.contains('veg')) {
        return true;
      }
    }

    // Default to true (Veg) if no non-veg indicators found
    return true;
  }

  /// Returns 'Veg' or 'Non-Veg' formatted string
  static String determineType({
    dynamic foodType,
    dynamic isVeg,
    dynamic vegStatus,
    String? type,
    String? productName,
  }) {
    final isVegResult = determineIsVeg(
      foodType: foodType,
      isVeg: isVeg,
      vegStatus: vegStatus,
      type: type,
      productName: productName,
    );
    return isVegResult ? 'Veg' : 'Non-Veg';
  }
}
