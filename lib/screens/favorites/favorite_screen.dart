import 'package:bcom_app/screens/home/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../providers/favorite_provider.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final favProducts = productProvider.products
        .where((p) => favoriteProvider.isFavorite(p.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: favProducts.isEmpty
          ? const Center(child: Text("No favorites yet."))
          : LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth > 600;
                final crossAxisCount = isTablet ? 3 : 1;
                final childAspectRatio = isTablet
                    ? (constraints.maxWidth / crossAxisCount) / 520
                    : 3 / 2;

                if (isTablet) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final product = favProducts[index];

                      return ProductCard(
                        product: product,
                        isFavorite: true,
                        onTapFav: () =>
                            favoriteProvider.toggleFavorite(product.id),
                        onTap: () {
                          Get.to(() => ProductDetailScreen(product: product));
                        },
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: favProducts.length,
                    itemBuilder: (context, index) {
                      final product = favProducts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProductCard(
                          product: product,
                          isFavorite: true,
                          onTapFav: () =>
                              favoriteProvider.toggleFavorite(product.id),
                          onTap: () {
                            Get.to(() => ProductDetailScreen(product: product));
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
    );
  }
}
