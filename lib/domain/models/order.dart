/// Lifecycle stage of a customer [Order].
enum OrderStatus { processing, shipped, delivered, canceled }

/// A past purchase shown in the profile / orders list.
///
/// Framework-free: [iconKey] resolves to a Material icon in the UI and
/// [colorValue] is a plain ARGB int for the thumbnail gradient.
class Order {
  const Order({
    required this.id,
    required this.dateLabel,
    required this.status,
    required this.total,
    required this.itemCount,
    required this.iconKey,
    required this.colorValue,
  });

  final String id;
  final String dateLabel;
  final OrderStatus status;
  final double total;
  final int itemCount;
  final String iconKey;
  final int colorValue;
}
