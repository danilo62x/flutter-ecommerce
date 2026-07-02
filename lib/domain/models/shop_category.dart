/// A browsable product category shown on the categories grid.
///
/// Framework-free: [iconKey] resolves to a Material icon in the UI layer and
/// [colorValue] is a plain ARGB int used for the tile gradient.
class ShopCategory {
  const ShopCategory({
    required this.name,
    required this.iconKey,
    required this.itemCount,
    required this.colorValue,
  });

  final String name;
  final String iconKey;
  final int itemCount;
  final int colorValue;
}
