import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../course_details/course_details.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
  super.key, required this.thumbnail, required this.title, required this.instructor, this.rating = 0, required this.price, this.promo = 0, this.rateNum = 0,
  });
  final String thumbnail;
  final String title;
  final String instructor;
  final double rating;
  final double price;
  final double promo;
  final int rateNum;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){Get.to(() => const CourseDetails());},
      child: Container(
        height: 220.0,
        width: 180.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          // Make background color transparent
          borderRadius: BorderRadius.circular(
              12.0), // Optional: Add rounded corners
        ),
        child: Column(
          children: [
            // Image section taking 35% of the container's height
            Container(
              height: 220 * 0.4,
              // 35% of the container height
              width: double.infinity,
              // Full width
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      thumbnail),
                  // Replace with your image
                  fit: BoxFit
                      .cover, // Fit image to fill the container width
                ),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(
                        12.0)), // Optional rounded corners
              ),
            ),
            // Text section taking the remaining height
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // Padding inside the text area
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  // Space out the text items evenly
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  // Align text to the left
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Iconsax.verify5,
                            size: TSizes.iconXs,
                            color: TColors.primary),
                        const SizedBox(width: 8.0),
                        Text(
                          instructor,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "$rating",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: TColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        RatingBarIndicator(
                          rating: rating,
                          itemSize: 16,
                          itemBuilder: (_, __) =>
                          const Icon(
                            Iconsax.star1,
                            color: TColors.primary,
                          ),
                        ),
                        Text(
                          "($rateNum)",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "$price DA",
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          promo!=0?
                          "${price - (price*promo)/100} DA" : "",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}