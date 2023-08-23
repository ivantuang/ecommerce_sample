import '../api/api_base.dart';
import '../models/product_model.dart';
import 'package:get/get.dart';

class ProductService {
  final _apiBase = Get.find<ApiBase>();

  Future<ProductListModel?> getProductList() async {
    ProductListModel? productListModel;

    final entity = await _apiBase.loadEntityData('/products');
    if (entity != null) {
      productListModel = ProductListModel.fromJson(entity);
    }

    return productListModel;
  }

  Future<ProductModel?> getProduct(num productId) async {
    ProductModel? productModel;

    final entity = await _apiBase.loadEntityData('/products/$productId');
    if (entity != null) {
      productModel = ProductModel.fromJson(entity);
    }

    return productModel;
  }

  Future<ProductListModel?> searchProducts(String query) async {
    ProductListModel? productListModel;

    final entity = await _apiBase.loadEntityData('/products/search', query: {
      'q': query
    });
    if (entity != null) {
      productListModel = ProductListModel.fromJson(entity);
    }

    return productListModel;
  }
}