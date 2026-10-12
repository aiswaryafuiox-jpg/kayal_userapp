import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/api_routes.dart';
import 'package:kayal_userapp/core/utils/navigation/app_routes.dart';
import 'package:kayal_userapp/data/model/search_response_model.dart';
import 'package:kayal_userapp/presentation/controller/home_controller.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/presentation/controller/user_search_controller.dart';

class HomeSearchResults extends StatelessWidget {
  final UserSearchController searchController;
  final HomeController homeController;

  const HomeSearchResults({
    super.key,
    required this.searchController,
    required this.homeController,
  });

  String _imageUrl(String? path) {
    final value = path?.trim() ?? '';
    if (value.isEmpty || value == 'null') return '';
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return '${ApiRoutes.imageBaseURL}$value';
  }

  ProductModel _product(SearchDishModel dish) => ProductModel(
    id: dish.id?.toString() ?? '',
    name: dish.name,
    type: dish.type,
    isVeg: dish.isVeg,
    oldPrice: dish.oldPrice,
    newPrice: dish.price,
    image: _imageUrl(dish.image).isNotEmpty
        ? _imageUrl(dish.image)
        : 'assets/images/product1.png',
  );

  RestaurantItem _restaurant(SearchRestaurantModel item) {
    final delivery = item.deliveryTime?.trim();
    return RestaurantItem(
      id: item.id,
      name: item.name,
      image: _imageUrl(item.image).isNotEmpty
          ? _imageUrl(item.image)
          : 'assets/images/homeimg.png',
      cuisine: item.cuisine?.isNotEmpty == true ? item.cuisine! : 'Restaurant',
      deliveryTime: delivery?.isNotEmpty == true
          ? (delivery!.toLowerCase().contains('min')
                ? delivery
                : '$delivery mins')
          : '30 mins',
      distance: item.distance?.isNotEmpty == true
          ? '${item.distance} Km'
          : 'Nearby',
      openingTime: item.openingTime?.isNotEmpty == true
          ? item.openingTime!
          : 'Opening hours unavailable',
      isOpen: item.isOpen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final result = searchController.searchResult.value;
      final loading = searchController.isLoading.value;

      return Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 110),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (loading)
              const LinearProgressIndicator(
                minHeight: 2,
                color: Color(0xFFFF823E),
              ),
            if (!searchController.hasSearched.value ||
                (loading && result == null))
              const _DropdownMessage(
                icon: Icons.search,
                message: 'Finding matching products...',
              )
            else if (result == null || (!loading && result.isEmpty))
              const _DropdownMessage(
                icon: Icons.search_off_rounded,
                message: 'No matching products or restaurants',
              )
            else ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                child: Text(
                  'Suggestions for "${searchController.query.value.trim()}"',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
              if (result.dishes.isNotEmpty) ...[
                const _SectionLabel('Products'),
                ...result.dishes.map(
                  (dish) => _SuggestionTile(
                    imageUrl: _imageUrl(dish.image),
                    fallbackIcon: Icons.fastfood_outlined,
                    title: dish.name,
                    subtitle: '${dish.type}  |  Rs. ${_money(dish.price)}',
                    trailingColor: dish.isVeg ? Colors.green : Colors.red,
                    onTap: () => Get.toNamed(
                      AppRoutes.productDetail,
                      arguments: {'product': _product(dish), 'isClosed': false},
                    ),
                  ),
                ),
              ],
              if (result.categories.isNotEmpty) ...[
                const _SectionLabel('Categories'),
                ...result.categories.map(
                  (category) => _SuggestionTile(
                    imageUrl: _imageUrl(category.image),
                    fallbackIcon: Icons.restaurant_menu,
                    title: category.name,
                    subtitle: 'View all products in this category',
                    onTap: () => Get.toNamed(
                      AppRoutes.product,
                      arguments: {
                        'categoryId': category.id,
                        'category': category.name,
                      },
                    ),
                  ),
                ),
              ],
              if (result.restaurants.isNotEmpty) ...[
                const _SectionLabel('Restaurants'),
                ...result.restaurants.map((item) {
                  final restaurant = _restaurant(item);
                  return _SuggestionTile(
                    imageUrl: _imageUrl(item.image),
                    fallbackIcon: Icons.storefront_outlined,
                    title: item.name,
                    subtitle:
                        '${item.cuisine ?? 'Restaurant'}  |  ${restaurant.deliveryTime}',
                    trailingColor: item.isOpen ? Colors.green : Colors.red,
                    onTap: () => homeController.onRestaurantTap(restaurant),
                  );
                }),
              ],
            ],
          ],
        ),
      );
    });
  }

  String _money(double amount) =>
      amount % 1 == 0 ? amount.toInt().toString() : amount.toStringAsFixed(2);
}

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF252B35),
        ),
      ),
    );
  }
}

class _DropdownMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const _DropdownMessage({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFFF823E)),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  final String imageUrl;
  final IconData fallbackIcon;
  final String title;
  final String subtitle;
  final Color? trailingColor;
  final VoidCallback onTap;

  const _SuggestionTile({
    required this.imageUrl,
    required this.fallbackIcon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailingColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFF1F3F5))),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _fallback(),
                    )
                  : _fallback(),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF252B35),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            if (trailingColor != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.circle, size: 9, color: trailingColor),
            ],
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFFFF823E)),
          ],
        ),
      ),
    );
  }

  Widget _fallback() => Container(
    width: 48,
    height: 48,
    color: const Color(0xFFFFF0E7),
    alignment: Alignment.center,
    child: Icon(fallbackIcon, color: const Color(0xFFFF823E), size: 23),
  );
}
