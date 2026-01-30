import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProductImage extends StatelessWidget {
  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return Icon(Icons.image, size: height ?? 50, color: AppColors.textMuted);
    }

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.image, size: height ?? 50, color: AppColors.textMuted),
      );
    }

    return Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.image, size: height ?? 50, color: AppColors.textMuted),
    );
  }
}
