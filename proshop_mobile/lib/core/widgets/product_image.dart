import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/api_constants.dart';

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
      return Icon(Icons.image, size: height ?? 50, color: Theme.of(context).hintColor);
    }

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.image, size: height ?? 50, color: Theme.of(context).hintColor),
      );
    }
    
    // Handle relative paths from backend
    if (imagePath.startsWith('/uploads') || imagePath.contains('uploads/')) {
       // Extract the path part if it's mixed
       final cleanPath = imagePath.startsWith('/') ? imagePath : '/$imagePath';
       // We need to use the IP from ApiConstants, stripped of /api/v1
       // ApiConstants.baseUrl is like http://10.232.87.165:5000/api/v1
       // We need http://10.232.87.165:5000
       
       // Derive base URL from ApiConstants to keep it synced
       final baseUri = Uri.parse(ApiConstants.baseUrl);
       final origin = '${baseUri.scheme}://${baseUri.host}:${baseUri.port}';
       
       return Image.network(
        '$origin$cleanPath',
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            Icon(Icons.image, size: height ?? 50, color: Theme.of(context).hintColor),
      );
    }

    return Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.image, size: height ?? 50, color: Theme.of(context).hintColor),
    );
  }
}
