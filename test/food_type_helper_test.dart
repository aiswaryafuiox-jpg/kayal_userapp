import 'package:flutter_test/flutter_test.dart';
import 'package:kayal_userapp/core/utils/helper/food_type_helper.dart';
import 'package:kayal_userapp/data/model/order_summary_response_model.dart';
import 'package:kayal_userapp/data/model/category_products_response_model.dart';
import 'package:kayal_userapp/data/model/product_details_response_model.dart';

void main() {
  group('FoodTypeHelper & Veg/Non-Veg Determination Tests', () {
    test('Correctly identifies non-veg items with food_type 1', () {
      expect(
        FoodTypeHelper.determineIsVeg(
          foodType: 1,
          productName: 'Chicken Briyani',
        ),
        isFalse,
      );
      expect(
        FoodTypeHelper.determineType(
          foodType: 1,
          productName: 'Chicken Briyani',
        ),
        'Non-Veg',
      );
    });

    test('Correctly identifies veg items with food_type 0', () {
      expect(
        FoodTypeHelper.determineIsVeg(
          foodType: 0,
          productName: 'Pineapple Juice',
        ),
        isTrue,
      );
      expect(
        FoodTypeHelper.determineType(
          foodType: 0,
          productName: 'Pineapple Juice',
        ),
        'Veg',
      );
    });

    test('Correctly identifies non-veg items by name keywords even without food_type', () {
      expect(FoodTypeHelper.determineIsVeg(productName: 'Mutton Chukka'), isFalse);
      expect(FoodTypeHelper.determineIsVeg(productName: 'Fish Fry'), isFalse);
      expect(FoodTypeHelper.determineIsVeg(productName: 'Prawn Masala'), isFalse);
      expect(FoodTypeHelper.determineIsVeg(productName: 'Egg Fried Rice'), isFalse);
      expect(FoodTypeHelper.determineIsVeg(productName: 'Crab Curry'), isFalse);
    });

    test('OrderSummaryItemModel accurately parses non-veg Chicken Briyani', () {
      final json = {
        "product_id": 1,
        "name": "Chicken briyani",
        "food_type": 1,
        "mrp": 200,
        "sell_price": 180,
        "quantity": 2,
      };

      final item = OrderSummaryItemModel.fromJson(json);
      expect(item.name, 'Chicken Briyani');
      expect(item.isVeg, isFalse);
      expect(item.type, 'Non-Veg');
    });

    test('CategoryProductItemModel accurately parses non-veg Mutton Briyani', () {
      final json = {
        "product_id": 2,
        "name": "Mutton briyani",
        "food_type": 1,
        "mrp": 220,
        "sell_price": 198,
      };

      final item = CategoryProductItemModel.fromJson(json);
      expect(item.name, 'Mutton Briyani');
      expect(item.isVeg, isFalse);
      expect(item.type, 'Non-Veg');
    });

    test('ProductDetailDataModel accurately parses non-veg Chicken Briyani', () {
      final json = {
        "product_id": 1,
        "name": "Chicken briyani",
        "food_type": 1,
        "sell_price": 180,
      };

      final item = ProductDetailDataModel.fromJson(json);
      expect(item.name, 'Chicken Briyani');
      expect(item.isVeg, isFalse);
      expect(item.type, 'Non-Veg');
    });
  });
}
