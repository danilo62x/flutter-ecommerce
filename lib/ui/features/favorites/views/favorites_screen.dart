import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/domain/models/product.dart';
import 'package:ecommerce/ui/core/widgets/app_widgets.dart';
import 'package:ecommerce/ui/features/favorites/view_models/favorites_view_model.dart';

/// Favorites: a responsive grid of the products the user has hearted, with a
/// summary banner and an empty state fallback.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FavoritesViewModel>();
    final favorites = vm.favorites;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: vm.isEmpty
            ? const EmptyState(
                icon: Icons.favorite_border,
                title: 'Nenhum favorito ainda',
                message: 'Toque no coração dos produtos para salvá-los aqui.',
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final crossAxisCount = width >= 1100
                      ? 4
                      : width >= 760
                          ? 3
                          : 2;

                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
                          child: Text(
                            'Favoritos',
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: _FavoritesBanner(count: vm.count)),
                      const SliverToBoxAdapter(child: SizedBox(height: 18)),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.66,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final Product p = favorites[index];
                              return ProductCard(
                                product: p,
                                isFavorite: vm.isFavorite(p.id),
                                onFavoriteToggle: () => vm.toggleFavorite(p.id),
                                onTap: () => context.push('/product/${p.id}'),
                              );
                            },
                            childCount: favorites.length,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _FavoritesBanner extends StatelessWidget {
  const _FavoritesBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.favorite, color: scheme.onPrimary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$count itens salvos',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'Receba um aviso quando entrarem em promoção',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.notifications_none_rounded,
                color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
