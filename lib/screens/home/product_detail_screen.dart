import 'package:bcom_app/core/constants/app_colors.dart';
import 'package:bcom_app/screens/home/widgets/image_gallery_thumbnails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/cached_image_view.dart';
import '../../widgets/rating_star.dart';
import 'widgets/additional_cards.dart';

class ProductDetailScreen extends HookWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFavorite = favoriteProvider.isFavorite(product.id);

    // Animation controllers
    final favAnimController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final imageTransitionController = useAnimationController(
      duration: const Duration(milliseconds: 400),
    );

    // Animations
    final favAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: favAnimController, curve: Curves.easeInOut),
    );

    final imageSlideAnimation =
        Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: imageTransitionController,
            curve: Curves.easeOutCubic,
          ),
        );

    final imageFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: imageTransitionController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    // Merge single image with images array and remove duplicates
    List<String> getAllImages() {
      List<String> allImages = [];
      Set<String> baseUrls = {}; // Track only the base URLs for comparison

      String getBaseUrl(String url) {
        return url.split('?').first.trim(); // Remove query params
      }

      // Add single image first
      if (product.image.isNotEmpty) {
        String base = getBaseUrl(product.image);
        if (!baseUrls.contains(base)) {
          baseUrls.add(base);
          allImages.add(product.image);
        }
      }

      // Add images from array, avoiding duplicates (base URL match)
      if (product.images.isNotEmpty) {
        for (String imageUrl in product.images) {
          if (imageUrl.isNotEmpty) {
            String base = getBaseUrl(imageUrl);
            if (!baseUrls.contains(base)) {
              baseUrls.add(base);
              allImages.add(imageUrl);
            }
          }
        }
      }

      return allImages;
    }

    final allImages = getAllImages();

    // Debug print to check what images we have
    print('DEBUG: product.image = "${product.image}"');
    print('DEBUG: product.images = ${product.images}');
    print('DEBUG: allImages = $allImages');

    // State for selected image
    final selectedImageIndex = useState(0);
    final isImageTransitioning = useState(false);

    // Trigger initial animation when screen loads
    useEffect(() {
      if (allImages.isNotEmpty) {
        imageTransitionController.forward();
      }
      return null;
    }, []);

    // Function to change main image with animation
    void changeMainImage(int newIndex) async {
      if (newIndex == selectedImageIndex.value || isImageTransitioning.value)
        return;

      isImageTransitioning.value = true;
      imageTransitionController.reset();
      selectedImageIndex.value = newIndex;
      await imageTransitionController.forward();
      isImageTransitioning.value = false;
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          ScaleTransition(
            scale: favAnimation,
            child: IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () => favoriteProvider.toggleFavorite(product.id),
            ),
          ),
        ],
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'B',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Shop',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;
          final maxContentWidth = isTablet ? 700.0 : double.infinity;
          final sidePadding = isTablet ? 24.0 : 5.0;

          return Center(
            child: Container(
              width: maxContentWidth,
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: ListView(
                children: [
                  const SizedBox(height: 16),

                  /// Main Image with Animation
                  Stack(
                    children: [
                      Hero(
                        tag: 'product-image-${product.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: AnimatedBuilder(
                            animation: imageTransitionController,
                            builder: (context, child) {
                              return SlideTransition(
                                position: imageSlideAnimation,
                                child: FadeTransition(
                                  opacity: imageFadeAnimation,
                                  child: ImageDisplay(
                                    height: isTablet ? 300 : 240,
                                    imageUrl: allImages.isNotEmpty
                                        ? allImages[selectedImageIndex.value]
                                        : product
                                              .image, // Fallback to original image
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.sell,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  /// Image Gallery Thumbnails
                  if (allImages.length > 1) ...[
                    const SizedBox(height: 9),
                    PremiumImageGallery(
                      images: allImages,
                      selectedIndex: selectedImageIndex.value,
                      onImageSelected: changeMainImage,
                    ),
                  ],

                  const SizedBox(height: 5),

                  /// Product Name & Rating
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.category,
                                color: Color.fromARGB(255, 104, 169, 202),
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                product.category,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blueGrey[700],
                                    ),
                              ),
                              const Spacer(),
                              Icon(
                                product.inStock
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: product.inStock
                                    ? Colors.green
                                    : Colors.red,
                                size: 15,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                product.inStock ? 'In Stock' : 'Out of Stock',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: product.inStock
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            product.name,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                ),
                          ),
                          const SizedBox(height: 8),

                          /// Rating
                          RatingWidget(product: product),
                          const SizedBox(height: 8),

                          /// Price & Discount
                          if (product.originalPrice > product.price)
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              runSpacing: 6,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '\$${product.originalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Save \$${(product.originalPrice - product.price).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                          const Divider(height: 30, thickness: 1),

                          /// Description
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.1,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[800],
                                  height: 1.5,
                                ),
                          ),

                          const Divider(height: 30, thickness: 1),
                        ],
                      ),
                    ),
                  ),

                  /// Specifications
                  const SizedBox(height: 5),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title
                          Text(
                            'Specifications',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          /// Specification List
                          ...product.specifications.entries
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                                final i = entry.key;
                                final e = entry.value;
                                final isLast =
                                    i == product.specifications.length - 1;

                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${e.key}:",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            e.value.toString(),
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (!isLast)
                                      const Divider(
                                        height: 20,
                                        color: Color(0xFFE0E0E0),
                                        thickness: 0.6,
                                      ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                  ),

                  /// Additional Info
                  const SizedBox(height: 5),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Title
                          Text(
                            'Additional Information',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 14),

                          /// Additional Info Cards
                          Wrap(
                            spacing: 15,
                            runSpacing: 0,
                            children: [
                              AdditionalCards(
                                icon: Icons.local_shipping,
                                label: 'Free Shipping',
                                backgroundColor: Colors.blue,
                              ),
                              AdditionalCards(
                                icon: Icons.security,
                                label: '1 Year Warranty',
                                backgroundColor: Colors.green,
                              ),
                              AdditionalCards(
                                icon: Icons.refresh,
                                label: '30 Days Return',
                                backgroundColor: Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
