import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/data/services/shop_api_service.dart';
import 'package:ecommerce/ui/features/checkout/view_models/checkout_view_model.dart';
import 'package:ecommerce/ui/features/checkout/views/checkout_screen.dart';
import 'package:ecommerce/ui/features/confirmation/views/order_confirmation_screen.dart';
import 'package:ecommerce/ui/features/home/views/home_shell.dart';
import 'package:ecommerce/ui/features/product/view_models/product_detail_view_model.dart';
import 'package:ecommerce/ui/features/product/views/product_detail_screen.dart';
import 'package:ecommerce/ui/features/search/view_models/search_view_model.dart';
import 'package:ecommerce/ui/features/search/views/search_screen.dart';

/// App-wide repository (composition root). In a bigger app register this in a
/// DI container such as `get_it` or a top-level `MultiProvider`.
final ShopRepository _shopRepository = ShopRepository(api: ShopApiService());

/// Declarative navigation with go_router. The `/` shell hosts the five bottom
/// tabs; product, search, checkout and confirmation are pushed on top.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => HomeShell(repository: _shopRepository),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => ProductDetailViewModel(
          repository: _shopRepository,
          productId: state.pathParameters['id'] ?? 'p1',
        ),
        child: const ProductDetailScreen(),
      ),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => SearchViewModel(repository: _shopRepository),
        child: const SearchScreen(),
      ),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => CheckoutViewModel(repository: _shopRepository),
        child: const CheckoutScreen(),
      ),
    ),
    GoRoute(
      path: '/confirmation',
      builder: (context, state) => const OrderConfirmationScreen(),
    ),
  ],
);
