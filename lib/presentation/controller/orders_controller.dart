import 'package:get/get.dart';
import 'package:kayal_userapp/core/const/app_images.dart';
import 'package:kayal_userapp/presentation/view/track_order/view_order_screen.dart';

class OrderItem {
  final String title;
  final String type;
  final bool isVeg;
  final String datetime;
  final double price;
  final String status;
  final String image;

  OrderItem({
    required this.title,
    required this.type,
    required this.isVeg,
    required this.datetime,
    required this.price,
    required this.status,
    required this.image,
  });
}

class OrdersController extends GetxController {
  final ordersList = <OrderItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    // Simulated data matching the design
    ordersList.assignAll([
      OrderItem(
        title: "Chicken Pizza",
        type: "Veg",
        isVeg: true,
        datetime: "Jun 24, 2026 . 12:45 PM",
        price: 120,
        status: "Out Of Delivery",
        image: productImg1,
      ),
      OrderItem(
        title: "The Spice Pizza",
        type: "Veg",
        isVeg: true,
        datetime: "Jun 24, 2026 . 12:45 PM",
        price: 120,
        status: "Cancelled",
        image: productImg2,
      ),
      OrderItem(
        title: "The Spice Pizza",
        type: "Veg",
        isVeg: true,
        datetime: "Jun 24, 2026 . 12:45 PM",
        price: 120,
        status: "Delivered",
        image: productImg3,
      ),
      OrderItem(
        title: "The Spice Pizza",
        type: "Veg",
        isVeg: true,
        datetime: "Jun 24, 2026 . 12:45 PM",
        price: 120,
        status: "Delivered",
        image: productImg4,
      ),
    ]);
  }

  void viewOrderDetails(int index) {
    Get.to(() => const ViewOrderScreen(), arguments: ordersList[index]);
  }

  void reOrder(int index) {
    // Handle re-order logic
  }
}
