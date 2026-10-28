// Temel (foundation) katalog girişleri: açık/koyu × 360 genişlik × metin 1.0/2.0'da taşmasız
// çizilir; Türkçe örnek ve tema rolleri görünür.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/dev/catalog/catalog_registry.dart';
import 'package:nizamio/app/dev/catalog/foundation_catalog.dart';
import 'package:nizamio/core/ui/widgets/buttons/nz_button.dart';
import 'package:nizamio/core/ui/widgets/inputs/inputs.dart';
import 'package:nizamio/core/ui/widgets/surfaces/surfaces.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  test('temel grup kayıt defterinde ilk sıradadır', () {
    expect(allCatalogEntries.first.group, 'foundation');
    expect(
      allCatalogEntries.where((e) => e.group == 'foundation').length,
      foundationCatalogEntries.length,
    );
  });

  for (final dark in [false, true]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('${dark ? 'koyu' : 'açık'} · 360 · ${scale}x: taşma yok', (
        tester,
      ) async {
        tester.view
          ..devicePixelRatio = 1
          ..physicalSize = const Size(360, 6000);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          testApp(
            MediaQuery.withClampedTextScaling(
              minScaleFactor: scale,
              maxScaleFactor: scale,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final e in foundationCatalogEntries)
                      Builder(builder: e.builder),
                  ],
                ),
              ),
            ),
            dark: dark,
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.text(turkishSample), findsWidgets);
        expect(find.byType(NzButton), findsNWidgets(2));
        expect(find.byType(NzTextField), findsOneWidget);
        expect(find.byType(NzCard), findsOneWidget);
      });
    }
  }
}
