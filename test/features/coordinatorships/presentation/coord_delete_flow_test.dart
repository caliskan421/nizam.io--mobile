// Koordinatörlük silme (ayrıntı ⋮ → etki önizlemesi → kod yazılınca Sil): yalnız yönetici,
// önizleme okunur, eşleşme olmadan düğme kapalı, başarıda DELETE + bildirim + listeye dönüş;
// sunucu hatası sayfada kalır.
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/core/ui/widgets/buttons/buttons.dart';
import 'package:nizamio/core/ui/widgets/inputs/inputs.dart';
import 'package:nizamio/features/coordinatorships/presentation/coordinatorship_page.dart';

import '../../../support/fake_backend.dart';
import '../../../support/harness.dart';
import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';
import '../coord_backend.dart';

final _l = AppLocalizationsTr();

Map<String, Object?> _impact() => {
  'department_id': dAlt,
  'name': 'Altyapı ve tesisat',
  'deleted': false,
  'programs': [
    {
      'program_id': coordProgram,
      'program_name': '2026',
      'department_name': 'Altyapı ve tesisat',
      'linked': true,
      'active_items': 3,
      'completed_items': 1,
      'deleted_items': 0,
      'deleted_with_department': 0,
    },
    {
      'program_id': 'prog-0',
      'program_name': '2025',
      'department_name': 'Altyapı',
      'linked': true,
      'active_items': 2,
      'completed_items': 5,
      'deleted_items': 1,
      'deleted_with_department': 0,
    },
  ],
  'active_items': 5,
  'completed_items': 6,
  'deleted_items': 1,
  'deleted_with_department': 0,
  'file_count': 4,
  'member_count': 7,
  'meeting_count': 2,
  'permanent_blockers': {'tables': 0, 'projects': 0, 'pending_proposals': 0},
  'permanent_blocked': false,
};

Future<(Harness, RecordingAppNav, List<String>)> _open(
  WidgetTester tester, {
  bool admin = true,
  String? deleteError,
}) async {
  final backend = CoordBackend()..admin = admin;
  final h = await real(tester, () => pilotHarness(backend, signedIn: true));
  h.read(scopeControllerProvider).selectProgram(coordProgram);
  final calls = <String>[];
  final serve = h.backend.handler;
  h.backend.handler = (r) {
    if (r.method == 'GET' && r.path == '/v1/departments/$dAlt/delete-impact') {
      calls.add('impact');
      return jsonResponse(200, _impact());
    }
    if (r.method == 'DELETE' && r.path == '/v1/departments/$dAlt') {
      calls.add('delete');
      if (deleteError != null) return errorBody(409, deleteError);
      return jsonResponse(200, {
        'department_id': dAlt,
        'deleted': true,
        'work_items_deleted': 11,
      });
    }
    return serve(r);
  };
  final nav = RecordingAppNav();
  await pumpScreen(tester, h, const CoordinatorshipPage(code: dAlt), nav: nav);
  await settle(tester);
  return (h, nav, calls);
}

Future<void> _openSheet(WidgetTester tester) async {
  await tester.tap(find.bySemanticsLabel(_l.uiCoordMoreActions));
  await settle(tester);
  await tester.tap(find.text(_l.uiCoordDeleteMenu));
  await settle(tester);
}

NzButton _deleteButton(WidgetTester tester) => tester.widget<NzButton>(
  find.widgetWithText(NzButton, _l.uiCoordDeleteDelete),
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('üye görünümünde sil girişi yok', (tester) async {
    await _open(tester, admin: false);
    await tester.tap(find.bySemanticsLabel(_l.uiCoordMoreActions));
    await settle(tester);
    expect(find.text(_l.uiCoordDeleteMenu), findsNothing);
  });

  testWidgets('önizleme → kod eşleşince Sil → bildirim ve listeye dönüş', (
    tester,
  ) async {
    final (_, nav, calls) = await _open(tester);
    await _openSheet(tester);
    expect(calls, ['impact']);
    expect(find.text('3 açık · 1 tamamlanmış'), findsOneWidget);
    expect(find.text('2025'), findsOneWidget);
    expect(_deleteButton(tester).onPressed, isNull);
    final field = find.widgetWithText(
      NzTextField,
      '${_l.uiCoordDeleteConfirmLabel}: ALT',
    );
    await tester.enterText(field, 'AL');
    await tester.pump();
    expect(_deleteButton(tester).onPressed, isNull);
    await tester.enterText(field, ' alt ');
    await tester.pump();
    expect(_deleteButton(tester).onPressed, isNotNull);
    await tester.tap(find.widgetWithText(NzButton, _l.uiCoordDeleteDelete));
    await settle(tester);
    expect(calls, ['impact', 'delete']);
    expect(find.text('11 ${_l.uiCoordDeleteToastMovedTail}'), findsOneWidget);
    expect(nav.calls, ['coordinatorships']);
  });

  testWidgets('sunucu hatası sayfada kalır; listeye dönülmez', (tester) async {
    final (_, nav, calls) = await _open(
      tester,
      deleteError: 'platform.conflict_retry',
    );
    await _openSheet(tester);
    await tester.enterText(
      find.widgetWithText(NzTextField, '${_l.uiCoordDeleteConfirmLabel}: ALT'),
      'ALT',
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(NzButton, _l.uiCoordDeleteDelete));
    await settle(tester);
    expect(calls, ['impact', 'delete']);
    expect(find.text(_l.uiCoordDeleteSoftWarning), findsOneWidget);
    expect(nav.calls, isEmpty);
    expect(_deleteButton(tester).onPressed, isNotNull, reason: 'tekrar dene');
  });
}
