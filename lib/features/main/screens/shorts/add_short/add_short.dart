import 'package:edify/features/main/controller/shorts/add_short_controller.dart';
import 'package:edify/features/main/screens/shorts/add_short/widgets/add_hashtag.dart';
import 'package:edify/features/main/screens/shorts/add_short/widgets/show_hashtags.dart';
import 'package:edify/features/main/screens/shorts/add_short/widgets/text_form_field.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/constants/text_strings.dart';
import 'package:edify/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddShort extends StatelessWidget {
  const AddShort({super.key});

  @override
  Widget build(BuildContext context) {
    AddShortControllerImp controller = Get.put(AddShortControllerImp());
    return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(TTexts.shortAppBarTitle),
            ],
          ),
        ),
        body: Form(
          key: controller.forms,
          child: Obx(() => ListView(
                shrinkWrap: true,
                children: [
                  Stepper(
                    currentStep: controller.currentStep.value,
                    onStepCancel: controller.isCompressing.value &&
                            controller.currentStep.value == 1
                        ? null
                        : controller.isPulishing.value
                            ? null
                            : controller.publishError.value
                                ? controller.publisherror()
                                : controller.currentStep.value == 0
                                    ? null
                                    : controller.isPublish.value
                                        ? null
                                        : controller.stepClose,
                    onStepContinue: controller.isPulishing.value
                        ? null
                        : controller.publishError.value
                            ? null
                            : controller.currentStep.value == 2 &&
                                    controller.isPublish.value &&
                                    controller.isPulishing.value == false
                                ? null
                                : controller.currentStep.value == 1 &&
                                        controller.isCompress.value == false
                                    ? null
                                    : controller.stepContinue,
                    steps: [
                      Step(
                          state: controller.currentStep > 0
                              ? StepState.complete
                              : StepState.disabled,
                          isActive: controller.currentStep >= 0,
                          title: const Text(TTexts.shortVideoDetails),
                          content: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              TTextFormField(
                                validator: (value) {
                                  return TValidator.validateShortTitle(
                                      value!, 5, 150);
                                },
                                controller: controller.titleController.value,
                                labelText: TTexts.shortLabelTextField,
                                hintText: TTexts.shortHintTextField,
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const AddHashtags(),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 20,
                                    child: TTextFormField(
                                      controller:
                                          controller.hashtagController.value,
                                      hintText:
                                          TTexts.shortHintTextFieldHasghtag,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                      onTap: () async {
                                        controller.addHashtag(context);
                                      },
                                      child: const Icon(Icons.send))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ShowHashtags(
                                  controller: controller,
                                  hashtags: controller.hashtags.value,
                                ),
                              )
                            ],
                          )),
                      Step(
                          isActive: controller.currentStep >= 1,
                          state: controller.currentStep > 1
                              ? StepState.complete
                              : StepState.disabled,
                          title: const Text(TTexts.shortVideoCommpress),
                          content: controller.isCompress.value
                              ? const Text(TTexts.shortSuccessfully,
                                  style: TextStyle(color: TColors.primary))
                              : controller.isCompressing.value
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          CircularProgressIndicator(),
                                          Text(TTexts.shortProccessing),
                                        ],
                                      ),
                                    )
                                  : Wrap(
                                      direction: Axis.horizontal,
                                      children: [
                                        const Text(
                                          'have an error ,please press continue to retry compressing.',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            controller.videoCompressing();
                                          },
                                          child: const Text(
                                            ' try again',
                                            style: TextStyle(
                                                backgroundColor: Color.fromARGB(
                                                    155, 105, 105, 105),
                                                color: Colors.red,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    )),
                      Step(
                          isActive: controller.currentStep >= 2,
                          state: controller.currentStep > 2
                              ? StepState.complete
                              : StepState.disabled,
                          title: const Text(TTexts.shortpublishingProgress),
                          content: controller.publishError.value
                              ? Wrap(
                                  direction: Axis.horizontal,
                                  children: [
                                    const Text(
                                      'have an error ,please press continue to retry uploading.',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.publisherror();
                                      },
                                      child: const Text(
                                        ' try again',
                                        style: TextStyle(
                                            backgroundColor: Color.fromARGB(
                                                155, 105, 105, 105),
                                            color: Colors.red,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                        flex: 20,
                                        child: LinearProgressIndicator(
                                          value:
                                              controller.uploadProgress.value,
                                          color: TColors.primary,
                                        )),
                                    const Spacer(),
                                    Text(
                                        '${(controller.uploadProgress * 100).toStringAsFixed(2)}%'),
                                  ],
                                )
                          // ignore: unrelated_type_equality_checks

                          // some error in publishing like 404 , network , 400

                          // is publishing

                          )
                    ],
                  ),
                ],
              )),
        ));
  }
}
