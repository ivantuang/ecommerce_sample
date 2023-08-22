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
}