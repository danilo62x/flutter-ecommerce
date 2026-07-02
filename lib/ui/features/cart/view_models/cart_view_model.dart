import 'package:flutter/foundation.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/domain/models/cart_item.dart';

/// Presentation state for the shopping cart (MVVM).
///
/// Seeded synchronously from the repository in the constructor so the screen
/// renders with content on the first frame.
class CartViewModel extends ChangeNotifier {
  CartViewModel({required ShopRepository repository})
      : _items = List<CartItem>.from(repository.seedCart());

  final List<CartItem> _items;

  /// Free-shipping threshold in reais.
  static const double freeShippingFrom = 299;
  static const double baseShipping = 19.90;

  String? _coupon = 'BEMVINDO10';
  String? get coupon => _coupon;
  bool get hasCoupon => _coupon != null;

  List<CartItem> get items => List<CartItem>.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.lineTotal);

  double get shipping =>
      subtotal >= freeShippingFrom || _items.isEmpty ? 0 : baseShipping;

  /// 10% coupon discount when applied.
  double get discount => hasCoupon ? subtotal * 0.10 : 0;

  double get total => subtotal + shipping - discount;

  void increment(int index) {
    _items[index] = _items[index].copyWith(quantity: _items[index].quantity + 1);
    notifyListeners();
  }

  void decrement(int index) {
    final current = _items[index].quantity;
    if (current <= 1) return;
    _items[index] = _items[index].copyWith(quantity: current - 1);
    notifyListeners();
  }

  void remove(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void applyCoupon(String code) {
    _coupon = code.trim().isEmpty ? null : code.trim().toUpperCase();
    notifyListeners();
  }

  void removeCoupon() {
    _coupon = null;
    notifyListeners();
  }
}
