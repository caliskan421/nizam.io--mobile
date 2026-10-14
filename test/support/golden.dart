// Golden test yardımcısı (ADR-0003 karar 8). Referans dosyası yalnız Linux'ta üretilir
// (`make golden-update` ya da CI `golden-update` işi); macOS'ta test atlanır.
// Karşılaştırıcı Flutter'ın varsayılanıdır (tam eşleşme, tolerans 0): tek platform + sabit
// runner etiketi (ubuntu-24.04) ve Ahem yazı tipi birlikte kararlılığı sağlar; tolerans
// gerçek bir regresyonu gizler.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const goldenTag = 'golden';

/// Golden doğrulaması bu platformda yapılır mı (yalnız Linux).
bool get goldenSupported => Platform.isLinux;

/// `testWidgets` + golden etiketi; Linux dışında atlanır (yerel `make test` yeşil kalır).
void goldenTestWidgets(
  String description,
  Future<void> Function(WidgetTester tester) body,
) {
  testWidgets(description, body, tags: [goldenTag], skip: !goldenSupported);
}
