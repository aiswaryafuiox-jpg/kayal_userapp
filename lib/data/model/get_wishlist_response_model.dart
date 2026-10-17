
import 'dart:convert';

GetWishlistResponseModel getWishlistResponseModelFromJson(String str) => GetWishlistResponseModel.fromJson(json.decode(str));

String getWishlistResponseModelToJson(GetWishlistResponseModel data) => json.encode(data.toJson());

class GetWishlistResponseModel {
    bool? success;
    WishlistData? data;
    String? message;
    int? code;

    GetWishlistResponseModel({
        this.success,
        this.data,
        this.message,
        this.code,
    });

    factory GetWishlistResponseModel.fromJson(Map<String, dynamic> json) => GetWishlistResponseModel(
        success: json["success"],
        data: json["data"] == null ? null : WishlistData.fromJson(json["data"]),
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
class WishlistData {
    List<WishlistItemModel>? items;
    int? currentPage;
    int? lastPage;
    int? total;

  WishlistData({
        this.items,
        this.currentPage,
        this.lastPage,
        this.total,
    });

    factory WishlistData.fromJson(Map<String, dynamic> json) => WishlistData(
        items: json["items"] == null ? [] : List<WishlistItemModel>.from(json["items"]!.map((x) => WishlistItemModel.fromJson(x))),
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
        "current_page": currentPage,
        "last_page": lastPage,
        "total": total,
    };
}

class WishlistItemModel {
   int? productId;
    String? name;
    String? imageUrl;
    bool? isVeg;
    num? mrp;
    num? sellPrice;
    bool? isFavorite;

    WishlistItemModel({
        this.productId,
        this.name,
        this.imageUrl,
        this.isVeg,
        this.mrp,
        this.sellPrice,
        this.isFavorite,
    });

    factory WishlistItemModel.fromJson(Map<String, dynamic> json) => WishlistItemModel(
        productId: json["product_id"],
        name: json["name"],
        imageUrl: json["image_url"],
        isVeg: json["is_veg"],
        mrp: json["mrp"],
        sellPrice: json["sell_price"],
        isFavorite: json["is_favorite"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "name": name,
        "image_url": imageUrl,
        "is_veg": isVeg,
        "mrp": mrp,
        "sell_price": sellPrice,
        "is_favorite": isFavorite,
    };
}
