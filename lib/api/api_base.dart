import 'package:get/get.dart';
import 'package:logger/logger.dart';

extension FormDataEx on FormData {
  FormData get baseParams {
    FormData params = this;

    return params;
  }
}

extension MapEx on Map? {
  StringBuffer logString(String title) {
    StringBuffer requestLog = StringBuffer();
    requestLog.writeln('===================== $title =====================');
    this?.forEach((key, value) {
      requestLog.writeln('$key = $value');
    });
    return requestLog;
  }

  Map<String, dynamic> get baseParams {
    Map<String, dynamic> params;
    if (this == null) {
      params = <String, dynamic>{};
    } else {
      params = Map.from(this!);
    }
    return params;
  }

  Map<String, String> get baseHeaders {
    Map<String, String> params;
    if (this == null) {
      params = <String, String>{};
    } else {
      params = Map.from(this!);
    }
    params['Content-Type'] = 'application/json';
    return params;
  }
}

extension ResponseEx on Response {
  StringBuffer get responseLog {
    StringBuffer responseLog = StringBuffer();
    responseLog.writeln('===================== Response =====================');
    responseLog.writeln('statusCode = $statusCode');
    responseLog.writeln('url = ${request?.url}');
    responseLog.writeln('data = $bodyString');
    return responseLog;
  }

  StringBuffer get errorLog {
    StringBuffer errorLog = StringBuffer();
    errorLog.writeln('===================== Error =====================');
    errorLog.writeln('url = ${request?.url}');
    errorLog.writeln('statusCode = $statusCode');
    errorLog.writeln('message = $statusText');
    errorLog.writeln('data = $bodyString');
    return errorLog;
  }
}

class ServerRepository extends GetConnect {

  @override
  void onInit() {
    super.onInit();

    httpClient.baseUrl = 'https://dummyjson.com';
    httpClient.timeout = const Duration(seconds: 30);

    httpClient.addResponseModifier((request, response) {

      if (response.isOk) {
        Get.find<Logger>().d(response.responseLog);
      } else {
        Get.find<Logger>().d(response.errorLog);
      }

      return response;
    });
  }

  Future<Map?> loadEntityData(
      String url, {
        String method = 'POST',
        dynamic body,
        String? contentType,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
        bool showLoading = true,
      }) async {
    try {
      if (showLoading && Get.overlayContext != null) {
        // LoadingUtils.showLoading(Get.overlayContext!);
      }
      StringBuffer requestLog = StringBuffer();

      headers = headers.baseHeaders;

      if(body is FormData){
        body = body.baseParams;

        headers['Content-Type'] = 'multipart/form-data; boundary=${body.boundary}';

        requestLog = Map.from({
          'url' : url,
          'headers' : headers,
          'method' : method,
          'body' : body.fields.map((e) => '${e.key}: ${e.value}'),
          'file' : body.files.map((e) => '${e.key}: ${e.value.filename}'),
          'query' : query,
        }).logString('Request');

      }else if (body != null){
        body = (body as Map).baseParams;

        requestLog = Map.from({
          'url' : url,
          'headers' : headers,
          'method' : method,
          'body' : body,
          'query' : query,
        }).logString('Request');
      }

      Get.find<Logger>().d(requestLog);

      var response = await request(
          url,
          method,
          body: body,
          contentType: contentType,
          headers: headers,
          query: query
      );

      if (showLoading && Get.overlayContext != null) {
        // LoadingUtils.stopLoading(Get.overlayContext!);
      }

      if (response.isOk) {
        return response.body!;
      }
      // else if (response.statusCode == null) {
      //   return ResponseEntity(success: false, message: Label.connection_error.tr);
      // } else {
      //   return ResponseEntity(success: false, message: response.statusText ?? '', statusCode: response.statusCode);
      // }

    } catch(e, s) {
      final runTimeLog = Map.from({
        'url' : url,
        'headers' : headers,
        'method' : method,
        'body' : body,
        'query' : query
      }).logString('Runtime Error');

      Get.find<Logger>().wtf(runTimeLog, error: e, stackTrace: s);
      if (Get.overlayContext != null) {
        // LoadingUtils.stopLoading(Get.overlayContext!);
      }

      // return ResponseEntity(success: false, message: Label.parse_error.tr);
    }
  }
}