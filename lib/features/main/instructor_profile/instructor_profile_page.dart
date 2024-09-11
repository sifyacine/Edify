import 'package:edify/features/main/instructor_profile/widgets/course_card.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../common/icon/social_icons.dart';
import '../../../common/tiles/custom_tile.dart';
import '../../../utils/helpers/helper_functions.dart';

class InstructorProfilePage extends StatelessWidget {
  const InstructorProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Instructor"), actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Iconsax.export_1),
        ),
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 42.0, // Adjust the value to control the size
                    backgroundImage: AssetImage("assets/images/content/user.png"),
                  ),
                  SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sif Yacine",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28.0),
                      ),
                      Text(
                        "software engineer",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 16.0),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Followers",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14.0),
                      ),
                      Text(
                        "1,234",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "reviews",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14.0),
                      ),
                      Text(
                        "130",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        "courses",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14.0),
                      ),
                      Text(
                        "7",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Text(
                        "instructor Rating",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14.0),
                      ),
                      Text(
                        "4.7",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              const Text(
                "About me",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const ReadMoreText(
                "I'm Angela, I'm a developer with a passion for teaching. I'm the lead instructor at the London App Brewery, London's leading Programming Bootcamp. I've helped hundreds of thousands of students learn to code and change their lives by becoming a developer. I've been invited by companies such as Twitter, Facebook and Google to teach their employees. My first foray into programming was when I was just 12 years old, wanting to build my own Space Invader game. Since then, I've made hundred of websites, apps and games. But most importantly, I realised that my greatest passion is teaching. I spend most of my time researching how to make learning to code fun and make hard concepts easy to understand. I apply everything I discover into my bootcamp courses. In my courses, you'll find lots of geeky humour but also lots of explanations and animations to make sure everything is easy to understand. I'll be there for you every step of the way.",
                trimLines: 8,
                trimMode: TrimMode.Line,
                trimExpandedText: ' less',
                trimCollapsedText: ' more',
                moreStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
                lessStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: TColors.primary,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My courses (7)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "view all",
                        style: TextStyle(color: TColors.primary),
                      )),
                ],
              ),
              const CourseCardRow(thumbnail: 'assets/images/content/java_course.png', title: 'Java course', instructor: 'Sif yacine', price: 3400,),
              const CourseCardRow(thumbnail: 'assets/images/content/post_image.png', title: 'flutter course', instructor: 'Sif yacine', price: 2400,),
              const CourseCardRow(thumbnail: 'assets/images/content/python_course.png', title: 'python course', instructor: 'Sif yacine', price: 4400,),
              const SizedBox(height: 16.0),
              const Text(
                "Contact me",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const CustomTile(leadingIcon: TSocialButtons(image: 'assets/logos/website_logo.png',), title: 'Website',),
              const CustomTile(leadingIcon: TSocialButtons(image: 'assets/logos/facebook-icon.png',), title: 'Facebook',),
              const CustomTile(leadingIcon: TSocialButtons(image: 'assets/logos/linkedIn_logo.jpg',), title: 'LinkedIn',),
            ],
          ),
        ),
      ),
    );
  }
}
