import 'package:flutter/material.dart';

import 'package:ecommerce/core/router.dart';
import 'package:ecommerce/core/theme.dart';

/// Root widget. Wires the Material 3 theme with declarative routing (go_router).
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ecommerce Template',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
