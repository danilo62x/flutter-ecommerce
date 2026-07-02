import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/domain/models/product.dart';
import 'package:ecommerce/ui/core/widgets/app_widgets.dart';
import 'package:ecommerce/ui/features/search/view_models/search_view_model.dart';

/// Search + results: a search field, price and rating filters and a scrollable
/// list of matching products.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    final results = vm.results;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: TextField(
          controller: TextEditingController(text: vm.query),
          onChanged: vm.setQuery,
          decoration: InputDecoration(
            hintText: 'Buscar produtos',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => vm.setQuery(''),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _FilterCard(vm: vm),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                'Resultados',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              Text(
                '${results.length} itens',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const Spacer(),
              Icon(Icons.swap_vert_rounded,
                  size: 20, color: theme.colorScheme.onSurfaceVariant),
              Text(
                'Relevância',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: EmptyState(
                icon: Icons.search_off_rounded,
                title: 'Nenhum resultado',
                message: 'Ajuste os filtros ou tente outra busca.',
              ),
            )
          else
            ...results.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ResultTile(
                  product: p,
                  isFavorite: vm.isFavorite(p.id),
                  onFavorite: () => vm.toggleFavorite(p.id),
                  onTap: () => context.push('/product/${p.id}'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({required this.vm});

  final SearchViewModel vm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, size: 20, color: scheme.primary),
              const SizedBox(width: 8),
              Text('Filtros',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(
                'Preço até ${formatBrl(vm.priceMax)}',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.primary, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          Slider(
            value: vm.priceMax,
            min: 0,
            max: SearchViewModel.maxPriceLimit,
            divisions: 24,
            onChanged: vm.setPriceMax,
          ),
          const SizedBox(height: 4),
          Text('Avaliação mínima',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              _RatingChip(label: 'Tudo', value: 0, vm: vm),
              _RatingChip(label: '4.0+', value: 4.0, vm: vm),
              _RatingChip(label: '4.5+', value: 4.5, vm: vm),
              _RatingChip(label: '4.8+', value: 4.8, vm: vm),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({
    required this.label,
    required this.value,
    required this.vm,
  });

  final String label;
  final double value;
  final SearchViewModel vm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final selected = vm.minRating == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      avatar: value > 0
          ? Icon(Icons.star_rounded,
              size: 16, color: selected ? scheme.onPrimary : const Color(0xFFFFB300))
          : null,
      onSelected: (_) => vm.setMinRating(value),
      labelStyle: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w600,
        color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
      ),
      selectedColor: scheme.primary,
      backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      side: BorderSide.none,
      shape: const StadiumBorder(),
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.product,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  final Product product;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 92,
                  height: 92,
                  child: ProductArt(
                    colorValue: product.colorValue,
                    iconKey: product.iconKey,
                    iconSize: 38,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    RatingRow(
                        rating: product.rating, count: product.reviewCount),
                    const SizedBox(height: 6),
                    Text(
                      formatBrl(product.price),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? scheme.error : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
