import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Color color;
  final Widget leading;
  final String title;
  final Widget content;
  final VoidCallback? onTap;
  final double height;
  final double width;

  const StatCard({
    super.key,
    required this.color,
    required this.leading,
    required this.title,
    required this.content,
    this.onTap,
    this.height = 200,
    this.width = 175,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Card(
          color: color,
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leading,
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 8),
                Expanded(child: Align(alignment: Alignment.bottomLeft, child: content)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
