import 'package:cached_network_image/cached_network_image.dart';
import 'package:edify/features/main/controller/courses/course_details_controller.dart/course_card_controller.dart';
import 'package:edify/features/main/models/course/courseDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import 'course_details.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.courses});

  final Map courses;

  @override
  Widget build(BuildContext context) {
    CourseCardControllerImp controller =
        Get.put(CourseCardControllerImp(courses));

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(() =>
              CourseDetailsView(courseDetails: controller.getCourseDetails()!));
        },
        child: Container(
          width: double.infinity, // ياخذ العرض كامل
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة الكورس
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12.0)),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://education15845d.pythonanywhere.com${courses["course_thumbnail"]}",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: Get.height * 0.25, // ممكن تغيره حسب ما يناسبك
                  placeholder: (context, url) => LottieBuilder.asset(
                      "assets/images/animations/141397-loading-juggle.json"),
                  errorWidget: (context, url, error) => Lottie.asset(
                      "assets/images/animations/53207-empty-file.json"),
                ),
              ),
              // تفاصيل الكورس
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReadMoreText(courses['course_title'],
                        trimLines: 2,
                        colorClickableText: TColors.primary,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '... المزيد',
                        trimExpandedText: ' أقل',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NotoSansArabic',
                        )),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(Iconsax.verify5,
                            size: TSizes.iconXs, color: TColors.primary),
                        SizedBox(width: 8.0),
                        Text(
                          "instructor",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          "${courses['course_rating']}",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: TColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        RatingBarIndicator(
                          rating: 0.0,
                          itemSize: 16,
                          itemBuilder: (_, __) => const Icon(
                            Iconsax.star1,
                            color: TColors.primary,
                          ),
                        ),
                        Text(
                          "(${courses["course_rating"]})",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          "${courses['course_price']} DA",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Lottie.asset(
                          "assets/images/animations/arrow.json",
                          width: 30,
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
