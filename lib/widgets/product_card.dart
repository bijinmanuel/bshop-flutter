import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../models/product_model.dart';
import 'cached_image_view.dart';
import 'rating_star.dart';

class ProductCard extends HookWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onTapFav,
    required this.onTap,
  });

  final ProductModel product;
  final bool isFavorite;
  final VoidCallback onTapFav;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final favAnimController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final favAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: favAnimController, curve: Curves.easeInOut),
    );

    useEffect(() {
      favAnimController.reset();
      if (isFavorite) {
        favAnimController.forward().then((_) => favAnimController.reverse());
      }
      return null;
    }, [isFavorite]);
    return Card(
      color: Colors.white,
      // margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                  child: ImageDisplay(height: 250, imageUrl: product.image),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (product.category.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 148, 202, 252),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                product.category,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      // Rating stars with half rating and review count
                      RatingWidget(product: product),
                      const SizedBox(height: 8),
                      // Original and discounted price
                      if (product.originalPrice > product.price)
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '\$${product.originalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        )
                      else
                        // If no discount, just show the price
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: ScaleTransition(
                scale: favAnimation,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: onTapFav,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
