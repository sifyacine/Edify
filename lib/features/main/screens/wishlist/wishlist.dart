import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wishlist"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Iconsax.search_normal),
          ),
        ],
      ),
    );
  }
}
