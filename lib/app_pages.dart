import 'package:ecommerce_sample/ui/home_page.dart';
import 'package:ecommerce_sample/ui/product_details_page.dart';
import 'package:get/get.dart';

class AppRoute {
  static const String homePage = '/homePage';
  static const String productDetailsPage = '/productDetailsPage';
}

class AppPage {
  static final routes = [
    GetPage(
      name: AppRoute.homePage,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoute.productDetailsPage,
      page: () => const ProductDetailsPage(),
    )
  ];
}