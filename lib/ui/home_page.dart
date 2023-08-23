import 'package:ecommerce_sample/app_pages.dart';
import 'package:ecommerce_sample/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:blinking_text/blinking_text.dart';
import '../viewmodels/home_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeViewModel>(
        init: HomeViewModel(),
        builder: (controller) {
          return Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(),
                  Expanded(
                    child: MasonryGridView.count(
                      itemCount: controller.productListLength,
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductCardWidget(
                          product: controller.productList[index],
                          onTap: () {
                            final productId = controller.productList[index].id;
                            if (productId != null ) {
                              Get.toNamed(AppRoute.productDetailsPage, arguments: [productId]);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductCardWidget extends StatelessWidget {

  final ProductModel product;
  final Function() onTap;

  const ProductCardWidget({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: product.thumbnail ?? '',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${product.brand} ${product.title}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black54
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.redAccent,
                        ),
                        text: '\$${((product.price ?? 0) * (1 - ((product.discountPercentage ?? 0)/100))).toStringAsFixed(0)} ',
                        children: <TextSpan>[
                          TextSpan(
                            text: '\$${product.price}',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.black12,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: RatingBarIndicator(
                          rating: product.rating?.toDouble() ?? 0.0,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemSize: 15,
                          itemCount: 5
                      ),
                    ),
                    Visibility(
                      visible: (product.stock ?? 0) < 50,
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: BlinkText(
                          'Selling Fast',
                          beginColor: Colors.red,
                          endColor: Colors.transparent,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}