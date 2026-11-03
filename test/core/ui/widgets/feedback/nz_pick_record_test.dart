import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/ui/widgets/feedback/nz_pick_record.dart';
import 'package:nizamio/core/ui/widgets/nz_icons.dart';

import 'feedback_test_support.dart';

const _message =
    'Soldaki listeden bir kayıt seçin; ayrıntısı bu bölmede açılır. '
    'Uzun açıklama satır genişliğini aşmamalıdır.';

void main() {
  setUpFonts();

  testWidgets('başlık, açıklama ve takvim simgesi gösterilir', (tester) async {
    await tester.pumpWidget(
      testApp(const NzPickRecord(title: 'Kayıt seçin', message: _message)),
    );
    expect(find.text('Kayıt seçin'), findsOneWidget);
    expect(find.text(_message), findsOneWidget);
    expect(find.byIcon(NzIcons.eventAvailable), findsOneWidget);
  });

  testWidgets('başlık ekran okuyucuya başlık olarak bildirilir', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      testApp(const NzPickRecord(title: 'Kayıt seçin', message: _message)),
    );
    expect(
      tester.getSemantics(find.text('Kayıt seçin')),
      matchesSemantics(label: 'Kayıt seçin', isHeader: true),
    );
    handle.dispose();
  });

  testWidgets('dar ekran ve 2.0 metin ölçeğinde taşma yok', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(
      testApp(const NzPickRecord(title: 'Kayıt seçin', message: _message)),
    );
    expect(tester.takeException(), isNull);
  });
}
