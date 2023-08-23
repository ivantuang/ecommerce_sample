import 'package:ecommerce_sample/viewmodels/product_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../services/notification_service.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});


  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {

  late final NotificationService notificationService;

  @override
  void initState() {
    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsViewModel>(
      init: ProductDetailsViewModel(Get.arguments.first),
      builder: (controller) {
        return Scaffold(
          body: Visibility(
            visible: controller.productModel != null,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Visibility(
                        visible: controller.productModel?.images?.isNotEmpty ?? false,
                        child: ImgCarousel(images: controller.productModel?.images)
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${controller.productModel?.brand} ${controller.productModel?.title}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.black54
                                ),
                              ),
                              const SizedBox(height: 6),
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: Colors.redAccent,
                                  ),
                                  text: '\$${((controller.productModel?.price ?? 0) * (1 - ((controller.productModel?.discountPercentage ?? 0)/100))).toStringAsFixed(0)} ',
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '\$${controller.productModel?.price}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.black12,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  '-${controller.productModel?.discountPercentage?.toStringAsFixed(0)}%',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              RatingBarIndicator(
                                  rating: controller.productModel?.rating?.toDouble() ?? 0.0,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemSize: 20,
                                  itemCount: 5
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(thickness: 2,),
                              ),
                              Text(
                                'Product Description',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w700
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${controller.productModel?.description}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.all(15),
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        )
                      ),
                      child: const Text(
                        'ADD TO CART'
                      ),
                      onPressed: () {
                        notificationService.showLocalNotification(
                            id: 0,
                            title: "Ecommerce Sample",
                            body: "Added ${controller.productModel?.title} to the cart",
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ImgCarousel extends StatelessWidget {

  final List<String>? images;
  int _current = 0;

  ImgCarousel({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.topLeft,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      height: MediaQuery.of(context).size.width * 0.7,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }
                  ),
                  items: images?.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CachedNetworkImage(
                          imageUrl: i,
                        );
                      },
                    );
                  }).toList(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images?.asMap().entries.map((entry) {
                return Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.redAccent)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                );
              }).toList() ?? [],
            ),
          ],
        );
      },
    );
  }

}