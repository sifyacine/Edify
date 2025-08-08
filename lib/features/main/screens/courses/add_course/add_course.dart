import 'dart:io';
import 'package:edify/features/main/controller/courses/add_course_controller/add_course_controller.dart';
import 'package:edify/features/main/screens/courses/add_course/widgets/text_form_field.dart';
import 'package:edify/features/main/screens/courses/add_course/widgets/upload_progress.dart';
import 'package:edify/features/main/screens/courses/add_course/widgets/compress_file_view.dart';
import 'package:edify/features/main/screens/shorts/add_short/widgets/show_hashtags.dart';
import 'package:edify/utils/constants/colors.dart';
import 'package:edify/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class AddCourse extends StatelessWidget {
  final int userID;
  int? courseID;

  AddCourse({super.key, required this.userID, this.courseID});

  @override
  Widget build(BuildContext context) {
    AddCourseControllerImp controller =
        Get.put(AddCourseControllerImp(userID, courseID!));
    return Scaffold(
        appBar:
            controller.isLoading.value || controller.videoisComprissing.value
                ? null
                : AppBar(
                    title: const Text(
                      'Add Course',
                      style: TextStyle(fontFamily: 'NotoSansArabic'),
                    ),
                  ),
        body: Obx(() => controller.videoisComprissing.value
            ? const CompressFileView()
            : controller.isLoading.value
                ? UploadProgress(
                    value: controller.uploadProgress,
                    uploadProgress: controller
                        .progressDownload(controller.uploadProgress)
                        .toStringAsFixed(2))
                : Form(
                    key: controller.forms,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: TColors.primary,
                              ),
                              Text(
                                ' Module Name',
                                style: TextStyle(
                                  fontFamily: 'Rowdies',
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextFormFieldCourse(
                              textController: controller.modelName,
                              autofocus: true,
                              maxLength: 50,
                              validator: (val) {
                                return TValidator.validateShortTitle(
                                    val!, 4, 50);
                              },
                              hintText: "Enter subject name...",
                              prefixIcon: const Icon(
                                Icons.book_outlined,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: TColors.primary,
                              ),
                              Text(
                                ' Add the course title.',
                                style: TextStyle(
                                  fontFamily: 'Rowdies',
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: TextFormFieldCourse(
                                autofocus: false,
                                maxLength: 70,
                                textController: controller.title,
                                validator: (val) {
                                  return TValidator.validateShortTitle(
                                      val!, 5, 70);
                                },
                                hintText: "Enter the title of the course..",
                                prefixIcon: const Icon(
                                  Icons.title_outlined,
                                  color: Colors.green,
                                ),
                              )),
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: TColors.primary,
                              ),
                              Text(
                                ' Add Description',
                                style: TextStyle(
                                  fontFamily: 'Rowdies',
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 5.0, bottom: 8.0),
                            child: Text(
                              '    Warning: Do not exceed 800 characters.',
                              style: TextStyle(
                                  color: Colors.grey, fontFamily: 'TiltNeon'),
                            ),
                          ),
                          TextFormFieldCourse(
                            autofocus: false,
                            maxLength: 800,
                            textController: controller.description,
                            validator: (val) {
                              return TValidator.validateShortTitle(
                                  val!, 100, 800);
                            },
                            maxLines: 5,
                            hintText:
                                "Enter the description of this course ...",
                            sufixIcon: const Icon(
                              Icons.description,
                              color: Colors.green,
                            ),
                          ),
                          const Wrap(
                            children: [
                              Text(
                                '◆ Course Benefits',
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'Rowdies'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "What does the participant benefit from this course?,for example, “After completing this course, you will be able to master the English language”.",
                                  style: TextStyle(
                                      fontSize: 16, fontFamily: 'TiltNeon'),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Warning: At least you must enter 5 benefits of this course.',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'TiltNeon'),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormFieldCourse(
                                      autofocus: false,
                                      textController: controller.benefit,
                                      hintText: "Benefits of this course?...",
                                      labelText: "Benefits of this course?...",
                                      maxLength: 100)),
                              IconButton(
                                  onPressed: () {
                                    controller.benefit.value.text.isEmpty
                                        ? null
                                        : controller.addBenefits(controller
                                            .benefit.value.text
                                            .trim());

                                    controller.benefitLength = 0.obs;
                                    FocusScope.of(context).unfocus();
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    size: 32,
                                    color: Color.fromARGB(255, 47, 145, 75),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Obx(() => ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.benefits.length,
                              itemBuilder: (context, i) =>
                                  controller.benefits.isEmpty
                                      ? const Text("")
                                      : Card(
                                          color: const Color.fromARGB(
                                              255, 160, 233, 163),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                          Iconsax.tick_circle),
                                                      Expanded(
                                                        child: Text(
                                                          "    ${controller.benefits[i]}",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  'NotoSansArabic'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  controller.removeBenefits(i);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))),
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0, bottom: 15),
                            child: Divider(height: 15, thickness: 1),
                          ),
                          const Text(
                            '◆ Thumbnail',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 33, 201, 80),
                                fontFamily: 'Rowdies'),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Please choose a thumbnail for your course to make it more attractive to viewers",
                              style: TextStyle(
                                  fontSize: 16, fontFamily: "NotoSansArabic"),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Warning: Image type must be PNG,JPG,JPEG',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Obx(() => Row(
                                children: [
                                  Expanded(
                                      child: SizedBox(
                                    height: 250,
                                    child: InkWell(
                                      onTap: () async {
                                        controller.chooseThumbnail();
                                      },
                                      child: Card(
                                        color: const Color.fromARGB(
                                            122, 255, 255, 255),
                                        child: !controller.thumbnailExist.value
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      controller
                                                          .chooseThumbnail();
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .add_a_photo_outlined,
                                                      size: 64,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Choose an Image",
                                                    style: TextStyle(
                                                        fontFamily: "Rowdies",
                                                        color: Color.fromARGB(
                                                            255, 90, 90, 90)),
                                                  )
                                                ],
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.file(
                                                  File(
                                                    controller.thumbnail!.path,
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ))
                                ],
                              )),
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0, bottom: 15),
                          ),
                          const Text(
                            '◆ Introductory Video',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Create an introductory video for your course explaining the advantages of this course",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Warning: Video type must be MP4 and less than 200 MB',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 141, 141, 141)),
                            ),
                          ),
                          Obx(() => Row(
                                children: [
                                  Expanded(
                                      child: SizedBox(
                                    height: 250,
                                    child: controller.checkVideo.value
                                        ? Lottie.asset(
                                            'assets/images/animations/141397-loading-juggle.json')
                                        : InkWell(
                                            onTap: () async {
                                              controller.checkVideo.value
                                                  ? null
                                                  : await controller
                                                      .chooseIntro();
                                            },
                                            child: Card(
                                              color: !controller
                                                      .videoIntroExist.value
                                                  ? const Color.fromARGB(
                                                      230, 250, 247, 247)
                                                  : Colors.green[400],
                                              child: !controller
                                                      .videoIntroExist.value
                                                  ? Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                          onPressed: () async {
                                                            controller
                                                                .chooseIntro();
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .video_collection_outlined,
                                                            size: 64,
                                                          ),
                                                        ),
                                                        const Text(
                                                          "Choose a video",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    )
                                                  : InkWell(
                                                      onTap: () async {
                                                        controller.checkVideo
                                                                .value
                                                            ? null
                                                            : await controller
                                                                .chooseIntro();
                                                      },
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: const Center(
                                                            child: Text(
                                                              "Done successfully",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ))),
                                            ),
                                          ),
                                  ))
                                ],
                              )),
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0, bottom: 5),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 5,
                                  backgroundColor: TColors.primary,
                                ),
                                Text(
                                  ' Enter the course prices ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => Card(
                              color: const Color.fromARGB(255, 245, 245, 245),
                              child: ExpansionTile(
                                  controller:
                                      controller.expansionTileController,
                                  title: controller.price.value == 1
                                      ? const Text(
                                          "Price",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "${controller.price.value.toString()} .0 DZ",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: TColors.primary),
                                        ),
                                  children: List.generate(
                                    controller.prices.length,
                                    (index) => InkWell(
                                      onTap: () {
                                        controller.price.value =
                                            controller.prices[index].value;
                                        controller.expansionTileController
                                            .collapse();
                                      },
                                      child: Column(
                                        children: [
                                          ListTile(
                                            trailing: controller
                                                        .prices[index] ==
                                                    0
                                                ? const Text(
                                                    "Is Free",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: TColors.primary),
                                                  )
                                                : null,
                                            title: Text(
                                              "${controller.prices[index].toString()}.0 DZ",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          const Divider(
                                            height: 5,
                                            thickness: 1,
                                          )
                                        ],
                                      ),
                                    ),
                                  )))),
                          const Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Text(
                                  "#",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  " Add Hashtags",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Then add keywords related to the content of your course',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: TextFormFieldCourse(
                                  autofocus: false,
                                  textController: controller.hashtag,
                                  hintText: "Add a  hashtags...",
                                  maxLength: 30,
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "  # ",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )),
                                IconButton(
                                    onPressed: () {
                                      controller.hashtag.value.text.isEmpty
                                          ? null
                                          : controller.addHashtag();
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: const Icon(
                                      Icons.add,
                                      size: 32,
                                      color: Colors.green,
                                    )),
                              ],
                            ),
                          ),
                          Obx(() => controller.hashtags.value.isNotEmpty
                              ? ShowHashtags(
                                  hashtags: controller.hashtags,
                                  controller: controller,
                                )
                              : Container()),
                          const SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            onPressed: () async {
                              await controller.publishPartOne(userID);
                            },
                            padding: const EdgeInsets.all(15),
                            color: TColors.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              " Publish ",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )));
  }
}
