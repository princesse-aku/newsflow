import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OptimizedNetworkImage extends StatelessWidget {
  const OptimizedNetworkImage({
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    super.key,
  });

  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: (width * MediaQuery.devicePixelRatioOf(context)).round(),
      memCacheHeight:
          (height * MediaQuery.devicePixelRatioOf(context)).round(),
      placeholder: (context, url) {
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return _buildPlaceholder();
      },
    );

    if (borderRadius <= 0) {
      return image;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: image,
    );
  }

  Widget _buildPlaceholder() {
    return SizedBox(
      width: width,
      height: height,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
        ),
      ),
    );
  }
}