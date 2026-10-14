// Golden test yardımcısı (ADR-0003 karar 8). Referans dosyası yalnız Linux'ta üretilir
// (`make golden-update` ya da CI `golden-update` işi); macOS'ta test atlanır.
// Karşılaştırıcı Flutter'ın varsayılanıdır (tam eşleşme, tolerans 0): tek platform + sabit
// runner etiketi (ubuntu-24.04) ve Ahem yazı tipi birlikte kararlılığı sağlar; tolerans
// gerçek bir regresyonu gizler.
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const goldenTag = 'golden';

/// Golden doğrulaması bu platformda yapılır mı (yalnız Linux).
bool get goldenSupported => Platform.isLinux;

Future<List<String>>? _fontsLoaded;

/// Uygulamanın yazı tiplerini (MaterialIcons dahil) `FontManifest.json`'dan okuyup yükler; test
/// ortamı ikonları varsayılan olarak boş kare (tofu) çizer. Bir kez çalışır; yüklenen aileleri
/// döndürür.
Future<List<String>> loadAppFonts() => _fontsLoaded ??= _loadAppFonts();

Future<List<String>> _loadAppFonts() async {
  final manifest = json.decode(
    utf8.decode(
      (await rootBundle.load('FontManifest.json')).buffer.asUint8List(),
    ),
  ) as List<dynamic>;
  final families = <String>[];
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final family = entry['family'] as String;
    final loader = FontLoader(family);
    for (final font
        in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
    families.add(family);
  }
  return families;
}

/// `testWidgets` + golden etiketi; Linux dışında atlanır (yerel `make test` yeşil kalır).
/// Gövdeden önce uygulama yazı tipleri yüklenir ([loadAppFonts]).
void goldenTestWidgets(
  String description,
  Future<void> Function(WidgetTester tester) body,
) {
  testWidgets(
    description,
    (tester) async {
      await tester.runAsync(loadAppFonts);
      await body(tester);
    },
    tags: [goldenTag],
    skip: !goldenSupported,
  );
}
