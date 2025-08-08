import 'package:better_player/better_player.dart';
import 'package:edify/features/main/controller/courses/course_edit_controller.dart/edit_course_controller.dart';
import 'package:edify/features/main/controller/courses/course_details_controller.dart/course_details_controller.dart';
import 'package:edify/features/main/controller/courses/course_edit_controller.dart/course_update_controller.dart';
import 'package:edify/features/main/models/course/courseDetails.dart';
import 'package:edify/features/main/screens/courses/add_course/widgets/text_form_field.dart';
import 'package:edify/utils/validators/validation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import 'package:timeago/timeago.dart' as timeago;
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/helpers/helper_functions.dart';
import '../../../../../personalization/screens/instructor_profile/instructor_profile_page.dart';

// ignore: must_be_immutable
class CourseDetailsCreaterView extends StatefulWidget {
  final CourseDetails courseDetails;
  final RxBool introChanged;
  final RxBool thumbnailChanged;

  final void Function()? changeVideoIntro;
  final void Function()? changeThumbnail;
  final int userID;
  final TextEditingController? editName;
  final TextEditingController? editTitle;
  final TextEditingController? editDesc;

  final XFile? newIntro;
  final XFile? newThumbnail;

  final Widget? dropDownMenu;

  const CourseDetailsCreaterView({
    super.key,
    this.changeVideoIntro,
    this.changeThumbnail,
    this.editTitle,
    this.editDesc,
    required this.courseDetails,
    this.editName,
    required this.introChanged,
    required this.thumbnailChanged,
    required this.dropDownMenu,
    required this.newIntro,
    required this.newThumbnail,
    required this.userID,
  });

  @override
  State<CourseDetailsCreaterView> createState() => _CourseDetailsCreaterView();
}

class _CourseDetailsCreaterView extends State<CourseDetailsCreaterView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    DateTime courseTime = DateTime.parse(widget.courseDetails.createAt);
    String courseTimeFormate = DateFormat('yyyy-MM-dd').format(courseTime);

    CourseDetailsControllerImp controller = Get.put(
      CourseDetailsControllerImp(widget.courseDetails.videoUrl),
    );
    final isDark = THelperFunctions.isDarkMode(context);
    CourseUpdateControllerImp courseUpdateControllerImp =
        Get.put(CourseUpdateControllerImp(widget.userID));
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: controller.betterPlayerController.videoPlayerController ==
                    null
                ? const Center(
                    child: Text("Empty"),
                  )
                : BetterPlayer(controller: controller.betterPlayerController),
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Obx(() => widget.introChanged.value
                    ? Row(
                        children: [
                          const Text(
                            "Video has been updated",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Obx(() => courseUpdateControllerImp
                                  .videoisComprissing.isTrue
                              ? Lottie.asset(
                                  'assets/images/animations/141397-loading-juggle.json',
                                  width: 30,
                                  height: 30)
                              : courseUpdateControllerImp.isLoadingIntro.value
                                  ? Text(
                                      '${(courseUpdateControllerImp.uploadProgress.value * 100).toStringAsFixed(2)}%'
                                          .toString())
                                  : IconButton(
                                      onPressed: () async {
                                        print(widget.newIntro!.path);
                                        await courseUpdateControllerImp
                                            .compressVideoIntro(
                                                widget.newIntro);
                                        await courseUpdateControllerImp
                                            .editVideoInto(widget.newIntro);
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        color: TColors.primary,
                                      )))
                        ],
                      )
                    : InkWell(
                        onTap: widget.changeVideoIntro,
                        child: const Row(
                          children: [
                            Icon(Icons.video_camera_back_rounded),
                            Text(
                              " Change intro video",
                              style: TextStyle(fontFamily: "NotoSansArabic"),
                            )
                          ],
                        ),
                      )),
                const SizedBox(
                  height: 10,
                ),
                // change thumbnail
                Obx(() => widget.thumbnailChanged.value
                    ? Row(
                        children: [
                          const Text(
                            "Thumbnail Has Been Updated",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Obx(() =>
                              courseUpdateControllerImp.isLoadingThumbnail.value
                                  ? Text(courseUpdateControllerImp
                                      .uploadProgress.value
                                      .toString())
                                  : IconButton(
                                      onPressed: () async {
                                        await courseUpdateControllerImp
                                            .editThumbnail(widget.newThumbnail);
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        color: TColors.primary,
                                      )))
                        ],
                      )
                    : InkWell(
                        onTap: widget.changeThumbnail,
                        child: const Row(
                          children: [
                            Icon(Icons.photo_library_outlined),
                            Text(
                              " Change thumbnail",
                              style: TextStyle(fontFamily: "NotoSansArabic"),
                            )
                          ],
                        ),
                      )),

                /// preview this course

                const SizedBox(
                  height: 20,
                ),

                /// course details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    // course name
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Subject :",
                        style: TextStyle(fontSize: 18, fontFamily: "Rowdies"),
                      ),
                    ),
                    TextFormFieldCourse(
                        textController: widget.editName!,
                        hintText: widget.courseDetails.courseName,
                        maxLength: 50,
                        validator: (val) {
                          return TValidator.validateShortTitle(val!, 3, 50);
                        },
                        sufixIcon: Obx(() =>
                            courseUpdateControllerImp.isLoadingSubject.value
                                ? const CircularProgressIndicator()
                                : IconButton(
                                    onPressed: () async {
                                      await courseUpdateControllerImp
                                          .editSubject(widget.editName!.text);
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      color: Color.fromARGB(255, 137, 4, 226),
                                    ))),
                        autofocus: false),

                    const Divider(),

                    /// course title
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Title of the course:",
                        style: TextStyle(fontSize: 18, fontFamily: "Rowdies"),
                      ),
                    ),
                    TextFormFieldCourse(
                        textController: widget.editTitle!,
                        hintText: widget.courseDetails.courseTitle,
                        maxLength: 100,
                        validator: (val) {
                          return TValidator.validateShortTitle(val!, 10, 100);
                        },
                        sufixIcon: Obx(
                            () => courseUpdateControllerImp.isLoadingTitle.value
                                ? const CircularProgressIndicator()
                                : IconButton(
                                    onPressed: () async {
                                      await courseUpdateControllerImp
                                          .editTitle(widget.editTitle!.text);
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      color: Color.fromARGB(255, 30, 9, 214),
                                    ))),
                        autofocus: false),

                    const SizedBox(
                      height: 20,
                    ),

                    /// course description
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Desciption of the course :",
                        style: TextStyle(fontSize: 18, fontFamily: "Rowdies"),
                      ),
                    ),
                    TextFormFieldCourse(
                        textController: widget.editDesc!,
                        hintText: widget.courseDetails.courseDesc,
                        maxLength: 800,
                        maxLines: 4,
                        validator: (val) {
                          return TValidator.validateShortTitle(val!, 100, 800);
                        },
                        sufixIcon: Obx(
                            () => courseUpdateControllerImp.isLoadingDesc.value
                                ? const CircularProgressIndicator(
                                    color: TColors.primary,
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      await courseUpdateControllerImp
                                          .editDesc(widget.editDesc!.text);
                                      FocusScope.of(context).unfocus();
                                    },
                                    icon: const Icon(
                                      Icons.send,
                                      color: Color.fromARGB(255, 7, 7, 7),
                                    ))),
                        autofocus: false),

                    const Divider(),

                    /// course rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.courseDetails.courseRating.toString(),
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: TColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RatingBarIndicator(
                              rating: 4.6,
                              itemSize: 16,
                              itemBuilder: (_, __) => const Icon(
                                Iconsax.star1,
                                color: TColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "(${widget.courseDetails.courseRating.toString()} student)",
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    /// created by
                    Row(
                      children: [
                        const Text("Created by",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            Get.to(() => const InstructorProfilePage());
                          },
                          child: Text(
                            widget.courseDetails.createBy,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TColors.primary,
                                fontSize: 14.0),
                          ),
                        ),
                      ],
                    ),

                    /// last update and language
                    Row(
                      children: [
                        const Icon(Iconsax.danger),
                        Text(
                          " $courseTimeFormate",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('  (${timeago.format(courseTime)})')
                      ],
                    ),

                    const SizedBox(height: 20.0),

                    /// price
                    widget.dropDownMenu!,

                    /// buy and add to wishlist buttons

                    const SizedBox(height: 10.0),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: isDark ? TColors.dark : TColors.light,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "What will you learn in this course",
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: 'Rowdies'),
                          ),
                          const SizedBox(height: 12.0),
                          ...List.generate(
                            widget.courseDetails.benefits.length,
                            (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // Align items to the top
                                  children: [
                                    const Icon(Iconsax.tick_circle),
                                    const SizedBox(width: 12.0),
                                    // Wrap Text inside Expanded to allow it to take the available space and wrap when needed
                                    Expanded(
                                      child: Text(
                                        widget.courseDetails.benefits[index]
                                            ['course_benefit'],
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: 'NotoSansArabic'),
                                        // Optional: adjust font size
                                        overflow: TextOverflow
                                            .visible, // Ensure text doesn't get clipped
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
