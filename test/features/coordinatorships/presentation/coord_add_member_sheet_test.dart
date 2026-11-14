import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/inputs/inputs.dart';
import 'package:nizamio/features/coordinatorships/presentation/coord_add_member_sheet.dart';
import 'package:nizamio/features/tasks/tasks.dart' show TaskCheckRow;

import '../../pilot_support.dart';
import '../coord_backend.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);
  testWidgets('mevcut üyeleri arar; yeni kişi oluşturma formuna geçer', (
    tester,
  ) async {
    final h = await real(
      tester,
      () => pilotHarness(CoordBackend(), signedIn: true),
    );
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    await pumpScreen(
      tester,
      h,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showCoordAddMemberSheet(context, dAlt),
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await settle(tester);
    expect(find.text('Bahar Kılıç'), findsOneWidget);
    expect(find.text('Kadir Özbek'), findsNothing);
    await tester.enterText(
      find.descendant(
        of: find.byType(NzSearchField),
        matching: find.byType(TextField),
      ),
      'Bahar',
    );
    await settle(tester);
    expect(find.text('Bahar Kılıç'), findsOneWidget);
    expect(find.text('Burak Er'), findsNothing);
    final l = AppLocalizationsTr();
    await tester.tap(find.text(l.uiCoordCreatePerson));
    await settle(tester);
    expect(find.text(l.uiTasksIvTitle), findsOneWidget);
    expect(find.text(l.uiTasksIvEmail), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('adaylar koordinatörlük ve rol süzgeciyle daralır', (
    tester,
  ) async {
    final h = await real(
      tester,
      () => pilotHarness(CoordBackend(), signedIn: true),
    );
    h.read(scopeControllerProvider).selectProgram(coordProgram);
    await pumpScreen(
      tester,
      h,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showCoordAddMemberSheet(context, dAlt),
          child: const Text('open'),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await settle(tester);
    final l = AppLocalizationsTr();
    expect(find.text('Burak Er'), findsOneWidget);
    expect(find.text('Bahar Kılıç'), findsOneWidget);
    // Rol: yalnız başka ekipte koordinatör olanlar.
    await tester.ensureVisible(find.text(l.uiCoordLeadRole));
    await settle(tester);
    await tester.tap(find.text(l.uiCoordLeadRole));
    await settle(tester);
    expect(find.text('Burak Er'), findsOneWidget);
    expect(find.text('Bahar Kılıç'), findsNothing);
    // Koordinatörlük: Eğitim ve Arge'de koordinatör yok → boş liste.
    await tester.ensureVisible(find.text(l.uiTasksFieldCoord));
    await settle(tester);
    await tester.tap(find.text(l.uiTasksFieldCoord));
    await settle(tester);
    final egi = find.widgetWithText(TaskCheckRow, 'Eğitim ve Arge');
    await tester.ensureVisible(egi);
    await settle(tester);
    await tester.tap(egi);
    await settle(tester);
    expect(find.text('Burak Er'), findsNothing);
    expect(find.text(l.uiCoordNoCandidates), findsOneWidget);
    // Rol tümü → Eğitim ve Arge üyesi görünür.
    await tester.ensureVisible(find.text(l.uiCoordStAll).last);
    await settle(tester);
    await tester.tap(find.text(l.uiCoordStAll).last);
    await settle(tester);
    expect(find.text('Bahar Kılıç'), findsOneWidget);
    expect(find.text('Burak Er'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
