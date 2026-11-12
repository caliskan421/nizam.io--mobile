import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/inputs/inputs.dart';
import 'package:nizamio/features/coordinatorships/presentation/coord_add_member_sheet.dart';

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
}
