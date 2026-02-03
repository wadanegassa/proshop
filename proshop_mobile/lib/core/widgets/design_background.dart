import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DesignBackground extends StatelessWidget {
  final Widget child;
  const DesignBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Stack(
      children: [
        // Base background with gradient
        Container(
          decoration: BoxDecoration(
            gradient: isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient,
          ),
        ),
        // The diagonal "cool" accent
        Positioned.fill(
          child: CustomPaint(
            painter: _BackgroundPainter(isDark: isDark),
          ),
        ),
        child,
      ],
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final bool isDark;

  _BackgroundPainter({required this.isDark});

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
    
    // Add another subtle shape at the bottom left
    final paintOverlay = Paint()
      ..color = AppColors.primary.withOpacity(isDark ? 0.1 : 0.05);
    
    final path2 = Path();
    path2.moveTo(0, size.height * 0.8);
    path2.lineTo(size.width * 0.3, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    
    canvas.drawPath(path2, paintOverlay);
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) => 
      oldDelegate.isDark != isDark;
}
