import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({super.key, required this.imageUrl, this.height});

  final String imageUrl;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      fit: BoxFit.cover,
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(color: Colors.white),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}


class ProductImageDisplay extends StatelessWidget {
  const ProductImageDisplay({
    super.key,
    required this.imageUrl,
    this.width = 80,
    this.height = 80,
    this.borderRadius = 12,
  });

  final String imageUrl;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        width: width,
        height: height,
        fit: BoxFit.cover,
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(width: width, height: height, color: Colors.white),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
        ),
      ),
    );
  }
}
