// CalendarPage: boş sağ bölme. (Görev örnek kataloğunun "bugün"üne — 21 Ekim — ve görevlerine
// dayanan sayfa vakaları örnek mod kaldırılınca silindi.)
//
// Gerçek bileşim kökü (`Harness`) kullanılır: takvim modülünün bileşime bağlanmış olması
// (`registerCalendarModule` + `calendarOverrides`) beklenir.
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizamio/core/i18n/generated/app_localizations_tr.dart';
import 'package:nizamio/features/calendar/calendar.dart';

import '../../pilot_support.dart';

final _l = AppLocalizationsTr();

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

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
