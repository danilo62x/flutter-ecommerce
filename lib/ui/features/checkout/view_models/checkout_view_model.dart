import 'package:flutter/foundation.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/domain/models/cart_item.dart';

/// A saved delivery address option.
class AddressOption {
  const AddressOption({
    required this.label,
    required this.recipient,
    required this.line,
  });

  final String label;
  final String recipient;
  final String line;
}

/// A payment method option (icon resolved in the UI).
class PaymentOption {
  const PaymentOption({
    required this.id,
    required this.label,
    required this.detail,
    required this.iconKey,
  });

  final String id;
  final String label;
  final String detail;
  final String iconKey;
}

/// Presentation state for the checkout flow (MVVM).
class CheckoutViewModel extends ChangeNotifier {
  CheckoutViewModel({required ShopRepository repository})
      : _items = repository.seedCart();

  final List<CartItem> _items;

  static const List<AddressOption> addresses = <AddressOption>[
    AddressOption(
      label: 'Casa',
      recipient: 'Ana Ribeiro',
      line: 'Rua das Palmeiras, 240 — Apto 52\nJardim Europa, São Paulo · 01455-000',
    ),
    AddressOption(
      label: 'Trabalho',
      recipient: 'Ana Ribeiro',
      line: 'Av. Paulista, 1000 — 14º andar\nBela Vista, São Paulo · 01310-100',
    ),
  ];

  static const List<PaymentOption> payments = <PaymentOption>[
    PaymentOption(
      id: 'credit',
      label: 'Cartão de crédito',
      detail: 'Mastercard •••• 4821',
      iconKey: 'card',
    ),
    PaymentOption(
      id: 'pix',
      label: 'Pix',
      detail: 'Aprovação imediata',
      iconKey: 'pix',
    ),
    PaymentOption(
      id: 'boleto',
      label: 'Boleto bancário',
      detail: 'Vence em 3 dias úteis',
      iconKey: 'boleto',
    ),
  ];

  int _selectedAddress = 0;
  int get selectedAddress => _selectedAddress;

  int _selectedPayment = 0;
  int get selectedPayment => _selectedPayment;

  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => _items.fold(0, (sum, i) => sum + i.lineTotal);
  double get shipping => subtotal >= 299 ? 0 : 19.90;
  double get discount => subtotal * 0.10;
  double get total => subtotal + shipping - discount;

  List<CartItem> get items => List<CartItem>.unmodifiable(_items);

  void selectAddress(int index) {
    _selectedAddress = index;
    notifyListeners();
  }

  void selectPayment(int index) {
    _selectedPayment = index;
    notifyListeners();
  }
}
