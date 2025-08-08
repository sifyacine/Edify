import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UploadProgress extends StatelessWidget {
  final RxDouble value;
  final String uploadProgress;
  const UploadProgress(
      {super.key, required this.value, required this.uploadProgress});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: value.value == 1.0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                      'assets/images/animations/141397-loading-juggle.json'),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      " ... جار النشر ",
                      style: TextStyle(
                          fontFamily: 'CairoPlay',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/images/animations/loading2.json'),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[100]),
                      child: LinearProgressIndicator(
                        value: value.value,
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(1, 1))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        " $uploadProgress% لا تغادر الصفحة حتى ينتهي التحميل ",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NotoSansArabic'),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "تنبيه: اذا غادرت الصفحة فستفقد بيانات التحميل",
                      style:
                          TextStyle(color: Colors.red, fontFamily: 'CairoPlay'),
                    ),
                  )
                ],
              ));
  }
}
