import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SubMain {
  static Future initServices() async {
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // init logger
    var logger = Logger(
        output: ConsoleOutput(),
        printer: HybridPrinter(
            PrettyPrinter(),
            debug: PrettyPrinter(printTime: true)
        )
    );
    Get.put(logger, permanent: true);

    Get.config(
        enableLog: true,
        defaultPopGesture: true,
        defaultTransition: Transition.cupertino
    );

    Get.put(logger, permanent: true);
    Get.put(logger, permanent: true);
  }
}

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (event.level == Level.debug) {
      for (var line in event.lines) {
        Get.log(line);
      }
    } else {
      for (var line in event.lines) {
        if (kDebugMode) {
          print(line);
        }
      }
    }
  }
}