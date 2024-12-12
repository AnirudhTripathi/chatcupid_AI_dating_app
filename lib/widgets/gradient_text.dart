import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientText extends StatelessWidget {
  final String gradientText;
  final double size;

  const GradientText({
    super.key,
    required this.gradientText,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFF00E0FF),
          Color(0xFFFF8FF4),
          Color(0xFFFF8FF4),
        ], // Use the provided colors
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(gradientText,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.w500,
          )),
    );
  }
}
