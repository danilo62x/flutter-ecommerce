import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/ui/core/widgets/app_widgets.dart';
import 'package:ecommerce/ui/features/checkout/view_models/checkout_view_model.dart';

/// Checkout: delivery-step indicator, address picker, payment methods, order
/// summary and a pay bar.
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CheckoutViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout',
            style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          const _StepBar(current: 1),
          const SizedBox(height: 22),
          const _SectionTitle(
              icon: Icons.location_on_outlined, label: 'Endereço de entrega'),
          const SizedBox(height: 10),
          ...List.generate(CheckoutViewModel.addresses.length, (i) {
            final a = CheckoutViewModel.addresses[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SelectableCard(
                selected: vm.selectedAddress == i,
                onTap: () => vm.selectAddress(i),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        StatusPill(
                          label: a.label,
                          color: Theme.of(context).colorScheme.primary,
                          icon: a.label == 'Casa'
                              ? Icons.home_outlined
                              : Icons.work_outline,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          a.recipient,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      a.line,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          const _SectionTitle(
              icon: Icons.credit_card_outlined, label: 'Forma de pagamento'),
          const SizedBox(height: 10),
          ...List.generate(CheckoutViewModel.payments.length, (i) {
            final p = CheckoutViewModel.payments[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SelectableCard(
                selected: vm.selectedPayment == i,
                onTap: () => vm.selectPayment(i),
                child: Row(
                  children: [
                    _PaymentIcon(iconKey: p.iconKey),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.label,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            p.detail,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          const _SectionTitle(
              icon: Icons.receipt_long_outlined, label: 'Resumo do pedido'),
          const SizedBox(height: 10),
          _OrderSummary(vm: vm),
        ],
      ),
      bottomNavigationBar: _PayBar(total: vm.total),
    );
  }
}

class _StepBar extends StatelessWidget {
  const _StepBar({required this.current});

  final int current;

  @override
  Widget build(BuildContext context) {
    const labels = ['Sacola', 'Entrega', 'Pagamento'];
    return Row(
      children: List.generate(labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final done = (i ~/ 2) < current;
          return Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: done
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }
        final index = i ~/ 2;
        return _StepDot(
          index: index + 1,
          label: labels[index],
          active: index <= current,
          done: index < current,
        );
      }),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.index,
    required this.label,
    required this.active,
    required this.done,
  });

  final int index;
  final String label;
  final bool active;
  final bool done;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: active
                ? scheme.primary
                : scheme.surfaceContainerHighest.withValues(alpha: 0.7),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: done
                ? Icon(Icons.check, size: 16, color: scheme.onPrimary)
                : Text(
                    '$index',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      color:
                          active ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active ? scheme.onSurface : scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style:
              theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({
    required this.selected,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? scheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: child),
              const SizedBox(width: 12),
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selected ? scheme.primary : scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentIcon extends StatelessWidget {
  const _PaymentIcon({required this.iconKey});

  final String iconKey;

  IconData get _icon {
    switch (iconKey) {
      case 'pix':
        return Icons.pix;
      case 'boleto':
        return Icons.receipt_outlined;
      default:
        return Icons.credit_card;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(_icon, color: scheme.primary),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({required this.vm});

  final CheckoutViewModel vm;

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
          PriceSummaryRow(
              label: 'Itens (${vm.itemCount})', value: formatBrl(vm.subtotal)),
          PriceSummaryRow(
            label: 'Frete',
            value: vm.shipping == 0 ? 'Grátis' : formatBrl(vm.shipping),
            valueColor: vm.shipping == 0 ? const Color(0xFF16A34A) : null,
          ),
          PriceSummaryRow(
            label: 'Desconto',
            value: '- ${formatBrl(vm.discount)}',
            valueColor: const Color(0xFF16A34A),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
                height: 1, color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          PriceSummaryRow(
              label: 'Total', value: formatBrl(vm.total), emphasize: true),
        ],
      ),
    );
  }
}

class _PayBar extends StatelessWidget {
  const _PayBar({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: FilledButton.icon(
          onPressed: () => context.push('/confirmation'),
          icon: const Icon(Icons.lock_outline, size: 20),
          label: Text('Pagar  ${formatBrl(total)}'),
          style: FilledButton.styleFrom(
            backgroundColor: scheme.primary,
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
