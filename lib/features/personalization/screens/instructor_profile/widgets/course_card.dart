import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../main/screens/course_details/course_details.dart';


class CourseCardRow extends StatelessWidget {
  const CourseCardRow({
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
      onTap: () {
        Get.to(() => const CourseDetails());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Container(
              width: 130, // Adjust this width as needed
              height: 100, // Adjust this height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(thumbnail),
                  fit: BoxFit.cover, // Fit the image inside the container
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            const SizedBox(width: 12.0), // Space between image and text
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Icon(Iconsax.verify5, size: 16.0, color: TColors.primary),
                      const SizedBox(width: 4.0),
                      Text(
                        instructor,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
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
                      const SizedBox(width: 4.0),
                      RatingBarIndicator(
                        rating: rating,
                        itemSize: 16.0,
                        itemBuilder: (_, __) => const Icon(
                          Iconsax.star1,
                          color: TColors.primary,
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "($rateNum)",
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        "$price DA",
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      if (promo != 0)
                        Text(
                          "${price - (price * promo) / 100} DA",
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
          ],
        ),
      ),
    );
  }
}
