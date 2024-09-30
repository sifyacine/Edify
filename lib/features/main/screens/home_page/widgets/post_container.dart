import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:readmore/readmore.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../models/post_model.dart';


class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final memberProfileImage = post.member.profilePicture.isNotEmpty
        ? NetworkImage(" http://10.0.2.2:8000${post.member.profilePicture}")
        : AssetImage("assets/images/default_profile.png") as ImageProvider;

    final images = post.images
        .map((img) => NetworkImage(" http://10.0.2.2:8000${img.image}"))
        .toList();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with profile picture, username, and post time
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: memberProfileImage,
                  radius: 20.0,
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.member.user.username,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        _getTimeSincePosted(post.publishedDate),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            // Post description with Read More widget

            // Post images if available
            if (images.isNotEmpty)
              Column(
                children: [
                  ReadMoreText(
                    post.description,
                    trimLines: 2,
                    colorClickableText: Colors.blue,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Read more',
                    trimExpandedText: 'Read less',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ImageCarousel(images: images), // Using ImageCarousel here
                ],
              )
            else
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                // Fixed height when no images
                color: isDark ? Colors.black : Colors.grey[200],
                // Optional: Background color for fixed size container
                child: Center(
                  child: ReadMoreText(
                    post.description,
                    trimLines: 6,
                    colorClickableText: Colors.blue,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Read more',
                    trimExpandedText: 'Read less',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 8.0),
            // Footer with like, comment, and share counts
            Row(
              children: [
                // Number of likes
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Iconsax.heart, size: 18.0),
                      SizedBox(width: 4.0),
                      Text('${post.numLikes}'),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),

                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Iconsax.message, size: 18.0),
                      SizedBox(width: 4.0),
                      Text('${post.numComments}'),
                    ],
                  ),
                ),
                SizedBox(width: 16.0),
                // Number of shares
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Iconsax.share, size: 18.0),
                      SizedBox(width: 4.0),
                      Text('${post.numShares}'),
                    ],
                  ),
                ),
                Spacer(), // Spacer to push other elements to the right
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.save, size: 18.0),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeSincePosted(DateTime publishedDate) {
    final now = DateTime.now();
    final difference = now.difference(publishedDate);

    if (difference.inDays >= 30) {
      return DateFormat('dd/MM/yyyy').format(publishedDate);
    } else if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}



class ImageCarousel extends StatefulWidget {
  final List<ImageProvider> images;

  ImageCarousel({required this.images});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity, // Make the container take the full width
          height: 400.0, // Adjust the height to match typical post sizes
          child: CarouselSlider.builder(
            itemCount: widget.images.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return AspectRatio(
                aspectRatio: 1,
                child: Image(
                  image: widget.images[index],
                  fit: BoxFit.cover,
                ),
              );
            },
            options: CarouselOptions(
              height: 400.0,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        Positioned(
          right: 16.0,
          top: 16.0,
          child: Text(
            '${_currentIndex + 1}/${widget.images.length}', // Update dynamically
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }
}