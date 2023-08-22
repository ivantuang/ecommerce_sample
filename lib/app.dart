import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'app_pages.dart';

class App extends StatefulWidget {

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: GetMaterialApp(
        title: 'Ecommerce Sample',
        locale: const Locale('en'),
        fallbackLocale: const Locale('en'),
        getPages: AppPage.routes,
        initialRoute: AppRoute.homePage,
      ),
    );
  }

}