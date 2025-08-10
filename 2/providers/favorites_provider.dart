import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/restaurant.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favoriteProducts = [];
  final List<Restaurant> _favoriteRestaurants = [];

  var favoriteProductIds;

  List<Product> get favoriteProducts => List.unmodifiable(_favoriteProducts);
  List<Restaurant> get favoriteRestaurants =>
      List.unmodifiable(_favoriteRestaurants);

  // Product favorites methods
  bool isFavorite(int productId) {
    return _favoriteProducts.any((product) => product.id == productId);
  }

  void toggleFavorite(Product product) {
    final existingIndex = _favoriteProducts.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingIndex >= 0) {
      _favoriteProducts.removeAt(existingIndex);
    } else {
      _favoriteProducts.add(product);
    }
    notifyListeners();
  }

  void addToFavorites(Product product) {
    if (!isFavorite(product.id)) {
      _favoriteProducts.add(product);
      notifyListeners();
    }
  }

  void removeProductFromFavorites(int productId) {
    // قم بتنفيذ منطق إزالة المنتج هنا
    // مثلاً:
    _favoriteProducts.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  void addProductToFavorites(Product product) {
    _favoriteProducts.add(product);
    notifyListeners();
  }

  bool isProductFavorite(int productId) {
    return _favoriteProducts.any((p) => p.id == productId);
  }

  void removeFromFavorites(int productId) {
    _favoriteProducts.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteProducts.clear();
    notifyListeners();
  }

  // Restaurant favorites methods
  bool isFavoriteRestaurant(int restaurantId) {
    return _favoriteRestaurants
        .any((restaurant) => restaurant.id == restaurantId);
  }

  void toggleRestaurantFavorite(Restaurant restaurant) {
    final existingIndex = _favoriteRestaurants.indexWhere(
      (item) => item.id == restaurant.id,
    );

    if (existingIndex >= 0) {
      _favoriteRestaurants.removeAt(existingIndex);
    } else {
      _favoriteRestaurants.add(restaurant);
    }
    notifyListeners();
  }

  void addRestaurantToFavorites(Restaurant restaurant) {
    if (!isFavoriteRestaurant(restaurant.id)) {
      _favoriteRestaurants.add(restaurant);
      notifyListeners();
    }
  }

  void removeRestaurantFromFavorites(int restaurantId) {
    _favoriteRestaurants
        .removeWhere((restaurant) => restaurant.id == restaurantId);
    notifyListeners();
  }

  void clearRestaurantFavorites() {
    _favoriteRestaurants.clear();
    notifyListeners();
  }

  void clearAllFavorites() {
    _favoriteProducts.clear();
    _favoriteRestaurants.clear();
    notifyListeners();
  }
}
