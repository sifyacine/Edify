import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class InstructorProfilePage extends StatelessWidget {
  const InstructorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Instructor"), actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Iconsax.export_1),
          ),
        ]),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 42.0, // Adjust the value to control the size
                      backgroundImage:
                      AssetImage("assets/images/content/user.png"),
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
                        "Reviews",
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
                        "Courses",
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
                        "Instructor Rating",
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
             Padding(
               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const Text(
                     "About me",
                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                   ),
                   const ReadMoreText(
                     "I'm Yacine, I'm a developer with a passion for teaching. I'm the lead instructor at the London App Brewery, London's leading Programming Bootcamp. I've helped hundreds of thousands of students learn to code and change their lives by becoming a developer. I've been invited by companies such as Twitter, Facebook and Google to teach their employees. My first foray into programming was when I was just 12 years old, wanting to build my own Space Invader game. Since then, I've made hundred of websites, apps and games. But most importantly, I realised that my greatest passion is teaching. I spend most of my time researching how to make learning to code fun and make hard concepts easy to understand. I apply everything I discover into my bootcamp courses. In my courses, you'll find lots of geeky humour but also lots of explanations and animations to make sure everything is easy to understand. I'll be there for you every step of the way.",
                     trimLines: 4,
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
                 ],
               ),
             ),
              // Tab Bar Section
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 22.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: TColors.primary,
                            borderRadius: BorderRadius.circular(12), // Applying circular border radius
                          ),
                          child: const Center(
                            child: Text(
                              "Follow",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: TColors.buttonDisabled,
                            borderRadius: BorderRadius.circular(12), // Applying circular border radius
                          ),
                          child: const Center(
                            child: Text(
                              "Message",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: TColors.buttonDisabled,
                            borderRadius: BorderRadius.circular(12), // Applying circular border radius
                          ),
                          child: const Center(
                            child: Text(
                              "Contact",
                              style: TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              const TabBar(
                indicatorColor: TColors.primary,
                labelColor: TColors.primary,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Posts'),
                  Tab(text: 'Shorts'),
                  Tab(text: 'Courses'),
                ],
              ),
              const SizedBox(
                height: 200.0, // Adjust this height as needed
                child: TabBarView(
                  children: [
                    Center(child: Text("No posts yet")),
                    Center(child: Text("No shorts yet")),
                    Center(child: Text("No courses yet")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
