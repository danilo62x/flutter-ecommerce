import 'package:ecommerce/data/services/shop_api_service.dart';
import 'package:ecommerce/domain/models/cart_item.dart';
import 'package:ecommerce/domain/models/order.dart';
import 'package:ecommerce/domain/models/product.dart';
import 'package:ecommerce/domain/models/shop_category.dart';

/// Single source of truth for the storefront.
///
/// Every `seed*` method returns a synchronous in-memory dataset so each screen
/// has content on its first frame (used by the screenshot test). [fetch] shows
/// the real async path that would hit the backend through [ShopApiService].
class ShopRepository {
  ShopRepository({required ShopApiService api}) : _api = api;

  final ShopApiService _api;

  /// Underlying HTTP service, exposed for real backend wiring.
  ShopApiService get api => _api;

  /// Synchronous demo catalog — always available, no backend required.
  List<Product> seed() => const <Product>[
        Product(
          id: 'p1',
          name: 'Runner Air',
          price: 499.90,
          oldPrice: 629.90,
          rating: 4.8,
          reviewCount: 1248,
          category: 'Tênis',
          colorValue: 0xFFF2601A,
          iconKey: 'run',
          sizes: <String>['38', '39', '40', '41', '42', '43'],
          description:
              'Amortecimento responsivo e cabedal em malha respirável para '
              'corridas longas. Entressola em espuma leve que devolve energia '
              'a cada passada.',
        ),
        Product(
          id: 'p2',
          name: 'Cloud Sprint',
          price: 649.90,
          rating: 4.9,
          reviewCount: 872,
          category: 'Tênis',
          colorValue: 0xFF2563EB,
          iconKey: 'run',
          sizes: <String>['38', '39', '40', '41', '42'],
          description:
              'Feito para velocidade: placa propulsora e solado com aderência '
              'extra em asfalto molhado. Leve, veloz e confortável.',
        ),
        Product(
          id: 'p3',
          name: 'Urban Jacket',
          price: 329.90,
          oldPrice: 399.90,
          rating: 4.6,
          reviewCount: 356,
          category: 'Roupas',
          colorValue: 0xFF16A34A,
          iconKey: 'shirt',
          sizes: <String>['P', 'M', 'G', 'GG'],
          description:
              'Jaqueta corta-vento resistente à água com forro térmico. '
              'Ideal para o dia a dia urbano em qualquer estação.',
        ),
        Product(
          id: 'p4',
          name: 'Classic Tee',
          price: 89.90,
          rating: 4.5,
          reviewCount: 2103,
          category: 'Roupas',
          colorValue: 0xFF7C3AED,
          iconKey: 'shirt',
          sizes: <String>['P', 'M', 'G', 'GG'],
          description:
              'Camiseta em algodão pima de toque macio e caimento perfeito. '
              'Um básico atemporal que combina com tudo.',
        ),
        Product(
          id: 'p5',
          name: 'Chrono Watch',
          price: 899.00,
          oldPrice: 1099.00,
          rating: 4.7,
          reviewCount: 541,
          category: 'Acessórios',
          colorValue: 0xFF0D9488,
          iconKey: 'watch',
          sizes: <String>['Único'],
          description:
              'Relógio analógico com caixa em aço inoxidável, resistência à '
              'água de 50 m e pulseira intercambiável. Elegância clássica.',
        ),
        Product(
          id: 'p6',
          name: 'Trail Backpack',
          price: 259.90,
          rating: 4.4,
          reviewCount: 418,
          category: 'Acessórios',
          colorValue: 0xFFDB2777,
          iconKey: 'bag',
          sizes: <String>['Único'],
          description:
              'Mochila de trilha de 28 L com compartimento para notebook, '
              'costas ventiladas e tecido repelente. Leve e organizada.',
        ),
        Product(
          id: 'p7',
          name: 'Pulse Earbuds',
          price: 429.90,
          oldPrice: 499.90,
          rating: 4.6,
          reviewCount: 967,
          category: 'Eletrônicos',
          colorValue: 0xFF9333EA,
          iconKey: 'audio',
          sizes: <String>['Único'],
          description:
              'Fones sem fio com cancelamento ativo de ruído, até 30 h de '
              'bateria com o estojo e conexão multiponto estável.',
        ),
        Product(
          id: 'p8',
          name: 'Court Sneaker',
          price: 379.90,
          rating: 4.5,
          reviewCount: 289,
          category: 'Tênis',
          colorValue: 0xFFEA580C,
          iconKey: 'run',
          sizes: <String>['37', '38', '39', '40', '41', '42'],
          description:
              'Silhueta retrô inspirada nas quadras dos anos 80, em couro '
              'premium com detalhes perfurados. Estilo que atravessa décadas.',
        ),
      ];

  /// Find a single product by id, falling back to the first item.
  Product productById(String id) =>
      seed().firstWhere((p) => p.id == id, orElse: () => seed().first);

  /// Browsable categories for the categories grid.
  List<ShopCategory> seedCategories() => const <ShopCategory>[
        ShopCategory(
            name: 'Tênis', iconKey: 'run', itemCount: 128, colorValue: 0xFFF2601A),
        ShopCategory(
            name: 'Roupas',
            iconKey: 'shirt',
            itemCount: 342,
            colorValue: 0xFF16A34A),
        ShopCategory(
            name: 'Acessórios',
            iconKey: 'watch',
            itemCount: 96,
            colorValue: 0xFF0D9488),
        ShopCategory(
            name: 'Eletrônicos',
            iconKey: 'audio',
            itemCount: 74,
            colorValue: 0xFF9333EA),
        ShopCategory(
            name: 'Casa', iconKey: 'home', itemCount: 210, colorValue: 0xFF2563EB),
        ShopCategory(
            name: 'Esportes',
            iconKey: 'sports',
            itemCount: 156,
            colorValue: 0xFFDB2777),
        ShopCategory(
            name: 'Beleza',
            iconKey: 'beauty',
            itemCount: 88,
            colorValue: 0xFFE11D48),
        ShopCategory(
            name: 'Infantil',
            iconKey: 'kids',
            itemCount: 132,
            colorValue: 0xFFF59E0B),
      ];

  /// Demo cart contents.
  List<CartItem> seedCart() {
    final catalog = seed();
    return <CartItem>[
      CartItem(product: catalog[0], size: '41', quantity: 1),
      CartItem(product: catalog[3], size: 'M', quantity: 2),
      CartItem(product: catalog[6], size: 'Único', quantity: 1),
    ];
  }

  /// Ids seeded as favorites on first launch.
  Set<String> seedFavorites() => <String>{'p1', 'p3', 'p5', 'p7'};

  /// Past orders shown in the profile screen.
  List<Order> seedOrders() => const <Order>[
        Order(
          id: '#EC-20482',
          dateLabel: '28 jun 2026',
          status: OrderStatus.shipped,
          total: 649.90,
          itemCount: 1,
          iconKey: 'run',
          colorValue: 0xFF2563EB,
        ),
        Order(
          id: '#EC-20475',
          dateLabel: '21 jun 2026',
          status: OrderStatus.delivered,
          total: 509.70,
          itemCount: 3,
          iconKey: 'shirt',
          colorValue: 0xFF16A34A,
        ),
        Order(
          id: '#EC-20461',
          dateLabel: '09 jun 2026',
          status: OrderStatus.delivered,
          total: 899.00,
          itemCount: 1,
          iconKey: 'watch',
          colorValue: 0xFF0D9488,
        ),
        Order(
          id: '#EC-20448',
          dateLabel: '30 mai 2026',
          status: OrderStatus.canceled,
          total: 259.90,
          itemCount: 1,
          iconKey: 'bag',
          colorValue: 0xFFDB2777,
        ),
      ];

  /// Real async path: fetch the catalog over HTTP and map to domain models.
  ///
  /// Falls back to [seed] so the template stays runnable without a backend.
  Future<List<Product>> fetch() async {
    try {
      final models = await _api.fetchProducts();
      return models.map((m) => m.toDomain()).toList();
    } catch (_) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return seed();
    }
  }
}
