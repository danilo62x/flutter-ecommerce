import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce/data/repositories/shop_repository.dart';
import 'package:ecommerce/data/services/shop_api_service.dart';
import 'package:ecommerce/ui/features/shop/view_models/shop_view_model.dart';
import 'package:ecommerce/ui/features/shop/views/shop_screen.dart';

Widget _wrap() => MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => ShopViewModel(
          repository: ShopRepository(api: ShopApiService()),
        ),
        child: const ShopScreen(),
      ),
    );

void main() {
  testWidgets('renders shop header and seeded products', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(500, 1200);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.text('Descubra'), findsOneWidget);
    expect(find.text('Runner Air'), findsOneWidget);
  });

  testWidgets('filters products by category', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(500, 1200);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_wrap());
    await tester.pump();

    // Filter to "Tênis": tennis shoes stay, the "Roupas" tee is hidden.
    await tester.tap(find.text('Tênis'));
    await tester.pump();

    expect(find.text('Runner Air'), findsOneWidget);
    expect(find.text('Classic Tee'), findsNothing);
  });
}
