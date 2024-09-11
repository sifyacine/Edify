import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart'; // You can use Icons if you prefer

class CustomTile extends StatelessWidget {
  final Widget? leadingIcon; // Optional leading icon
  final String title; // Name of the tile
  final VoidCallback? onTap; // Click action

  const CustomTile({
    super.key,
    this.leadingIcon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap, // Handle the tap action
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isDark ? TColors.dark : Colors.white,
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
        child: Row(
          children: [
            // Optional leading icon
            if (leadingIcon != null) leadingIcon!,

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
            const Icon(
              Iconsax.arrow_right,
              size: 20.0,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
