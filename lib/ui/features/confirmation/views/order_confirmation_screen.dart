import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecommerce/ui/core/widgets/app_widgets.dart';

/// Success screen shown after payment: animated check badge, order number and
/// an order summary with delivery estimate.
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({
    super.key,
    this.orderNumber = '#EC-20493',
    this.total = 1043.73,
    this.itemCount = 4,
  });

  final String orderNumber;
  final double total;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF16A34A),
                        Color.lerp(
                            const Color(0xFF16A34A), Colors.black, 0.25)!,
                      ],
                    ),
                  ),
                  child: const Icon(Icons.check_rounded,
                      size: 64, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Pedido confirmado!',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Obrigado pela compra. Enviamos os detalhes\npara o seu e-mail.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant, height: 1.4),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Número do pedido',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        Text(
                          orderNumber,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: scheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Divider(
                          height: 1,
                          color: scheme.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    _SummaryLine(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Itens',
                      value: '$itemCount produtos',
                    ),
                    const SizedBox(height: 12),
                    _SummaryLine(
                      icon: Icons.payments_outlined,
                      label: 'Total pago',
                      value: formatBrl(total),
                    ),
                    const SizedBox(height: 12),
                    const _SummaryLine(
                      icon: Icons.local_shipping_outlined,
                      label: 'Entrega estimada',
                      value: '3–5 dias úteis',
                    ),
                    const SizedBox(height: 12),
                    const _SummaryLine(
                      icon: Icons.location_on_outlined,
                      label: 'Endereço',
                      value: 'Rua das Palmeiras, 240',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.local_shipping_outlined, size: 20),
                label: const Text('Acompanhar pedido'),
                style: FilledButton.styleFrom(backgroundColor: scheme.primary),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () => context.canPop() ? context.go('/') : null,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  side: BorderSide(color: scheme.outlineVariant),
                  textStyle: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Voltar à loja'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: scheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(
          label,
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
