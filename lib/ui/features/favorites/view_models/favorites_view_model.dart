import 'package:flutter/foundation.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/domain/models/product.dart';

/// Presentation state for the favorites grid (MVVM).
class FavoritesViewModel extends ChangeNotifier {
  FavoritesViewModel({required ShopRepository repository})
      : _all = repository.seed(),
        _favorites = repository.seedFavorites();

  final List<Product> _all;
  final Set<String> _favorites;

  /// Products currently marked as favorite.
  List<Product> get favorites =>
      _all.where((p) => _favorites.contains(p.id)).toList();

  bool get isEmpty => _favorites.isEmpty;
  int get count => _favorites.length;

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }
}
