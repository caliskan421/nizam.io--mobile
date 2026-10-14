import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/app/dev/catalog/inputs_catalog.dart';
import 'package:nizamio/core/ui/widgets/nz_size.dart';

import '../feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  test(
    'girişler inputs grubunda, adları benzersiz ve bütün bileşenleri kapsar',
    () {
      final entries = inputsCatalogEntries;
      expect(entries.map((e) => e.group).toSet(), {'inputs'});
      final names = entries.map((e) => e.name).toList();
      expect(names.toSet().length, names.length);
      for (final component in [
        'NzTextField',
        'NzTextField.email',
        'NzTextField.multiline',
        'NzTextField.number',
        'NzPasswordField',
        'NzPasswordField.newPassword',
        'NzSearchField',
        'NzCheckbox',
        'NzSwitch',
        'NzSelect',
        'NzForm',
      ]) {
        expect(
          names.any((n) => n == component || n.startsWith('$component ')),
          isTrue,
          reason: component,
        );
      }
    },
  );

  testWidgets('her giriş çizilir ve her boyutu içerir (taşma yok)', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 3000);
    addTearDown(tester.view.reset);
    for (final entry in inputsCatalogEntries) {
      await tester.pumpWidget(
        testApp(
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Builder(builder: entry.builder),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(tester.takeException(), isNull, reason: entry.name);
      if (!entry.name.startsWith('NzForm')) {
        final text = tester
            .widgetList<Text>(find.byType(Text))
            .map((t) => t.data ?? '')
            .join('|');
        for (final size in NzSize.values) {
          expect(text, contains('(${size.name})'), reason: entry.name);
        }
      }
    }
  });
}
