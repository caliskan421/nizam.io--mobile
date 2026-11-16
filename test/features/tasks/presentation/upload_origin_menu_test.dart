import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/features/tasks/tasks.dart';

import '../../../core/ui/widgets/feedback/feedback_test_support.dart';

void main() {
  setUpFonts();

  testWidgets(
    'kaynak menüsü seçilen kaynağı döndürür; dışarı dokunma iptaldir',
    (t) async {
      final l = AppLocalizationsTr();
      final results = <UploadOrigin?>[];
      await t.pumpWidget(
        testApp(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async =>
                  results.add(await showUploadOriginSheet(context)),
              child: const Text('Kaynak seç'),
            ),
          ),
        ),
      );
      for (final (label, origin) in [
        (l.uiTasksPickPhotos, UploadOrigin.photos),
        (l.uiTasksPickCamera, UploadOrigin.camera),
        (l.uiTasksPickFiles, UploadOrigin.files),
      ]) {
        await t.tap(find.text('Kaynak seç'));
        await t.pumpAndSettle();
        await t.tap(find.text(label));
        await t.pumpAndSettle();
        expect(results.last, origin);
      }
      await t.tap(find.text('Kaynak seç'));
      await t.pumpAndSettle();
      await t.tapAt(const Offset(780, 20));
      await t.pumpAndSettle();
      expect(results.last, isNull);
      expect(t.takeException(), isNull);
    },
  );
}
