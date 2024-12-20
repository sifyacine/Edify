import 'package:edify/features/main/controller/report/report_controller.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class SendReport extends StatelessWidget {
  const SendReport({super.key});

  @override
  Widget build(BuildContext context) {
    SendReportControllerImp controller = Get.put(SendReportControllerImp());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "what's going on here?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Select the violation you saw in this content. Please do not submit a report without an actual violation.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: controller.reportReasons.length,
              itemBuilder: (context, index) {
                return Obx(() => RadioListTile<String>(
                      title: Text(controller.reportReasons[index]),
                      value: controller.reportReasons[index],
                      groupValue: controller.selectedReason!.value,
                      activeColor: TColors.primary,
                      onChanged: (value) {
                        controller.changeSelected(value);
                      },
                    ));
              },
            ),
          ),
          Obx(() => Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.selectedReason == null
                          ? Colors.grey.shade400
                          : controller.isLoading.value
                              ? TColors.white
                              : Colors.blue,
                      disabledForegroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: controller.selectedReason!.value.isEmpty
                        ? null
                        : () async {
                            await controller.sendREport(
                                controller.type,
                                controller.member,
                                controller.userID,
                                controller.selectedReason!.value);
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'We will check that in the future. Thanks for your report')));
                          },
                    child: controller.isLoading.value
                        ? Lottie.asset(
                            'assets/images/animations/141397-loading-juggle.json',
                            width: 100,
                            height: 50)
                        : const Text(
                            'Report',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
