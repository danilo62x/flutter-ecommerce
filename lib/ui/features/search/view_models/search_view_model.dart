import 'package:flutter/foundation.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/domain/models/product.dart';

/// Presentation state for search + results (MVVM).
///
/// Seeds a query in the constructor so the results list has content on the
/// first frame (screenshot test).
class SearchViewModel extends ChangeNotifier {
  SearchViewModel({required ShopRepository repository})
      : _all = repository.seed(),
        _favorites = repository.seedFavorites();

  final List<Product> _all;
  final Set<String> _favorites;

  static const double maxPriceLimit = 1200;
  static const List<String> recent = <String>['Tênis corrida', 'Jaqueta', 'Fones'];

  String _query = 'Tênis';
  String get query => _query;

  double _priceMax = maxPriceLimit;
  double get priceMax => _priceMax;

  double _minRating = 0;
  double get minRating => _minRating;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setPriceMax(double value) {
    _priceMax = value;
    notifyListeners();
  }

  void setMinRating(double value) {
    _minRating = value;
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  /// Products matching the query and active filters.
  List<Product> get results {
    final q = _query.trim().toLowerCase();
    return _all.where((p) {
      final matchesQuery = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
      return matchesQuery && p.price <= _priceMax && p.rating >= _minRating;
    }).toList();
  }
}
