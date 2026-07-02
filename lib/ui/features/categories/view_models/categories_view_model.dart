import 'package:flutter/foundation.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/domain/models/shop_category.dart';

/// Presentation state for the categories grid (MVVM).
class CategoriesViewModel extends ChangeNotifier {
  CategoriesViewModel({required ShopRepository repository})
      : _categories = repository.seedCategories();

  final List<ShopCategory> _categories;

  List<ShopCategory> get categories =>
      List<ShopCategory>.unmodifiable(_categories);

  int get totalItems =>
      _categories.fold(0, (sum, c) => sum + c.itemCount);
}
