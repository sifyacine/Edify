import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // You can use Icons if you prefer

class CustomTile extends StatelessWidget {
  final Widget? leadingIcon; // Optional leading icon
  final String title; // Name of the tile
  final VoidCallback? onTap; // Click action

  const CustomTile({
    Key? key,
    this.leadingIcon,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle the tap action
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the tile
          borderRadius: BorderRadius.circular(8.0), // Rounded corners

        ),
        child: Row(
          children: [
            // Optional leading icon
            if (leadingIcon != null)
                leadingIcon!,

            if (leadingIcon != null)
              const SizedBox(width: 12.0), // Spacing between icon and title

            // Tile title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Arrow pointing to the right
            const Icon(
              Iconsax.arrow_right, // You can use Icons.arrow_forward_ios if you don't use Iconsax
              size: 20.0,
              color: Colors.grey, // Customize arrow color
            ),
          ],
        ),
      ),
    );
  }
}
