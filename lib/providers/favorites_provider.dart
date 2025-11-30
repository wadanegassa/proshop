import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => {..._favoriteIds};

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    notifyListeners();
  }

  void addFavorite(Product product) {
    _favoriteIds.add(product.id);
    notifyListeners();
  }

  void removeFavorite(String productId) {
    _favoriteIds.remove(productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteIds.clear();
    notifyListeners();
  }
}
