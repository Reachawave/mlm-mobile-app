import 'package:flutter/material.dart';

class DrawerMenuRow extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String title;
  final VoidCallback? onTap;

  const DrawerMenuRow({
    super.key,
    this.icon,
    this.imagePath,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final leading = imagePath != null
        ? Image.asset(imagePath!, width: 24, height: 24, color: Colors.green)
        : (icon != null
        ? Icon(icon, color: Colors.green)
        : const SizedBox(width: 24, height: 24));

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 15),
            Text(title, style: const TextStyle(fontSize: 20, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
