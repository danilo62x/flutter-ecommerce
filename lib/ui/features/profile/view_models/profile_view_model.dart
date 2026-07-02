import 'package:flutter/foundation.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/domain/models/order.dart';

/// Presentation state for the profile / orders screen (MVVM).
class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required ShopRepository repository})
      : _orders = repository.seedOrders(),
        _favoritesCount = repository.seedFavorites().length;

  final List<Order> _orders;
  final int _favoritesCount;

  String get userName => 'Ana Ribeiro';
  String get userEmail => 'ana.ribeiro@email.com';
  String get initials => 'AR';

  List<Order> get orders => List<Order>.unmodifiable(_orders);

  int get ordersCount => _orders.length;
  int get favoritesCount => _favoritesCount;
  int get couponsCount => 5;
}
