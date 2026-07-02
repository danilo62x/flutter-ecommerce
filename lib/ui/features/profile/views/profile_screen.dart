import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/domain/models/order.dart';
import 'package:ecommerce/ui/core/widgets/app_widgets.dart';
import 'package:ecommerce/ui/features/profile/view_models/profile_view_model.dart';

/// Profile: user header with avatar, quick stats, recent orders with status
/// pills and an account settings menu.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            _ProfileHeader(vm: vm),
            const SizedBox(height: 18),
            _StatsRow(vm: vm),
            const SizedBox(height: 22),
            const SectionHeader(
              title: 'Meus pedidos',
              actionLabel: 'Ver todos',
              padding: EdgeInsets.only(bottom: 12),
            ),
            ...vm.orders.take(3).map(
                  (o) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _OrderTile(order: o),
                  ),
                ),
            const SizedBox(height: 10),
            const SectionHeader(
              title: 'Conta',
              padding: EdgeInsets.only(bottom: 8),
            ),
            _MenuCard(
              children: const [
                _MenuItem(icon: Icons.location_on_outlined, label: 'Endereços'),
                _MenuItem(
                    icon: Icons.credit_card_outlined,
                    label: 'Formas de pagamento'),
                _MenuItem(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notificações'),
                _MenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Sair',
                    danger: true,
                    last: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.vm});

  final ProfileViewModel vm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.primary,
                Color.lerp(scheme.primary, Colors.black, 0.3)!,
              ],
            ),
          ),
          child: Center(
            child: Text(
              vm.initials,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: scheme.onPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.userName,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                vm.userEmail,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        Material(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.edit_outlined, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.vm});

  final ProfileViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.receipt_long_outlined,
            value: '${vm.ordersCount}',
            label: 'Pedidos',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.favorite_border,
            value: '${vm.favoritesCount}',
            label: 'Favoritos',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.local_offer_outlined,
            value: '${vm.couponsCount}',
            label: 'Cupons',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: scheme.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = orderStatusStyle(order.status, scheme);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 56,
              height: 56,
              child: ProductArt(
                colorValue: order.colorValue,
                iconKey: order.iconKey,
                iconSize: 26,
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
                    Text(
                      order.id,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    StatusPill(
                        label: style.label,
                        color: style.color,
                        icon: style.icon),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.dateLabel} · ${order.itemCount} '
                  '${order.itemCount == 1 ? "item" : "itens"}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  formatBrl(order.total),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.danger = false,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final bool danger;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = danger ? scheme.error : scheme.onSurface;
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: danger ? scheme.error : scheme.primary),
          title: Text(
            label,
            style: theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600, color: color),
          ),
          trailing: danger
              ? null
              : Icon(Icons.chevron_right_rounded,
                  color: scheme.onSurfaceVariant),
          onTap: () {},
        ),
        if (!last)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
                height: 1,
                color: scheme.outlineVariant.withValues(alpha: 0.4)),
          ),
      ],
    );
  }
}
