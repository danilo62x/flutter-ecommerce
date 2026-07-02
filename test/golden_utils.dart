import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads real fonts so screenshots show actual glyphs/icons instead of boxes.
Future<void> loadGoldenFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  try {
    final manifest =
        json.decode(await rootBundle.loadString('FontManifest.json')) as List<dynamic>;
    for (final entry in manifest) {
      final family = entry['family'] as String;
      final loader = FontLoader(family);
      for (final font in (entry['fonts'] as List<dynamic>)) {
        loader.addFont(rootBundle.load(font['asset'] as String));
      }
      await loader.load();
    }
  } catch (_) {}

  const facePairs = <List<String>>[
    [r'C:\Windows\Fonts\segoeui.ttf', r'C:\Windows\Fonts\segoeuib.ttf'],
    [r'C:\Windows\Fonts\arial.ttf', r'C:\Windows\Fonts\arialbd.ttf'],
  ];
  final faces = <String>[];
  for (final pair in facePairs) {
    if (pair.every((p) => File(p).existsSync())) {
      faces.addAll(pair);
      break;
    }
  }
  if (faces.isEmpty) return;
  for (final family in <String>['Roboto', 'Inter', 'SF Pro Text', 'sans-serif']) {
    final loader = FontLoader(family);
    for (final path in faces) {
      loader.addFont(_bytes(path));
    }
    await loader.load();
  }
}

Future<ByteData> _bytes(String path) async {
  final bytes = File(path).readAsBytesSync();
  return ByteData.view(bytes.buffer);
}
