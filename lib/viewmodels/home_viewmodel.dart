import 'package:ecommerce_sample/models/product_model.dart';
import 'package:ecommerce_sample/services/product_service.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final _productService = ProductService();

  ProductListModel? _productListModel;

  List<ProductModel> get productList {
    return _productListModel?.products ?? [];
  }

  int get productListLength {
    return _productListModel?.products?.length ?? 0;
  }

  @override
  onReady() async {
    super.onReady();
    await getProductList();
  }

  getProductList() async {
    _productListModel = await _productService.getProductList();
    update();
  }
}