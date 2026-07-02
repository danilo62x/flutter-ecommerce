import 'package:ecommerce/domain/models/product.dart';

/// A single line in the shopping cart: a [product] plus the chosen [size] and
/// [quantity]. Kept immutable; mutations go through [copyWith].
class CartItem {
  const CartItem({
    required this.product,
    required this.size,
    this.quantity = 1,
  });

  final Product product;
  final String size;
  final int quantity;

  /// Price for this line (unit price × quantity).
  double get lineTotal => product.price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        product: product,
        size: size,
        quantity: quantity ?? this.quantity,
      );
}
