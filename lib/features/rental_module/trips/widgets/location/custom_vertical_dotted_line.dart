import 'package:flutter/material.dart';

class CustomVerticalDottedLine extends StatelessWidget {
  final int dotCount;
  final double dotWidth;
  final double dotHeight;
  final Color dotColor;

  const CustomVerticalDottedLine({super.key, this.dotCount = 4, this.dotWidth = 1, this.dotHeight = 2, this.dotColor = Colors.grey,});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(dotCount, (index) => Container(
        width: dotWidth,
        height: dotHeight,
        color: dotColor,
        margin: const EdgeInsets.symmetric(vertical: 2),
      )),
    );
  }
}
