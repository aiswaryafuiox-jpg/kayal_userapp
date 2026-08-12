import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kayal_userapp/presentation/controller/product_controller.dart';
import 'package:kayal_userapp/presentation/view/product/widgets/product_card.dart';
import 'package:kayal_userapp/presentation/widgets/app_bar.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      
      appBar: CustomAppBar(
        title: 'Product List',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: controller.openFilter,
              child: const Icon(
                Icons.filter_alt_outlined,
                color: Color(0xFF3A4A7A),
                size: 24,
              ),
            ),
          ),
        ],
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Obx(
                  () => GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75, // Adjust based on your image and content
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: controller.products[index],
                        controller: controller,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: controller.viewCart,
        backgroundColor: const Color(0xFFFF823E),
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.shopping_cart_outlined,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}
