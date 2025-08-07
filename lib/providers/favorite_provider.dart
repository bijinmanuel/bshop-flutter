import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Set<String> _favoriteProductIds = {};

  Set<String> get favoriteProductIds => _favoriteProductIds;

  FavoriteProvider() {
    _loadFavorites();
  }

  /// Load favorites for the logged-in user
  Future<void> _loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc = await _firestore.collection('favorite').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        final favs = List<String>.from(data?['productIds'] ?? []);
        _favoriteProductIds = Set<String>.from(favs);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }
  }

  /// Toggle favorite status
  void toggleFavorite(String productId) {
    if (_favoriteProductIds.contains(productId)) {
      _favoriteProductIds.remove(productId);
    } else {
      _favoriteProductIds.add(productId);
    }
    notifyListeners();
    _saveFavorites();
  }

  /// Check if a product is favorite
  bool isFavorite(String productId) {
    return _favoriteProductIds.contains(productId);
  }

  /// Save updated favorites to Firestore
  Future<void> _saveFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('favorite').doc(user.uid).set({
        'productIds': _favoriteProductIds.toList(),
      });
    } catch (e) {
      debugPrint("Error saving favorites: $e");
    }
  }
}
  