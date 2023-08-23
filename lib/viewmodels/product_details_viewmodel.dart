import 'package:get/get.dart';

import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductDetailsViewModel extends GetxController {
  final num productId;
  ProductDetailsViewModel(this.productId);

  final _productService = ProductService();
  ProductModel? _productModel;

  ProductModel? get productModel {
    return _productModel;
  }

  @override
  onReady() async {
    super.onReady();
    await getProduct(productId);
  }

  getProduct(num productId) async {
    _productModel = await _productService.getProduct(productId);
    update();
  }
}