import 'package:flutter/foundation.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/domain/models/product.dart';

/// Presentation state for the shop screen (MVVM).
///
/// The catalog is seeded synchronously in the constructor so the first frame
/// already has content (important for the screenshot test). [refresh] shows the
/// real async path through the repository.
class ShopViewModel extends ChangeNotifier {
  ShopViewModel({required ShopRepository repository})
      : _repository = repository {
    _products = _repository.seed();
  }

  final ShopRepository _repository;

  List<Product> _products = const <Product>[];

  static const List<String> categories = <String>[
    'Tudo',
    'Tênis',
    'Roupas',
    'Acessórios',
  ];

  String _selectedCategory = 'Tudo';
  String get selectedCategory => _selectedCategory;

  final Set<String> _favorites = <String>{'p1'};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int get cartCount => 3;

  /// Products visible for the current category filter.
  List<Product> get products {
    if (_selectedCategory == 'Tudo') return List<Product>.unmodifiable(_products);
    return List<Product>.unmodifiable(
      _products.where((p) => p.category == _selectedCategory),
    );
  }

  bool isFavorite(String id) => _favorites.contains(id);

  void selectCategory(String category) {
    if (category == _selectedCategory) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  /// Real async reload of the catalog through the repository/service.
  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _repository.fetch();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
