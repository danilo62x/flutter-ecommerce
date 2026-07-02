import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/domain/models/cart_item.dart';
import 'package:ecommerce/ui/core/widgets/app_widgets.dart';
import 'package:ecommerce/ui/features/cart/view_models/cart_view_model.dart';

/// Shopping cart: line items with quantity steppers, coupon field and a price
/// summary (subtotal, shipping, discount, total) plus a checkout bar.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CartViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho',
            style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w800)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '${vm.totalQuantity} itens',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
      body: vm.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Seu carrinho está vazio',
              message: 'Adicione produtos para vê-los aqui.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                ...List.generate(vm.items.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CartTile(
                      item: vm.items[index],
                      onIncrement: () => vm.increment(index),
                      onDecrement: () => vm.decrement(index),
                      onRemove: () => vm.remove(index),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                const _CouponField(),
                const SizedBox(height: 16),
                _SummaryCard(vm: vm),
              ],
            ),
      bottomNavigationBar: vm.isEmpty ? null : _CheckoutBar(total: vm.total),
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 78,
              height: 78,
              child: ProductArt(
                colorValue: item.product.colorValue,
                iconKey: item.product.iconKey,
                iconSize: 34,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(Icons.close_rounded,
                            size: 18, color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Tam. ${item.size}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formatBrl(item.lineTotal),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    QuantityStepper(
                      quantity: item.quantity,
                      onIncrement: onIncrement,
                      onDecrement: onDecrement,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponField extends StatelessWidget {
  const _CouponField();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CartViewModel>();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (vm.hasCoupon) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer_outlined,
                size: 20, color: Color(0xFF16A34A)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cupom ${vm.coupon} aplicado',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A34A),
                ),
              ),
            ),
            TextButton(
              onPressed: vm.removeCoupon,
              child: Text(
                'Remover',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        const Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cupom de desconto',
              prefixIcon: Icon(Icons.local_offer_outlined),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: () => vm.applyCoupon('BEMVINDO10'),
            style: FilledButton.styleFrom(
              backgroundColor: scheme.primary,
              minimumSize: const Size(88, 56),
            ),
            child: const Text('Aplicar'),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.vm});

  final CartViewModel vm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          PriceSummaryRow(label: 'Subtotal', value: formatBrl(vm.subtotal)),
          PriceSummaryRow(
            label: 'Frete',
            value: vm.shipping == 0 ? 'Grátis' : formatBrl(vm.shipping),
            valueColor: vm.shipping == 0 ? const Color(0xFF16A34A) : null,
          ),
          if (vm.discount > 0)
            PriceSummaryRow(
              label: 'Desconto (${vm.coupon})',
              value: '- ${formatBrl(vm.discount)}',
              valueColor: const Color(0xFF16A34A),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
                height: 1, color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          PriceSummaryRow(
            label: 'Total',
            value: formatBrl(vm.total),
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                Text(
                  formatBrl(total),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 18),
            Expanded(
              child: FilledButton(
                onPressed: () => context.push('/checkout'),
                style: FilledButton.styleFrom(backgroundColor: scheme.primary),
                child: const Text('Finalizar compra'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
