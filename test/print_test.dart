import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/core/theme.dart';
import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/data/services/shop_api_service.dart';
import 'package:ecommerce/ui/features/cart/view_models/cart_view_model.dart';
import 'package:ecommerce/ui/features/cart/views/cart_screen.dart';
import 'package:ecommerce/ui/features/categories/view_models/categories_view_model.dart';
import 'package:ecommerce/ui/features/categories/views/categories_screen.dart';
import 'package:ecommerce/ui/features/checkout/view_models/checkout_view_model.dart';
import 'package:ecommerce/ui/features/checkout/views/checkout_screen.dart';
import 'package:ecommerce/ui/features/confirmation/views/order_confirmation_screen.dart';
import 'package:ecommerce/ui/features/favorites/view_models/favorites_view_model.dart';
import 'package:ecommerce/ui/features/favorites/views/favorites_screen.dart';
import 'package:ecommerce/ui/features/product/view_models/product_detail_view_model.dart';
import 'package:ecommerce/ui/features/product/views/product_detail_screen.dart';
import 'package:ecommerce/ui/features/profile/view_models/profile_view_model.dart';
import 'package:ecommerce/ui/features/profile/views/profile_screen.dart';
import 'package:ecommerce/ui/features/search/view_models/search_view_model.dart';
import 'package:ecommerce/ui/features/search/views/search_screen.dart';
import 'package:ecommerce/ui/features/shop/view_models/shop_view_model.dart';
import 'package:ecommerce/ui/features/shop/views/shop_screen.dart';

import 'golden_utils.dart';

typedef PageBuilder = Widget Function();

/// Renders every screen at phone resolution in light then dark theme and writes
/// real PNGs to `screenshots/`:
///
///   ecommerce.png … ecommerce-9.png   (light: 9 screens)
///   ecommerce-10.png … ecommerce-18.png (dark: same 9 screens)
///
///   flutter test test/print_test.dart
void main() {
  final repo = ShopRepository(api: ShopApiService());

  final pages = <(String, PageBuilder)>[
    (
      'Home',
      () => ChangeNotifierProvider(
            create: (_) => ShopViewModel(repository: repo),
            child: const ShopScreen(),
          ),
    ),
    (
      'Produto',
      () => ChangeNotifierProvider(
            create: (_) =>
                ProductDetailViewModel(repository: repo, productId: 'p1'),
            child: const ProductDetailScreen(),
          ),
    ),
    (
      'Carrinho',
      () => ChangeNotifierProvider(
            create: (_) => CartViewModel(repository: repo),
            child: const CartScreen(),
          ),
    ),
    (
      'Checkout',
      () => ChangeNotifierProvider(
            create: (_) => CheckoutViewModel(repository: repo),
            child: const CheckoutScreen(),
          ),
    ),
    ('Confirmação', () => const OrderConfirmationScreen()),
    (
      'Categorias',
      () => ChangeNotifierProvider(
            create: (_) => CategoriesViewModel(repository: repo),
            child: const CategoriesScreen(),
          ),
    ),
    (
      'Busca',
      () => ChangeNotifierProvider(
            create: (_) => SearchViewModel(repository: repo),
            child: const SearchScreen(),
          ),
    ),
    (
      'Favoritos',
      () => ChangeNotifierProvider(
            create: (_) => FavoritesViewModel(repository: repo),
            child: const FavoritesScreen(),
          ),
    ),
    (
      'Perfil',
      () => ChangeNotifierProvider(
            create: (_) => ProfileViewModel(repository: repo),
            child: const ProfileScreen(),
          ),
    ),
  ];

  testWidgets('ecommerce screenshots (claro+escuro)', (tester) async {
    await loadGoldenFonts();
    tester.binding.focusManager.highlightStrategy =
        FocusHighlightStrategy.alwaysTouch;
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    var idx = 0;
    for (final theme in <ThemeData>[AppTheme.light(), AppTheme.dark()]) {
      for (final page in pages) {
        final key = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              home: page.$2(),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 3.0);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final suffix = idx == 0 ? '' : '-${idx + 1}';
          final file = File('screenshots/ecommerce$suffix.png');
          await file.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
        });
        idx++;
      }
    }
  });
}
