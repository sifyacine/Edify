import 'dart:async' as async;

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;

import 'package:get/get.dart';

Dio myDio = Dio();

class TDioHelper {
  static post(
      String url, Map<String, dynamic> data, RxDouble uploadProgress) async {
    int send = 0;
    dio.FormData formData = dio.FormData.fromMap(data);

    // إرسال الطلب مع متابعة التقدم
    dio.Response response = await myDio.post(
      url,
      data: formData,
      onSendProgress: (int sent, int total) {
        // حساب التقدم بالنسبة المئوية
        double progress = sent / total;
        send = sent;
        print('Progress: ${(progress * 100).toStringAsFixed(2)}%');

        // يمكنك تحديث واجهة المستخدم هنا
        uploadProgress.value = progress;
      },
      options: dio.Options(
        headers: {
          "Range": "bytes=$send-", // إعلام الخادم باستئناف التحميل
        },
      ),
    );
    print(response);
    print(response.statusCode);

    return response;
  }

  static get(String url, Map data) async {
    dio.Response response = await myDio.get(
      url,
      data: {},
      onReceiveProgress: (received, total) {
        // تحديث واجهة المستخدم بعرض تقدم التنزيل
        print('Received: $received / Total: $total');
      },
    );
    return response;
  }
}
