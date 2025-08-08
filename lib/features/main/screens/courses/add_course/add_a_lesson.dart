import 'dart:io';
import 'package:edify/features/main/controller/courses/add_course_controller/add_a_lesson_controller.dart';
import 'package:edify/features/main/screens/courses/add_course/widgets/text_form_field.dart';
import 'package:edify/features/main/screens/courses/add_course/widgets/upload_progress.dart';
import 'package:edify/features/main/screens/courses/add_course/widgets/compress_file_view.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AddALesson extends StatelessWidget {
  final int courseID;
  final int userID;

  const AddALesson({super.key, required this.courseID, required this.userID});

  @override
  Widget build(BuildContext context) {
    AddALessonControllerImp controller =
        Get.put(AddALessonControllerImp(courseID, userID));

    return Scaffold(
        appBar: AppBar(
          title: InkWell(
              onTap: () async {
                await controller.publishLesson();
              },
              child: const Text(
                "Add a lesson",
                style: TextStyle(fontFamily: 'NotoSansArabic'),
              )),
        ),
        body: Obx(() =>
            // في حال كان الفيديو اثناء عملية الضغط
            controller.videoisComprissing.value
                ? const CompressFileView()
                :
                // في حال كان الكورس في عملية التحميل
                controller.isLoading.value
                    ? UploadProgress(
                        value: controller.uploadProgressCourse,
                        uploadProgress: controller
                            .progressDownload(controller.uploadProgressCourse)
                            .toStringAsFixed(2))
                    : Form(
                        key: controller.forms,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView(
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.isChooseLesson.value
                                      ? null
                                      : controller.chooseLesson();
                                },
                                child: Container(
                                  height: 250,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 173, 171, 171),
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Obx(
                                        () => controller.isChooseLesson.value
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Lottie.asset(
                                                      'assets/images/animations/loading2.json',
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      '... يتم التحقق الفيديو ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily:
                                                              'CairoPlay',
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : !controller.lessonVideoExist.value
                                                ? const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons
                                                          .video_collection),
                                                      Text(
                                                        'Choose a video',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Rowdies'),
                                                      )
                                                    ],
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      controller.chooseLesson();
                                                    },
                                                    child: const Card(
                                                      color: Colors.green,
                                                      child: Center(
                                                        child: Text(
                                                          'Video Selected',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                      )),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Row(children: [
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor: TColors.primary,
                                  ),
                                  Text(
                                    " Add a Title ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Rowdies',
                                    ),
                                  ),
                                ]),
                              ),
                              TextFormFieldCourse(
                                maxLength: 100,
                                autofocus: false,
                                textController: controller.title.value,
                                validator: (val) {
                                  return TValidator.validateShortTitle(
                                      val!, 5, 100);
                                },
                                hintText: "Enter a title for this lesson",
                                labelText: "Title of this lesson",
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Row(
                                children: [
                                  CircleAvatar(
                                    radius: 5,
                                    backgroundColor: TColors.primary,
                                  ),
                                  Text(
                                    " Add a Description ",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Rowdies',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormFieldCourse(
                                maxLines: 5,
                                maxLength: 500,
                                autofocus: false,
                                textController: controller.desc.value,
                                validator: (val) {
                                  return TValidator.validateShortTitle(
                                      val!, 5, 500);
                                },
                                hintText: "Enter a descrption for this lesson",
                                labelText: "Description of this lesson",
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 8.0, left: 8.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 5,
                                      backgroundColor: Colors.blue,
                                    ),
                                    Text(
                                      " Add a Source",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'TiltNeon',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 20.0, bottom: 8),
                                child: Text(
                                  'add sources to the video, such as exercises, homework, or books in the form of PDF files',
                                  style: TextStyle(
                                      fontFamily: 'TiltNeon',
                                      color: Colors.grey,
                                      fontSize: 14),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  controller.chooseSourse();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: const ListTile(
                                    title: Text("Choose a Homework"),
                                    leading: Icon(Icons.photo),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 150,
                                  child: Obx(
                                    () => Card(
                                      color: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[100]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: controller
                                                  .listSources!.length,
                                              itemBuilder:
                                                  (context, i) =>
                                                      controller.listSources!
                                                              .isEmpty
                                                          ? const Text(
                                                              '',
                                                            )
                                                          : SizedBox(
                                                              height: 150,
                                                              width: 150,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        5.0),
                                                                child: Stack(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      child: Image
                                                                          .file(
                                                                        File(
                                                                          controller
                                                                              .listSources![i]
                                                                              .path,
                                                                        ),
                                                                        height:
                                                                            150,
                                                                        width:
                                                                            150,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    ),
                                                                    Positioned(
                                                                        top: 5,
                                                                        right:
                                                                            5,
                                                                        child: InkWell(
                                                                            onTap: () {
                                                                              controller.deleteImgSource(i);
                                                                            },
                                                                            child: const CircleAvatar(
                                                                              radius: 15,
                                                                              backgroundColor: Color.fromARGB(104, 158, 158, 158),
                                                                              child: Icon(
                                                                                Icons.delete,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ))),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                        ),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  controller.checkInformation().isTrue
                                      ? controller.publishLesson()
                                      : null;
                                },
                                padding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: TColors.primary,
                                child: const Text(
                                  "Publish",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )));
  }
}
