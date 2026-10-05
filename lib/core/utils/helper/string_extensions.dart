extension StringCasingExtension on String {
  /// Capitalizes only the first letter of the string (e.g. "hello world" -> "Hello world")
  String capitalizeFirstLetter() {
    if (trim().isEmpty) return this;
    final trimmed = trim();
    return trimmed[0].toUpperCase() + (trimmed.length > 1 ? trimmed.substring(1) : '');
  }

  /// Capitalizes the first letter of each word in a string (e.g. "special dishes" -> "Special Dishes", "non-veg" -> "Non-Veg")
  String capitalizeWords() {
    if (trim().isEmpty) return this;
    return split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return '';
          if (word.contains('-')) {
            return word
                .split('-')
                .map((sub) {
                  if (sub.isEmpty) return '';
                  return sub[0].toUpperCase() +
                      (sub.length > 1 ? sub.substring(1).toLowerCase() : '');
                })
                .join('-');
          }
          return word[0].toUpperCase() +
              (word.length > 1 ? word.substring(1).toLowerCase() : '');
        })
        .where((word) => word.isNotEmpty)
        .join(' ');
  }

  /// Alias for capitalizeWords
  String get toTitleCase => capitalizeWords();

  /// Alias for capitalizeFirstLetter
  String get toCapitalized => capitalizeFirstLetter();
}

extension NullableStringCasingExtension on String? {
  String capitalizeFirstLetter([String defaultVal = '']) {
    if (this == null || this!.trim().isEmpty) return defaultVal;
    return this!.capitalizeFirstLetter();
  }

  String capitalizeWords([String defaultVal = '']) {
    if (this == null || this!.trim().isEmpty) return defaultVal;
    return this!.capitalizeWords();
  }

  String? capitalizeFirstLetterOrNull() {
    if (this == null || this!.trim().isEmpty) return null;
    return this!.capitalizeFirstLetter();
  }

  String? capitalizeWordsOrNull() {
    if (this == null || this!.trim().isEmpty) return null;
    return this!.capitalizeWords();
  }
}

