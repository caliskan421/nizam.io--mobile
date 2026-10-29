// CalendarPage: varsayılan gün (21 Ekim), hücre etiketleri, gün seçimi + "Bugün", ay/hafta
// adımı, haftaya daralt, boş gün + toplantı planla, görev → ayrıntı, toplantı / talep / tablo
// kaydı önizlemesi ve düğmeleri, yeniden boyutta durumun korunması, boş sağ bölme.
//
// Gerçek bileşim kökü (`Harness`) kullanılır: takvim modülünün bileşime bağlanmış olması
// (`registerCalendarModule` + `calendarOverrides`) beklenir.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/core/providers.dart';
import 'package:nizamio/features/calendar/calendar.dart';

import '../../../support/recording_app_nav.dart';
import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

Future<RecordingAppNav> _open(
  WidgetTester tester, {
  ValueChanged<DateTime>? onPlan,
  Size size = const Size(390, 1400),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
  final h = await real(
    tester,
    () => pilotHarness(PilotBackend(), signedIn: true),
  );
  h.read(scopeControllerProvider).selectProgram('prog-2');
  final nav = RecordingAppNav();
  await pumpScreen(tester, h, CalendarPage(onPlanMeeting: onPlan), nav: nav);
  await settle(tester);
  return nav;
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f.first);
  await tester.pump();
  await tester.tap(f.first);
  await settle(tester);
}

Finder _cell(String label) => find.bySemanticsLabel(label);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('varsayılan: Ekim 2026, 21 Ekim seçili, gün bölümleri', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await _open(tester);
    expect(find.text(_l.uiCalendarTitle), findsOneWidget);
    expect(find.text('Ekim 2026'), findsOneWidget);
    for (final d in ['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pz']) {
      expect(find.text(d), findsOneWidget);
    }
    expect(_cell('21 Ekim, Çarşamba, bugün, 4 kayıt'), findsOneWidget);
    expect(
      tester.getSemantics(_cell('21 Ekim, Çarşamba, bugün, 4 kayıt')),
      matchesSemantics(
        label: '21 Ekim, Çarşamba, bugün, 4 kayıt',
        value: '21',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
        hasEnabledState: false,
      ),
    );
    expect(_cell('28 Eylül, Pazartesi'), findsOneWidget);
    expect(_cell('29 Ekim, Perşembe, 5 kayıt'), findsOneWidget);
    expect(_cell('1 Kasım, Pazar, 2 kayıt'), findsOneWidget);
    expect(_cell('Haftaya daralt · Ekim 2026'), findsOneWidget);
    expect(find.text('21 Ekim, Çarşamba'), findsOneWidget);
    expect(find.text('bugün'), findsOneWidget);
    expect(find.text('toplantılar · 2'), findsOneWidget);
    expect(find.text('talepler · 1'), findsOneWidget);
    expect(find.text('tablo kayıtları · 1'), findsOneWidget);
    expect(find.text('14:00'), findsOneWidget);
    expect(find.text('ALT · 6 katılımcı · 3 gündem'), findsOneWidget);
    expect(find.text('İDA, OPE · 5 katılımcı · 2 gündem'), findsOneWidget);
    expect(find.text('Satın alma · ALT · ₺14.600'), findsOneWidget);
    expect(find.text('Teslim alındı'), findsOneWidget);
    expect(find.text('yapıldı'), findsOneWidget);
    // Bugün seçiliyken "Bugün" devre dışı.
    expect(
      tester.getSemantics(find.bySemanticsLabel(_l.uiCalendarToday)),
      matchesSemantics(
        label: _l.uiCalendarToday,
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
      ),
    );
    handle.dispose();
  });

  testWidgets('gün seçimi ve Bugün; görev satırı ayrıntıyı açar', (
    tester,
  ) async {
    final nav = await _open(tester);
    await _tap(tester, _cell('29 Ekim, Perşembe, 5 kayıt'));
    expect(find.text('29 Ekim, Perşembe'), findsOneWidget);
    expect(find.text('8 gün sonra'), findsOneWidget);
    expect(find.text('görevler · 3'), findsOneWidget);
    expect(find.text('talepler · 1'), findsOneWidget);
    expect(find.text('Fiyat teklifi · OPE'), findsOneWidget);
    await _tap(tester, find.text('SİS-1'));
    expect(nav.calls, ['task:SİS-1']);
    await _tap(tester, find.bySemanticsLabel(_l.uiCalendarToday));
    expect(find.text('21 Ekim, Çarşamba'), findsOneWidget);
    await _tap(tester, _cell('20 Ekim, Salı, 2 kayıt'));
    expect(find.text('dün'), findsOneWidget);
    expect(find.text('Onay bekliyor'), findsOneWidget);
  });

  testWidgets('geciken görev etiketi; ay dışı hücre ayı değiştirir', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, _cell('30 Eylül, Çarşamba, 1 kayıt'));
    expect(find.text('Eylül 2026'), findsOneWidget);
    expect(find.text('ALT-10'), findsOneWidget);
    expect(find.text('gecikti'), findsOneWidget);
    expect(find.text('21 gün önce'), findsOneWidget);
  });

  testWidgets('ay adımı: sonraki ay 1\'i seçer, bugünün ayına dönünce bugün', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, find.bySemanticsLabel(_l.uiCalendarNextMonth));
    expect(find.text('Kasım 2026'), findsOneWidget);
    expect(find.text('1 Kasım, Pazar'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel(_l.uiCalendarPrevMonth));
    expect(find.text('Ekim 2026'), findsOneWidget);
    expect(find.text('21 Ekim, Çarşamba'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel(_l.uiCalendarPrevMonth));
    expect(find.text('1 Eylül, Salı'), findsOneWidget);
  });

  testWidgets('haftaya daralt: hafta başlığı, hafta adımı, aya genişlet', (
    tester,
  ) async {
    await _open(tester);
    await _tap(tester, _cell('Haftaya daralt · Ekim 2026'));
    expect(find.text('Ekim 2026 · 4. hafta'), findsOneWidget);
    expect(_cell('5 Ekim, Pazartesi, 3 kayıt'), findsNothing);
    expect(_cell('19 Ekim, Pazartesi, 3 kayıt'), findsOneWidget);
    await _tap(tester, find.bySemanticsLabel(_l.uiCalendarNextWeek));
    expect(find.text('Ekim 2026 · 5. hafta'), findsOneWidget);
    expect(find.text('28 Ekim, Çarşamba'), findsOneWidget);
    await _tap(tester, _cell('Aya genişlet · Ekim 2026'));
    expect(find.text('Ekim 2026'), findsOneWidget);
    expect(_cell('5 Ekim, Pazartesi, 3 kayıt'), findsOneWidget);
  });

  testWidgets('boş gün: metin + Toplantı planla seçili günle; + düğmesi', (
    tester,
  ) async {
    final planned = <DateTime>[];
    await _open(tester, onPlan: planned.add);
    await _tap(tester, _cell('6 Ekim, Salı'));
    expect(find.text(_l.uiCalendarEmpty), findsOneWidget);
    await _tap(tester, find.text(_l.uiCalendarPlan));
    await _tap(tester, find.bySemanticsLabel(_l.uiCalendarPlanMeeting));
    expect(planned, [DateTime(2026, 10, 6), DateTime(2026, 10, 6)]);
  });

  testWidgets('toplantı önizlemesi: bilgiler, gündem, Gruba yaz / Hatırlat', (
    tester,
  ) async {
    final nav = await _open(tester);
    await _tap(tester, find.text('Hidrofor teslim kontrolü'));
    expect(find.text('toplantı'), findsOneWidget);
    expect(find.text('21 Ekim Çarşamba · 14:00'), findsOneWidget);
    expect(find.text('Havalimanı yerleşkesi'), findsOneWidget);
    expect(find.text('ALT · 6 kişi'), findsOneWidget);
    expect(find.text('gündem · 3'), findsOneWidget);
    expect(find.text('Teslim tutanağı'), findsOneWidget);
    await _tap(tester, find.text(_l.uiCalendarWriteGroup));
    expect(nav.calls, ['chat:hid']);
    expect(find.text('gündem · 3'), findsNothing);
    await _tap(tester, find.text('Konaklama ve servis planı'));
    await _tap(tester, find.text(_l.uiCalendarRemind));
    expect(find.text(_l.uiCalendarReminded), findsOneWidget);
    expect(nav.calls, ['chat:hid']);
  });

  testWidgets('talep önizlemesi: koordinatörlük bağlantısı, bağlı görev', (
    tester,
  ) async {
    final nav = await _open(tester);
    await _tap(tester, find.text('Hidrofor yedek vana seti'));
    expect(find.text('talep · ST-107'), findsOneWidget);
    expect(find.text('Altyapı ve tesisat'), findsOneWidget);
    expect(find.text('₺14.600'), findsOneWidget);
    expect(find.text('21 Ekim Çarşamba'), findsOneWidget);
    expect(find.text('ALT-7'), findsOneWidget);
    await _tap(tester, find.text(_l.uiCalendarGoTask));
    expect(nav.calls, ['task:ALT-7']);
    await _tap(tester, find.text('Hidrofor yedek vana seti'));
    await _tap(tester, find.text('Altyapı ve tesisat'));
    expect(nav.calls, ['task:ALT-7', 'coord:ALT']);
    await _tap(tester, find.text('Hidrofor yedek vana seti'));
    await _tap(tester, find.text(_l.uiCalendarClose).last);
    expect(nav.calls, ['task:ALT-7', 'coord:ALT']);
  });

  testWidgets('teklif talebi "Teklif bekleniyor"; tablo kaydı önizlemesi', (
    tester,
  ) async {
    final nav = await _open(tester);
    await _tap(tester, find.text('Jeneratör yakıt dolumu'));
    expect(find.text('tablo kaydı'), findsOneWidget);
    expect(find.text('Enerji kontrol listesi'), findsOneWidget);
    expect(find.text('Yapıldı'), findsOneWidget);
    await _tap(tester, find.text(_l.uiCalendarGoCoordinatorship));
    expect(nav.calls, ['coord:ELE']);
    await _tap(tester, _cell('24 Ekim, Cumartesi, 1 kayıt'));
    await _tap(tester, find.text('ST-118'));
    expect(find.text(_l.uiCalendarQuotePending), findsOneWidget);
  });

  testWidgets('yeniden boyut: seçili gün, kip ve ay korunur', (tester) async {
    await _open(tester, size: const Size(390, 1400));
    await _tap(tester, _cell('29 Ekim, Perşembe, 5 kayıt'));
    await _tap(tester, _cell('Haftaya daralt · Ekim 2026'));
    for (final s in const [Size(820, 1180), Size(1180, 820), Size(390, 1400)]) {
      tester.view.physicalSize = s;
      await settle(tester);
      expect(find.text('29 Ekim, Perşembe'), findsOneWidget);
      expect(find.text('Ekim 2026 · 5. hafta'), findsOneWidget);
    }
  });

  testWidgets('boş sağ bölme metni', (tester) async {
    final h = await real(
      tester,
      () => pilotHarness(PilotBackend(), signedIn: true),
    );
    await pumpScreen(tester, h, const CalendarEmptyDetail());
    expect(find.text(_l.uiCalendarPickTitle), findsOneWidget);
    expect(find.text(_l.uiCalendarPickBody), findsOneWidget);
  });
}
