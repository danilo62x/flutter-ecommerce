import 'package:ecommerce/domain/models/product.dart';

/// Raw API model with manual JSON (de)serialization.
///
/// The transport shape differs from the domain: price arrives in cents and the
/// accent color as a hex string, both normalized in [toDomain].
class ProductApiModel {
  const ProductApiModel({
    required this.id,
    required this.title,
    required this.priceCents,
    required this.rating,
    required this.category,
    required this.colorHex,
    required this.icon,
  });

  final String id;
  final String title;
  final int priceCents;
  final double rating;
  final String category;
  final String colorHex;
  final String icon;

  factory ProductApiModel.fromJson(Map<String, dynamic> json) => ProductApiModel(
        id: json['id'] as String,
        title: (json['title'] ?? json['name'] ?? '') as String,
        priceCents: (json['price_cents'] ?? 0) as int,
        rating: ((json['rating'] ?? 0) as num).toDouble(),
        category: (json['category'] ?? 'Tudo') as String,
        colorHex: (json['color'] ?? 'FF888888') as String,
        icon: (json['icon'] ?? 'bag') as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'price_cents': priceCents,
        'rating': rating,
        'category': category,
        'color': colorHex,
        'icon': icon,
      };

  /// Transform the transport model into the clean domain model.
  Product toDomain() => Product(
        id: id,
        name: title,
        price: priceCents / 100,
        rating: rating,
        category: category,
        colorValue: int.parse(colorHex, radix: 16),
        iconKey: icon,
      );
}
