import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String category;
  final String description;
  final bool featured;
  final String image;
  final List<String> images;
  final bool inStock;
  final String name;
  final double originalPrice;
  final double price;
  final double rating;
  final int reviewCount;
  final String slug;
  final Map<String, dynamic> specifications;
  final List<String> tags;

  ProductModel({
    required this.id,
    required this.category,
    required this.description,
    required this.featured,
    required this.image,
    required this.images,
    required this.inStock,
    required this.name,
    required this.originalPrice,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.slug,
    required this.specifications,
    required this.tags,
  });

  ///FROM FIRESTORE (DocumentSnapshot to ProductModel)
  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ProductModel(
      id: doc.id,
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      featured: data['featured'] ?? false,
      image: data['image'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      inStock: data['inStock'] ?? false,
      name: data['name'] ?? '',
      originalPrice: (data['originalPrice'] ?? 0).toDouble(),
      price: (data['price'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      reviewCount: data['reviewCount'] ?? 0,
      slug: data['slug'] ?? '',
      specifications: Map<String, dynamic>.from(data['specifications'] ?? {}),
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'category': category,
      'description': description,
      'featured': featured,
      'image': image,
      'images': images,
      'inStock': inStock,
      'name': name,
      'originalPrice': originalPrice,
      'price': price,
      'rating': rating,
      'reviewCount': reviewCount,
      'slug': slug,
      'specifications': specifications,
      'tags': tags,
    };
  }
}
