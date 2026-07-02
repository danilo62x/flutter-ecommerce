import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/ui/core/widgets/app_widgets.dart';
import 'package:ecommerce/ui/features/product/view_models/product_detail_view_model.dart';

/// Rich product detail: gradient hero, price, rating, size + color selectors,
/// description and a sticky add-to-cart bar.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductDetailViewModel>();
    final product = vm.product;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HeroBanner(
              colorValue: product.colorValue,
              iconKey: product.iconKey,
              isFavorite: vm.isFavorite,
              onBack: () => context.canPop() ? context.pop() : null,
              onFavorite: vm.toggleFavorite,
              onSale: product.isOnSale,
              discount: product.discountPercent,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      StatusPill(
                        label: product.category,
                        color: scheme.primary,
                        icon: Icons.sell_outlined,
                      ),
                      const Spacer(),
                      RatingRow(
                        rating: product.rating,
                        count: product.reviewCount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    product.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatBrl(product.price),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: scheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (product.isOnSale) ...[
                        const SizedBox(width: 10),
                        Text(
                          formatBrl(product.oldPrice!),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        'em até 10x',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _SelectorLabel(
                    label: 'Tamanho',
                    trailing: 'Guia de medidas',
                  ),
                  const SizedBox(height: 10),
                  _SizeSelector(
                    sizes: product.sizes,
                    selected: vm.selectedSize,
                    onSelected: vm.selectSize,
                  ),
                  const SizedBox(height: 20),
                  const _SelectorLabel(label: 'Cor'),
                  const SizedBox(height: 10),
                  _ColorSelector(
                    colors: ProductDetailViewModel.colorOptions,
                    selected: vm.selectedColor,
                    onSelected: vm.selectColor,
                  ),
                  const SizedBox(height: 22),
                  const _SelectorLabel(label: 'Descrição'),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _FeatureRow(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _AddToCartBar(
        quantity: vm.quantity,
        total: vm.total,
        onIncrement: vm.increment,
        onDecrement: vm.decrement,
        onAdd: () => context.push('/cart'),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({
    required this.colorValue,
    required this.iconKey,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
    required this.onSale,
    required this.discount,
  });

  final int colorValue;
  final String iconKey;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final bool onSale;
  final int discount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 340,
      child: Stack(
        children: [
          Positioned.fill(
            child: ProductArt(
              colorValue: colorValue,
              iconKey: iconKey,
              iconSize: 128,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleButton(icon: Icons.arrow_back_rounded, onTap: onBack),
                  Row(
                    children: [
                      _CircleButton(icon: Icons.share_outlined, onTap: () {}),
                      const SizedBox(width: 8),
                      _CircleButton(
                        icon: isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite ? scheme.error : null,
                        onTap: onFavorite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (onSale)
            Positioned(
              left: 20,
              bottom: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '-$discount% OFF',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap, this.color});

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 22, color: color ?? Colors.black87),
        ),
      ),
    );
  }
}

class _SelectorLabel extends StatelessWidget {
  const _SelectorLabel({required this.label, this.trailing});

  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          label,
          style:
              theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        if (trailing != null)
          Text(
            trailing!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

class _SizeSelector extends StatelessWidget {
  const _SizeSelector({
    required this.sizes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> sizes;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: sizes.map((size) {
        final isSelected = size == selected;
        return GestureDetector(
          onTap: () => onSelected(size),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            constraints: const BoxConstraints(minWidth: 54),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? scheme.primary
                  : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              size,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w700,
                color: isSelected ? scheme.onPrimary : scheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  const _ColorSelector({
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final List<int> colors;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(colors.length, (index) {
        final isSelected = index == selected;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(colors[index]),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? scheme.primary : Colors.transparent,
                  width: 3,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),
        );
      }),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _FeatureChip(
            icon: Icons.local_shipping_outlined,
            label: 'Frete grátis',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _FeatureChip(
            icon: Icons.verified_outlined,
            label: 'Garantia 1 ano',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _FeatureChip(
            icon: Icons.replay_outlined,
            label: 'Troca fácil',
          ),
        ),
      ],
    );
  }
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: scheme.primary, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({
    required this.quantity,
    required this.total,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAdd,
  });

  final int quantity;
  final double total;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            QuantityStepper(
              quantity: quantity,
              onIncrement: onIncrement,
              onDecrement: onDecrement,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                label: Text('Adicionar  •  ${formatBrl(total)}'),
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.primary,
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
