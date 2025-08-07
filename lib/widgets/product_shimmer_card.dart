import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmerCardList extends StatelessWidget {
  const ProductShimmerCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        final crossAxisCount = isTablet ? 3 : 1;
        final childAspectRatio = isTablet
            ? (constraints.maxWidth / crossAxisCount) / 520
            : 3 / 2;
        if (isTablet) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              return ProductCardShimmer();
            },
          );
        } else {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: ProductCardShimmer(),
            ),
          );
        }
      },
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title placeholder
                ShimmerBox(height: 20, width: double.infinity),
                const SizedBox(height: 8),

                // Description placeholder
                ShimmerBox(height: 14, width: double.infinity),
                const SizedBox(height: 6),
                ShimmerBox(
                  height: 14,
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                const SizedBox(height: 12),

                // Rating placeholder
                ShimmerBox(height: 16, width: 80),
                const SizedBox(height: 12),

                // Price row
                Row(
                  children: [
                    ShimmerBox(height: 20, width: 60),
                    const SizedBox(width: 8),
                    ShimmerBox(height: 16, width: 40),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable shimmer box
class ShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  const ShimmerBox({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
