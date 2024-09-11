import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(length: 3, vsync: Scaffold.of(context));

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Iconsax.search_normal_1), onPressed: () {}),

        ],
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: "All"),
            Tab(text: "Reminders"),
            Tab(text: "Groups"),
          ],
          indicatorColor: TColors.primary,
          labelColor: TColors.primary,
          unselectedLabelColor: Colors.grey,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Center(
            child: Text("All notifications"),
          ),
          Center(
            child: Text("reminders"),
          ),
          Center(
            child: Text("groups notifications"),
          ),
        ],
      ),
    );
  }
}