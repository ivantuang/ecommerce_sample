import 'package:ecommerce_sample/viewmodels/product_details_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});


  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailsViewModel>(
      init: ProductDetailsViewModel(),
      builder: (controller) {
        return Container(color: Colors.amber,);
      },
    );
  }

}