import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DesignBackground extends StatelessWidget {
  final Widget child;
  const DesignBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base dark background
        Container(
          color: AppColors.background,
        ),
        // The blue diagonal "swoosh"
        Positioned.fill(
          child: CustomPaint(
            painter: _BackgroundPainter(),
          ),
        ),
        child,
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = AppColors.primaryGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final path = Path();
    // Create a diagonal shape as seen in the design
    path.moveTo(size.width * 0.4, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.7);
    path.close();

    canvas.drawPath(path, paint);
    
    // Add another subtle shape at the bottom left if needed
    final paintOverlay = Paint()
      ..color = AppColors.primary.withOpacity(0.1);
    
    final path2 = Path();
    path2.moveTo(0, size.height * 0.8);
    path2.lineTo(size.width * 0.3, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path2, paintOverlay);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
