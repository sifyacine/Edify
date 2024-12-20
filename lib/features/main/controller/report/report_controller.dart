import 'package:dio/dio.dart';
import 'package:edify/utils/loaders/loaders.dart';
import 'package:get/get.dart';

abstract class SendReportController extends GetxController {
  sendREport(String type, int member, int userID, String content);
  changeSelected(String? value);
}

class SendReportControllerImp extends SendReportController {
  String type = Get.arguments['type'];
  int member = Get.arguments['member'];
  int userID = Get.arguments['userID'];

  Dio dio = Dio();
  RxBool isLoading = false.obs;
  List<String> reportReasons = [
    'Sexual content',
    'Violent or repulsive content',
    'Hateful or abusive content',
    'Harassment or bullying',
    'Harmful or dangerous acts',
    'Misinformation',
    'Child abuse',
    'Promotes terrorism',
    'Spam or misleading',
  ];
  RxString? selectedReason = "".obs;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  sendREport(String type, int member, int userID, String content) async {
    print(true);
    isLoading.value = true;
    try {
      var response = await dio.post(
          "https://education15845d.pythonanywhere.com/reports/report/",
          data: {
            "type": type,
            "member": member,
            "user_id": userID,
            "content": content
          });
      print(response.statusCode);
      if (response.statusCode == 201) {}
    } catch (e) {
      print(e);
    }
    Get.back();
    isLoading.value = false;
  }

  @override
  changeSelected(String? value) {
    selectedReason!.value = value!;
  }
}
