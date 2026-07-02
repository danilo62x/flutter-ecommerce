import 'package:flutter/foundation.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/domain/models/product.dart';

/// Presentation state for a single product page (MVVM).
///
/// The product is resolved synchronously from the repository seed in the
/// constructor so the first frame already has content (screenshot test).
class ProductDetailViewModel extends ChangeNotifier {
  ProductDetailViewModel({
    required ShopRepository repository,
    required String productId,
  }) : _product = repository.productById(productId) {
    _selectedSize = _product.sizes.length > 2
        ? _product.sizes[2]
        : (_product.sizes.isNotEmpty ? _product.sizes.first : 'Único');
  }

  final Product _product;
  Product get product => _product;

  /// Demo color swatches offered on the detail page.
  static const List<int> colorOptions = <int>[
    0xFF1F2937,
    0xFFEF4444,
    0xFF2563EB,
    0xFFF59E0B,
  ];

  late String _selectedSize;
  String get selectedSize => _selectedSize;

  int _selectedColor = 0;
  int get selectedColor => _selectedColor;

  int _quantity = 1;
  int get quantity => _quantity;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  /// Running price for the chosen quantity.
  double get total => _product.price * _quantity;

  void selectSize(String size) {
    if (size == _selectedSize) return;
    _selectedSize = size;
    notifyListeners();
  }

  void selectColor(int index) {
    if (index == _selectedColor) return;
    _selectedColor = index;
    notifyListeners();
  }

  void increment() {
    _quantity++;
    notifyListeners();
  }

  void decrement() {
    if (_quantity <= 1) return;
    _quantity--;
    notifyListeners();
  }

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}
