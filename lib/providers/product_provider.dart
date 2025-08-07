import 'package:bcom_app/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _products = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<ProductModel> get products => _products;

  ProductProvider() {
    fetchProducts();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Fetch products from Firestore
  Future<void> fetchProducts() async {
    setLoading(true);
    try {
      final querySnapshot = await _firestore.collection('products').get();
      _products.clear();
      for (var doc in querySnapshot.docs) {
        _products.add(ProductModel.fromFirestore(doc));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      setLoading(false);
    }
  }

}