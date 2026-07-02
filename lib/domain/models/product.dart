/// Clean domain model consumed by the UI layer.
///
/// Holds no Flutter types: [colorValue] is a plain ARGB int and [iconKey] is a
/// string the UI maps to a Material icon, so the domain stays framework-free.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    required this.colorValue,
    required this.iconKey,
    this.oldPrice,
    this.reviewCount = 0,
    this.description = '',
    this.sizes = const <String>[],
  });

  final String id;
  final String name;

  /// Price in Brazilian reais.
  final double price;

  /// Original price before discount, in reais. Null when the item is not on sale.
  final double? oldPrice;

  /// Average rating from 0 to 5.
  final double rating;

  /// Number of ratings that produced [rating].
  final int reviewCount;
  final String category;

  /// ARGB accent color used to build the card gradient.
  final int colorValue;

  /// Logical icon name (`run`, `shirt`, `watch`, ...) resolved in the UI.
  final String iconKey;

  /// Long-form marketing copy shown on the product detail screen.
  final String description;

  /// Available size labels (`38`, `M`, `Único`, ...).
  final List<String> sizes;

  /// Whether the item currently carries a discount.
  bool get isOnSale => oldPrice != null && oldPrice! > price;

  /// Discount percentage (0–100) or 0 when the item is not on sale.
  int get discountPercent =>
      isOnSale ? (((oldPrice! - price) / oldPrice!) * 100).round() : 0;
}
