import 'package:flutter/material.dart';

import '../models/product_model.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          if (product.rating >= i + 1) {
            return const Icon(Icons.star, color: Colors.amber, size: 15);
          } else if (product.rating > i && product.rating < i + 1) {
            return const Icon(Icons.star_half, color: Colors.amber, size: 15);
          } else {
            return const Icon(Icons.star_border, color: Colors.amber, size: 15);
          }
        }),
        const SizedBox(width: 6),
        Text(
          '(${product.reviewCount})',
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ],
    );
  }
}
