// To parse this JSON data, do
//
//     final getCartResponseModel = getCartResponseModelFromJson(jsonString);

import 'dart:convert';
import 'package:kayal_userapp/core/utils/helper/string_extensions.dart';

GetCartResponseModel getCartResponseModelFromJson(String str) =>
    GetCartResponseModel.fromJson(json.decode(str));

String getCartResponseModelToJson(GetCartResponseModel data) =>
    json.encode(data.toJson());

class GetCartResponseModel {
  bool? success;
  GetCartData? data;
  String? message;
  int? code;

  GetCartResponseModel({
    this.success,
    this.data,
    this.message,
    this.code,
  });

  List<CartItem> get items => data?.items ?? [];
  String get formattedErrorMessage => message ?? '';

  factory GetCartResponseModel.fromJson(Map<String, dynamic> json) =>
      GetCartResponseModel(
        success: json["success"],
        data: json["data"] == null ? null : GetCartData.fromJson(json["data"]),
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "message": message,
    "code": code,
  };
}

class GetCartData {
  String? cartId;
  List<CartItem>? items;
  double? totalAmount;

  GetCartData({
    this.cartId,
    this.items,
    this.totalAmount,
  });

  double get total => totalAmount ?? 0.0;

  factory GetCartData.fromJson(Map<String, dynamic> json) => GetCartData(
    cartId: json["cart_id"]?.toString(),
    items: json["items"] == null
        ? []
        : List<CartItem>.from(
            json["items"]!.map((x) => CartItem.fromJson(x)),
          ),
    totalAmount: (json["total_amount"] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "cart_id": cartId,
    "items": items == null
        ? []
        : List<dynamic>.from(items!.map((x) => x.toJson())),
    "total_amount": totalAmount,
  };
}

class CartItem {
  String? cartItemId;
  int? productId;
  String? name;
  String? imageUrl;
  bool? isVeg;
  int? mrp;
  double? sellPrice;
  int? discountPct;
  int? quantity;

  CartItem({
    this.cartItemId,
    this.productId,
    this.name,
    this.imageUrl,
    this.isVeg,
    this.mrp,
    this.sellPrice,
    this.discountPct,
    this.quantity,
    String? id,
    String? image,
    double? oldPrice,
    double? newPrice,
    String? discount,
    String? type,
  }) {
    if (id != null && cartItemId == null) cartItemId = id;
    if (image != null && imageUrl == null) imageUrl = image;
    if (newPrice != null && sellPrice == null) sellPrice = newPrice;
    if (oldPrice != null && mrp == null) mrp = oldPrice.toInt();
    if (type != null && isVeg == null) {
      isVeg =
          type.toLowerCase().contains('veg') &&
          !type.toLowerCase().contains('non');
    }
  }

  String get id => cartItemId ?? productId?.toString() ?? '';
  String get displayName => (name ?? '').capitalizeWords();
  String get image => imageUrl ?? '';
  bool get isVegetarian => isVeg ?? true;
  double get newPrice => sellPrice ?? (mrp?.toDouble() ?? 0.0);
  double get oldPrice => (mrp != null && mrp! > 0) ? mrp!.toDouble() : newPrice;
  String get type => (isVeg ?? true) ? 'Veg' : 'Non-Veg';
  String get discount => discountPct != null ? '$discountPct %' : '';
  int get qty => quantity ?? 1;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    cartItemId: json["cart_item_id"]?.toString(),
    productId: json["product_id"] is int
        ? json["product_id"]
        : int.tryParse(json["product_id"]?.toString() ?? ''),
    name: json["name"],
    imageUrl: json["image_url"],
    isVeg: json["is_veg"],
    mrp: (json["mrp"] as num?)?.toInt(),
    sellPrice: (json["sell_price"] as num?)?.toDouble(),
    discountPct: (json["discount_pct"] as num?)?.toInt(),
    quantity: (json["quantity"] as num?)?.toInt(),
  );

  Map<String, dynamic> toJson() => {
    "cart_item_id": cartItemId,
    "product_id": productId,
    "name": name,
    "image_url": imageUrl,
    "is_veg": isVeg,
    "mrp": mrp,
    "sell_price": sellPrice,
    "discount_pct": discountPct,
    "quantity": quantity,
  };
}

typedef GetCartItemModel = CartItem;
typedef GetCartDataModel = GetCartData;
typedef CartItemModel = CartItem;
