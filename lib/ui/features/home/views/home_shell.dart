import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/ui/features/cart/view_models/cart_view_model.dart';
import 'package:ecommerce/ui/features/cart/views/cart_screen.dart';
import 'package:ecommerce/ui/features/categories/view_models/categories_view_model.dart';
import 'package:ecommerce/ui/features/categories/views/categories_screen.dart';
import 'package:ecommerce/ui/features/favorites/view_models/favorites_view_model.dart';
import 'package:ecommerce/ui/features/favorites/views/favorites_screen.dart';
import 'package:ecommerce/ui/features/profile/view_models/profile_view_model.dart';
import 'package:ecommerce/ui/features/profile/views/profile_screen.dart';
import 'package:ecommerce/ui/features/shop/view_models/shop_view_model.dart';
import 'package:ecommerce/ui/features/shop/views/shop_screen.dart';

/// Bottom-navigation shell hosting the five primary tabs (Loja, Categorias,
/// Favoritos, Carrinho, Perfil). Each tab owns its ViewModel provider.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.repository});

  final ShopRepository repository;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final repo = widget.repository;
    final tabs = <Widget>[
      ChangeNotifierProvider(
        create: (_) => ShopViewModel(repository: repo),
        child: const ShopScreen(),
      ),
      ChangeNotifierProvider(
        create: (_) => CategoriesViewModel(repository: repo),
        child: const CategoriesScreen(),
      ),
      ChangeNotifierProvider(
        create: (_) => FavoritesViewModel(repository: repo),
        child: const FavoritesScreen(),
      ),
      ChangeNotifierProvider(
        create: (_) => CartViewModel(repository: repo),
        child: const CartScreen(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileViewModel(repository: repo),
        child: const ProfileScreen(),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront),
            label: 'Loja',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Categorias',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Badge(label: Text('3'), child: Icon(Icons.shopping_bag_outlined)),
            selectedIcon: Badge(label: Text('3'), child: Icon(Icons.shopping_bag)),
            label: 'Carrinho',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
