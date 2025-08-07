
import 'package:bcom_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../providers/favorite_provider.dart';
import '../../widgets/product_card.dart';
import '../../widgets/product_shimmer_card.dart';
import '../favorites/favorite_screen.dart';
import 'product_detail_screen.dart';
import 'widgets/logout_icon_button.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
        ),

        actions: [
          //Favorites
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Get.to(() => const FavouritesScreen());
            },
          ),
          //Logout
          LogoutIconButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Products',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover our complete collection of premium products',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 16),
              // Product List
              productProvider.isLoading
                  ? ProductShimmerCardList()
                  : productProvider.products.isEmpty
                  ? Padding(
                      padding: EdgeInsets.only(top: 250),
                      child: const Center(
                        child: Text("No products available."),
                      ),
                    )
                  : LayoutBuilder(
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
                            itemCount: productProvider.products.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: childAspectRatio,
                                ),
                            itemBuilder: (context, index) {
                              final product = productProvider.products[index];
                              final isFav = favoriteProvider.isFavorite(
                                product.id,
                              );

                              return ProductCard(
                                product: product,
                                isFavorite: isFav,
                                onTapFav: () =>
                                    favoriteProvider.toggleFavorite(product.id),
                                onTap: () {
                                  Get.to(
                                    () => ProductDetailScreen(product: product),
                                  );
                                },
                              );
                            },
                          );
                        } else {
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: productProvider.products.length,
                            itemBuilder: (context, index) {
                              final product = productProvider.products[index];
                              final isFav = favoriteProvider.isFavorite(
                                product.id,
                              );

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: ProductCard(
                                  product: product,
                                  isFavorite: isFav,
                                  onTapFav: () => favoriteProvider
                                      .toggleFavorite(product.id),
                                  onTap: () {
                                    Get.to(
                                      () =>
                                          ProductDetailScreen(product: product),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
