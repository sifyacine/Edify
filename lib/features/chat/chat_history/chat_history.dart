import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Iconsax.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
