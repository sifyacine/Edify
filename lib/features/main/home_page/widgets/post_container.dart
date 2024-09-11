import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({
    super.key,
    required this.profileImage,
    required this.userName,
    required this.date,
    required this.postDetails,
    required this.postImage,
    required this.likes,
    required this.comments, required this.shares,
  });

  final String profileImage;
  final String userName;
  final String date;
  final String postDetails;
  final String postImage;
  final int likes;
  final int comments;
  final int shares;

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: isDark ? Colors.black : Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.0, // Adjust the value to control the size
                backgroundImage: AssetImage(profileImage),
              ),
              const SizedBox(width: 12.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Follow'),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.close_square),
                        ),
                      ],
                    ),
                    Text(date),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          ReadMoreText(
            postDetails,
            trimLines: 2,
            trimMode: TrimMode.Line,
            trimExpandedText: ' less',
            trimCollapsedText: ' more',
            moreStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
            lessStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
          ),
          Container(
            height: 300.0,
            // Set the height of the container
            width: double.infinity,
            // Makes the container take the full width of the screen
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(postImage),
                // Path to your image
                fit: BoxFit
                    .cover, // Ensures the image covers the entire container
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Text("$likes likes"),
              const Spacer(),
              Text("$comments comments"),
              SizedBox(width: 8.0),
              Text("$shares shares"),
            ],
          ),
          const SizedBox(height: 8.0),
          // Interaction buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Iconsax.heart, size: 20.0),
                    SizedBox(width: 4.0),
                    Text("Like", style: TextStyle(fontSize: 12.0)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Iconsax.message, size: 20.0),
                    SizedBox(width: 4.0),
                    Text("Comments", style: TextStyle(fontSize: 12.0)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Iconsax.bookmark, size: 20.0),
                    SizedBox(width: 4.0),
                    Text("Save", style: TextStyle(fontSize: 12.0)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Iconsax.export_1, size: 20.0),
                    SizedBox(width: 4.0),
                    Text("Share", style: TextStyle(fontSize: 12.0)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
